defmodule GameHub.GamesTest do
  @moduledoc false

  use GameHub.DataCase

  import Mox

  setup :verify_on_exit!

  @games_per_page GameHub.Games.Game.per_page()

  defp build_game(_) do
    %{game: %{"id" => 1, "name" => "game1"}}
  end

  defp build_games(_) do
    games =
      for i <- 1..(@games_per_page + 3) do
        %{"id" => i, "name" => "game#{i}"}
      end

    %{games: games}
  end

  describe "list_games/0" do
    setup [:build_game]

    test "return a list of game resources", %{game: game_data} do
      expect(GameHub.MockIGDB, :post, fn "/games", _opts ->
        {:ok, [game_data]}
      end)

      [game] = GameHub.Games.list_games()

      assert game.id == game_data["id"]
    end
  end

  describe "list_games/1" do
    setup [:build_games]

    test "return a list of game resources per page", %{games: games_data} do
      expect(GameHub.MockIGDB, :post, 2, fn "/games", opts ->
        limit = Keyword.fetch!(opts, :limit)
        offset = Keyword.fetch!(opts, :offset)
        {:ok, Enum.slice(games_data, offset, limit)}
      end)

      games1 = GameHub.Games.list_games(1)
      assert Enum.count(games1) == @games_per_page

      games2 = GameHub.Games.list_games(2)
      assert Enum.count(games2) == Enum.count(games_data) - @games_per_page
    end
  end
end
