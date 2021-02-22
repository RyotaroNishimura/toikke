def full_title(page_title)
  base_title = "トイッケ"
end

def sign_in_as(user)
  post login_path, params: { session: { email: user.email, password: user.password, sex: 1 } }
end
