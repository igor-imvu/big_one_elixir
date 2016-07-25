defmodule Timelinex.User do
  use Timelinex.Web, :model

  schema "users" do
    field :user_name, :string
    field :display_name, :string
    field :birthday, Ecto.Date
    has_many :posts, Timelinex.Post

    many_to_many :mentions_posts, Timelinex.Post, join_through: "mentions", on_replace: :delete

    timestamps()
  end

  @required_fields ~w(user_name display_name birthday)
  @optional_fields ~w()

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> validate_required([:user_name, :display_name, :birthday])
  end
end
