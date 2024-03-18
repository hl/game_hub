defmodule GameHub.IGDB do
  @moduledoc """
  Client behaviour
  """

  @type access_token :: String.t()
  @type client_id :: String.t()
  @type client_secret() :: String.t()

  @type response :: %{String.t() => term()}
  @type endpoint :: String.t()
  @type opt :: {:fields, String.t()} | {:limit, integer()} | {:offset, integer()}

  @callback oauth2(client_id(), client_secret()) :: {:ok, response()} | {:error, term()}
  @callback post(endpoint(), [opt()]) :: {:ok, response() | [response()]} | {:error, term()}

  def oauth2(client_id, client_secret), do: impl().oauth2(client_id, client_secret)
  def post(endpoint, opts), do: impl().post(endpoint, opts)

  defp impl, do: Application.get_env(:game_hub, :client, GameHub.IGDB.Client)
end
