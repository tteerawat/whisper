defmodule Whisper.PostView do
  use Whisper.Web, :view

  def render("index.json", %{posts: posts}) do
    render_many(posts, Whisper.PostView, "show.json")
  end

  def render("show.json", %{post: post}) do
    %{ title: post.title, url: post.url, favorite: post.favorite }
  end

  def post_icon(post) do
    if post.favorite do
      "fa fa-heart heart"
    else
      "fa fa-heart-o"
    end
  end

  def post_url(post) do
    url = post.url
    if String.length(url) <= 50 do
      url
    else
      String.slice(url, 0, 46) <> "..."
    end
  end

  def check_user(user, post, fun) do
    if user.id == post.user_id do
      fun.()
    end
  end

  def query_params(conn) do
    conn.params["q"]
  end
end
