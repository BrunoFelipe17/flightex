defmodule Flightex.Users.User do
  @keys [:name, :email, :cpf, :id]
  @enforce_keys @keys
  defstruct @keys

  def build(name, _email, _cpf) when not is_bitstring(name), do: {:error, "Name must be a String"}

  def build(_name, email, _cpf) when not is_bitstring(email),
    do: {:error, "Email must be a String"}

  def build(_name, _email, cpf) when is_number(cpf), do: {:error, "Cpf must be a String"}

  def build(name, email, cpf) when is_bitstring(cpf) do
    with {:ok, email} <- is_email(email),
         {:ok, cpf} <- is_cpf(cpf) do
      {:ok, %__MODULE__{id: UUID.uuid4(), name: name, email: email, cpf: cpf}}
    end
  end

  defp is_email(email) do
    (Regex.match?(~r/.+@.+\.com/, email) && {:ok, email}) || {:error, "Invalid email"}
  end

  defp is_cpf(cpf) do
    (Regex.match?(~r/\d{3}\.?\d{3}\.?\d{3}\-?\d{2}/, cpf) && {:ok, cpf}) ||
      {:error, "Invalid cpf"}
  end
end
