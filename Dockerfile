FROM ubuntu:24.04

ENV TERM=xterm-256color

RUN apt-get update && apt-get install -y \
    vim git curl shellcheck man-db bat htop \
    build-essential ripgrep bash-completion \
    && yes | unminimize \
    && rm -rf /var/lib/apt/lists/*

# vim-plug
RUN curl -fLo /root/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

COPY vimrc /root/.vimrc
COPY profile /root/.profile

RUN vim +PlugInstall +qall

# bat のシンボリックリンク
RUN ln -s /usr/bin/batcat /usr/local/bin/bat

# Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# rust-analyzer
RUN rustup component add rust-analyzer

# zellij (aarch64 バイナリ)
RUN curl -L https://github.com/zellij-org/zellij/releases/latest/download/zellij-aarch64-unknown-linux-musl.tar.gz \
    | tar -xz -C /usr/local/bin

# readline設定
RUN echo 'set keyseq-timeout 50' >> /root/.inputrc

# bashrc 設定
RUN echo 'export MANPAGER="batcat -l man -p"' >> /root/.bashrc \
    && echo 'export MANWIDTH=120' >> /root/.bashrc \
    && echo 'export PATH="/root/.cargo/bin:$PATH"' >> /root/.bashrc \
    && echo 'alias zellij="TERM=xterm-256color zellij"' >> /root/.bashrc \
    && echo '[ -f /etc/bash_completion ] && . /etc/bash_completion' >> /root/.bashrc

CMD ["/bin/bash"]
