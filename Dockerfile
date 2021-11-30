FROM bfaar/nodo:test

USER root

ADD env ${BFAHOME}/bin/

RUN chown 0:0 -R ${HOME}

RUN chgrp -R 0 ${BFAHOME} && chmod -R g=u ${BFAHOME}

#RUN chgrp -R 0 ${BFAHOME} && chmod -R g=u ${BFAHOME} && chmod -R 777 ${BFAHOME}

#RUN chgrp -R 0 ${BFANETWORKDIRTEST} && chmod -R g=u ${BFANETWORKDIRTEST} && chmod -R 777 ${BFANETWORKDIRTEST}

#RUN chgrp -R 0 ${BFANETWORKDIR} && chmod -R g=u ${BFANETWORKDIR} && chmod -R 777 ${BFANETWORKDIR} 

#RUN chgrp -R 0 ${BFANODEDIR} && chmod -R g=u ${BFANODEDIR} && chmod -R 777 ${BFANODEDIR} 


#RUN chown 1023000000:1023000000 -R ${HOME}

USER bfa
