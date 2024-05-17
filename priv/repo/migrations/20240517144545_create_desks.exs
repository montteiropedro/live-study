defmodule LiveStudy.Repo.Migrations.CreateDesks do
  use Ecto.Migration

  def change do
    create table(:desks) do
      add :name, :string
      add :photo_locations, {:array, :string}, null: false, default: []

      timestamps(type: :utc_datetime)
    end
  end
end
