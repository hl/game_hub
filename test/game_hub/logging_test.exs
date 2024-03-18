defmodule GameHub.LoggingTest do
  @moduledoc false

  use GameHub.DataCase

  alias GameHub.Logging

  test "create an api log" do
    name = "test"
    opts = %{hello: "world"}

    {:ok, api_log} = Logging.create_api_log(name, opts)

    assert api_log.name == name
    assert api_log.opts == opts
  end
end
