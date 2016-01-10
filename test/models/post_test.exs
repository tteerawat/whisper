defmodule Whisper.PostTest do
  use Whisper.ModelCase

  alias Whisper.{Post, User}

  setup do
    user = Repo.insert!(%User{email: "test@gmail.com", password: "1qazxsw2"})

    {:ok, user: user}
  end

  @valid_attrs %{title: "Awesome Elixir", url: "https://awesome-elixir.com"}
  @invalid_attrs %{}

  test "changeset with valid attributes", %{user: user} do
    changeset = Post.changeset(%Post{}, Map.merge(@valid_attrs, %{user_id: user.id}))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?
  end
end
