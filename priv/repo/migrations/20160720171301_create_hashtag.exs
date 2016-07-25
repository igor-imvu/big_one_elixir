defmodule Timelinex.Repo.Migrations.CreateHashtag do
  use Ecto.Migration

  def change do
    create table(:hashtags) do
      add :title, :string

      timestamps()
    end
    create unique_index(:hashtags, [:title])
  end
end
