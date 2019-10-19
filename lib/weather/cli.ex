defmodule Weather.CLI do
  @moduledoc """
  Parse the command line options passed in
  """

  @fields [
    Station: "/current_observation/station_id/text()",
    Location: "/current_observation/location/text()",
    Updated: "/current_observation/observation_time/text()",
    Weather: "/current_observation/weather/text()",
    Temperature: "/current_observation/temperature_string/text()",
    Wind: "/current_observation/wind_string/text()",
    Pressure: "/current_observation/pressure_string/text()",
    Dewpoint: "/current_observation/dewpoint_string/text()"
  ]

  def main(argv) do
    argv
    |> parse_args()
    |> process()
  end

  @doc """
  Parses input arguments and converts to internal data format

  `argv` is an array of arguments

  Returns a string or `:help`
  """
  def parse_args(argv) do
    OptionParser.parse(
      argv,
      strict: [help: :boolean],
      aliases: [h: :help]
    )
    |> args_to_internal_representation()
  end

  def args_to_internal_representation({[help: true], _, _}) do
    :help
  end

  def args_to_internal_representation({_parsed, [station], _errors}) do
    station
    |> String.upcase()
  end

  def args_to_internal_representation(_) do
    :help
  end

  @doc """
  Main process loop
  Receives `:help` or an all-capital string representing a weather station ID
  """
  def process(:help) do
    IO.puts("""
      Usage: weather <station>
      """)
    System.halt(1)
  end

  def process(station) do
    Weather.WeatherData.fetch(station)
    |> xml_to_erl_records()
    |> Weather.TableFormatter.print_table_by_xpaths(@fields)
  end

  def xml_to_erl_records({:ok, xmlstring}) do
    xmlstring
    |> String.to_charlist()
    |> :xmerl_scan.string()
    |> elem(0)
  end

  def xml_to_erl_records({:error, error}) do
    IO.puts("Error fetching data: #{error}")
    System.halt(1)
  end
end
