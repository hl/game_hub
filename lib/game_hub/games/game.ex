defmodule GameHub.Games.Game do
  @moduledoc """
  Game resource
  """

  defstruct [:id, :name]

  @type t :: %__MODULE__{
          id: non_neg_integer(),
          name: String.t()
        }

  @spec per_page() :: non_neg_integer()
  def per_page, do: 10

  @spec new(%{String.t() => term()}) :: t()
  def new(attrs) do
    %__MODULE__{
      id: attrs["id"],
      name: attrs["name"]
    }
  end
end
