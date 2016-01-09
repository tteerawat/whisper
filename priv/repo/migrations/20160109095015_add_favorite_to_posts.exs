defmodule Whisper.Repo.Migrations.AddFavoriteToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :favorite, :boolean, default: false
    end
  end
end
