class LiveSubmissionsController < ApplicationController
  include ActionController::Live

  def stream
    do_streaming()
  end

  def detailed_stream
    do_streaming(:detailed)
  end

  private

  def do_streaming(detailed = nil)
    response.headers['Content-Type'] = 'text/event-stream'
    response.headers['X-Accel-Buffering'] = 'no'

    $stderr.puts "#{Thread.current.object_id}: Stream opend"
    response.stream.write "event: connected\n\n"

    th = Thread.new do
      begin
        Submission.stream do |submission|
          payload = {submission_id: submission.id,
                    html: render_to_string(
                            partial: 'submissions/submission',
                            locals: {
                              submission: submission,
                              show_judges: !!detailed,
                            },
                            formats: [:html]
                          )
                    }
          response.stream.write "event: submission\ndata: #{payload.to_json}\n\n"
          $stderr.puts "#{Thread.current.object_id}: Sending event"
        end
      rescue Exception => e
        $stderr.puts "#{Thread.current.object_id}: Error on subscribe thread: #{e.inspect}"
        $stderr.puts e.backtrace
      end
    end

    loop do
      return unless th && th.alive?
      $stderr.puts "#{Thread.current.object_id}: keepalive"
      response.stream.write "event: keepalive\ndata: {}\n\n"
      sleep 10
    end
    $stderr.puts "#{Thread.current.object_id}: Finish"
  rescue IOError, Errno::EPIPE
  ensure
    th.kill if th && th.alive?
    begin
      response.stream.close
    rescue IOError
    end
  end

  def render_to_string(*)
    orig_stream = response.stream
    super
  ensure
    if orig_stream
      response.instance_variable_set(:@stream, orig_stream)
    end
  end
end
