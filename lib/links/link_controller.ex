defmodule Urlner.Link.Controller do
  use Urlner, :controller

  alias Urlner.Link.{
    Helpers
  }

  def index(conn, params) do
    conn |> send_resp(Helpers.get_link(params["url"]))
  end

  def create(conn, params) do
    conn |> send_resp(Helpers.create_link(params["url"]))
  end

  defp send_resp(conn, res) do
    {status, response} =
      case res do
        {:ok, resp} -> {200, resp}
        {:error, resp} -> {400, resp}
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{resp: response}))
  end
end
