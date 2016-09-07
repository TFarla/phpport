defmodule Phpport.Batch.Pool do
  def process_jobs(ids) do
      :poolboy.transaction(name, fn pid ->
          Phpport.Batch.Worker.process(pid, ids)
      end)
  end

  def name, do: :batch_pool
end
