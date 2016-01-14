defmodule Cowgirl.Protocol do
  def start(:http, ref, acceptors, trans_opts, protocol_opts) do
    :ranch.start_listener(ref, acceptors, :ranch_tcp, trans_opts, Cowgirl.ProtocolHandler.Http, protocol_opts)
  end

  def start(:https, ref, acceptors, trans_opts, protocol_opts) do
    :ranch.start_listener(ref, acceptors, :ranch_ssl, trans_opts, Cowgirl.ProtocolHandler.Http, protocol_opts)
  end

  def stop(ref) do
    :ranch.stop_listener(ref)
  end
end
