defmodule GameHub.Logging.APILog do
  @moduledoc """
  Schema for logging API calls
  """

  use Ecto.Schema

  @type t :: %__MODULE__{
          id: non_neg_integer() | nil,
          name: String.t() | nil,
          opts: map() | nil,
          inserted_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }

  schema "api_logs" do
    field :name, :string
    field :opts, :map

    timestamps(type: :utc_datetime)
  end
end
