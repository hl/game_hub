defmodule GameHubWeb.GamesLive do
  use GameHubWeb, :live_view

  alias GameHub.Games

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _uri, socket) do
    current_page =
      case Integer.parse(params["page"] || "1") do
        {page, _rem} -> page
        :error -> 1
      end

    games = Games.list_games(current_page)
    stream_limit = Enum.count(games) * -1

    socket =
      socket
      |> assign(:current_page, current_page)
      |> stream(:games, games, limit: stream_limit)

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.header>
      Listing Games
      <:actions>
        <.button :if={@current_page > 1} phx-click="prev-page">
          Previous page
        </.button>
        <.button phx-click="next-page">Next page</.button>
      </:actions>
    </.header>

    <.table id="games" rows={@streams.games}>
      <:col :let={{_id, game}} label="ID"><%= game.id %></:col>
      <:col :let={{_id, game}} label="Name"><%= game.name %></:col>
    </.table>
    """
  end

  @impl Phoenix.LiveView
  def handle_event("next-page", _params, socket) do
    new_page = socket.assigns.current_page + 1
    {:noreply, change_page(socket, new_page)}
  end

  def handle_event("prev-page", _params, socket) do
    new_page = max(socket.assigns.current_page - 1, 1)
    {:noreply, change_page(socket, new_page)}
  end

  defp change_page(socket, new_page) do
    socket
    |> assign(:current_page, new_page)
    |> push_patch(to: ~p"/games?page=#{new_page}")
  end
end
