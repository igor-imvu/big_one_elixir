defmodule Timelinex.Post do
  use Timelinex.Web, :model

  schema "posts" do
    field :content, :string
    field :context, :string
    belongs_to :author, Timelinex.User
    belongs_to :parent, Timelinex.Post

    has_many :comments, Timelinex.Post, foreign_key: :parent_id, references: :id

    many_to_many :mentioned_users, Timelinex.User, join_through: "mentions", on_replace: :delete
    many_to_many :hashtags, Timelinex.Hashtag, join_through: "posts_hashtags", on_replace: :delete

    timestamps()
  end

  def filtered(query, params) do
    query
    |> paginated(params)
    |> search(params)
    |> desc_ordered
  end

  def paginated(query, params) do
    Ecto.Query.from p in query,
               offset: ^Map.get(params, "offset", 0),
               limit:  ^Map.get(params, "limit", 10)
  end

  def search(query, %{"text" => text}) do
    Ecto.Query.from p in query, where: ilike(p.content, ^("%" <> text <> "%"))
  end
  def search(query, _), do: query

  def desc_ordered(query), do:
    Ecto.Query.from p in query,
               order_by: [desc: p.inserted_at]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content, :context], [:parent_id])
    |> validate_required([:content, :context])
    |> validate_comment(:parent_id, message: "Can't comment non-root post!")
    # TODO: move the logic below to controller
    |> build_assoc_hashtags
    |> build_assoc_mentions
  end

  def validate_comment(changeset, field, opts \\ []) do
    validate_change changeset, field, fn _, value ->
      parent_post = Timelinex.Repo.get(Timelinex.Post, value)
      valid? = parent_post.parent_id == nil
      if valid?, do: [], else: [{field, opts[:message] || "is invalid"}]
    end
  end

  defp build_assoc_hashtags(changeset) do
    case get_change(changeset, :content) do
      nil ->
        changeset
      content ->
        hashtags_assoc =
          content
          |> extract_hashtags
          |> Enum.map(&Timelinex.Hashtag.find_or_create_assoc(&1))
        changeset
          |> put_assoc(:hashtags, hashtags_assoc)
    end
  end

  defp extract_hashtags(text) do
    String.split(text, " ")
    |> Enum.reject(&(!String.starts_with?(&1, "#")))
  end

  defp build_assoc_mentions(changeset) do
    case get_change(changeset, :content) do
      nil ->
        changeset
      content ->
        mentions_assoc =
          content
          |> extract_mentions
          |> build_mentioned_users_assoc
        changeset
          |> put_assoc(:mentioned_users, mentions_assoc)
    end
  end

  defp extract_mentions(text) do
    String.split(text, " ")
    |> Enum.reject(&(!String.starts_with?(&1, "@")))
    |> Enum.map(&(String.slice(&1, 1..-1)))
  end

  defp build_mentioned_users_assoc(mentions) do
    from(u in Timelinex.User, where: u.user_name in ^mentions)
    |> Timelinex.Repo.all
    |> Enum.map(&Ecto.Changeset.change/1)
  end
end
