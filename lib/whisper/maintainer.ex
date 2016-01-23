defmodule Whisper.Maintainer do
  @urls ["https://whisper1992.herokuapp.com/", "https://m-bucket.herokuapp.com/"]

  use GenServer

  def start_link(number) do
    GenServer.start_link(__MODULE__, number, name: __MODULE__ )
  end

  def init(number) do
    Process.send_after(self, :trigger, 1 * 1000)
    {:ok, number}
  end

  def handle_info(:trigger, number) do
    for url <- @urls do
      HTTPoison.get(url)
    end
    Process.send_after(self, :trigger, 25 * 60 * 1000)
    {:noreply, number + 1}
  end
end
