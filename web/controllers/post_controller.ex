defmodule Timelinex.PostController do
  use Timelinex.Web, :controller
  alias Timelinex.{Post, Chronicler, Timeline}
  import Ecto.Query, only: [from: 2]

  def index(conn, %{"hashtag" => hashtag} = params) do
    hashtag = Timelinex.Repo.get_by(Timelinex.Hashtag, %{title: "#" <> hashtag})
    query =
      assoc(hashtag, :posts)
      |> Post.filtered(params)

    posts = Repo.all(query)
    render(conn, "index.json", posts: posts)
  end

  def index(conn, %{"mention" => user_name} = params) do
    user = Timelinex.Repo.get_by(Timelinex.User, %{user_name: user_name})
    query =
      assoc(user, :mentions_posts)
      |> Post.filtered(params)

    posts = Repo.all(query)
    render(conn, "index.json", posts: posts)
  end

  def index(conn, %{"text" => _text, "personal" => _personal} = params) do
    query =
      from(p in Post, where: p.author_id == ^conn.assigns[:current_user].id)
      |> Post.filtered(params)

    posts = Repo.all(query)
    render(conn, "index.json", posts: posts)
  end

  def index(conn, %{"text" => _text} = params) do
    query =
      Post
      |> Post.filtered(params)

    posts = Repo.all(query)
    render(conn, "index.json", posts: posts)
  end

  def index(conn, params) do
    offset = String.to_integer(Map.get(params, "offset", "0"))
    limit = String.to_integer(Map.get(params, "limit", "10"))
    {:ok, ids} = Timeline.public(conn.assigns[:current_user].id, offset, offset+limit-1)
    IO.inspect ids
    query =
      from p in Post,
      where: p.id in ^ids

    posts = Repo.all(query)
    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    changeset =
      Post.changeset(%Post{}, post_params)
      |> Ecto.Changeset.put_assoc(:author, conn.assigns[:current_user])

    case Repo.insert(changeset) do
      {:ok, post} ->
        Chronicler.record(post)
        conn
        |> put_status(:created)
        |> put_resp_header("location", post_path(conn, :show, post))
        |> render("show.json", post: post)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Timelinex.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    render(conn, "show.json", post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get!(Post, id) |> Repo.preload([:hashtags, :mentioned_users])
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        render(conn, "show.json", post: post)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Timelinex.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    send_resp(conn, :no_content, "")
  end
end
