     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRFA2: QUOM Versión 2                                       *
      *         Ingreso de Factura                                   *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *18-Ago-2020            *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      *   JSN 07/06/2022 - Se modifica validación de fecha de factura*
      *                    contra emisión para que haya un tope de   *
      *                    diferencia.                               *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpfac_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'

     D uri             s            512a
     D tfac            s              2a
     D pvta            s              5a
     D nfac            s              8a
     D ffac            s              8a
     D fven            s              8a
     D imau            s             13a
     D varc            s            300a
      * Variables ----------------------------------------------
     D @@a             s              4  0
     D @@m             s              2  0
     D @@d             s              2  0
     D @dia            s             10i 0
     D @@Fsis          s              8  0
     D @@Nfac          s              8  0
     D @@pvta          s              5  0
     D @@tfac          s              2  0
     D @@ffac          s              8  0
     D @@fven          s              8  0
     D @@imau          s             13  2
     D @@repl          s          65535a
     D @@long          s             10i 0
     D @@Femi          s              8  0
     D @@Mens          s            512
     D @@Dest          s             40a
     D ErrCode         s             10i 0
     D ErrText         s             80A
     D @@Cade          s              5  0 dim(9)
     D @@msg           s          65535a
     D @@empr          s              1    inz('A')
     D @@sucu          s              2    inz('CA')
     D DsVw            ds                  likeds( dsPahivw_t ) dim( 9999 )
     D DsVwC           s             10i 0
     D @@DsVa          ds                  likeds( dsPahiva_t ) dim( 9999 )
     D @@DsVaC         s             10i 0
     D @@Vsys          s            512
     D @@Dif           s             15  2
     D @@DifMax        s             15  2
     D @@DifMin        s             15  2
     D @@DifDat        s              8  0
     D @1Date          s               d

     D
     D url             s           3000a   varying
     D x               s             10i 0
     D rc              s              1n

      * Constantes -------------------------------------------------*
     D VALNROFACTURA   C                   'HFACVALNFC'
     D DIFIMPMAXIMO    C                   'HFACIMPMAX'
     D DIFIMPMINIMO    C                   'HFACIMPMIN'
     D DIFFECFACTUR    C                   'HFACFECHDF'

      * Auditorias -------------------------------------------------*
     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)
     D   JobName                     10a   overlay(PsDs:244)
     D   JobUser                     10a   overlay(PsDs:254)
     D   JobNbr                       6  0 overlay(PsDs:264)
     D   JobCurU                     10a   overlay(PsDs:358)

     D lda             ds                  qualified dtaara(*lda)
     D  empr                          1a   overlay(lda:401)
     D  sucu                          2a   overlay(lda:402)

     D WSLOG           pr                  extpgm('QUOMDATA/WSLOG')
     D  msg                         512a   const
     D  peMsg          s            512a

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  peEmpr                        1a                           const
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

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
     D peErro          s             10i 0
     D pemsgs          ds                  likeds(paramMsgs)

      * Dtaara envío automático ------------------------------------ *
     D dtapdf          ds                  dtaara(DTAPDF01) qualified
     D  filler                       22a   overlay(dtapdf:1)
     D  enviar                        1a   overlay(dtapdf:*next)
     D  filer2                       77a   overlay(dtapdf:*next)

      * Claves de arvhivos ----------------------------------------- *

      /free

       *inlr = *on;

       in lda;
       if lda.empr = *blanks;
             lda.empr = @@empr;
             lda.sucu = @@sucu;
          out lda;
       endif;

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
            + '<b>Respuesta del Proveedor (Request)</b>'    + CRLF
            + '&nbspFecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                    + CRLF
            + '&nbsp&nbspURL   : '      + uri               + CRLF ;
       COWLOG_pgmlog( psds.this : Data );

       url = %trim(uri);
       tfac =  REST_getNextPart(url);
       pvta =  REST_getNextPart(url);
       nfac =  REST_getNextPart(url);
       ffac =  REST_getNextPart(url);
       imau =  REST_getNextPart(url);
       fven =  REST_getNextPart(url);
       varc =  REST_getNextPart(url);

       if %check('0123456789':%trim(tfac)) <> *zeros;
          @@tfac = 0;
       else;
          monitor;
            @@tfac = %int( %trim(tfac) );
          on-error;
            @@tfac = 0;
          endmon;
       endif;

       if %check('0123456789':%trim(pvta)) <> *zeros;
          @@pvta = 0;
       else;
          monitor;
            @@pvta = %int( %trim(pvta) );
          on-error;
            @@pvta = 0;
          endmon;
       endif;

       if %check('0123456789':%trim(nfac)) <> *zeros;
          @@nfac = 0;
       else;
          monitor;
            @@nfac = %int( %trim(nfac) );
          on-error;
            @@nfac = 0;
          endmon;
       endif;

       if %check('0123456789':%trim(ffac)) <> *zeros;
          @@ffac = 0;
       else;
          monitor;
            @@ffac = %int( %trim(ffac) );
          on-error;
            @@ffac = 0;
          endmon;
       endif;

       if %check('0123456789':%trim(fven)) <> *zeros;
          @@fven = 0;
       else;
          monitor;
            @@fven = %int( %trim(fven) );
          on-error;
            @@fven = 0;
          endmon;
       endif;

       monitor;
         @@imau = %dec( %trim(imau):13:2 );
         @@imau /= 100;
       on-error;
         @@imau = 0;
       endmon;

       // Valida Nombre del Archivo...
       if Varc = *blanks;
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'FAC0003' : peMsgs );
         exsr setError;
       endif;

       // Valida tipo de Factura...
       if not SVPFAC_chkTipoDeFactura( @@Tfac );

         %subst(@@repl:1:2) = %editc( @@Tfac : 'X' );
         @@long = %len ( %trim ( @@repl ) );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'FAC0008'
                       : peMsgs : @@repl : @@long );
         exsr setError;

       endif;

       // Valida que Nro. de Factura no este en cero...
       if @@nfac = *zeros;
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'FAC0009' : peMsgs );
         exsr setError;
       endif;

       // Valida que la fecha de factura no sea mayor a la fecha de sistema...
       PAR310X3( @@Empr : @@a : @@m : @@d);
       @@Fsis = (@@a * 10000) + (@@m * 100) + @@d;

       // Busca datos dela factura Web por el nombre...
       if not SVPFAC_getPahivwXArchivo( Varc
                                      : DsVw
                                      : DsVwC );

          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'TAB0001' : peMsgs );
          exsr setError;

       endif;

       // Valida si la factura esta en estado de descarga...
         if DsVw(DsVwC).pwEsta <> '2';
           @@Dest = SVPDES_estadoDeFactura( DsVw(DsVwC).pwEsta );
           %subst(@@repl:1:40) = %trim( @@Dest );
           @@long = %len ( %trim ( @@repl ) );

           SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'FAC0007'
                         : peMsgs : @@repl : @@long );
           exsr setError;
         endif;

       // Valida que este registrado la factura en PAHIVA...
       if not SVPFAC_chkFactura( lda.empr
                               : lda.sucu
                               : DsVw(DsVwC).pwComa
                               : DsVw(DsVwC).pwNrma
                               : DsVw(DsVwC).pwFe1a
                               : DsVw(DsVwC).pwFe1m
                               : DsVw(DsVwC).pwFe1d
                               : DsVw(DsVwC).pwC4s2 );

         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'FAC0001' : peMsgs );
         exsr setError;

       endif;

       @@Femi = ( DsVw(DsVwC).pwFe1a * 10000)
              + ( DsVw(DsVwC).pwFe1m * 100)
              +   DsVw(DsVwC).pwFe1d;

       if SVPVLS_getValSys( DIFFECFACTUR : *omit : @@Vsys );
          if %check('0123456789':%trim(@@Vsys) )<> *zeros;
             @Dia = 0;
          else;
             monitor;
               @Dia = %dec( @@Vsys:2:0 );
             on-error;
               @Dia = 0;
             endmon;
          endif;
       endif;

       if @Dia = 0;
         @@DifDat = @@Femi;
       else;
         @1Date  = %date( %char ( @@Femi ) : *iso0);
         @1Date -= %days( @Dia );

         @@DifDat = %int( %char( @1Date : *iso0) );
       endif;

       if @@Ffac > @@Fsis;
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'FAC0010' : peMsgs );
         exsr setError;
       endif;

       if @@Ffac < @@DifDat;
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'FAC0011' : peMsgs );
         exsr setError;
       endif;

       // Obtener datos de IVA Productores para ser Actualizados...
       if SVPFAC_getPahiva( lda.empr
                          : lda.sucu
                          : DsVw(DsVwC).pwComa
                          : DsVw(DsVwC).pwNrma
                          : DsVw(DsVwC).pwFe1a
                          : DsVw(DsVwC).pwFe1m
                          : DsVw(DsVwC).pwFe1d
                          : DsVw(DsVwC).pwC4s2
                          : @@DsVa
                          : @@DsVaC            );

         if SVPVLS_getValSys( VALNROFACTURA : *omit : @@Vsys );
            if @@Vsys <> 'N';
               if @@DsVa(@@DsVaC).ivfacn <> *zeros;
                 %subst(@@repl:1:8) = %editc( @@DsVa(@@DsVaC).ivfacn : 'X' );
                 @@long = %len ( %trim ( @@repl ) );
                 SVPWS_getMsgs ( '*LIBL'
                               : 'WSVMSG'
                               : 'FAC0014'
                               : peMsgs
                               : @@repl
                               : @@long );
                 exsr setError;
               endif;
            endif;
         endif;

         @@Dif = ( @@DsVa(@@DsVaC).ivitot - @@imau );
         Select;
            when @@Dif > 0;
                 if SVPVLS_getValSys( DIFIMPMAXIMO : *omit : @@Vsys );
                    if %check('0123456789':%trim(@@Vsys) )<> *zeros;
                       @@DifMax = 0;
                    else;
                       monitor;
                         @@DifMax = %dec( @@Vsys:15:2 );
                       on-error;
                         @@DifMax = 0;
                       endmon;
                    endif;
                 endif;

                 if @@Dif > @@DifMax;
                   %subst(@@repl:1:15) = %editW( @@imau : '           0 ,  ');
                   %subst(@@repl:16:15)=%editW( @@Dif   : '           0 ,  ');
                   @@long = %len ( %trim ( @@repl ) );
                   SVPWS_getMsgs ( '*LIBL'
                                 : 'WSVMSG'
                                 : 'FAC0016'
                                 : peMsgs
                                 : @@repl
                                 : 30     );
                   exsr setError;
                 endif;

                 when @@Dif < 0;

                 if SVPVLS_getValSys( DIFIMPMINIMO : *omit : @@Vsys );
                    if %check('0123456789':%trim(@@Vsys)) <> *zeros;
                       @@DifMin = 0;
                    else;
                       monitor;
                         @@DifMin = %dec( @@Vsys:15:2 );
                       on-error;
                         @@DifMin = 0;
                       endmon;
                    endif;
                 endif;

                 if %abs(@@Dif) > @@DifMin;
                   %subst(@@repl:1:15) = %editW( @@imau :'           0 ,  ');
                   %subst(@@repl:16:15)=%editW( @@Dif:'           0 ,  ');

                   @@long = %len ( %trim ( @@repl ) );
                   SVPWS_getMsgs ( '*LIBL'
                                 : 'WSVMSG'
                                 : 'FAC0015'
                                 : peMsgs
                                 : @@repl
                                 : 30     );
                   exsr setError;
                 endif;
            other;
          endsl;

         @@DsVa(@@DsVaC).ivfafd = %int(%subst(%char(@@Ffac):7:2));
         @@DsVa(@@DsVaC).ivfafm = %int(%subst(%char(@@Ffac):5:2));
         @@DsVa(@@DsVaC).ivfafa = %int(%subst(%char(@@Ffac):1:4));
         @@DsVa(@@DsVaC).ivticp = @@Tfac;
         @@DsVa(@@DsVaC).ivsucp = @@Pvta;
         @@DsVa(@@DsVaC).ivfacn = @@Nfac;

         if not SVPFAC_updPahiva( @@Dsva(@@DsVaC) );
           SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'FAC0014' : peMsgs );
           exsr setError;
         endif;

         DsVw(DsVwC).pwImau = @@Imau;
         DsVw(DsVwC).pwFven = @@Fven;
         DsVw(DsVwC).pwFfac = @@Ffac;
         DsVw(DsVwC).pwNfac = @@Nfac;
         DsVw(DsVwC).pwPvta = @@Pvta;
         DsVw(DsVwC).pwTfac = @@Tfac;

         if not SVPFAC_updFactura( DsVw(DsVwC) );
           SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'FAC0013' : peMsgs );
           exsr setError;
         endif;

         //Ingresa vuelta...
         if not SVPFAC_setVuelta( lda.empr
                                : lda.sucu
                                : DsVw(DsVwC).pwComa
                                : DsVw(DsVwC).pwNrma
                                : DsVw(DsVwC).pwFe1a
                                : DsVw(DsVwC).pwFe1m
                                : DsVw(DsVwC).pwFe1d
                                : DsVw(DsVwC).pwC4s2
                                : peErro
                                : peMsgs             );

           exsr setError;
         endif;

       endif;


       REST_writeHeader();
       REST_writeEncoding();

       REST_writeXmlLine('resultado' : 'OK');

       clear peMsgs;
       Data = '<br><br><b>WSRFA2-Respuesta del Proveedor '
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

          Data = '<br><br><b>WSRFA2-Respuesta del Proveedor '
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

          REST_writeXmlLine('resultado' : 'NO OK');

          REST_end();
          return;
       endsr;

      /define GETSYSV_LOAD_PROCEDURE
      /copy './qcpybooks/getsysv_h.rpgle'
