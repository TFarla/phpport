defmodule Phpport.Batch.Supervisor do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    poolboy_config = [
      {:name, {:local, Phpport.Batch.Pool.name}},
      {:worker_module, Phpport.Batch.Worker},
      {:size, 5},
      {:max_overflow, 0}
    ]

    children = [
      :poolboy.child_spec(Phpport.Batch.Pool.name, poolboy_config, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
