# yahuRDE

A personal pre-configured shell development environment. Develop anywhere via ssh/mosh access. I'm using this with an ipad using Blink app, remoting to an instance on cloud providers.

## Prerequsite

- Docker

## Usage

Start your ide with your workspsace path:
```
docker run -ti yahu.io/rde -v /ws:{your workspace}
```

To enable docker commands using host docker daemon
```
docker run -ti yahu.io/rde -v /ws:{your workspace} -v /var/run/docker.sock:/var/run/docker.sock
```

# Features/Setup
- Debian base
- tmux
- zsh/oh-my-zsh
  - spaceship prompt
- neovim 
  - NERDTree
  - telescope.nvim

# Roadmap
[ ] golang 
[ ] nodejs
[ ] 

