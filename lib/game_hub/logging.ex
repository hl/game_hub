defmodule GameHub.Logging do
  @moduledoc """
  Logging context
  """

  alias GameHub.Logging.APILog
  alias GameHub.Repo

  @doc """
  Creates a new APILog entry
  """
  @spec create_api_log(name :: String.t(), opts :: map()) :: APILog.t()
  def create_api_log(name, opts \\ %{}) do
    api_log = %APILog{name: name, opts: opts}

    Repo.insert(api_log)
  end
end
