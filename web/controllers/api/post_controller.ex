defmodule Whisper.Api.PostController do
  use Whisper.Web, :controller

  alias Whisper.Post

  def index(conn, _) do
    render(conn, Whisper.PostView, "index.json", posts: Repo.all(Post))
  end
end
