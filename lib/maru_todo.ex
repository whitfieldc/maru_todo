defmodule MaruTodo do
  use Application

  def start(_type, _args) do
    MaruTodo.Supervisor.start_link
  end

end
