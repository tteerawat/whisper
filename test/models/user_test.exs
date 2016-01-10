defmodule Whisper.UserTest do
  use Whisper.ModelCase

  alias Whisper.User

  @valid_attrs %{email: "test@gmail.com", password: "1qazxsw2"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
