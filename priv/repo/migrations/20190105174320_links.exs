defmodule Urlner.Repo.Migrations.Links do
  use Ecto.Migration

  def up do
    create table(:links) do
      add :code, :string
      add :url, :string
      add :uid, :string
      add :is_active, :boolean
      add :expire_time, :naive_datetime
      timestamps()
    end
    create unique_index(:links, [ :code])
  end

  def down do
    drop table(:links)
  end

end
