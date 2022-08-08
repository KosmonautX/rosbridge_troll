defmodule Troll.Repo.Migrations.CreateOperations do
  use Ecto.Migration

  def change do
    create_query = "CREATE TYPE ros_op_type AS ENUM ('advertise', 'unadvertise', 'subscribe', 'unsubscribe', 'publish', 'set_level', 'status', 'auth', 'call_service', 'service_response', 'advertise_service', 'unadvertise_service')"
    drop_query = "DROP TYPE "
    execute(create_query, drop_query)

    create table(:operations, primary_key: false) do
      add :op, :ros_op_type
      add :op_id, :uuid, primary_key: true
      add :id, :uuid
      add :topic, :string
      add :type, :string
      add :msg, :jsonb

      timestamps()
    end
  end
end
