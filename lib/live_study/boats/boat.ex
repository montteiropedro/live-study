defmodule LiveStudy.Boats.Boat do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:model, :type, :price, :image]
  @optional_fields []

  schema "boats" do
    field :type, :string
    field :image, :string
    field :model, :string
    field :price, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(boat, attrs) do
    boat
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
