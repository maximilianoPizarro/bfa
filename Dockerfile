FROM bfaar/nodo:test

USER root


#https://github.com/RHsyseng/container-rhel-examples/tree/master/starter-arbitrary-uid
#RUN chown 1023000000:1023000000 -R /home/bfa

COPY uid_entrypoint /usr/local/bin/

#USER 1023000000
RUN chmod -R u+x /home/bfa

RUN chgrp -R 0 /home/bfa 

RUN chmod -R g=u /home/bfa /etc/passwd

ENTRYPOINT [ "uid_entrypoint" ]
USER 1001
