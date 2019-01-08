defmodule Urlner.Network.Provider.Poison do
  @behaviour Urlner.Behaviours.NetworkProvider
  require Logger

  @baseurl "http://localhost:4000"

  #expecting path will give response in {:ok, resp} | {:error, reason} format
  def get(path) do
    HTTPoison.get(@baseurl<>path)
  end

  def post(path, body) do
    case HTTPoison.post(
      @baseurl <> path,
      Jason.encode!(body),
      ["Content-Type": "application/json"]
    ) do
      {:ok, response} ->
        Jason.decode!(response.body)
      {:error, response} ->
        {:error, response}
    end

  end
end
