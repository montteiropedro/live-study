defmodule LiveStudyWeb.JugglingLive do
  use LiveStudyWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    images =
      0..18
      |> Enum.map(&String.pad_leading("#{&1}", 2, "0"))
      |> Enum.map(&"juggling-#{&1}.jpg")

    socket =
      assign(socket,
        images: images,
        current: 0,
        is_playing: false,
        timer: nil
      )

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Juggling Key Events</h1>

    <div id="juggling" phx-window-keyup="update">
      <div class="legend">
        k = play/pause, &larr; = previous, &rarr; = next
      </div>

      <img
        src={"/images/juggling/#{Enum.at(@images, @current)}"}
        alt={"juggling #{@current}"}
      />

      <div class="footer">
        <div class="filename">
          <%= Enum.at(@images, @current) %>
        </div>

        <input type="number" value={@current} phx-key="Enter" phx-keyup="set-current" />

        <button phx-click="toggle-playing">
          <%= if @is_playing, do: "Pause", else: "Play" %>
        </button>
      </div>
    </div>
    """
  end

  @impl true
  def handle_info(:tick, socket) do
    {:noreply, assign(socket, :current, next(socket))}
  end

  @impl true
  def handle_event("set-current", %{"key" => "Enter", "value" => value}, socket) do
    {:noreply, assign(socket, :current, String.to_integer(value))}
  end

  def handle_event("update", %{"key" => "k"}, socket) do
    {:noreply, toggle_playing(socket)}
  end

  def handle_event("update", %{"key" => "ArrowLeft"}, socket) do
    {:noreply, assign(socket, :current, previous(socket))}
  end

  def handle_event("update", %{"key" => "ArrowRight"}, socket) do
    {:noreply, assign(socket, :current, next(socket))}
  end

  def handle_event("update", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("toggle-playing", _params, socket) do
    {:noreply, toggle_playing(socket)}
  end

  def toggle_playing(socket) do
    socket = update(socket, :is_playing, fn playing -> !playing end)

    if socket.assigns.is_playing do
      {:ok, timer} = :timer.send_interval(250, self(), :tick)
      assign(socket, :timer, timer)
    else
      {:ok, _} = :timer.cancel(socket.assigns.timer)
      assign(socket, :timer, nil)
    end
  end

  def next(socket) do
    %{current: current, images: images} = socket.assigns
    rem(current + 1, Enum.count(images))
  end

  def previous(socket) do
    %{current: current, images: images} = socket.assigns
    rem(current - 1 + Enum.count(images), Enum.count(images))
  end
end
