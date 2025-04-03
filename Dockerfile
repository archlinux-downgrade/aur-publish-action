FROM archlinux:base-devel
RUN \
  pacman -Sy --needed --noconfirm git openssh pacman-contrib && \
  sed -i 's/ !color / color /' /etc/makepkg.conf && \
  useradd app --create-home && \
  mkdir -p /home/app/.ssh && \
  chown app:app /home/app/.ssh && \
  echo 'app ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/app

COPY bin/ /usr/local/bin/

USER app
WORKDIR /home/app

# Configure SSH
COPY --chown=app:app ssh/ .ssh/
RUN \
  chmod 700 ./.ssh && \
  chmod 600 ./.ssh/config

CMD ["aur-publish", "--help"]
