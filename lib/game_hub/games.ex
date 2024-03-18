defmodule GameHub.Games do
  @moduledoc """
  Games context.
  """

  use Nebulex.Caching

  alias GameHub.Games.Game
  alias GameHub.IGDB
  alias GameHub.Logging

  require Logger

  @doc """
  Returns a list of games

  ## Example

    iex> GameHub.Games.list_games()
    [%GameHub.Games.Game{}, ...]

    iex> list_games(2)
    [%GameHub.Games.Game{}, ...]
  """
  @decorate cacheable(cache: {GameHub.Cache, :cache, []}, key: {:list_games, page})
  @spec list_games(page :: non_neg_integer()) :: [Game.t()]
  def list_games(page \\ 1) when is_integer(page) and page > 0 do
    opts = [
      fields: "id,name",
      limit: Game.per_page(),
      offset: (page - 1) * Game.per_page()
    ]

    case IGDB.post("/games", opts) do
      {:ok, response} ->
        Logging.create_api_log("igdb", Map.new(opts))
        Enum.map(response, &Game.new/1)

      {:error, reason} ->
        Logger.error(inspect(reason))
        []
    end
  end
end
