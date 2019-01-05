defmodule Urlner.LinkController do
  # alias Urlner.Router
  use Urlner, :controller

  def index(conn, _params) do
    # {status, response} =
    #   case PromoModel.get_codes(params) do
    #     {:ok, resp} -> {200, resp}
    #     {:error, resp} -> {400, resp}
    #   end
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{resp: "response"}))
  end

end