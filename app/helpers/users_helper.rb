module UsersHelper
  def avatar_for user
    avatar_id = Digest::MD5::hexdigest user.email.downcase
    avatar_url = "https://en.gravatar.com/userimage/122389688/b22d9e4c2ece9eb07732561028910ea8.jpeg"
    image_tag avatar_url, alt: user.name, class: "avatar"
  end
end
