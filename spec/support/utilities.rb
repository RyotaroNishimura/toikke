def full_title(page_title)
  base_title = "RecomendApp"
end

def  sign_in_as(user)
  post login_path, params: { session: { email:user.email, password: user.password } }
end
