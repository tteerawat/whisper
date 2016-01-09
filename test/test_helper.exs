ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Whisper.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Whisper.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Whisper.Repo)
