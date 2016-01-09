defmodule Whisper.PostTest do
  use Whisper.ModelCase

  alias Whisper.Post

  @valid_attrs %{title: "Awesome Elixir", url: "https://awesome-elixir.com"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?
  end
end
