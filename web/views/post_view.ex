defmodule Whisper.PostView do
  use Whisper.Web, :view

  def render("index.json", %{posts: posts}) do
    render_many(posts, __MODULE__, "show.json")
  end

  def render("show.json", %{post: post}) do
    %{
      title: post.title,
      url: post.url,
      inserted_at: to_string(post.inserted_at),
    }
  end
end
