defmodule Urlner.Repo.Migrations.Links do
  use Ecto.Migration
  Application.ensure_all_started(:timex)

  def up do
    create table(:links) do
      add :code, :string
      add :url, :string
      add :hash, :string, default: ""
      add :is_active, :boolean
      add :expire_time, :naive_datetime
      timestamps()
    end
    create unique_index(:links, [:code, :hash])
  end

  def down do
    drop table(:links)
  end

end
