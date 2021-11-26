FROM bfaar/nodo:test

USER root

RUN chown 1023000000:1023000000 -R /home/bfa

USER 1023000000
