FROM            ethereum/solc:0.6.3-alpine AS solc
FROM		ethereum/client-go:alltools-v1.9.11
LABEL		maintainer="Robert Martin-Legene <robert@nic.ar>"
CMD		[ "/bin/bash" ]
COPY		--from=solc /usr/local/bin/solc /usr/local/bin
EXPOSE          8545 8546 30303
ENV		USERNAME=bfa HOME=/home/bfa BFAHOME=/home/bfa/bfa BFANETWORKIDPROD=47525974938 BFANETWORKIDTEST=55555000000 VIRTUALIZATION=DOCKER BFANETWORKDIRPROD=/home/bfa/bfa/network BFANETWORKDIRTEST=/home/bfa/bfa/test2network PATH=/home/bfa/bfa/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN		adduser -u 30303 -s /bin/bash -h ${HOME} -D ${USERNAME} ${USERNAME} && apk add --no-cache git bash jq perl perl-class-accessor perl-json perl-json-xs perl-lwp-protocol-https nodejs npm binutils python python3 curl make g++ && find /var/cache/apk -type f -delete
USER		${USERNAME}
VOLUME [/home/bfa]
WORKDIR 	${BFAHOME}
RUN		git clone --quiet https://gitlab.bfa.ar/blockchain/nucleo.git bfa && cd bfa && npm update && npm audit fix
#CMD		[ "/home/bfa/bfa/bin/singlestart.sh" ]
CMD		[ "/home/bfa/bfa/bin/singlestart.sh" ]
ENTRYPOINT [ "/home/bfa/bfa/bin/singlestart" ]
USER root

RUN chown 1023000000:1023000000 -R ${BFAHOME}

USER 1023000000
