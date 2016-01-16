defmodule Whisper.UserTest do
  use Whisper.ModelCase

  alias Whisper.User

  test "that user can't be created with blank email or password" do
    changeset = User.registration_changeset(%User{}, %{})

    refute changeset.valid?
    assert changeset.errors[:email] == "can't be blank"
    assert changeset.errors[:password] == "can't be blank"
  end

  test "that user can't be created with invalid email" do
    changeset = User.registration_changeset(%User{},
      %{email: "helloworld", password: "1qazxsw2"})

    refute changeset.valid?
    assert changeset.errors[:email] == "has invalid format"
  end

  test "that password must contains at least 8 characters" do
    changeset = User.registration_changeset(%User{},
      %{email: "test@gmail.com", password: "123"})

    refute changeset.valid?
    assert changeset.errors[:password] == {"should be at least %{count} character(s)", [count: 8]}
  end

  test "that user can be created" do
    changeset = User.registration_changeset(%User{},
      %{email: "test@gmail.com", password: "12345678"})

    assert changeset.valid?
  end
end
