# Dunst Web Historic

A simple web interface to view your Dunst notification history, served by [Kapow!](https://github.com/BBVA/kapow).

This project provides a real-time web UI to browse through your Dunst notification history.

## Features

- **Real-time Updates**: Automatically refreshes the notification list and counts.
- **Interactive Notifications**: Features clickable links and a one-click copy button for OTP codes.
- **Dynamic Timestamps**: Displays relative timestamps that update live, with the absolute time available on hover.
- **Urgency Styling**: Color-codes notifications based on their urgency level.

## Requirements

- [Nix](https://nixos.org/download.html) with Flakes enabled.
- The `dunst` notification daemon.

## Running the Server

To run the server, navigate to the project's root directory and execute:

```sh
nix run .
```

By default, the server will be available at `http://127.0.0.1:9888`.

You can also pass additional arguments to the `kapow server` command. For example, to run in debug mode:

```sh
nix run . -- --debug
```

## Development

To enter a development shell with all the necessary dependencies, run:

```sh
nix develop
```

Inside the shell, you can run the server with:

```sh
kapow server --bind 127.0.0.1:9888 ./dunst_kapow_script.sh
```

## Building

To build the project, run:

```sh
nix build
```

This will create a `result` symlink in the current directory containing the compiled package.