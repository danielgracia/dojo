defmodule Dojo.Message do
  use Dojo.Web, :model

  schema "messages" do
    field :user_name, :string
    field :content, :string

    timestamps
  end

  @required_fields ~w(user_name content )
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
  def presente(model) do
    "<#{model.user_name}>: #{model.content}" 
  end
end
