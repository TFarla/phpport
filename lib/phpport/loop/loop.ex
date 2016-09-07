defmodule Phpport.Loop.Loop do
  require Logger
  use GenServer

  def start_link(fetcher, opts \\ []) do
    GenServer.start_link(__MODULE__, fetcher, opts)
  end

  def init(fetcher) do
    {:ok, task} = Task.Supervisor.start_link()
    send(self, :run)
    {:ok, [fetcher: fetcher, task: task]}
  end

  def run(pid) do
    GenServer.cast(pid, :run)
  end

  def handle_cast(:run, state) do
    pid = self
    spawn_link(fn ->
      send(pid, {:loop, Task.Supervisor.children(state.task)})
    end)

    {:noreply, state}
  end

  def handle_info(:run, state) do
    children = Task.Supervisor.children(state[:task])
    send(self, {:loop, children})
    {:noreply, state}
  end

  def handle_info({:loop, []}, state) do
    Logger.debug("Loop: starting worker")
    Logger.debug(inspect :poolboy.status(Phpport.Batch.Pool.name))
    Task.Supervisor.start_child(state[:task], fn ->
      Phpport.Loop.Fetcher.fetch(state[:fetcher], self)
    end)

    send(self, :run)
    {:noreply, state}
  end

  def handle_info({:loop, _}, state) do
    Logger.debug("Loop: worker already started")
    :timer.send_after(:timer.seconds(5), self, :run)
    {:noreply, state}
  end
end
