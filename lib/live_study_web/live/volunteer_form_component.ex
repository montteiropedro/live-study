defmodule LiveStudyWeb.VolunteerFormComponent do
  use LiveStudyWeb, :live_component

  alias LiveStudy.Volunteers
  alias LiveStudy.Volunteers.Volunteer

  @impl true
  def mount(socket) do
    changeset = Volunteers.change_volunteer(%Volunteer{})

    {:ok, assign_form(socket, changeset)}
  end

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(:count, assigns.count + 1)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div class="count">
        Go for it! You'll be volunteer #<%= @count %>
      </div>

      <.form for={@form} phx-change="validate" phx-submit="submit" phx-target={@myself}>
        <.input
          field={@form[:name]}
          placeholder="Name"
          autocomplete="off"
          phx-debounce="2000"
        />
        <.input
          field={@form[:phone]}
          type="tel"
          placeholder="Phone"
          autocomplete="off"
          phx-debounce="blur"
        />
        <.button>
          Check In
        </.button>
      </.form>
    </div>
    """
  end

  @impl true
  def handle_event("validate", %{"volunteer" => volunteer_params}, socket) do
    changeset =
      %Volunteer{}
      |> Volunteers.change_volunteer(volunteer_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("submit", %{"volunteer" => volunteer_params}, socket) do
    case Volunteers.create_volunteer(volunteer_params) do
      {:ok, _volunteer} ->
        changeset = Volunteers.change_volunteer(%Volunteer{})

        {:noreply, assign_form(socket, changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, changeset) do
    assign(socket, form: to_form(changeset))
  end
end
