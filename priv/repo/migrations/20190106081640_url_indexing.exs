defmodule Urlner.Repo.Migrations.UrlIndexing do
  use Ecto.Migration

  def up() do
    create index(:links, [ :url])
  end

  def down() do
    drop_if_exists index(:links, [:url])
  end
end
