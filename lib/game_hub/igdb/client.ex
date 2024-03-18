defmodule GameHub.IGDB.Client do
  @moduledoc """
  API Client

  A basic API client that handles the calls to IGDB.
  Error handling has been kept to a minimum due to
  this being an assignment.
  """

  @behaviour GameHub.IGDB

  alias GameHub.IGDB.Token

  require Logger

  @oauth_url "https://id.twitch.tv/oauth2/token"
  @base_url "https://api.igdb.com/v4"

  @impl GameHub.IGDB
  def oauth2(client_id, client_secret) do
    json = %{
      grant_type: "client_credentials",
      client_id: client_id,
      client_secret: client_secret
    }

    case Req.post(@oauth_url, json: json) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %Req.Response{status: 400}} ->
        {:error, "client_id or client_secret missing"}

      unmatched_response ->
        Logger.error(inspect(unmatched_response))
        {:error, "unknown"}
    end
  end

  @impl GameHub.IGDB
  def post(endpoint, opts) do
    {client_id, access_token} = Token.get_credentials()

    headers = %{
      "Client-ID" => client_id,
      "Authorization" => "Bearer #{access_token}"
    }

    query =
      "fields #{Keyword.get(opts, :fields, "*")}; " <>
        "limit #{Keyword.get(opts, :limit, 10)}; " <>
        "offset #{Keyword.get(opts, :offset, 0)};" <>
        "sort id asc;"

    case Req.post(@base_url <> endpoint, headers: headers, body: query) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        {:ok, body}

      unmatched_response ->
        Logger.error(inspect(unmatched_response))
        {:error, "unknown"}
    end
  end
end
