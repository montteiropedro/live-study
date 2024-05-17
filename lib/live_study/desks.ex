defmodule LiveStudy.Desks do
  @moduledoc """
  The Desks context.
  """

  alias LiveStudy.Desks.Desk
  alias LiveStudy.Repo

  import Ecto.Query, warn: false

  def subscribe do
    Phoenix.PubSub.subscribe(LiveStudy.PubSub, "desks")
  end

  def broadcast({:ok, desk}, tag) do
    Phoenix.PubSub.broadcast(LiveStudy.PubSub, "desks", {tag, desk})
    {:ok, desk}
  end

  def broadcast({:error, _reason} = error, _tag), do: error

  @doc """
  Returns the list of desks.

  ## Examples

      iex> list_desks()
      [%Desk{}, ...]

  """
  def list_desks do
    Repo.all(from d in Desk, order_by: [desc: d.id])
  end

  @doc """
  Gets a single desk.

  Raises `Ecto.NoResultsError` if the Desk does not exist.

  ## Examples

      iex> get_desk!(123)
      %Desk{}

      iex> get_desk!(456)
      ** (Ecto.NoResultsError)

  """
  def get_desk!(id), do: Repo.get!(Desk, id)

  @doc """
  Creates a desk.

  ## Examples

      iex> create_desk(%{field: value})
      {:ok, %Desk{}}

      iex> create_desk(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_desk(attrs \\ %{}) do
    %Desk{}
    |> Desk.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:desk_created)
  end

  @doc """
  Updates a desk.

  ## Examples

      iex> update_desk(desk, %{field: new_value})
      {:ok, %Desk{}}

      iex> update_desk(desk, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_desk(%Desk{} = desk, attrs) do
    desk
    |> Desk.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a desk.

  ## Examples

      iex> delete_desk(desk)
      {:ok, %Desk{}}

      iex> delete_desk(desk)
      {:error, %Ecto.Changeset{}}

  """
  def delete_desk(%Desk{} = desk) do
    Repo.delete(desk)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking desk changes.

  ## Examples

      iex> change_desk(desk)
      %Ecto.Changeset{data: %Desk{}}

  """
  def change_desk(%Desk{} = desk, attrs \\ %{}) do
    Desk.changeset(desk, attrs)
  end
end
