json.array!(@comments) do |comment|
  json.extract! comment, :id, :body, :user_id, :stack_id
  json.url comment_url(comment, format: :json)
end
