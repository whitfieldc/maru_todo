# MaruTodo

To-do List JSON API built against (Todo-Backend)[http://todobackend.com/] spec

(Hosted on Heroku)[http://maru-todo.herokuapp.com/tasks]

#### To Run
```sh
git clone https://github.com/whitfieldc/maru_todo.git
cd maru_todo
mix deps.get
mix ecto.create
mix ecto.migrate
iex -S mix
```
Test local version at http://www.todobackend.com/specs/index.html?http://localhost:8000/tasks

#### Requirements
- Elixir 1.1.1
- Hex
- PostgreSQL
