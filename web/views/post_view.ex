defmodule Whisper.PostView do
  use Whisper.Web, :view

  def post_icon(post) do
    if post.favorite do
      "fa fa-heart heart"
    else
      "fa fa-heart-o"
    end
  end
end
