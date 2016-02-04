defmodule Whisper.Repo do
  use Ecto.Repo, otp_app: :whisper
  use Beaker.Integrations.Ecto
end
