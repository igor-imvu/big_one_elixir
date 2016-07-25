defmodule Timelinex.UserView do
  use Timelinex.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Timelinex.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Timelinex.UserView, "user.json")}
  end

  def render("debug.json", %{message: message}) do
    %{message: message}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      user_name: user.user_name,
      display_name: user.display_name,
      birthday: user.birthday}
  end
end
