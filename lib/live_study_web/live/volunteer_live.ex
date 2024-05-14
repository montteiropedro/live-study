defmodule LiveStudyWeb.VolunteerLive do
  use LiveStudyWeb, :live_view

  alias LiveStudy.Volunteers

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Volunteers.subscribe()
    end

    volunteers = Volunteers.list_volunteers()

    socket =
      socket
      |> stream(:volunteers, volunteers)
      |> assign(:count, length(volunteers))

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Volunteer Check-In</h1>

    <div id="volunteer-checkin">
      <.live_component
        module={LiveStudyWeb.VolunteerFormComponent}
        id={:new}
        count={@count}
      />

      <div id="volunteers" phx-update="stream">
        <.volunteer
          :for={{volunteer_dom_id, volunteer} <- @streams.volunteers}
          id={volunteer_dom_id}
          volunteer={volunteer}
        />
      </div>
    </div>
    """
  end

  def volunteer(assigns) do
    ~H"""
    <div
      id={@id}
      class={"volunteer #{if @volunteer.checked_out, do: "out"}"}
    >
      <div class="name"><%= @volunteer.name %></div>
      <div class="phone"><%= @volunteer.phone %></div>
      <div class="status">
        <button phx-disabled-with="Checking In..." phx-click="toggle-status" phx-value-id={@volunteer.id}>
          <%= if @volunteer.checked_out, do: "Check In", else: "Check Out" %>
        </button>
      </div>
    </div>
    """
  end

  @impl true
  def handle_info({:volunteer_created, volunteer}, socket) do
    socket =
      socket
      |> update(:count, &(&1 + 1))
      |> stream_insert(:volunteers, volunteer, at: 0)

    {:noreply, socket}
  end

  def handle_info({:volunteer_updated, volunteer}, socket) do
    {:noreply, stream_insert(socket, :volunteers, volunteer)}
  end

  @impl true
  def handle_event("toggle-status", %{"id" => id}, socket) do
    volunteer = Volunteers.get_volunteer!(id)

    {:ok, _volunteer} = Volunteers.update_volunteer(
      volunteer,
      %{checked_out: !volunteer.checked_out}
    )

    {:noreply, socket}
  end
end
