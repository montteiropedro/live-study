defmodule LiveStudy.Desks.Desk do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name, :photo_locations]
  @optional_fields []

  schema "desks" do
    field :name, :string
    field :photo_locations, {:array, :string}, default: []

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(desk, attrs) do
    desk
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
