defmodule Timelinex.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :content, :string
      add :context, :string
      add :author_id, references(:users, on_delete: :nothing)
      add :parent_id, references(:posts, on_delete: :nothing)

      timestamps()
    end
    create index(:posts, [:author_id])
    create index(:posts, [:parent_id])

  end
end
