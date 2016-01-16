defmodule Whisper.SessionController do
  use Whisper.Web, :controller

  plug :check_if_already_logged_in? when action in [:new]

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Whisper.Auth.login_by_email_and_password(conn, email, password, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back! #{email}")
        |> redirect(to: post_path(conn, :index))
      {:error, _reason, _conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Whisper.Auth.logout
    |> put_flash(:info, "You have benn logged out")
    |> redirect(to: session_path(conn, :new))
  end
end
