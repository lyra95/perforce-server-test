FROM nixos/nix:2.30.1

RUN echo 'experimental-features = nix-command flakes' >> /etc/nix/nix.conf
RUN mkdir -p /root/.config/nixpkgs
RUN echo '{ allowUnfree = true; }' > /root/.config/nixpkgs/config.nix

RUN nix-env -iA nixpkgs.p4d
RUN mkdir -p /data/perforce
WORKDIR /data/perforce
RUN echo 'foobar' > server.id

WORKDIR /data/perforce
# -xi: unicode 모드 활성화
RUN ["p4d", "-xi"]
ENTRYPOINT ["p4d"]
