     H option(*srcstmt:*noshowcpy:*nodebugio) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRAGM: Portal de Autogestión de Asegurados.                 *
      *         Arrepentimiento con Siniestro/Endoso                 *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *28-Jul-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fpahag5    if a e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svppol_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'

      * ------------------------------------------------------------ *
      * URL y URI
      * ------------------------------------------------------------ *
     D uri             s            512a
     D url             s           3000a   varying

      * ------------------------------------------------------------ *
      * Parámetros de URL
      * ------------------------------------------------------------ *
     D empr            s              1a
     D sucu            s              2a
     D tdoc            s              2a
     D ndoc            s             11a
     D arcd            s              6a
     D spol            s              9a
     D rama            s              2a
     D arse            s              2a
     D oper            s              7a
     D poli            s              7a
     D mar1            s              1a

     D peTdoc          s              2  0
     D peNdoc          s             11  0
     D peArcd          s              6  0
     D peSpol          s              9  0
     D peRama          s              2  0
     D peArse          s              2  0
     D peOper          s              7  0
     D pePoli          s              7  0
     D @@fecn          s              8  0
     D @@horn          s              6  0
     D peCade          s              5  0 dim(9)

     D x               s             10i 0
     D peRepl          s          65535a
     D rc              s              1n
     D LogData         s          65535a   varying
     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0

     D k1hag5          ds                  likerec(p1hag5:*key)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)
     D  curusr                       10a   overlay(psds:358)

      /free

       *inlr = *on;

       REST_getUri( psds.this : uri );
       url = %trim(uri);

       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       tdoc = REST_getNextPart(url);
       ndoc = REST_getNextPart(url);
       arcd = REST_getNextPart(url);
       spol = REST_getNextPart(url);
       rama = REST_getNextPart(url);
       arse = REST_getNextPart(url);
       oper = REST_getNextPart(url);
       poli = REST_getNextPart(url);
       mar1 = REST_getNextPart(url);

       if SVPREST_chkCliente( empr
                            : sucu
                            : tdoc
                            : ndoc
                            : peMsgs ) = *Off;
          exsr logError;
          REST_writeHeader();
          REST_writeEncoding();
          exsr wrtError;
          REST_end();
          SVPREST_end();
          close *all;
          return;
       endif;

       if SVPREST_chkPolizaCliente( empr
                                  : sucu
                                  : arcd
                                  : spol
                                  : rama
                                  : poli
                                  : tdoc
                                  : ndoc
                                  : peMsgs ) = *off;
          exsr logError;
          REST_writeHeader();
          REST_writeEncoding();
          exsr wrtError;
          REST_end();
          SVPREST_end();
          close *all;
          return;
       endif;

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

       monitor;
         peArcd = %dec(arcd:6:0);
        on-error;
         peArcd = 0;
       endmon;

       monitor;
         peSpol = %dec(spol:9:0);
        on-error;
         peSpol = 0;
       endmon;

       monitor;
         peRama = %dec(rama:2:0);
        on-error;
         peRama = 0;
       endmon;

       monitor;
         peArse = %dec(arse:2:0);
        on-error;
         peArse = 0;
       endmon;

       monitor;
         peOper = %dec(oper:7:0);
        on-error;
         peOper = 0;
       endmon;

       monitor;
         pePoli = %dec(poli:7:0);
        on-error;
         pePoli = 0;
       endmon;

       rc = COWLOG_logConAutoGestion( empr
                                    : sucu
                                    : peTdoc
                                    : peNdoc
                                    : psds.this);

       //
       // Tipo de error:
       // "S" = Con Siniestro
       // "E" = Con Endoso
       // "A" = Ambos

       if mar1 <> 'S' and mar1 <> 'E' and mar1 <> 'A';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'AAG0011'
                       : peMsgs    );
          exsr logError;
          REST_writeHeader( 200
                          : *omit
                          : *omit
                          : peMsgs.peMsid
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          exsr wrtError;
          REST_end();
          SVPREST_end();
          close *all;
          return;
       endif;

       k1hag5.g5empr = empr;
       k1hag5.g5sucu = sucu;
       k1hag5.g5arcd = peArcd;
       k1hag5.g5spol = peSpol;
       k1hag5.g5rama = peRama;
       k1hag5.g5arse = peArse;
       k1hag5.g5oper = peOper;
       k1hag5.g5poli = pePoli;
       setll %kds(k1hag5:8) pahag5;
       if not %equal;
          g5empr = empr;
          g5sucu = sucu;
          g5arcd = peArcd;
          g5spol = peSpol;
          g5rama = peRama;
          g5arse = peArse;
          g5oper = peOper;
          g5poli = pePoli;
          g5mar1 = mar1;
          g5mar5 = '0';
          g5usr1 = psds.curusr;
          g5fec1 = %dec(%date():*iso);
          g5tim1 = %dec(%time():*iso);
          write p1hag5;
          exsr logSuccess;
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'envioMail' );
        REST_writeXmlLine( 'estado'    : 'OK'   );
        REST_writeXmlLine( 'mensaje'   : ' '    );
       REST_endArray( 'envioMail' );

       return;

       begsr logError;
        LogData = %trim(url)
                + '<br>'
                + 'peErro: ' + %trim(%char(peErro))
                + '<br>'
                + 'peMsid: ' + %trim(peMsgs.peMsid)
                + '<br>'
                + 'peMsg1: ' + %trim(peMsgs.peMsg1)
                + '<br>'
                + 'peMsg2: ' + %trim(peMsgs.peMsg2)
                + '<br>';
        COWLOG_pgmLog( psds.this : LogData );
       endsr;

       begsr logSuccess;
        LogData = %trim(url)
                + '<br>'
                + 'Se ha grabado correctamente registro en PAHAG5<br>';
        COWLOG_pgmLog( psds.this : LogData );
       endsr;

       begsr wrtError;
        REST_startArray( 'envioMail' );
         REST_writeXmlLine( 'estado'    : 'ERROR');
         REST_writeXmlLine( 'mensaje' : %trim(peMsgs.peMsg1) );
        REST_endArray( 'envioMail' );
       endsr;

      /end-free

