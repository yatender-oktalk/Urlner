defmodule Urlner.Network.Provider.Tesla do
  @behaviour Urlner.Behaviours.NetworkProvider
  require Logger
  use Tesla

  plug Tesla.Middleware.BaseUrl, "http://localhost:4000"
  # plug Tesla.Middleware.Headers, [{"content-type", "application/json"}]
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Logger

  #expecting path will give response in {:ok, resp} | {:error, reason} format
  def get(path) do
    get(path)
  end

  def post(path, body) do
    case post(path, Jason.encode!(body), headers: [{"content-type", "application/json"}]) do
      {:ok, response} ->
        {:ok, response.body}

      {:error, msg} ->
        {:error, msg}
    end
  end
end
