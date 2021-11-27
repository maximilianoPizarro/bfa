FROM bfaar/nodo:test

USER root

RUN chgrp -R 0 /home/bfa && 
    chmod -R g=u /home/bfa

#RUN chown 1023000000:1023000000 -R /home/bfa

#USER 1023000000
USER 1001
