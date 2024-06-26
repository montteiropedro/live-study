defmodule LiveStudyWeb.SalesLive do
  use LiveStudyWeb, :live_view

  alias LiveStudy.Sales

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok, assign_stats(socket)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Snappy Sales 📊</h1>

    <div id="sales">
      <div class="stats">
        <div class="stat">
          <span class="value"><%= @new_orders %></span>
          <span class="label">New Orders</span>
        </div>

        <div class="stat">
          <span class="value">$<%= @sales_amount %></span>
          <span class="label">Sales Amount</span>
        </div>

        <div class="stat">
          <span class="value"><%= @satisfaction %>%</span>
          <span class="label">Satisfaction</span>
        </div>
      </div>

      <button phx-click="refresh">
        <img src="/images/refresh.svg" alt="refresh"> Refresh
      </button>
    </div>
    """
  end

  @impl true
  def handle_info(:tick, socket) do
    {:noreply, assign_stats(socket)}
  end

  @impl true
  def handle_event("refresh", _params, socket) do
    {:noreply, assign_stats(socket)}
  end

  defp assign_stats(socket) do
    assign(socket,
      new_orders: Sales.new_orders(),
      sales_amount: Sales.sales_amount(),
      satisfaction: Sales.satisfaction()
    )
  end
end
