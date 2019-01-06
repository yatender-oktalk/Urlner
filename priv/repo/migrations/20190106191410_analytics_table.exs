defmodule Urlner.Repo.Migrations.AnalyticsTable do
  use Ecto.Migration

  def up do
    create table(:analytics) do
      add :headers, :map
      add :params, :map
      timestamps()
    end
  end

  def down do
    drop table(:analytics)
  end
end
