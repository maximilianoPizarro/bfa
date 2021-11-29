FROM bfaar/nodo:test

USER root

RUN chgrp -R 0 ${HOME} && chmod -R g=u ${HOME}

RUN chgrp -R 0 ${BFANODEDIR} && chmod -R g=u ${BFANODEDIR}


#RUN chown 1023000000:1023000000 -R ${HOME}

USER bfa
