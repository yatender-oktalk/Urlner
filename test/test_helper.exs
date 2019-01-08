ExUnit.start()

Mix.Task.run "ecto.create", ~w(-r Urlner.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Urlner.Repo --quiet)

Ecto.Adapters.SQL.Sandbox.mode(Urlner.Repo, {:shared, self()})
ExUnit.start(exclude: [:pending])
