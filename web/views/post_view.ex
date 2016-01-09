defmodule Whisper.PostView do
  use Whisper.Web, :view

  def post_icon(post) do
    if post.favorite do
      "fa fa-heart heart"
    else
      "fa fa-heart-o"
    end
  end

  def post_url(post) do
    String.slice(post.url, 0, 50) <> "..."
  end

  def query_params(conn) do
    conn.params["q"]
  end
end
