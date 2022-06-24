     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRO01: QUOM Versión 2                                       *
      *         Ordenes de Pago - Digital                            *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *18-Ene-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpopg_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D artc            s              2a
     D pacp            s              6a
      * Variables ----------------------------------------------
     D @@Artc          s              2  0
     D @@Pacp          s              6  0
     D @@repl          s          65535a
     D @@long          s             10i 0
     D ErrCode         s             10i 0
     D ErrText         s             80A

     D url             s           3000a   varying
     D x               s             10i 0
     D z               s             10i 0
     D rc              s              1n
     D rc2             s             10i 0
     D @@Dsts          s             40a
     D fecha           s              8  0
     D fechOrde        s             10a

      * Auditorias -------------------------------------------------*
     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)
     D   JobName                     10a   overlay(PsDs:244)
     D   JobUser                     10a   overlay(PsDs:254)
     D   JobNbr                       6  0 overlay(PsDs:264)
     D   JobCurU                     10a   overlay(PsDs:358)

     d WSLOG           pr                  extpgm('QUOMDATA/WSLOG')
     d  msg                         512a   const
     d  peMsg          s            512a

     d sleep           pr            10u 0 extproc('sleep')
     d  secs                         10u 0 value

      * -------------------------------------------------------------------- *

     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a

      * -------------------------------------------------------------------- *
     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

      * Estructuras ------------------------------------------------ *
     D @@base          ds                  likeds(paramBase)
     D peErro          s             10i 0
     D peMsgs          ds                  likeds(paramMsgs)
     D DsPa            ds                  likeds( dscnhopa_t ) dim(9999)
     D DsPaC           s             10i 0

      * Dtaara envío automático ------------------------------------ *
     D dtapdf          ds                  dtaara(DTAPDF01) qualified
     D  filler                       22a   overlay(dtapdf:1)
     D  enviar                        1a   overlay(dtapdf:*next)
     D  filer2                       77a   overlay(dtapdf:*next)

      * Claves de arvhivos ----------------------------------------- *

      /free

       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
         peMsgs.pemsev = 40;
         peMsgs.peMsid = 'RPG0001';
         peMsgs.pemsg1 = 'Error al parsear URL';
         peMsgs.pemsg2 = 'Error al parsear URL';
         exsr setError;
       endif;

       Data = CRLF + CRLF
            + '&nbsp<b>' +  psds.this  + '</b>'
            + '<b>Ordenes de Pago(Request)</b>'    + CRLF
            + '&nbspFecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                    + CRLF
            + '&nbsp&nbspURL   : '      + uri               + CRLF ;
       COWLOG_pgmlog( psds.this : Data );

       url = %trim(uri);
       empr =  REST_getNextPart(url);
       sucu =  REST_getNextPart(url);
       artc =  REST_getNextPart(url);
       pacp =  REST_getNextPart(url);

       empr = %xlate( min : may : empr );
       sucu = %xlate( min : may : sucu );

       monitor;
         @@Artc = %int( %trim(artc) );
       on-error;
         @@Artc = 0;
       endmon;

       monitor;
         @@Pacp = %int( %trim(pacp) );
       on-error;
         @@Pacp = 0;
       endmon;

       clear DsPa;
       DsPaC = 0;
       if not SVPOPG_getCnhopa( Empr : Sucu : @@Artc : @@Pacp : DsPa : DsPaC );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0001' : peMsgs );
         exsr setError;
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       for x = 1 to DsPaC;
       clear @@Dsts;
       REST_startArray('ordenDePago');
         REST_writeXmlLine('status' : %trim(DsPa(x).paStop));
         @@Dsts = SVPDES_estadoOrdenDePago( DsPa(x).paStop );
         REST_writeXmlLine('descripcionStatus' : %trim(@@Dsts));

         REST_startArray('datosDelPago');
           fecha = (DsPa(x).pbfasa * 10000)
                 + (DsPa(x).pbfasm *   100)
                 +  DsPa(x).pbfasd;

           monitor;
             fechOrde = %char(%date(fecha:*iso):*iso);
            on-error;
             fechOrde = *blanks;
           endmon;
           if fechOrde = '0001-01-01';
             fechOrde = *blanks;
           endif;

           REST_writeXmlLine('fechaDelPago' : fechOrde);
           REST_writeXmlLine('comprobanteDePago' : %char(DsPa(x).pbNras));
           REST_writeXmlLine('libro' : %char(DsPa(x).pbLibr));
           REST_writeXmlLine('tipoComprobante' : %char(DsPa(x).pbTico));
           REST_writeXmlLine('nroChequetransferencia' : %char(DsPa(x).pbIvch));
         REST_endArray('datosDelPago');
       REST_endArray('ordenDePago');
       endfor;

       clear peMsgs;
       Data = '<br><br><b>WSRMPO-Ordenes de Pago    '
            + '(Response)</b> : Finalizo OK' + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                  + CRLF
            + 'PEERRO: ' +  '0'                           + CRLF
            + 'PEMSGS'                                    + CRLF
            + '&nbsp;PEMSEV: ' + %char(peMsgs.peMsev)     + CRLF
            + '&nbsp;PEMSID: ' + peMsgs.peMsid            + CRLF
            + '&nbsp;PEMSG1: ' + %trim(peMsgs.peMsg1)     + CRLF
            + '&nbsp;PEMSG2: ' + %trim(peMsgs.peMsg2)     + CRLF
            + 'PEMSGS' + CRLF;
       COWLOG_pgmlog( psds.this : Data );
       separa = *all'-';
       data = separa;
       COWLOG_pgmlog( psds.this : Data );
       REST_end();

      /end-free

       //* ---------------------------------------------------------- *
       begsr setError;

         REST_writeHeader( 400
                         : *omit
                         : *omit
                         : peMsgs.peMsid
                         : peMsgs.peMsev
                         : peMsgs.peMsg1
                         : peMsgs.peMsg2 );

          Data = '<br><br><b>WSRO01-Ordenes de Pago '
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
          separa = *all'-';
          data = separa;
          COWLOG_pgmlog( psds.this : Data );
          REST_end();
          return;
       endsr;

      /define GETSYSV_LOAD_PROCEDURE
      /copy './qcpybooks/getsysv_h.rpgle'
