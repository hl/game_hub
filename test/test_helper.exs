ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(GameHub.Repo, :manual)

Mox.defmock(GameHub.MockIGDB, for: GameHub.IGDB)
Application.put_env(:game_hub, :client, GameHub.MockIGDB)
