defmodule GameHub.Repo.Migrations.CreateApiLogs do
  use Ecto.Migration

  def change do
    create table(:api_logs) do
      add :name, :string
      add :opts, :map

      timestamps(type: :utc_datetime)
    end
  end
end
