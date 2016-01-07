defmodule MaruTodo.Task do
  use Ecto.Model
  import Ecto.Changeset

  schema "tasks" do
    field :title
    field :completed, :boolean, default: false, null: false
    field :url
    field :order, :integer
  end

  @required_fields ~w(title)
  @optional_fields ~w(url completed order)

  def changeset(task, params \\ :empty) do
    task
    |> cast(params, @required_fields, @optional_fields)
  end

end

defimpl Poison.Encoder, for: MaruTodo.Task do
  def encode(model, opts) do
    model
    |> Map.take([:title, :id, :completed, :order])
    |> Map.put_new(:url, "#{Application.get_env(:maru_todo, :base_url)}#{model.id}")
    |> Poison.Encoder.encode(opts)
  end
end