defmodule GameHub.TestCache do
  @moduledoc """
  Cache for use during testing.
  """

  use Nebulex.Cache,
    otp_app: :game_hub,
    adapter: Nebulex.Adapters.Nil
end
