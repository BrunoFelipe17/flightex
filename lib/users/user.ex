defmodule Flightex.Users.User do
  @keys [:name, :email, :cpf, :id]
  @enforce_keys @keys
  defstruct @keys

  def build(name, email, cpf) when is_bitstring(cpf) do
    # TO DO
    {:ok, %__MODULE__{id: UUID.uuid4(), name: name, email: email, cpf: cpf}}
  end

  def build(_name, _email, cpf) when is_number(cpf), do: {:error, "Cpf must be a String"}
end
