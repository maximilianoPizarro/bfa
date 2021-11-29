FROM bfaar/nodo:test

USER root

ADD env ${BFAHOME}/bin/

RUN chgrp -R 0 ${HOME} && chmod -R 777 g=u ${HOME}

RUN chgrp -R 0 ${BFAHOME} && chmod -R 777 g=u ${BFAHOME}

RUN chgrp -R 0 ${BFANETWORKDIRTEST} && chmod -R 777 g=u ${BFANETWORKDIRTEST}

RUN chgrp -R 0 ${BFANETWORKDIR} && chmod -R 777 g=u ${BFANETWORKDIR} 

RUN chgrp -R 0 ${BFANODEDIR} && chmod -R 777 g=u ${BFANODEDIR} 


#RUN chown 1023000000:1023000000 -R ${HOME}

USER bfa
