defmodule Timelinex.Mention do
  use Timelinex.Web, :model

  schema "mentions" do
    belongs_to :post, Timelinex.Post
    belongs_to :user, Timelinex.User
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
