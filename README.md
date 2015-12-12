# Cowgirl

My goal is to build a small, fast, modular HTTP server written in Elixir, like the famous [cowboy](https://github.com/ninenines/cowboy).

[![Build Status](https://img.shields.io/travis/larrylv/cowgirl.svg)](https://travis-ci.org/larrylv/cowgirl)
[![Hex.pm Version](https://img.shields.io/hexpm/v/cowgirl.svg?style=flat-square)](https://hex.pm/packages/cowgirl)
[![Docs](https://inch-ci.org/github/larrylv/cowgirl.svg?branch=master&style=flat-square)](https://inch-ci.org/github/larrylv/cowgirl)
[![Hex.pm Downloads](https://img.shields.io/hexpm/dt/cowgirl.svg?style=flat-square)](https://hex.pm/packages/cowgirl)

## Installation

The package can be installed as:

  1. Add cowgirl to your list of dependencies in `mix.exs`:

        def deps do
          [{:cowgirl, "~> 0.0.1"}]
        end

  2. Ensure cowgirl is started before your application:

        def application do
          [applications: [:cowgirl]]
        end
