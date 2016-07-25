defmodule Timelinex.Router do
  use Timelinex.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :auth
  end

  scope "/api", Timelinex do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit] do
      post "/subscribe", UserController, :subscribe
      post "/unsubscribe", UserController, :unsubscribe
      post "/block_user", UserController, :block_user
      post "/block_term", UserController, :block_term
    end
    resources "/posts", PostController, except: [:new, :edit]
  end

  defp auth(conn, _opts) do
    case conn |> get_req_header("x-imvu-user") |> List.first do
      nil ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(401, Poison.encode!(%{error: "Not allowed"}))
        |> halt()
      user_id ->
        user = Timelinex.Repo.get(Timelinex.User, user_id)
        conn
          |> assign(:current_user, user)
    end
  end

end
