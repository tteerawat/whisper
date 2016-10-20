defmodule Whisper.PostView do
  use Whisper.Web, :view

  def render("index.json", %{posts: posts}) do
    render_many(posts, __MODULE__, "show.json")
  end

  def render("show.json", %{post: post}) do
    %{title: post.title, url: post.url, favorite: post.favorite}
  end
end
