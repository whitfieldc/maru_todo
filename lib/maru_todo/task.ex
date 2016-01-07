defmodule MaruTodo.Task do
  use Ecto.Model
  import Ecto.Changeset

  # after_insert :generate_url_string

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

  # def generate_url_string(task_changeset) do
  #   current_task = task_changeset.model
  #   id_string = task_changeset.model.id |> Integer.to_string
  #   url = "http://localhost:8880/tasks/"<>id_string
  #   url_update_changeset = MaruTodo.Task.changeset(current_task, %{url: url})
  #   case MaruTodo.Repo.update(url_update_changeset) do
  #     {:ok, model} ->
  #       url_update_changeset
  #     {:error, returned_changeset} ->
  #       returned_changeset
  #   end
  # end
end

defimpl Poison.Encoder, for: MaruTodo.Task do
  def encode(model, opts) do
    model
    |> Map.take([:title, :id, :completed, :order])
    # |> IO.inspect
    |> Map.put_new(:url, "#{Application.get_env(:maru_todo, :base_url)}#{model.id}")
    # |> IO.inspect
    |> Poison.Encoder.encode(opts)
    # |> IO.inspect
  end
end