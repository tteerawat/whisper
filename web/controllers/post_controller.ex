defmodule Whisper.PostController do
  use Whisper.Web, :controller

  alias Whisper.Post

  plug :authenticate_user
  plug :scrub_params, "post" when action in [:create, :update]

  def index(conn, _params, _) do
    render(conn, "index.html")
  end

  def new(conn, _params, user) do
    changeset =
      user
      |> build_assoc(:posts)
      |> Post.changeset
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}, user) do
    changeset =
      user
      |> build_assoc(:posts)
      |> Post.changeset(post_params)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: post_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => post_id}, _user) do
    authorize_user conn, post_id, fn(post) ->
      render(conn, "show.html", post: post)
    end
  end

  def edit(conn, %{"id" => post_id}, _user) do
    authorize_user conn, post_id, fn(post) ->
      changeset = Post.changeset(post)
      render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def update(conn, %{"id" => post_id, "post" => post_params}, _user) do
    authorize_user conn, post_id, fn(post) ->
      changeset = Post.changeset(post, post_params)
      case Repo.update(changeset) do
        {:ok, post} ->
          conn
          |> put_flash(:info, "Post updated successfully.")
          |> redirect(to: post_path(conn, :show, post))
        {:error, changeset} ->
          render(conn, "edit.html", post: post, changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => post_id}, _user) do
    authorize_user conn, post_id, fn(post) ->
      Repo.delete!(post)
      conn
      |> put_flash(:info, "Post deleted successfully.")
      |> redirect(to: post_path(conn, :index))
    end
  end

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  defp authorize_user(conn, post_id, fun) do
    post = Repo.get!(Post, post_id)
    current_user_id = conn.assigns.current_user.id
    if post.user_id != current_user_id do
      conn
      |> put_flash(:error, "Ahem, this is not your post!!!")
      |> redirect(to: post_path(conn, :index))
    else
      fun.(post)
    end
  end
end
