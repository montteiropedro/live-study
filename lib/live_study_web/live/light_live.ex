defmodule LiveStudyWeb.LightLive do
  use LiveStudyWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Front Porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style={"width: #{@brightness}%"}>
          <%= @brightness %>%
        </span>
      </div>

      <button phx-click="off">
        <img src="/images/light-off.svg" alt="light off">
      </button>

      <button phx-click="down">
        <img src="/images/down.svg" alt="down light">
      </button>

      <button phx-click="up">
        <img src="/images/up.svg" alt="up light">
      </button>

      <button phx-click="on">
        <img src="/images/light-on.svg" alt="light on">
      </button>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, brightness: 10)}
  end

  @impl true
  def handle_event("on", _params, socket) do
    {:noreply, assign(socket, brightness: 100)}
  end

  def handle_event("up", _params, socket) do
    {:noreply, update(socket, :brightness, &(&1 + 10))}
  end

  def handle_event("down", _params, socket) do
    {:noreply, update(socket, :brightness, &(&1 - 10))}
  end

  def handle_event("off", _params, socket) do
    {:noreply, assign(socket, brightness: 0)}
  end
end
