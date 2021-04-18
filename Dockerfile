FROM debian:10
# Package Manager
RUN su root && apt-get update \
  && apt-get -y install apt-utils \
  && apt-get -y install sudo \
  && apt-get -y install curl \ 
  && apt-get -y install git 

# Docker In Docker
# Run with -v /var/run/docker.sock:/var/run/docker.sock
RUN sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
   && sudo apt-get update \
   && sudo apt-get -y install docker-ce docker-ce-cli containerd.io

WORKDIR /root

# Shell env
RUN sudo apt-get -y install tmux

RUN sudo apt-get -y install zsh \
  && chsh -s $(which zsh) \
  && sudo apt-get -y install fonts-powerline
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ENV ZSH_CUSTOM /root/.oh-my-zsh/custom

RUN git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1 \
 && ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme" 

ENV LANG en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8

COPY .tmux.conf .tmux.conf
COPY .tmux/ .tmux/
COPY .zshrc .zshrc

# IDE: nvim
RUN curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage \
  && chmod u+x nvim.appimage \
  && ./nvim.appimage --appimage-extract \
  && ./squashfs-root/AppRun --version \
  && mv squashfs-root / && ln -s /squashfs-root/AppRun /usr/bin/nvim

RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' 
RUN mkdir .config
COPY .vimrc .vimrc
COPY .config/nvim .config/nvim
COPY ide.sh ide.sh

RUN nvim --headless +PlugInstall +qall

VOLUME /ws

CMD WORKSPACE=/ws /root/ide.sh
