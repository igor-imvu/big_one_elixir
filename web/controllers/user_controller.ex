defmodule Timelinex.UserController do
  use Timelinex.Web, :controller

  alias Timelinex.{User, Subscription, Block}

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def subscribe(conn, %{"user_id" => id, "target_user_id" => target_id}) do
    source_user = Repo.get!(User, id)
    target_user = Repo.get!(User, target_id)
    {:ok, result} = Subscription.subscribe(source_user.id, target_user.id)

    render(conn, Timelinex.UserView, "debug.json", message: result)

  end

  def unsubscribe(conn, %{"user_id" => id, "target_user_id" => target_id}) do
    source_user = Repo.get!(User, id)
    target_user = Repo.get!(User, target_id)
    {:ok, result} = Subscription.unsubscribe(source_user.id, target_user.id)

    render(conn, Timelinex.UserView, "debug.json", message: result)

  end

  def block_user(conn, %{"user_id" => id, "blocked_user_id" => blocked_id}) do
    source_user = Repo.get!(User, id)
    target_user = Repo.get!(User, blocked_id)
    {:ok, result} = Block.block(source_user.id, target_user.id)
    render(conn, Timelinex.UserView, "debug.json", message: result)
  end

  def block_term(conn, %{"user_id" => id, "blocked_term" => term}) do
    source_user = Repo.get!(User, id)
    {:ok, result} = Block.block(source_user.id, term)
    render(conn, Timelinex.UserView, "debug.json", message: result)
  end

  def unblock_user(conn, %{"user_id" => id, "blocked_user_id" => blocked_id}) do
    source_user = Repo.get!(User, id)
    target_user = Repo.get!(User, blocked_id)
    {:ok, result} = Block.unblock(source_user.id, target_user.id)
    render(conn, Timelinex.UserView, "debug.json", message: result)
  end

  def unblock_term(conn, %{"user_id" => id, "blocked_term" => term}) do
    source_user = Repo.get!(User, id)
    {:ok, result} = Block.unblock(source_user.id, term)
    render(conn, Timelinex.UserView, "debug.json", message: result)
  end


  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Timelinex.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Timelinex.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end
end
