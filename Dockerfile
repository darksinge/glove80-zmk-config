FROM nixos/nix

WORKDIR /app

RUN nix-channel --update
RUN git clone https://github.com/moergo-sc/zmk.git /zmk

COPY scripts ./scripts

CMD './scripts/build.sh'
