FROM bfaar/nodo:test

USER root

ADD env ${BFAHOME}/bin/

RUN chgrp -R 0 ${BFAHOME} && chmod -R g=u ${BFAHOME}

USER bfa
