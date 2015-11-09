defmodule MaruTodo.Router.Homepage do
	use Maru.Router

	import Ecto.Query
	alias MaruTodo.Tasks
	# plug CORS
	get do
    	%{ hello: :world }
	end

	post do
    	# IO.inspect(fetch_req_body)
    	body = fetch_req_body

    	IO.inspect(body.body_params)
	end

	patch do
		
	end

	delete do

	end
end

defmodule MaruTodo.Repo do
	use Ecto.Repo, otp_app: :maru
end

defmodule MaruTodo.Tasks do
	use Ecto.Model

	schema "tasks" do
		field :title
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
