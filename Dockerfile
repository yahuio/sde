FROM debian:10

# Package Manager
RUN su root && apt-get update \
  && apt-get -y install apt-utils \
  && apt-get -y install sudo \
  && apt-get -y install curl \ 
  && apt-get -y install git 

# Docker In Docker


WORKDIR /root

# Shell env
RUN sudo apt-get -y install tmux

COPY .tmux.conf .tmux.conf
COPY .tmux/ .tmux/

RUN sudo apt-get -y install zsh \
  && chsh -s $(which zsh) \
  && sudo apt-get -y install fonts-powerline
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ENV ZSH_CUSTOM /root/.oh-my-zsh/custom

RUN git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1 \
 && ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme" 
COPY .zshrc .zshrc

# IDE


CMD tmux 
