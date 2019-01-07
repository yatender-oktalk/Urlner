defmodule Urlner.Link.Model do
  use Urlner, :model
  Application.ensure_all_started(:timex)
  alias Urlner.{
    Repo
  }

  alias Urlner.Link.{
    Model
  }
  @default_active_days 30
  # macros to generate function which will be called dynamically.
  require Urlner.LinkMacros
  Urlner.LinkMacros.generate_dao([:code, :url])

  @primary_key {:id, :id, autogenerate: true}
  schema "links" do
    field(:code, :string)
    field(:url, :string)
    field(:uid, :string, default: nil)
    field(:is_active, :boolean, default: true)
    field(:expire_time, Timex.Ecto.DateTime, default: Timex.shift(Timex.now(), days: @default_active_days))
    timestamps()
  end

  # def get_code_2(_val) do
  #   {:ok, %{
  #     url: "http://example.com/about/index.html",
  #     uid: 12345
  #   }}
  # end

  def get_url_uid({url, _uid}) do
    query =
      from(u in Model,
        where:
          u.url == ^url and u.is_active == true and u.expire_time > ^Timex.now(),
        select: u.code
      )

    execute_one(query)
  end

  def insert_link(url, code, uid) do
    # changeset and insert link with code
    changeset(%Urlner.Link.Model{},
      %{
        code: code,
        url: url,
        uid: uid
      }
    ) |> Repo.insert()
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

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:code, :url, :uid, :is_active])
  end

end
