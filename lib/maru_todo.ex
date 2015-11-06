defmodule MaruTodo.Router.Homepage do
	use Maru.Router

	get do
    	%{ hello: :world }
	end
end

defmodule MaruTodo.API do
    use Maru.Router

    mount MaruTodo.Router.Homepage

	rescue_from :all do
    	status 500
    	"Server Error"
    end
end
