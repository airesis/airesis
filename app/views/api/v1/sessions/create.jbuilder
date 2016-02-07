json.success true
json.data do
  json.authentication_token @user.authentication_token
  json.message t('.message')
end
