defmodule Timelinex.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :user_name, :string
      add :display_name, :string
      add :birthday, :date

      timestamps()
    end
    create unique_index(:users, [:user_name])
  end
end
