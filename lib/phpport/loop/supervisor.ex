defmodule Phpport.Loop.Supervisor do
  use Supervisor

  def start_link(loop, fetcher, opts \\ []) do
    Supervisor.start_link(__MODULE__, [loop: loop, fetcher: fetcher], opts)
  end

  def init([loop: loop, fetcher: fetcher]) do
    children = [
      worker(Phpport.Loop.Subscriber, []),
      worker(Phpport.Loop.Fetcher, [[name: fetcher]]),
      worker(Phpport.Loop.Loop, [fetcher, [name: loop]])
    ]

    supervise(children, strategy: :one_for_all)
  end
end
