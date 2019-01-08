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
  Urlner.LinkMacros.generate_dao([:code, :url, :hash])

  @primary_key {:id, :id, autogenerate: true}
  schema "links" do
    field(:code, :string)
    field(:url, :string)
    field(:hash, :string)
    field(:is_active, :boolean, default: true)
    field(:expire_time, Timex.Ecto.DateTime, default: Timex.shift(Timex.now(), days: @default_active_days))
    timestamps()
  end

  def insert_link(url, code, hash) do
    # changeset and insert link with code
    changeset(%Urlner.Link.Model{},
      %{
        code: code,
        url: url,
        hash: hash
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
    |> cast(params, [:code, :url, :hash, :is_active])
  end

end
