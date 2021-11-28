FROM bfaar/nodo:test

USER root
#https://github.com/RHsyseng/container-rhel-examples/tree/master/starter-arbitrary-uid

ADD entrypoint.sh ${BFAHOME}/bin/entrypoint_uid.sh

#RUN chmod +x ${BFAHOME}/bin/entrypoint_uid.sh

#RUN source ${BFAHOME}/bin/entrypoint.sh

#RUN ls -la ${BFAHOME}/bin/entrypoint.sh

#RUN chmod -R u+x /home/bfa

#RUN chgrp -R 0 /home/bfa 

#RUN chmod -R g=u /home/bfa /etc/passwd

#ENTRYPOINT [ "entrypoint" ]

RUN chown 1023000000:1023000000 -R /home/bfa
USER 1023000000
