FROM debian:10

# Package Manager
RUN su root && apt-get update \
  && apt-get -y install apt-utils \
  && apt-get -y install sudo \
  && apt-get -y install curl \ 
  && apt-get -y install git 

# Docker In Docker

# Shell env
RUN sudo apt-get -y install tmux
RUN sudo apt-get -y install zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Editor
# RUN sudo apt-get -y install neovim

COPY .zshrc .zshrc

WORKDIR /home/root

