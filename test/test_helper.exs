ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Dojo.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Dojo.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Dojo.Repo)

