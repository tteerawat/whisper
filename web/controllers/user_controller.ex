defmodule Whisper.UserController do
  use Whisper.Web, :controller

  alias Whisper.{User, Post}

  plug :authenticate_user when action in [:show]
  plug :check_if_already_logged_in? when action in [:new]


  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    if conn.assigns.current_user == user do
      render(conn, "show.html",
        user: user_with_posts(user))
    else
      conn
      |> put_flash(:error, "Ahem, this is not you!!!")
      |> redirect(to: post_path(conn, :index))
    end
  end

  defp user_with_posts(user) do
    Repo.preload(user, posts: from(p in Post, order_by: p.inserted_at))
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Whisper.Auth.login(user)
        |> put_flash(:info, "#{user.email} created!")
        |> redirect(to: post_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
