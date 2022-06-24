     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRCXF: QUOM Versión 2                                       *
      *         Listar Cambio de forma de pagos                      *
      * ------------------------------------------------------------ *
      * Luis Roberto Gomez                   *13-Jun-2020            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     D uri             s            512a
     D arcd            s              6a
     D cfpg            s              1a
     D cfp1            s              1a
     D tipo            s              1a
     D url             s           3000a   varying
     D x               s             10i 0
     D y               s             10i 0
     D rc              s              1n
     D @@cfpg          s              1  0
     D @@cfp1          s              1  0
     D @@arcd          s              6  0
     D isPrimera       s               n
     D cantRel         s             10i 0

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)
     D   JobName                     10a   overlay(PsDs:244)
     D   JobUser                     10a   overlay(PsDs:254)
     D   JobNbr                       6  0 overlay(PsDs:264)

     d WSLOG           pr                  extpgm('QUOMDATA/WSLOG')
     d  msg                         512a   const
     d  peMsg          s            512a

     d sleep           pr            10u 0 extproc('sleep')
     d  secs                         10u 0 value

      * ------------------------------------------------------------ *
     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')
      * Estructuras ------------------------------------------------ *
     D @@DsCf          ds                  likeds( dsSet919_t ) dim( 999 )
     D @@DsCfC         s             10i 0
     D @@DsFpg         ds                  likeds( dsGntfpg_t ) dim( 99 )
     D @@DsFpgC        s             10i 0

      * Campos de Log ---------------------------------------------- *
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a

      * Estructuras ------------------------------------------------ *
     D @@erro          s                   like(paramErro)
     D @@msgs          ds                  likeds(paramMsgs)
      * ------------------------------------------------------------ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

      /free

       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       Data = CRLF + CRLF
            + '<b>' +  psds.this  + '</b>'
            + '<b>Combinacion para cambio de Forma de Pago (Request)</b>'+ CRLF
            + '&nbspFecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                    + CRLF
            + '&nbsp&nbspURL   : '      + uri               + CRLF ;
       COWLOG_pgmlog( psds.this : Data );
       if rc = *off;
         @@msgs.pemsev = 40;
         @@msgs.peMsid = 'RPG0001';
         @@msgs.pemsg1 = 'Error al parsear URL';
         @@msgs.pemsg2 = 'Error al parsear URL';
         exsr setError;
       endif;

       url = %trim(uri);
       arcd = REST_getNextPart(url);
       cfpg = REST_getNextPart(url);
       cfp1 = REST_getNextPart(url);
       tipo = REST_getNextPart(url);

       Data = '<b>Parámetros de entrada :</b>'+ CRLF
            + '&nbspPEARCD: '      + arcd              + CRLF
            + '&nbspPECFPG: '      + cfpg              + CRLF
            + '&nbspPECFP1: '      + cfp1              + CRLF
            + '&nbspPETIPO: '      + tipo              + CRLF ;
       COWLOG_pgmlog( psds.this : Data );

       tipo = %xlate( min : may : tipo );
       if ( tipo <> 'T' and tipo <> 'W' );
          tipo = 'T';
       endif;

       if %check('0123456789':%trim(arcd)) <> *zeros;
          @@arcd = 0;
       else;
          @@arcd = %int(%trim( arcd ));
       endif;

       if %check('0123456789':cfpg) <> *zeros;
          @@cfpg = 0;
       else;
          @@cfpg = %int( cfpg );
       endif;

       if %check('0123456789':cfp1) <> *zeros;
          @@cfp1 = 0;
       else;
          @@cfp1 = %int( cfp1 );
       endif;

       // Busca lista de formas de pagos...
       clear cantRel;
       clear @@DsCf;
       clear @@DsCfC;
       clear @@DsFpg;
       clear @@DsFpgC;
       clear @@msgs;
       separa = *all'-';

       rc = *off;
       isPrimera = *on;

       if @@cfpg > 0;
          rc = SVPTAB_getFormasDePago( tipo: @@DsFpg : @@DsFpgC : @@cfpg );
       else;
          rc = *off;
       endif;

       if not rc;
         @@msgs.pemsev = 40;
         @@msgs.peMsid = 'TAB0001';
         @@msgs.pemsg1 = 'No se encontraron datos para informar';
         @@msgs.pemsg2 = 'Verifique la informacion solicitada' ;
         exsr setError;
       endif;

       for y = 1 to @@DsFpgC;
          if @@cfp1 > 0;
             if SVPTAB_getCombinacionFormaDePago( @@arcd
                                                : @@DsFpg( y ).fpcfpg
                                                : @@cfp1
                                                : @@DsCf
                                                : @@DsCfC
                                                : tipo                );
                exsr imprimir;
             endif;
          else;
             if SVPTAB_getCombinacionFormaDePago( @@arcd
                                                : @@DsFpg( y ).fpcfpg
                                                : *omit
                                                : @@DsCf
                                                : @@DsCfC
                                                : tipo                );
                exsr imprimir;
             endif;
          endif;
       endfor;

       if isPrimera;
         @@msgs.pemsev = 40;
         @@msgs.peMsid = 'TAB0001';
         @@msgs.pemsg1 = 'No se encontraron datos para informar';
         @@msgs.pemsg2 = 'Verifique la informacion solicitada ' ;
         exsr setError;
       endif;

       REST_writeXmlLine( 'cantidadFormasDePago' : %char(@@DsCfC));
       REST_endArray( 'formasDePago' );

       exsr setLog;
       REST_end();

       return;

       // --------------------------------------------------------------- //
       begsr imprimir;
          if isPrimera;
             REST_writeHeader();
             REST_writeEncoding();
             REST_startArray('formasDePago');
             isPrimera = *off;
          endif;
          for x = 1 to @@DsCfC;
              REST_startArray( 'formaDePago');
              REST_startArray( 'tipoDePago');
              REST_writeXmlLine( 'codigo' : %char(@@DsCf(x).t@cfp1));
              REST_writeXmlLine( 'descripcion' :
                                  SVPDES_formaPago( @@DsCf(x).t@cfp1 ));
              select;
               when @@dscf(x).t@cfp1 = 1;
                    REST_writeXmlLine( 'efectivo' : 'N');
                    REST_writeXmlLine( 'debito'   : 'N');
                    REST_writeXmlLine( 'credito'  : 'S');
               when @@dscf(x).t@cfp1 = 4;
                    REST_writeXmlLine( 'efectivo' : 'S');
                    REST_writeXmlLine( 'debito'   : 'N');
                    REST_writeXmlLine( 'credito'  : 'N');
               other;
                    REST_writeXmlLine( 'efectivo' : 'N');
                    REST_writeXmlLine( 'debito'   : 'S');
                    REST_writeXmlLine( 'credito'  : 'N');
              endsl;
              REST_endArray( 'tipoDePago');
              REST_startArray( 'tarjeta');
              REST_writeXmlLine( 'codigo' : '000' );
              REST_writeXmlLine( 'nombreTarjeta' : *blanks);
              REST_endArray( 'tarjeta');
              REST_endArray( 'formaDePago');
          endfor;

       endsr;

      /end-free

       //* ---------------------------------------------------------- *
       begsr setLog;

       Data = '<br><br><b>WSRCXF-Combinacion para cambio de forma de pago '
            + '(Response)</b> : OK' + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                  + CRLF
            + 'PEERRO: ' +  '  '                          + CRLF
            + 'PEMSGS'                                    + CRLF
            + '&nbsp;PEMSEV: ' + %char(@@msgs.peMsev)     + CRLF
            + '&nbsp;PEMSID: ' + @@msgs.peMsid            + CRLF
            + '&nbsp;PEMSG1: ' + %trim(@@msgs.peMsg1)     + CRLF
            + '&nbsp;PEMSG2: ' + %trim(@@msgs.peMsg2)     + CRLF
            + 'PEMSGS' + CRLF;
       COWLOG_pgmlog( psds.this : Data );

       data = separa;
       COWLOG_pgmlog( psds.this : Data );

       endsr;

       //* ---------------------------------------------------------- *
       begsr setError;

         REST_writeHeader( 400
                         : *omit
                         : *omit
                         : @@msgs.peMsid
                         : @@msgs.peMsev
                         : @@msgs.pemsg1
                         : @@msgs.pemsg2 );

          Data = '<br><br><b>WSRCXF-Combinacion para cambio de forma de pago '
               + '(Response)</b> : Error' + CRLF
               + 'Fecha/Hora: '
               + %trim(%char(%date():*iso)) + ' '
               + %trim(%char(%time():*iso))                  + CRLF
               + 'PEERRO: ' +  '-1'                          + CRLF
               + 'PEMSGS'                                    + CRLF
               + '&nbsp;PEMSEV: ' + %char(@@msgs.peMsev)     + CRLF
               + '&nbsp;PEMSID: ' + @@msgs.peMsid            + CRLF
               + '&nbsp;PEMSG1: ' + %trim(@@msgs.peMsg1)     + CRLF
               + '&nbsp;PEMSG2: ' + %trim(@@msgs.peMsg2)     + CRLF
               + 'PEMSGS' + CRLF;
          COWLOG_pgmlog( psds.this : Data );
          separa = *all'-';
          data = separa;
          COWLOG_pgmlog( psds.this : Data );
          REST_end();
          return;
       endsr;

