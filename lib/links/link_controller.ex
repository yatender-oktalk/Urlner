defmodule Urlner.Link.Controller do
  use Urlner, :controller

  alias Urlner.Link.{
    Helpers
  }
  alias Urlner.Analytics
  alias Urlner.Analytics.Model.Postgres, as: Analytics

  def index(conn, params) do
    headers = Enum.into(conn.req_headers, %{})
    spawn(fn -> Analytics.insert_item(headers, params) end)
    conn |> send_resp(Helpers.get_link(params["url"]))
  end

  def create(conn, params) do
    conn |> send_resp(Helpers.create_link(params["url"]))
  end

  def health(conn, params) do
    send_resp(conn, {:ok, "health is fine"})
  end

  defp send_resp(conn, res) do
    {status, response} =
      case res do
        {:ok, resp} ->

          {200, resp}
        {:error, resp} -> {400, resp}
      end
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(%{resp: response}))
  end
end
