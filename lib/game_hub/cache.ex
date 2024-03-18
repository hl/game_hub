defmodule GameHub.Cache do
  @moduledoc """
  General Cache
  """

  use Nebulex.Cache,
    otp_app: :game_hub,
    adapter: Nebulex.Adapters.Local

  def cache(_mod, _fun, _arg) do
    Application.get_env(:game_hub, :nebulex_cache, __MODULE__)
  end
end
