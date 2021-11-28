FROM bfaar/nodo:test

USER root

ADD uid_entrypoint /bin/uid_entrypoint

ENTRYPOINT [ "uid_entrypoint" ]
USER 1001
