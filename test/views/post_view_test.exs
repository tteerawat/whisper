defmodule Whisper.PostViewTest do
  use Whisper.ConnCase, async: false

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View
  alias Whisper.{Repo, Post, User}

  setup do
    user = Repo.insert!(%User{email: "test@gmail.com", password: "1qazxsw2"})
    post = Repo.insert!(%Post{title: "test title", url: "http://test.com", user_id: user.id})
    {:ok, user: user, post: post}
  end

  test "renders show.json", %{post: post} do
    assert render(Whisper.PostView, "show.json", post: post) ==
      %{title: post.title, url: post.url, inserted_at: Ecto.DateTime.to_string(post.inserted_at)}
  end

  test "renders index.json", %{post: post} do
    assert render(Whisper.PostView, "index.json", posts: [post]) ==
      [%{title: post.title, url: post.url, inserted_at: Ecto.DateTime.to_string(post.inserted_at)}]
  end
end
