require 'json'
require 'open-uri'
require 'rack/utils'

class Judge
  def initialize(test_example, tag = nil)
    @test_example = test_example
    @tag = tag
  end

  def test(code)
    target_code = "input = #{@test_example.input.to_s.inspect}\n#{code}"

    Rails.logger.info "Judge(#{@tag}) -- Starting test"
    Rails.logger.debug "Judge(#{@tag}) executing target: #{target_code.inspect}"
    target = LLEval.new(target_code).run

    result = {result: target.success? ? :success : :failed,
              input: @test_example.input,
              error: [target.stderr, target.error].join("\n"),
              output: target.stdout, status: target.status}

    Rails.logger.info "Judge(#{@tag}) target result: #{result.inspect}"
    return result unless target.success?

    tester_code = "out = #{result[:output].to_s.inspect}\np(#{@test_example.tester})"
    Rails.logger.debug "Judge(#{@tag}) executing tester: #{tester_code.inspect}"

    tester = LLEval.new(tester_code).run
    result[:tester] = {result: tester.success? ? :success : :failed,
                       error: [tester.stderr, tester.error].join("\n"),
                       output: tester.stdout, status: tester.status}

    if tester.success?
      Rails.logger.debug "Judge(#{@tag}) tester result: #{result[:tester].inspect}"
    else
      result[:result] = :tester_error
      Rails.logger.error "Judge(#{@tag}) tester returned error: #{result[:tester].inspect}"
      return result
    end

    result[:result] = tester.stdout.chomp == 'true' ? :success : :failed

    Rails.logger.info "Judge(#{@tag}) -- Finishing test: #{result.inspect}"
    result
  end

  class LLEval
    ENDPOINT = 'http://api.dan.co.jp/lleval.cgi'

    def initialize(code, language = 'rb20')
      @code = code
      @language = language
    end

    attr_reader :status, :error, :stdout, :stderr, :syscalls, :time, :language, :code

    def success?
      if @status
        !@error && @status.zero?
      else
        nil
      end
    end

    def run
      response = JSON.parse(open("#{ENDPOINT}?l=#{@language}&s=#{Rack::Utils.escape(@code)}", &:read))

      @status = response['status'] / 256
      @error  = response['error']
      @stdout = response['stdout']
      @stderr = response['stderr']
      @syscalls = response['syscalls']

      self
    end
  end
end
