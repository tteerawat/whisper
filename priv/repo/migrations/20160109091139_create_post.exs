defmodule Whisper.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :url, :string

      timestamps
    end

  end
end
