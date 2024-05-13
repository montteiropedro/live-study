defmodule LiveStudy.DonationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveStudy.Donations` context.
  """

  @doc """
  Generate a donation.
  """
  def donation_fixture(attrs \\ %{}) do
    {:ok, donation} =
      attrs
      |> Enum.into(%{
        days_until_expires: 42,
        emoji: "some emoji",
        item: "some item",
        quantity: 42
      })
      |> LiveStudy.Donations.create_donation()

    donation
  end
end
