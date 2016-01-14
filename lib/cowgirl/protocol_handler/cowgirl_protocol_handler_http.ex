defmodule Cowgirl.ProtocolHandler.Http do
  def start_link(ref, socket, transport_handler, opts) do
    pid = spawn_link(__MODULE__, :init, [ref, socket, transport_handler, opts])
    {:ok, pid}
  end

  def init(ref, socket, transport_handler, opts) do
    :ok = :ranch.accept_ack(ref)

    case recv(socket, transport_handler, Keyword.get(opts, :timeout, 5000)) do
      {:ok, http_message} ->
        parse_request(socket, http_message)
        transport_handler.send(socket, http_message) # dummy handler
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

  @crlf "\r\n"

  def parse_request(socket, http_message) do
    [request_line | headers_and_body] = String.split(http_message, @crlf)

    body    = List.last(headers_and_body)
    headers = List.delete_at(headers_and_body, -1)

    %Cowgirl.Request{socket: socket}
    |> parse_request_line(request_line)
    |> parse_headers(headers)
    |> parse_body(body)
    |> IO.inspect
  end

  @sp " "

  # RFC: https://tools.ietf.org/html/rfc7230#section-3.1.1
  defp parse_request_line(request, request_line) do
    [method, request_target, http_version] = String.split(request_line, @sp)

    uri = URI.parse(request_target)

    %Cowgirl.Request{
      request |
      method: method,
      http_version: http_version,
      path: uri.path,
      query: (uri.query || "") |> URI.decode_query
    }
  end

  @hd_splitter ": "

  defp parse_headers(request, headers) do
    headers = Enum.reduce(headers, %{}, &parse_hd_pair/2)

    %Cowgirl.Request{ request | headers: headers }
    |> parse_host(headers["host"])
  end

  defp parse_body(request, body) do
    %Cowgirl.Request{ request | body: body}
  end

  defp parse_hd_pair("", acc) do
    acc
  end

  defp parse_hd_pair(hd_pair, acc) do
    [name, value] = String.split(hd_pair, @hd_splitter)
    Map.put(acc, String.downcase(name), value)
  end

  defp parse_host(request, nil) do
    request
  end

  defp parse_host(request, "") do
    request
  end

  defp parse_host(request, host_hd_value) do
    [host, port] =
      case String.match?(host_hd_value, ~r/:\d+/) do
        true -> host_hd_value |> String.split(":")
        _ -> [host_hd_value, "80"]
      end

    %Cowgirl.Request{
      request |
      host: host,
      port: port |> String.to_integer,
    }
  end
end
