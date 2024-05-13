defmodule LiveStudy.Donations.Donation do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:item, :emoji, :quantity, :days_until_expires]
  @optional_fields []

  schema "donations" do
    field :item, :string
    field :emoji, :string
    field :quantity, :integer
    field :days_until_expires, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(donation, attrs) do
    donation
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
