     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRPS2: QUOM Versión 2                                       *
      *         Predenuncia Siniestros Web - Inserta Predenuncia     *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *04-Ene-2018            *
      * ------------------------------------------------------------ *
      * Modificacion:                                                *
      * LRG 10/01/2018 - Se elimina carga de header 200 ok antes de  *
      *                  invocar al servicio.-                       *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy inf1serg/qcpybooks,svppds_h
      /copy './qcpybooks/svppds_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D rama            s              2a
     D poli            s              7a
     D pate            s             25a
     D focu            s              8a
     D hocu            s              6a
     D caus            s              2a
     D npds            s              7a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D peErro          s             10i 0
     D @@repl          s          65535a
     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)

     D @@npds          s              7  0

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

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
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       nivt = REST_getNextPart(url);
       nivc = REST_getNextPart(url);
       nit1 = REST_getNextPart(url);
       niv1 = REST_getNextPart(url);
       rama = REST_getNextPart(url);
       poli = REST_getNextPart(url);
       pate = REST_getNextPart(url);
       focu = REST_getNextPart(url);
       hocu = REST_getNextPart(url);
       caus = REST_getNextPart(url);
       npds = REST_getNextPart(url);

       // -------------------------------------
       // Valida base
       // -------------------------------------
       if SVPREST_chkBase(empr:sucu:nivt:nivc:nit1:niv1:peMsgs) = *off;
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
       endif;

       // -------------------------------------
       // Valido rama
       // -------------------------------------
       if %check( '0123456789' : %trim(rama) ) <> 0;
          @@repl = rama;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'RAM0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          return;
       endif;

       // -------------------------------------
       // Valido poliza
       // -------------------------------------
       if %check( '0123456789' : %trim(poli) ) <> 0;
          %subst(@@repl:1:2) = rama;
          %subst(@@repl:3:7) = poli;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          return;
       endif;

       // -------------------------------------
       // Valido numero de predenuncia
       // -------------------------------------
       if %check( '0123456789' : %trim(npds) ) <> 0;
          @@repl = npds;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0006'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          return;
       endif;

       @@npds = %dec(npds:7:0);
       if @@npds <= 0;
          @@repl = npds;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0006'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          return;
       endif;

       // -------------------------------------
       // Valido fecha de ocurrencia
       // -------------------------------------
       if %check( '0123456789' : %trim(focu) ) <> 0;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0003'
                       : peMsgs      );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          return;
       endif;

       // -------------------------------------
       // Valido hora de ocurrencia
       // -------------------------------------
       if %check( '0123456789' : %trim(hocu) ) <> 0;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0007'
                       : peMsgs   );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          return;
       endif;

       // -------------------------------------
       // Valido causa
       // -------------------------------------
       if %check( '0123456789' : %trim(caus) ) <> 0;
          @@repl = caus;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0002'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          return;
       endif;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       SVPPDS_setPreDen2( peBase
                        : %dec(npds:7:0)
                        : %dec(rama:2:0)
                        : %dec(poli:7:0)
                        : %trim(pate)
                        : %dec(focu:8:0)
                        : %dec(hocu:6:0)
                        : %dec(caus:2:0)
                        : peErro
                        : peMsgs          );

       if peErro = -1;
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          return;
       endif;

       REST_writeHeader();
       REST_writeEncoding();
       REST_end();
       return;

      /end-free

