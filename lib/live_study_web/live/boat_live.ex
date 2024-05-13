defmodule LiveStudyWeb.BoatLive do
  use LiveStudyWeb, :live_view

  alias LiveStudy.Boats

  import LiveStudyWeb.CustomComponents

  @impl true
  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        filter: %{type: "", prices: []},
        boats: Boats.list_boats()
      )

    {:ok, socket, temporary_assigns: [boats: []]}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Daily Boat Rentals</h1>

    <.promo expiration={2}>
      Save 25% on rentals!
      <:legal>
        <.icon name="hero-exclamation-circle" />
        Limit 1 per party
      </:legal>
    </.promo>

    <div id="boats">
      <.filter_form filter={@filter} />

      <div class="boats">
        <.boat :for={boat <- @boats} boat={boat} />
      </div>
    </div>

    <.promo>
      Hurry, only 3 boats left!
      <:legal>
        Excluding weekends
      </:legal>
    </.promo>
    """
  end

  attr :filter, :map, required: true

  def filter_form(assigns) do
    ~H"""
    <form phx-change="filter">
      <div class="filters">
        <select name="type">
          <%= Phoenix.HTML.Form.options_for_select(
            type_options(),
            @filter.type
          ) %>
        </select>

        <div class="prices">
          <%= for price <- ["$", "$$", "$$$"] do %>
            <input
              type="checkbox"
              name="prices[]"
              value={price}
              id={price}
              checked={price in @filter.prices}
            >
            <label for={price}><%= price %></label>
          <% end %>
          <input type="hidden" name="prices[]" value="">
        </div>
      </div>
    </form>
    """
  end

  attr :boat, LiveStudy.Boats.Boat, required: true

  def boat(assigns) do
    ~H"""
    <div class="boat">
      <img src={@boat.image} alt="boat picture">
      <div class="content">
        <div class="model"><%= @boat.model %></div>
        <div class="details">
          <span class="price"><%= @boat.price %></span>
          <span class="type"><%= @boat.type %></span>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("filter", %{"type" => type, "prices" => prices}, socket) do
    filter = %{type: type, prices: prices}
    boats = Boats.list_boats(filter)

    {:noreply, assign(socket, boats: boats, filter: filter)}
  end

  defp type_options do
    [
      "All Types": "",
      Fishing: "fishing",
      Sporting: "sporting",
      Sailing: "sailing"
    ]
  end
end