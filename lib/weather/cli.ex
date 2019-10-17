defmodule Weather.CLI do
  @moduledoc """
  Parse the command line options passed in
  """

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
  Processes inputs
  """
  def process(:help) do
    IO.puts("""
      Usage: weather <station>
      """)

    System.halt(1)
  end

  def process(station) do
    Weather.WeatherData.fetch(station)
  end
end
