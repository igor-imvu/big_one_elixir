defmodule Timelinex.PostView do
  use Timelinex.Web, :view

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, Timelinex.PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, Timelinex.PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{id: post.id,
      content: post.content,
      context: post.context,
      author_id: post.author_id,
      parent_id: post.parent_id,
      submitted_at: post.inserted_at}
  end
end
