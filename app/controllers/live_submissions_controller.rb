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

    response.stream.write "event: connected\n\n"

    th = Thread.new do
      Submission.stream do |submission|
        payload = {submission_id: submission.id,
                   html: render_to_string(
                           partial: 'submissions/submission',
                           locals: {
                             submission: submission,
                             show_judges: !!detailed,
                           }
                         )
                  }
        response.stream.write "data: #{payload.to_json}\n\n"
      end
    end

    loop do
      #return unless th && th.alive?
      response.stream.write "event: keepalive\n\n"
      sleep 10
    end
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
