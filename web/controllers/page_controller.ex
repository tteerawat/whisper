defmodule Whisper.PageController do
  use Whisper.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
