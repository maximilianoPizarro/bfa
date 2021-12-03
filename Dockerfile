FROM bfaar/nodo:test

USER root

ADD env ${BFAHOME}/bin/

RUN chown 0:0 -R ${HOME}

RUN chown 30303:0 ${BFAHOME} && chgrp -R 0 ${BFAHOME} && chmod -R g=u ${BFAHOME}

USER bfa
