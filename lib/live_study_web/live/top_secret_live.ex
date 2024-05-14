defmodule LiveStudyWeb.TopSecretLive do
  use LiveStudyWeb, :live_view

  # on_mount can be used here as a lifecycle macro. Example:
  #
  # on_mount {LiveStudyWeb.UserAuth, :ensure_authenticated}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="top-secret">
      <img src="/images/spy.svg" alt="spy" />
      <div class="mission">
        <h1>Top Secret</h1>
        <h2>Your Mission</h2>
        <h3>00<%= @current_user.id %></h3>
        <p>
          Storm the castle and capture 3 bottles of Elixir.
        </p>
      </div>
    </div>
    """
  end
end
