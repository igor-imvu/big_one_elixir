defmodule Timelinex.Repo.Migrations.CreateMention do
  use Ecto.Migration

  def change do
    create table(:mentions) do
      add :post_id, references(:posts, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
    end
    create index(:mentions, [:post_id])
    create index(:mentions, [:user_id])

  end
end
