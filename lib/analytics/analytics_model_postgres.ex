defmodule Urlner.Analytics.Model.Postgres do
  use Urlner, :model
  alias Urlner.{
    Repo
  }

  @primary_key {:id, :id, autogenerate: true}
  schema "analytics" do
    field(:headers, :map)
    field(:params, :map)
    timestamps()
  end

  def insert_item(header, params) do
    changeset(%Urlner.Analytics.Model.Postgres{}, %{headers: header, params: params})
    |> Repo.insert!()
  end


  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:headers, :params])
  end

end
