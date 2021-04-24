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

# create user
RUN groupadd -g 1000 yahu \
  && useradd -l -u 1000 -g yahu yahu \
  && install -d -m 0755 -o yahu -g yahu /home/yahu \
  && chown -R \
    1000:1000 \
    /home/yahu

# Shell env
RUN sudo apt-get -y install tmux

RUN sudo apt-get -y install zsh \
  && usermod --shell $(which zsh) yahu \
  && sudo apt-get -y install fonts-powerline


# nodejs
RUN sudo apt-get -y install nodejs

# golang
RUN curl -LO https://golang.org/dl/go1.16.3.linux-amd64.tar.gz \
  && rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.3.linux-amd64.tar.gz \
  && echo "\nexport PATH=$PATH:/usr/local/go/bin" >> /etc/profile

USER yahu
WORKDIR /home/yahu


ENV ZSH_CUSTOM /home/yahu/.oh-my-zsh/custom
ENV LANG en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
  && git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1 \
  && ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme" 

COPY --chown=yahu .tmux.conf .tmux.conf
COPY --chown=yahu .tmux/ .tmux/
COPY --chown=yahu .zshrc .zshrc

# IDE: nvim
USER root
WORKDIR /root

RUN curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage \
  && chmod u+x nvim.appimage \
  && ./nvim.appimage --appimage-extract \
  && ./squashfs-root/AppRun --version \
  && mv squashfs-root / && ln -s /squashfs-root/AppRun /usr/bin/nvim

USER yahu
WORKDIR /home/yahu

RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' 
RUN mkdir .config
COPY --chown=yahu .vimrc .vimrc
COPY --chown=yahu .config/nvim .config/nvim
COPY --chown=yahu ide.sh ide.sh

RUN nvim --headless +PlugInstall +qall

VOLUME /home/yahu/ws
CMD WORKSPACE=/home/yahu/ws /home/yahu/ide.sh
