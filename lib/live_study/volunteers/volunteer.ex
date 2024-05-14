defmodule LiveStudy.Volunteers.Volunteer do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name, :phone]
  @optional_fields [:checked_out]

  @phone_format ~r/^\d{3}[\s-.]?\d{3}[\s-.]?\d{4}$/

  schema "volunteers" do
    field :name, :string
    field :phone, :string
    field :checked_out, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(volunteer, attrs) do
    volunteer
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:name, min: 2, max: 100)
    |> validate_format(:phone, @phone_format, message: "must be a valid phone number")
  end
end
