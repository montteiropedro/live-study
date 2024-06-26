defmodule LiveStudyWeb.FlightLive do
  use LiveStudyWeb, :live_view

  alias LiveStudy.Flights
  alias LiveStudy.Airports

  @impl true
  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        airport: "",
        flights: [],
        matches: %{},
        loading: false
      )

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Find a Flight</h1>

    <div id="flights">
      <form phx-change="suggest" phx-submit="search">
        <input
          type="text"
          name="airport"
          value={@airport}
          autofocus
          autocomplete="off"
          readonly={@loading}
          list="matches"
          phx-debounce="1000"
        >

        <button>
          <img src="/images/search.svg" alt="search">
        </button>
      </form>

      <datalist id="matches">
        <option :for={{code, name} <- @matches} value={code}>
          <%= name %>
        </option>
      </datalist>

      <div :if={@loading} class="loader">Loading...</div>

      <div class="flights">
        <ul>
          <li :for={flight <- @flights}>
            <div class="first-line">
              <div class="number">
                Flight #<%= flight.number %>
              </div>
              <div class="origin-destination">
                <%= flight.origin %> to <%= flight.destination %>
              </div>
            </div>

            <div class="second-line">
              <div class="departs">
                Departs: <%= flight.departure_time %>
              </div>
              <div class="arrives">
                Departs: <%= flight.arrival_time %>
              </div>
            </div>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  @impl true
  def handle_info({:run_search, airport}, socket) do
    socket =
      assign(socket,
        flights: Flights.search_by_airport(airport),
        loading: false
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("search", %{"airport" => airport}, socket) do
    send(self(), {:run_search, airport})

    socket =
      assign(socket,
        airport: airport,
        flights: [],
        loading: true
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("suggest", %{"airport" => prefix}, socket) do
    {:noreply, assign(socket, matches: Airports.suggest(prefix))}
  end
end
