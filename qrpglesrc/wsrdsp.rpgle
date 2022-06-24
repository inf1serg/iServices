     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRDSP: QUOM Versión 2                                       *
      *         Retorna datos de Siniestro para armar denuncia en    *
      *         PDF.                                                 *
      *         Para productores.                                    *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *14-Abr-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fpahstr1   if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D WSRDSI          pr                  extpgm('WSRDSI')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peRama                        2  0 const
     D  peSini                        7  0 const
     D  peTipo                        1a   const

     D rc              s              1n
     D url             s           3000a   varying
     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D rama            s              2a
     D sini            s              7a

     D @@repl          s          65535a
     D peRama          s              2  0
     D peSini          s              7  0
     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)

     D k1hstr          ds                  likerec(p1hstr1:*key)

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
       sini = REST_getNextPart(url);

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
          close *all;
          return;
       endif;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);
       COWLOG_logcon( 'WSRDSP' : peBase );

       monitor;
          peRama = %dec(rama:2:0);
        on-error;
          peRama = 0;
       endmon;

       monitor;
          peSini = %dec(sini:7:0);
        on-error;
          peSini = 0;
       endmon;

       k1hstr.stempr = empr;
       k1hstr.stsucu = sucu;
       k1hstr.stnivt = %dec( nivt : 1 : 0 );
       k1hstr.stnivc = %dec( nivc : 5 : 0 );
       k1hstr.strama = peRama;
       k1hstr.stsini = peSini;
       setll %kds(k1hstr:6) pahstr1;
       if not %equal;
          %subst(@@repl:1:2) = rama;
          %subst(@@repl:3:7) = sini;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl))  );
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

       WSRDSI( empr : sucu : peRama : peSini : 'P');

       return;

      /end-free

