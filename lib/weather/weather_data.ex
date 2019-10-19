defmodule Weather.WeatherData do
  @moduledoc """
  Fetch weather data from weather service
  """

  @headers [{"User-Agent", "Jesse vanvoljg@gmail.com"}]
  @weather_url "https://w1.weather.gov/xml/current_obs"

  @doc """
  Takes a string representing a station ID
  Returns a tuple with status and either a response or an error
  """
  def fetch(station) do
    construct_weather_url(station)
    |> Tesla.get(headers: @headers)
    |> handle_response()
  end

  def construct_weather_url(station) do
    "#{@weather_url}/#{station}.xml"
  end

  def handle_response({:ok, %{status: status, body: body}}) do
    {
      http_status_validation(status),
      body
    }
  end

  def handle_response({:error, error}) do
    {:error, error}
  end

  def handle_response(_) do
    raise("An unexpected error has occurred")
  end

  defp http_status_validation(200), do: :ok
  defp http_status_validation(_), do: :error
end
