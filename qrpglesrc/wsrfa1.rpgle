     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRFA1: QUOM Versión 2                                       *
      *         Ingreso de Factura                                   *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *12-Ago-2020            *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      *   JSN 08/04/2021 - Se agrega cambios con la extencion del    *
      *                    nombre del documento                      *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/svpfac_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D coma            s              2a
     D nrma            s              7a
     D fe1a            s              4a
     D fe1m            s              2a
     D fe1d            s              2a
     D c4s2            s              3a
     D varc            s            300a
     D tipo            s              1a
      * Variables ----------------------------------------------
     D @@nivt          s              1  0
     D @@nivc          s              5  0
     D @@nit1          s              1  0
     D @@niv1          s              5  0
     D @@nrma          s              7  0
     D @@fe1a          s              4  0
     D @@fe1m          s              2  0
     D @@fe1d          s              2  0
     D @@c4s2          s              3  0
     D @@repl          s          65535a
     D @@long          s             10i 0
     D ErrCode         s             10i 0
     D ErrText         s             80A

     D url             s           3000a   varying
     D x               s             10i 0
     D z               s             10i 0
     D rc              s              1n
     D rc2             s             10i 0

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
     D finArc          c                   const('.pdf')
     D finAr1          c                   const('.PDF')
      * Estructuras ------------------------------------------------ *
     D @@base          ds                  likeds(paramBase)
     D peErro          s             10i 0
     D peMsgs          ds                  likeds(paramMsgs)

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
            + '<b>Ingreso de Factura (Request)</b>'    + CRLF
            + '&nbspFecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                    + CRLF
            + '&nbsp&nbspURL   : '      + uri               + CRLF ;
       COWLOG_pgmlog( psds.this : Data );

       url = %trim(uri);
       empr =  REST_getNextPart(url);
       sucu =  REST_getNextPart(url);
       nivt =  REST_getNextPart(url);
       nivc =  REST_getNextPart(url);
       nit1 =  REST_getNextPart(url);
       niv1 =  REST_getNextPart(url);
       coma =  REST_getNextPart(url);
       nrma =  REST_getNextPart(url);
       fe1a =  REST_getNextPart(url);
       fe1m =  REST_getNextPart(url);
       fe1d =  REST_getNextPart(url);
       c4s2 =  REST_getNextPart(url);
       varc =  REST_getNextPart(url);
       tipo =  REST_getNextPart(url);

       empr = %xlate( min : may : empr );
       sucu = %xlate( min : may : sucu );

       tipo = %xlate( min : may : tipo );
       if ( tipo <> 'G' and tipo <> 'W' );
         tipo = 'W';
       endif;

       if %check('0123456789':%trim(nivt)) <> *zeros;
         @@nivt = 0;
       else;
         monitor;
           @@nivt = %int( %trim(nivt) );
         on-error;
           @@nivt = 0;
         endmon;
       endif;

       if %check('0123456789':%trim(nivc)) <> *zeros;
         @@nivc = 0;
       else;
         monitor;
           @@nivc = %int( %trim(nivc) );
         on-error;
           @@nivc = 0;
         endmon;
       endif;

       if %check('0123456789':%trim(nit1)) <> *zeros;
         @@niv1 = 0;
       else;
         monitor;
           @@niv1 = %int( %trim(niv1) );
         on-error;
           @@niv1 = 0;
         endmon;
       endif;

       if %check('0123456789':%trim(nit1)) <> *zeros;
         @@nit1 = 0;
       else;
         monitor;
           @@nit1 = %int( %trim(nit1) );
         on-error;
           @@nit1 = 0;
         endmon;
       endif;

       if %check('0123456789':%trim(nrma)) <> *zeros;
         @@nrma = 0;
       else;
          monitor;
            @@nrma = %int( %trim(nrma) );
          on-error;
            @@nrma = 0;
          endmon;
       endif;

       if %check('0123456789':%trim(fe1a)) <> *zeros;
          @@fe1a = 0;
       else;
          monitor;
            @@fe1a = %int( %trim(fe1a) );
          on-error;
            @@fe1a = 0;
          endmon;
       endif;

       if %check('0123456789':%trim(fe1m)) <> *zeros;
          @@fe1m = 0;
       else;
          monitor;
            @@fe1m = %int( %trim(fe1m) );
          on-error;
            @@fe1m = 0;
          endmon;
       endif;

       if %check('0123456789':%trim(fe1d)) <> *zeros;
          @@fe1d = 0;
       else;
          monitor;
            @@fe1d = %int( %trim(fe1d) );
          on-error;
            @@fe1d = 0;
          endmon;
       endif;

       if %check('0123456789':%trim(c4s2)) <> *zeros;
          @@c4s2 = 0;
       else;
          monitor;
            @@c4s2 = %int( %trim(c4s2) );
          on-error;
            @@c4s2 = 0;
          endmon;
       endif;

       // Valida Nombre del Archivo...
       if Varc = *blanks;
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'FAC0003' : peMsgs );
         exsr setError;
       else;
         x = %scan( finArc : varc );
         if x = 0;
           x = %scan( finAr1 : varc );
           if x = 0;
             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'FAC0004' : peMsgs );
             exsr setError;
           else;
             varc = %scanrpl( '.PDF' : '.pdf' : varc);
           endif;
         endif;
       endif;

       @@base.peEmpr = empr;
       @@base.peSucu = sucu;
       @@base.peNivt = @@nivt;
       @@base.peNivc = @@nivc;
       if not SVPWS_chkParmBase( @@base : peMsgs);
          exsr setError;
       endif;

       // Valida que este registrado la factura en PAHIVA...
       if not SVPFAC_chkFactura( Empr
                               : sucu
                               : coma
                               : @@Nrma
                               : @@Fe1a
                               : @@Fe1m
                               : @@Fe1d
                               : @@C4s2 );

         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'FAC0001' : peMsgs );
         exsr setError;

       endif;

       // Valida que exista mayor auxiliar
       if not SVPVAL_chkMayorAuxiliar( Empr
                                     : Sucu
                                     : Coma
                                     : @@Nrma );

         %subst(@@repl:1:2) = %trim( coma );
         %subst(@@repl:3:7) = %editc( @@Nrma :'X');
         @@long = %len ( %trim ( @@repl ) );

         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'MAY0001'
                       : peMsgs : @@repl : @@long );
         exsr setError;

       endif;

       //Ingresa factura Web...
       if not SVPFAC_setIngreso( Empr
                               : Sucu
                               : Coma
                               : @@Nrma
                               : @@Fe1a
                               : @@Fe1m
                               : @@Fe1d
                               : @@C4s2
                               : Varc
                               : peErro
                               : peMsgs );
         exsr setError;
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray('resultado');
         REST_writeXmlLine('ok' : '1');
       REST_endArray('resultado');

       clear peMsgs;
       Data = '<br><br><b>WSRFA1-Ingreso de Factura '
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

          Data = '<br><br><b>WSRFA1-Ingreso de Factura '
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
