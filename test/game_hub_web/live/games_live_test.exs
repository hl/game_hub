defmodule GameHubWeb.GamesLiveTest do
  @moduledoc false

  use GameHubWeb.ConnCase

  import Mox
  import Phoenix.LiveViewTest

  setup :verify_on_exit!

  defp build_game(_) do
    id = System.unique_integer([:positive])
    %{game: %{"id" => id, "name" => "game#{id}"}}
  end

  describe "Index" do
    setup [:build_game]

    test "lists all games", %{conn: conn, game: game} do
      expect(GameHub.MockIGDB, :post, 2, fn "/games", _opts ->
        {:ok, [game]}
      end)

      {:ok, _index_live, html} = live(conn, ~p"/games")

      assert html =~ "Listing Games"
      assert html =~ game["name"]
    end
  end
end
