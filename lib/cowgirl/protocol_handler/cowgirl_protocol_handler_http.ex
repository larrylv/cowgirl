defmodule Cowgirl.ProtocolHandler.Http do
  def start_link(ref, socket, transport_handler, opts) do
    pid = spawn_link(__MODULE__, :init, [ref, socket, transport_handler, opts])
    {:ok, pid}
  end

  def init(ref, socket, transport_handler, opts) do
    :ok = :ranch.accept_ack(ref)
    loop(socket, transport_handler, opts)
  end

  def loop(socket, transport_handler, opts) do
    case recv(socket, transport_handler, Keyword.get(opts, :timeout, 5000)) do
      {:ok, data} ->
        transport_handler.send(socket, data) # dummy handler
        loop(socket, transport_handler, opts)
      {:error, _} ->
        terminate(socket, transport_handler)
    end
  end

  def recv(socket, transport_handler, :infinity) do
    transport_handler.recv(socket, 0, :infinity)
  end

  def recv(socket, transport_handler, timeout) do
    transport_handler.recv(socket, 0, timeout)
  end

  def terminate(socket, transport_handler) do
    transport_handler.close(socket)
  end
end
