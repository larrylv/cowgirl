defmodule Cowgirl.Request do
  defstruct socket: nil,
            host: "",
            port: 0,
            http_version: "",
            method: "",
            headers: %{},
            path: "",
            query: %{},
            body: "",
            peer: {}

end
