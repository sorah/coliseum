json.array!(@problems) do |problem|
  json.extract! problem, :title, :body, :tests, :source, :copyright, :user_id
  json.url problem_url(problem, format: :json)
end
