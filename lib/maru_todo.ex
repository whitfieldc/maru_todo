defmodule MaruTodo do
	use Application

	def start(_type, _args) do
		import Supervisor.Spec, warn: false

		children = [
			# supervisor(MaruTodo.API, []),
			worker(MaruTodo.Repo, [])
		]
		opts = [strategy: :one_for_one, name: MaruTodo.Supervisor]
    	Supervisor.start_link(children, opts)
	end
end

defmodule MaruTodo.Repo do
	use Ecto.Repo, otp_app: :maru
end

defmodule MaruTodo.Task do
	use Ecto.Model
	import Ecto.Changeset

  after_insert :generate_url_string

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

  def generate_url_string(task_changeset) do
    current_task = task_changeset.model
    id_string = task_changeset.model.id |> Integer.to_string
    url = "http://localhost:8880/tasks/"<>id_string
    url_update_changeset = MaruTodo.Task.changeset(current_task, %{url: url})
    case MaruTodo.Repo.update(url_update_changeset) do
      {:ok, model} ->
        model
        url_update_changeset
      {:error, changeset} ->
        changeset
    end
  end
end

defimpl Poison.Encoder, for: MaruTodo.Task do
  def encode(model, opts) do
    model
    |> Map.take([:title, :id, :completed, :url, :order])
    |> Poison.Encoder.encode(opts)
  end
end

defmodule MaruTodo.Router.Homepage do
	use Maru.Router
  import Ecto.Query

	alias MaruTodo.Task
	alias MaruTodo.Repo
  alias Maru.Response
  namespace :tasks do
  	get do
      query = (from t in Task, select: t)
      |> Repo.all
      |> Response.resp_body
      # Response.resp_body(Repo.all(query))
  	end

  	post do
      	body = fetch_req_body
      	changeset = Task.changeset(%Task{}, body.body_params)
      	case Repo.insert(changeset) do
      		{:ok, task} ->
            task_id = task.id
            url_added_task = Repo.get(MaruTodo.Task, task_id)
            Response.resp_body(url_added_task)
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



defmodule MaruTodo.API do
    use Maru.Router
    plug CORSPlug
    plug Plug.Logger

    mount MaruTodo.Router.Homepage

	rescue_from :all, as: e do
		IO.inspect (e)
    	status 500
    	"Server Error"
    end
end
