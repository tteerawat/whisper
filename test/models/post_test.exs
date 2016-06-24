defmodule Whisper.PostTest do
  use Whisper.ModelCase

  alias Whisper.{Post, User}

  setup do
    user = Repo.insert!(%User{email: "test@gmail.com", password: "1qazxsw2"})
    {:ok, user: user}
  end

  test "that a post can't be created without user_id" do
    changeset = Post.changeset(%Post{},
      %{title: "hello world", url: "http://helloworld.com"})

    refute changeset.valid?
    assert changeset.errors[:user_id] == {"can't be blank", []}
  end

  test "that a post can't be created with blank title or url", %{user: user} do
    changeset =
      user
      |> build_assoc(:posts)
      |> Post.changeset(%{})

    refute changeset.valid?
    assert changeset.errors[:title] == {"can't be blank", []}
    assert changeset.errors[:url] == {"can't be blank", []}
  end

  test "that a post can't be created with invalid url format", %{user: user} do
    changeset =
      user
      |> build_assoc(:posts)
      |> Post.changeset(%{title: "helloworld", url: "helloworld"})

    refute changeset.valid?
    assert changeset.errors[:url] == {"has invalid format", []}
  end

  test "that a post can be created", %{user: user} do
    changeset =
      user
      |> build_assoc(:posts)
      |> Post.changeset(%{title: "helloworld", url: "http://helloworld.com"})

    assert changeset.valid?
  end
end
