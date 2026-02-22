# bash-lab

A personal Linux development environment running on Docker + Colima (macOS).
Built for learning bash, Vim, and Rust in an isolated, reproducible environment.

## What's inside

- **Ubuntu 24.04**
- **Vim** with vim-plug and plugins (airline, ALE, rust.vim, surround, commentary, tabular, vim-markdown)
- **Rust** (rustup, cargo, rustc, rust-analyzer)
- **zellij** - terminal multiplexer
- **shellcheck** - bash linter
- **ripgrep** - fast grep
- **bat** - cat with syntax highlighting
- **btop** - process viewer
- **man pages** (full, via unminimize)
- **bash-completion**
- Git prompt with branch display

## Requirements

- [Docker](https://docs.docker.com/get-docker/)
- [Colima](https://github.com/abiosoft/colima) (macOS)

## Setup

### 1. Start Colima

```bash
colima start --memory 4 --cpu 4
```

### 2. Build the image

```bash
git clone https://github.com/a-lost-social-misfit/bash-lab.git
cd bash-lab
docker build -t bash-lab .
```

### 3. Create the container

```bash
docker run -it --name bashlab --hostname bashlab \
  -v ~/.ssh:/root/.ssh:ro \
  -w /root \
  bash-lab
```

### 4. Add alias to your shell (~/.zshrc or ~/.bashrc)

```bash
alias void="docker start bashlab; docker exec -it bashlab bash --login"
```

Then just type `void` to enter the environment.

## Docker config (fix Ctrl+p)

Add this to `~/.docker/config.json` to fix `Ctrl+p` in bash:

```json
{
  "detachKeys": "ctrl-z,z"
}
```

## Usage

```bash
void          # enter the environment
exit          # leave (container keeps running)
colima stop   # stop everything
colima start  # start again
```

## Acknowledgements

- vimrc based on [Dave Eddy's dotfiles](https://github.com/bahamas10/dotfiles)
