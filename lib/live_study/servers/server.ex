defmodule LiveStudy.Servers.Server do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name, :status, :deploy_count, :size, :framework, :last_commit_message]
  @optional_fields []

  schema "servers" do
    field :name, :string
    field :size, :float
    field :status, :string, default: "down"
    field :deploy_count, :integer, default: 0
    field :framework, :string
    field :last_commit_message, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(server, attrs) do
    server
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
