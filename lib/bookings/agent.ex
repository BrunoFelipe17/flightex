defmodule Flightex.Bookings.Agent do
  use Agent

  alias Flightex.Bookings.Booking

  def start_link(%{}) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%Booking{id: id} = booking) do
    Agent.update(__MODULE__, &update_state(&1, booking))

    {:ok, id}
  end

  def get_all(), do: Agent.get(__MODULE__, & &1)

  def get(booking_id), do: Agent.get(__MODULE__, &get_booking(&1, booking_id))

  defp get_booking(state, booking_id) do
    case Map.get(state, booking_id) do
      nil -> {:error, "Booking not found"}
      booking -> {:ok, booking}
    end
  end

  defp update_state(state, %Booking{id: id} = booking) do
    Map.put(state, id, booking)
  end
end
