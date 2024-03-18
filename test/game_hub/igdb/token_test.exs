defmodule GameHub.IGDB.TokenTest do
  @moduledoc false

  use ExUnit.Case

  alias GameHub.IGDB.Token

  import Mox

  describe "get_credentials/0" do
    setup _ do
      set_mox_global()
      verify_on_exit!()

      client_id = "client_id"
      client_secret = "client_secret"

      expect(GameHub.MockIGDB, :oauth2, 1, fn ^client_id, ^client_secret ->
        access_token = "access-token#{System.unique_integer()}"
        {:ok, %{"access_token" => access_token, "expires_in" => 5_587_808, token_type: "bearer"}}
      end)

      start_supervised!({Token, [client_id: client_id, client_secret: client_secret]})

      %{client_id: client_id}
    end

    test "get the credentials from the token server", %{client_id: client_id} do
      {^client_id, _access_token} = Token.get_credentials()
    end
  end
end
