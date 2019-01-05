defmodule Urlner.Link.Model do
  use Urlner, :model

  alias Urlner.{
    Repo
  }

  alias Urlner.Link.{
    Model
  }

  @primary_key {:id, :id, autogenerate: true}
  schema "links" do
    field :code, :string
    field :url, :string
    field :uid, :string, default: nil
    field :is_active, :boolean, default: true
    field :expire_time, Timex.Ecto.DateTime
    timestamps()
  end

  def get_code(code) do
    query =
      from u in Model,
      where: u.code == ^code and u.is_active == true and u.expire_time > ^Timex.now(),
      select: u

    query
    |> Repo.one()
    |> send_resp()
  end



  defp send_resp(resp) do
    case resp do
      nil -> {:error, nil}
      _ -> {:ok, resp}
    end
  end
end
