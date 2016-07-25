defmodule Timelinex.Hashtag do
  use Timelinex.Web, :model

  schema "hashtags" do
    field :title, :string
    many_to_many :posts, Timelinex.Post, join_through: "posts_hashtags"

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end

  def find_or_create_assoc(title) do
    hashtag = Timelinex.Repo.get_by(Timelinex.Hashtag, title: title) || %Timelinex.Hashtag{}
    changeset(hashtag, %{title: title})
  end
end
