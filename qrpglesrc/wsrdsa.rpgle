     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRDSA: QUOM Versión 2                                       *
      *         Retorna datos de Siniestro para armar denuncia en    *
      *         PDF.                                                 *
      *         Para asegurados.                                     *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *14-Abr-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

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
     D tdoc            s              2a
     D ndoc            s             11a
     D rama            s              2a
     D sini            s              7a

     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D @@repl          s          65535a
     D peRama          s              2  0
     D peSini          s              7  0
     D peTdoc          s              2  0
     D peNdoc          s             11  0

     D peMsgs          ds                  likeds(paramMsgs)

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
       tdoc = REST_getNextPart(url);
       ndoc = REST_getNextPart(url);
       rama = REST_getNextPart(url);
       sini = REST_getNextPart(url);

       if SVPREST_chkCliente( empr
                            : sucu
                            : tdoc
                            : ndoc
                            : peMsgs ) = *Off;
          exsr setError;
       endif;

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

       monitor;
          peTdoc = %dec(tdoc:2:0);
        on-error;
          peTdoc = 0;
       endmon;

       monitor;
          peNdoc = %dec(ndoc:11:0);
        on-error;
          peNdoc = 0;
       endmon;

       rc = COWLOG_logConAutoGestion( empr
                                    : sucu
                                    : peTdoc
                                    : peNdoc
                                    : psds.this);

       WSRDSI( empr : sucu : peRama : peSini : 'A' );

       return;

       begsr setError;
         REST_writeHeader( 400
                         : *omit
                         : *omit
                         : peMsgs.peMsid
                         : peMsgs.peMsev
                         : peMsgs.peMsg1
                         : peMsgs.peMsg2 );
          Data = '<br><br><b> psds.this-Detalle de Cuotas'
               + '(Response)</b> : Error' + CRLF
               + 'Fecha/Hora: '
               + %trim(%char(%date():*iso)) + ' '
               + %trim(%char(%time():*iso))                  + CRLF
               + 'PEERRO: ' +  '-1'                          + CRLF
               + 'PEMSGS'                                    + CRLF
               + '&nbsp;PEMSEV: ' + %char(peMsgs.peMsev)     + CRLF
               + '&nbsp;PEMSID: ' + peMsgs.peMsid            + CRLF
               + '&nbsp;PEMSG1: ' + %trim(peMsgs.peMsg1)     + CRLF
               + '&nbsp;PEMSG2: ' + %trim(peMsgs.peMsg2)     + CRLF
               + 'PEMSGS' + CRLF;
          COWLOG_pgmlog( psds.this : Data );
          data = '<hr color="green" size=3 />' + CRLF;
          COWLOG_pgmlog( psds.this : Data );
          REST_end();
          return;
       endsr;

      /end-free

