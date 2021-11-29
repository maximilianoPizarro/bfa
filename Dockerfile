FROM bfaar/nodo:test

USER root

ADD env ${BFAHOME}/bin/

RUN chgrp -R 0 ${HOME} && chmod -R u+x ${HOME} && chmod -R g=u ${HOME}

RUN chgrp -R 0 ${BFAHOME} && chmod -R u+x ${HOME} && chmod -R g=u ${BFAHOME}

RUN chgrp -R 0 ${BFANETWORKDIRTEST} && chmod -R u+x ${BFANETWORKDIRTEST} && chmod -R g=u ${BFANETWORKDIRTEST}

RUN chgrp -R 0 ${BFANETWORKDIR} && chmod -R u+x ${BFANETWORKDIR} && chmod -R g=u ${BFANETWORKDIR} 

RUN chgrp -R 0 ${BFANODEDIR} && chmod -R u+x ${BFANODEDIR} && chmod -R g=u ${BFANODEDIR} 


#RUN chown 1023000000:1023000000 -R ${HOME}

USER bfa
