defmodule Urlner.Link.Model do
  use Urlner, :model

  alias Urlner.{
    Repo
  }

  alias Urlner.Link.{
    Model
  }

  #macros to generate function which will be called dynamically.
  require Urlner.LinkMacros
  Urlner.LinkMacros.generate_dao([:code, :url])

  @primary_key {:id, :id, autogenerate: true}
  schema "links" do
    field :code, :string
    field :url, :string
    field :uid, :string, default: nil
    field :is_active, :boolean, default: true
    field :expire_time, Timex.Ecto.DateTime
    timestamps()
  end

  # def get_code_2(val) do
  #   query =
  #     from u in Model,
  #     where: u.code == ^val and u.is_active == true and u.expire_time > ^Timex.now(),
  #     select: u

    # execute_one(query)
  # end

  # def get_url(val) do
  #   query =
  #     from u in Model,
  #     where: u.url == ^val and u.is_active == true and u.expire_time > ^Timex.now(),
  #     select: u

  #   execute_one(query)
  # end

  #TODO
  def update_uid(row, uid) do
    #create changeset and update
  end

  def insert_link(link, code, uid) do
    #changeset and insert link with code
  end

  defp execute_one(query) do
    resp =
      query
      |> Repo.one()

    case resp do
      nil ->
        {:error, nil}
      _ ->
        {:ok, resp}
    end
  end

end
