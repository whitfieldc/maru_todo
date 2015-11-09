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

	schema "tasks" do
		field :title
	end

	@required_fields ~w(title)

	def changeset(task, params \\ :empty) do
		task
		|> cast(params, @required_fields)
	end
end

defmodule MaruTodo.Router.Homepage do
	use Maru.Router

	alias MaruTodo.Task
	alias MaruTodo.Repo
	get do
    	%{ hello: :world }
	end

	post do
    	body = fetch_req_body
    	changeset = Task.changeset(%Task{}, body.body_params)
    	case Repo.insert(changeset) do
    		{:ok, task} ->
    			Plug.Conn.send_resp(conn, 200, task)
    		{:error, changeset} ->
    			status(400)
    	end
	end

	# patch do

	# end

	# delete do

	# end
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
