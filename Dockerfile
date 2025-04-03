# Copyright (C) 2025 Patrick Brisbin
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
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
