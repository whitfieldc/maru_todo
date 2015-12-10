defmodule MaruTodo.Router.Homepage do
  use Maru.Router
  import Ecto.Query
  import Ecto.Changeset

  alias MaruTodo.Task
  alias MaruTodo.Repo
  alias Maru.Response
  namespace :tasks do
    get do
      query = (from t in Task, select: t)
      |> Repo.all
      |> Response.resp_body
    end

    post do
      body = fetch_req_body
      changeset = Task.changeset(%Task{}, body.body_params)
      case Repo.insert(changeset) do
        {:ok, task} ->
          task_id = task.id |> Integer.to_string
          task_url = "http://localhost:8880/tasks/" <> task_id
          optimistic_update = %{
            title: task.title,
            completed: task.completed,
            order: task.order,
            id: task.id,
            url: task_url
          }
          Response.resp_body(optimistic_update)
        {:error, changeset} ->
          status(400)
      end
    end

    delete do
      case Repo.delete_all(Task) do
        {_number, nil} ->
          status(200)
          Response.resp_body("[]")
        _ ->
          status(500)
          "Delete Failed"
      end
    end

    route_param :task_id do

      get do
        MaruTodo.Task
        |> Repo.get(params[:task_id])
        |> Response.resp_body
      end

      patch do
        body = fetch_req_body.body_params
        task = MaruTodo.Task |> Repo.get(params[:task_id])
        patch_changeset = Task.changeset(task, body)

        case MaruTodo.Repo.update(patch_changeset) do
          {:ok, model} ->
            Response.resp_body(model)
          {:error, changeset} ->
            changeset
        end
      end

      delete do
        dead_task = MaruTodo.Task |> Repo.get(params[:task_id])
        case Repo.delete(dead_task) do
          {:ok, model} ->
            status(200)
            Response.resp_body(model)
          _ ->
            status(500)
            "Delete Failed"
        end
      end

    end
  end
end
