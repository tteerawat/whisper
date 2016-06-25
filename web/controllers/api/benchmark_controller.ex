defmodule Whisper.Api.BenchmarkController do
  use Whisper.Web, :controller

  def index(conn, _) do
    :timer.sleep(5000)

    json(conn, %{code: "ok"})
  end
end
