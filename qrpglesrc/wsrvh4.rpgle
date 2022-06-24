     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRVEH: QUOM Versión 2                                       *
      *         Retorna Infoauto de un GAUS.                         *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *20-Jun-2017            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fset204    if   e           k disk
     Fset20493  if   e           k disk    rename(s1t204:s1t20493)
     Fset209    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpiau_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'

     D empr            s              1a
     D sucu            s              2a
     D vhmc            s              3a
     D vhmo            s              3a
     D vhcs            s              3a

     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n
     D c               s             10i 0
     D rc2             s             10i 0
     D @@vhct          s              2  0
     D @@vhni          s              1a
     D peVehi          ds                  likeds(iauto2_t)
     D peMsgs          ds                  likeds(paramMsgs)

     D k1t204          ds                  likerec(s1t204:*key)
     D k2t204          ds                  likerec(s1t20493:*key)
     D k1t209          ds                  likerec(g1upos:*key)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

      /free

       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
          return;
       endif;
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       vhmc = REST_getNextPart(url:'@');
       vhmo = REST_getNextPart(url:'@');
       vhcs = REST_getNextPart(url:'@');

       k1t204.t@vhmc = vhmc;
       k1t204.t@vhmo = vhmo;
       k1t204.t@vhcs = vhcs;

       chain %kds(k1t204:3) set204;
       if not %found;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0199'
                       : peMsgs     );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          close *all;
          return;
       endif;

       @@vhct = t@vhct;
       @@vhni = t@vhni;

       if t@mar1 = 'E';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0200'
                       : peMsgs     );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          close *all;
          return;
       endif;

       c = 0;
       k2t204.t@cma1 = t@cma1;
       k2t204.t@cmo1 = t@cmo1;
       setll %kds(k2t204:2) set20493;
       reade %kds(k2t204:2) set20493;
       dow not %eof;
           c += 1;
           if c > 1;
              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'COW0201'
                           : peMsgs     );
              rc = REST_writeHeader( 400
                                   : *omit
                                   : *omit
                                   : peMsgs.peMsid
                                   : peMsgs.peMsev
                                   : peMsgs.peMsg1
                                   : peMsgs.peMsg2 );
              REST_end();
              SVPREST_end();
              close *all;
              return;
           endif;
        reade %kds(k2t204:2) set20493;
       enddo;

       rc2 = SVPIAU_getVehicul2( t@cma1 : t@cmo1 : peVehi );
       if rc2 = -1;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0199'
                       : peMsgs     );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          close *all;
          return;
       endif;

       k1t209.g1cmar = t@cma1;
       k1t209.g1cgru = peVehi.i@grup;
       chain %kds(k1t209:2) set209;
       if not %found;
          gnomgr = *blanks;
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'codigosInfoauto' );

       REST_writeXmlLine( 'codigoMarca'      : %char(t@cma1) );
       REST_writeXmlLine( 'descripcionMarca' : peVehi.i@dmar );
       REST_writeXmlLine( 'codigoModelo'     : %char(peVehi.i@grup) );
       REST_writeXmlLine( 'descripcionModelo': gnomgr );
       REST_writeXmlLine( 'codigoVersion'    : %char(t@cmo1) );
       REST_writeXmlLine( 'descripcion'      : peVehi.i@dmod );
       REST_writeXmlLine( 'codigoOrigen' : @@vhni );
       if @@vhni = 'I';
          REST_writeXmlLine( 'descripcionOrigen' : 'IMPORTADO');
        else;
          REST_writeXmlLine( 'descripcionOrigen' : 'NACIONAL');
       endif;
       REST_writeXmlLine( 'codigoTipo' : %char(@@vhct) );
       REST_writeXmlLine( 'descripcionTipo'
                        : SVPDES_getTipoDeVehiculo( @@vhct ) );

       REST_endArray( 'codigosInfoauto' );

       return;

      /end-free

