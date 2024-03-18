defmodule GameHub.IGDB.Token do
  @moduledoc """
  Token manager

  When the Token manager is started it will try to retrieve
  the access_token and the expires_in (seconds) value from the IGDB API.

  When succcesful, it will schedule a message to itself to refresh
  the access_token 60 seconds before it's about to expire.
  """

  use GenServer

  alias GameHub.IGDB

  require Logger

  defstruct access_token: nil,
            client_id: nil,
            client_secret: nil,
            expires_in: 0

  @type t :: %__MODULE__{
          access_token: access_token() | nil,
          client_id: client_id(),
          client_secret: client_secret(),
          expires_in: non_neg_integer()
        }
  @type access_token :: String.t()
  @type client_id :: String.t()
  @type client_secret() :: String.t()

  @spec start_link(Keyword.t()) :: GenServer.on_start()
  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @spec get_credentials() :: {client_id() | nil, access_token() | nil}
  def get_credentials do
    GenServer.call(__MODULE__, :get_credentials)
  end

  @impl GenServer
  def init(init_arg) do
    state = %__MODULE__{
      client_id: Keyword.fetch!(init_arg, :client_id),
      client_secret: Keyword.fetch!(init_arg, :client_secret)
    }

    {:ok, state, {:continue, :fetch_token}}
  end

  @impl GenServer
  def handle_call(:get_credentials, _from, state) do
    {:reply, {state.client_id, state.access_token}, state}
  end

  @impl GenServer
  def handle_continue(:fetch_token, state) do
    state = fetch_token(state)
    schedule_token_refresh(state)
    {:noreply, state}
  end

  @impl GenServer
  def handle_info(:refresh_token, state) do
    state = fetch_token(state)
    schedule_token_refresh(state)
    {:noreply, state}
  end

  defp schedule_token_refresh(state) do
    seconds = max(state.expires_in - 60, 0)
    Process.send_after(self(), :refresh_token, :timer.seconds(seconds))
  end

  defp fetch_token(state) do
    case IGDB.oauth2(state.client_id, state.client_secret) do
      {:ok, token} ->
        %{state | access_token: token["access_token"], expires_in: token["expires_in"] || 0}

      {:error, reason} ->
        Logger.error("Unable to fetch token: #{inspect(reason)}")
        state
    end
  end
end
