FROM            bfaar/nodo:toolbase
LABEL		maintainer="Robert Martin-Legene <robert@nic.ar>"
#HEALTHCHECK	--start-period=15s CMD [ "/usr/bin/nc", "-z", "-w", "2", "127.0.0.1", "8545" ]
CMD		[ "/home/bfa/bfa/bin/singlestart.sh" ]
EXPOSE          8545 8546 30303
ENV		USERNAME=bfa HOME=/home/bfa
ENV             BFAHOME=${HOME}/bfa BFANETWORKIDPROD=47525974938 BFANETWORKIDTEST=55555000000 VIRTUALIZATION=DOCKER GITBRANCH=__GITBRANCH__
ENV             BFANETWORKDIRPROD=${BFAHOME}/network BFANETWORKDIRTEST=${BFAHOME}/test2network PATH=${BFAHOME}/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV     	BFANETWORKID=__BFANETWORKID__ BFANETWORKDIR=__BFANETWORKDIR__ GITBRANCH=__GITBRANCH__
ENV		BFANODEDIR=${BFANETWORKDIR}/node BFATOML=${BFANETWORKDIR}/config.toml
#RUN             mkdir ${BFANODEDIR} && ln -s ${BFANODEDIR} ${HOME}/.ethereum
USER		${USERNAME}
WORKDIR 	${BFAHOME}
RUN		git checkout package-lock.json ; git checkout ${GITBRANCH} && git pull
VOLUME          $BFANETWORKDIR/cache
VOLUME          $BFANODEDIR

RUN chown 1023000000:1023000000 -R /home/bfa

USER 1023000000
