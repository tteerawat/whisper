defmodule Whisper.Post do
  use Whisper.Web, :model

  schema "posts" do
    field :title, :string
    field :url, :string
    field :favorite, :boolean
    belongs_to :user, Whisper.User

    timestamps
  end

  @required_fields ~w(title url)
  @optional_fields ~w(favorite)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:url, ~r/^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/)
  end
end
