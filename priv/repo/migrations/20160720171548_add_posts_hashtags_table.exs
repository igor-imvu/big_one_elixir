defmodule Timelinex.Repo.Migrations.AddPostsHashtagsTable do
  use Ecto.Migration

  def change do
    create table(:posts_hashtags) do
      add :post_id, references(:posts, on_delete: :delete_all)
      add :hashtag_id, references(:hashtags, on_delete: :delete_all)
    end

    create index(:posts_hashtags, [:post_id])
    create index(:posts_hashtags, [:hashtag_id])
  end
end
