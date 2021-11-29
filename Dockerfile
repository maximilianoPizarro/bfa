FROM            ethereum/solc:0.6.3-alpine AS solc
FROM		ethereum/client-go:alltools-v1.9.11
LABEL		maintainer="Robert Martin-Legene <robert@nic.ar>, Maximiliano Pizarro <maximiliano.pizarro.5@gmail.com>"

COPY		--from=solc /usr/local/bin/solc /usr/local/bin

ENV		USERNAME=bfa HOME=/home/bfa BFAHOME=/home/bfa/bfa BFANETWORKIDPROD=47525974938 BFANETWORKIDTEST=55555000000 VIRTUALIZATION=DOCKER BFANETWORKDIRPROD=/home/bfa/bfa/network BFANETWORKDIRTEST=/home/bfa/bfa/test2network PATH=/home/bfa/bfa/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV         BFANETWORKDIR=/home/bfa/bfa/test2network
ENV         BFANODEDIR=/home/bfa/bfa/test2network/node
ENV         BFATOML=/home/bfa/bfa/test2network/docker-config.toml

RUN		adduser -u 30303 -s /bin/bash -h ${HOME} -D ${USERNAME} ${USERNAME} && apk add --no-cache git bash jq perl perl-class-accessor perl-json perl-json-xs perl-lwp-protocol-https nodejs npm binutils python python3 curl make g++ && find /var/cache/apk -type f -delete
USER		${USERNAME}
WORKDIR 	${HOME}
RUN		git clone --quiet -b dev https://gitlab.bfa.ar/blockchain/nucleo.git bfa
WORKDIR 	${BFAHOME}
ADD         env ${BFAHOME}/bin/
RUN             npm update && npm audit fix


VOLUME          ${HOME}
VOLUME          $BFANETWORKDIR/cache
VOLUME          $BFANODEDIR

EXPOSE          8545 8546 30303

CMD		[ "/home/bfa/bfa/bin/singlestart.sh" ]
ENTRYPOINT	[ "/bin/bash" ]

USER root

RUN chown 1023000000:1023000000 -R ${HOME}

USER 1023000000
