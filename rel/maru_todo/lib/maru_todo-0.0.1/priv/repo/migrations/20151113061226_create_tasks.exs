defmodule MaruTodo.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def up do
    create table(:tasks) do
      add :title, :string
      add :completed, :boolean, default: false, null: false
      add :url, :string
      add :order, :integer
    end
  end

  def down do
    drop table(:tasks)
  end
end
