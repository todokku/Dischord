json.entities do
  json.users do
    json.partial! 'user', user: @user
  end
end
json.partial! '/api/sessions/session', user: @user
json.partial! '/api/errors/session_errors'