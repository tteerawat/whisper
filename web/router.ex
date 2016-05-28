defmodule Whisper.Router do
  use Whisper.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Whisper.Auth, repo: Whisper.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Whisper do
    pipe_through [:browser] # Use the default browser stack

    get "/", PostController, :index
    resources "/posts", PostController
    resources "/users", UserController, only: [:show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  forward "/beaker", Beaker.Web

  scope "/api", Whisper.Api do
    pipe_through :api

    resources "/posts", PostController, only: [:index]
  end
end
