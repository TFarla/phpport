defmodule Phpport.Loop.Subscriber do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init([]) do
    Phoenix.PubSub.subscribe(Phpport.PubSub, self, "new:jobs")
    {:ok, []}
  end

  def handle_info(result, state) do
    require Logger
    Logger.debug(result)
    Phpport.Batch.Pool.process_jobs(result)
    {:noreply, state}
  end
end
