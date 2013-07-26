json.array!(@submissions) do |submission|
  json.extract! submission, :problem, :language, :code, :judge_status, :judge_result
  json.url submission_url(submission, format: :json)
end
