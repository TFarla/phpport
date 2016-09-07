defmodule Phpport do
  use Application
  import Supervisor.Spec

  def start(_, _) do
    children = [
      supervisor(Phoenix.PubSub.PG2, [Phpport.PubSub, [pool_size: 1]]),
      supervisor(Phpport.Batch.Supervisor, []),
      supervisor(Phpport.Loop.Supervisor, [:loop, :fetcher])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
