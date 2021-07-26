defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Booking
  alias Flightex.Bookings.Agent, as: BookingAgent

  def generate(from_date, to_date, filename \\ "report.csv") do
    booking_list = build_bookings_list(from_date, to_date)

    File.write(filename, booking_list)
    {:ok, "Report generated successfully"}
  end

  def generate(filename \\ "report.csv") do
    booking_list = build_bookings_list()

    File.write(filename, booking_list)
    {:ok, "Report generated successfully"}
  end

  defp build_bookings_list(from_date, to_date) do
    BookingAgent.get_all()
    |> Map.values()
    |> Enum.map(fn booking -> booking_string(booking, from_date, to_date) end)
  end

  defp build_bookings_list() do
    BookingAgent.get_all()
    |> Map.values()
    |> Enum.map(fn booking -> booking_string(booking) end)
  end

  defp booking_string(
         %Booking{
           complete_date: complete_date
         } = booking,
         from_date,
         to_date
       ) do
    date_range = Date.range(from_date, to_date)
    naive_date = NaiveDateTime.to_date(complete_date)

    Enum.member?(date_range, naive_date)
    |> build_string(booking)
  end

  defp booking_string(%Booking{} = booking) do
    build_string(true, booking)
  end

  defp build_string(true, %Booking{
         complete_date: complete_date,
         local_origin: local_origin,
         local_destination: local_destination,
         user_id: user_id,
         id: _id
       }) do
    "#{user_id},#{local_origin},#{local_destination},#{complete_date}\n"
  end

  defp build_string(false, _), do: ""
end
