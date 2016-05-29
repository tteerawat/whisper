defmodule Whisper.Api.PostController do
  use Whisper.Web, :controller

  alias Whisper.Post

  def index(conn, _) do
    posts = Post |> order_by(desc: :inserted_at) |> Repo.all
    render(conn, Whisper.PostView, "index.json", posts: posts)
  end
end
