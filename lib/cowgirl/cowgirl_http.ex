defmodule Cowgirl.Http do
  def start_link(port) do
    {:ok, listen_socket} = :gen_tcp.listen(port, [:binary, {:packet, 0}, {:active, false}])
    do_accept_socket(listen_socket)
  end

  defp do_accept_socket(listen_socket) do
    {:ok, socket} = :gen_tcp.accept(listen_socket)
    {:ok, packet} = :gen_tcp.recv(socket, 0)
    :gen_tcp.close(socket)

    do_accept_socket(listen_socket)
  end
end
