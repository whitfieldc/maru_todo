defmodule MaruTodo.Router.Homepage do
  use Maru.Router

  helpers do
    alias MaruTodo.Task, warn: false
    alias MaruTodo.Repo, warn: false
    import Ecto.Query, warn: false
  end

  namespace :tasks do
    get do
      query = (from t in Task, select: t)
      tasks = query |> Repo.all
      json conn, tasks
    end

    params do
      requires :title,     type: String
      optional :order,     type: Integer
      optional :completed, type: Boolean, default: false
    end
    post do
      changeset = Task.changeset(%Task{}, params)
      case Repo.insert(changeset) do
        {:ok, task} ->
          # IO.inspect(task)
          # json conn, %{
          #   title: task.title,
          #   completed: task.completed,
          #   order: task.order,
          #   id: task.id,
          #   url: "http://localhost:8880/tasks/#{task.id}",
          # }
          json conn, task
        {:error, _changeset} ->
          conn
          |> put_status(400)
          |> text("Insert Failed")
      end
    end

    delete do
      case Repo.delete_all(Task) do
        {_number, nil} ->
          json conn, []
        _ ->
          conn
          |> put_status(500)
          |> text("Delete Failed")
      end
    end

    route_param :task_id do
      get do
        IO.puts("HELLOOOOO")
        task = MaruTodo.Task
          |> IO.inspect
          |> Repo.get(params[:task_id])
        json conn, task
      end

      params do
        optional :title,     type: String
        optional :order,     type: Integer
        optional :completed, type: Boolean
        at_least_one_of [:title, :order, :completed]
      end
      patch do
        # Next version of Maru will NOT keep nil params
        changeset =
          params |> Enum.filter(fn
            {_, nil} -> false
            _        -> true
          end) |> Enum.into(%{})
        task = MaruTodo.Task |> Repo.get(params[:task_id])
        patch_changeset = Task.changeset(task, changeset)

        case MaruTodo.Repo.update(patch_changeset) do
          {:ok, task} ->
            json conn, task
          {:error, _changeset} ->
            conn
            |> put_status(500)
            |> text("Update Failed")
        end
      end

      delete do
        dead_task = MaruTodo.Task |> Repo.get(params[:task_id])
        case Repo.delete(dead_task) do
          {:ok, task} ->
            json conn, task
          _ ->
            conn
            |> put_status(500)
            |> text("Delete Failed")
        end
      end

    end
  end
end
