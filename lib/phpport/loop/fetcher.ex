defmodule Phpport.Loop.Fetcher do
  use GenServer
  require Logger

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init([]) do
    {:ok, Port.open({:spawn, "php php/fetcher.php"}, [:binary])}
  end

  def fetch(pid, reporter) do
    GenServer.cast(pid, :fetch)
  end

  def handle_cast(:fetch, port) do
    true = Port.command(port, "\n")
    {:noreply, port}
  end

  def handle_info({port, {:data, result}}, port) do
    ids = String.split(result, ",")
    Phoenix.PubSub.broadcast(Phpport.PubSub, "new:jobs", ids)
    {:noreply, port}
  end
end
