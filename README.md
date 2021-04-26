# yahuSDE

A personal pre-configured shell development environment. Allowing me to develop anywhere with ssh/mosh access. I'm using this with an ipad using Blink app, remoting to an instance on cloud providers.

## Prerequsite

- Docker
- Docker volume driver lebokus/bindfs
```
docker plugin install lebokus/bindfs
```

## Usage

Run the starting script
```
SDE_WS={/path/to/ws} run.sh
```

# Features/Setup
- Debian base
- tmux
- zsh/oh-my-zsh
  - spaceship prompt
- neovim 
  - NERDTree
  - telescope.nvim
  - golang
    - coc
    - coc-go
- host docker

# Roadmap
[ ] golang 
[ ] nodejs
[ ] theme 

