defmodule CORS do
	use Maru.Middleware

	def call(conn, _opts) do
		conn 
		|> Plug.Conn.put_resp_header("access-control-allow-origin", "*")
		|> Plug.Conn.put_resp_header("access-control-allow-headers", "Content-Type")
		|> Plug.Conn.put_resp_header("access-control-allow-methods", "POST, GET, PUT, PATCH, DELETE, OPTIONS")
	end

end

defmodule MaruTodo.Router.Homepage do
	use Maru.Router
	# plug CORS
	get do
    	%{ hello: :world }
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




# defmodule MaruTodo.CORS do
# 	use Corsica.Router,
# 		origins: "*",
# 		allow_headers: "Content-Type"

# 	resource "/*"
# end
