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
	end

	@required_fields ~w(title)
  @optional_fields ~w()

	def changeset(task, params \\ :empty) do
		task
		|> cast(params, @required_fields)
	end

  def generate_url_string(task_changeset) do
    IO.inspect(task_changeset.model)
    id_string = task_changeset.model.id |> Integer.to_string
    url = "http://localhost:8880/"<>id_string
    IO.inspect(url)
    new_changeset = change(task_changeset, url: url)
    # case MaruTodo.Repo.update(new_changeset) do
    #   {:ok, model} ->
    #     model
    #   {:error, changeset} ->
    #     changeset
    # end
    ####################
    # need to create new changeset to allwo update to repo
    ####################
  end
end

defimpl Poison.Encoder, for: MaruTodo.Task do
  def encode(model, opts) do
    model
    |> Map.take([:title, :id, :completed, :url])
    |> Poison.Encoder.encode(opts)
  end
end

defmodule MaruTodo.Router.Homepage do
	use Maru.Router
  import Ecto.Query

	alias MaruTodo.Task
	alias MaruTodo.Repo
  alias Maru.Response
	get do
    query = from t in Task, select: t
    Response.resp_body(Repo.all(query))
	end

	post do
    	body = fetch_req_body
    	changeset = Task.changeset(%Task{}, body.body_params)
    	case Repo.insert(changeset) do
    		{:ok, task} ->
          IO.inspect(task)
          Response.resp_body(task)
    		{:error, changeset} ->
    			status(400)
    	end
	end

	# patch do

	# end

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
