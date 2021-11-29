FROM bfaar/nodo:test

USER root

ADD env ${BFAHOME}/bin/

RUN chgrp -R 0 ${HOME} && chown -R 0:0 ${HOME} && chmod -R g=u ${HOME}

RUN chgrp -R 0 ${BFAHOME} && chown -R 0:0 ${HOME} && chmod -R g=u ${BFAHOME}

RUN chgrp -R 0 ${BFANETWORKDIRTEST} && chown -R 0:0 ${BFANETWORKDIRTEST} && chmod -R g=u ${BFANETWORKDIRTEST}

RUN chgrp -R 0 ${BFANETWORKDIR} && chown -R 0:0 ${BFANETWORKDIR} && chmod -R g=u ${BFANETWORKDIR} 

RUN chgrp -R 0 ${BFANODEDIR} && chown -R 0:0 ${BFANODEDIR} && chmod -R g=u ${BFANODEDIR} 


#RUN chown 1023000000:1023000000 -R ${HOME}

USER bfa
