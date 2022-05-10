FROM voidlinux/voidlinux

RUN xbps-install -ASy --yes \
  dash bash \
  curl \
  git \
  make \
  sudo

WORKDIR /root/

COPY . ./.dotfiles

RUN make -BC ./.dotfiles dev

RUN xbps-remove -O --yes

ENTRYPOINT ["/usr/bin/zsh", "-l"]

