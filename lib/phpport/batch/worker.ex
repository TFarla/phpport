defmodule Phpport.Batch.Worker do
  use GenServer
  require Logger

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init(_) do
    {:ok, Port.open({:spawn, "php php/worker.php"}, [:binary])}
  end

  def process(pid, ids) do
    GenServer.call(pid, {:process, ids})
  end

  def handle_call({:process, ids}, _from, port) do
    true = Port.command(port, Enum.join(ids, ",") <> "\n")
    {:reply, :ok, port}
  end

  def handle_info({port, result}, port) do
    Logger.debug(inspect result)
    {:noreply, port}
  end
end
