     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRMPO: QUOM Versión 2                                       *
      *         Mercado Pago                                         *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *16-Sep-2020            *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      *  JSN 18/01/2021 Se cambia estatus del proceso por '2'        *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpmpo_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D tdoc            s              2a
     D ndoc            s              8a
     D rama            s              2a
     D poli            s              7a
     D arcd            s              6a
     D spol            s              9a
     D sspo            s              3a
     D imcu            s             15a
     D fpag            s              8a
     D ncuo            s             10a
     D nrsc            s             10a
     D fvcu            s              8a
     D orig            s              2a
     D clid            s             56a
     D clst            s             10a
     D exre            s             56a
     D paty            s             10a
     D moid            s             56a
     D prid            s             56a
     D stid            s             56a
     D prmo            s             56a
     D maid            s             56a
      * Variables ----------------------------------------------
     D @@tdoc          s              2  0
     D @@ndoc          s              8  0
     D @@rama          s              2  0
     D @@poli          s              7  0
     D @@arcd          s              6  0
     D @@spol          s              9  0
     D @@sspo          s              3  0
     D @@imcu          s             15  2
     D @@fpag          s              8  0
     D @@ncuo          s             10  0
     D @@nrsc          s             10  0
     D @@fvcu          s              8  0
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
     D DsMpo           ds                  likeds( dsPahmpo_t )

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
            + '<b>Mercado Pago(Request)</b>'    + CRLF
            + '&nbspFecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                    + CRLF
            + '&nbsp&nbspURL   : '      + uri               + CRLF ;
       COWLOG_pgmlog( psds.this : Data );

       url = %trim(uri);
       empr =  REST_getNextPart(url);
       sucu =  REST_getNextPart(url);
       tdoc =  REST_getNextPart(url);
       ndoc =  REST_getNextPart(url);
       rama =  REST_getNextPart(url);
       poli =  REST_getNextPart(url);
       arcd =  REST_getNextPart(url);
       spol =  REST_getNextPart(url);
       sspo =  REST_getNextPart(url);
       imcu =  REST_getNextPart(url);
       fpag =  REST_getNextPart(url);
       ncuo =  REST_getNextPart(url);
       nrsc =  REST_getNextPart(url);
       fvcu =  REST_getNextPart(url);
       orig =  REST_getNextPart(url);
       clid =  REST_getNextPart(url);
       clst =  REST_getNextPart(url);
       exre =  REST_getNextPart(url);
       paty =  REST_getNextPart(url);
       moid =  REST_getNextPart(url);
       prid =  REST_getNextPart(url);
       stid =  REST_getNextPart(url);
       prmo =  REST_getNextPart(url);
       maid =  REST_getNextPart(url);

       empr = %xlate( min : may : empr );
       sucu = %xlate( min : may : sucu );

       if %check('0123456789':%trim(tdoc)) <> *zeros;
         @@tdoc = 0;
       else;
         monitor;
           @@tdoc = %int( %trim(tdoc) );
         on-error;
           @@tdoc = 0;
         endmon;
       endif;

       if %check('0123456789':%trim(ndoc)) <> *zeros;
         @@ndoc = 0;
       else;
         monitor;
           @@ndoc = %int( %trim(ndoc) );
         on-error;
           @@ndoc = 0;
         endmon;
       endif;

       if %check('0123456789':%trim(rama)) <> *zeros;
         @@rama = 0;
       else;
         monitor;
           @@rama = %int( %trim(rama) );
         on-error;
           @@rama = 0;
         endmon;
       endif;

       if %check('0123456789':%trim(poli)) <> *zeros;
         @@poli = 0;
       else;
         monitor;
           @@poli = %int( %trim(poli) );
         on-error;
           @@poli = 0;
         endmon;
       endif;

       if %check('0123456789':%trim(arcd)) <> *zeros;
         @@arcd = 0;
       else;
          monitor;
            @@arcd = %int( %trim(arcd) );
          on-error;
            @@arcd = 0;
          endmon;
       endif;

       if %check('0123456789':%trim(spol)) <> *zeros;
          @@spol = 0;
       else;
          monitor;
            @@spol = %int( %trim(spol) );
          on-error;
            @@spol = 0;
          endmon;
       endif;

       if %check('0123456789':%trim(sspo)) <> *zeros;
          @@sspo = 0;
       else;
          monitor;
            @@sspo = %int( %trim(sspo) );
          on-error;
            @@sspo = 0;
          endmon;
       endif;

       monitor;
         @@imcu = %dec( %trim(imcu):13:2 );
         @@imcu /= 100;
       on-error;
         @@imcu = 0;
       endmon;

       if %check('0123456789':%trim(fpag)) <> *zeros;
          @@fpag = 0;
       else;
          monitor;
            @@fpag = %int( %trim(fpag) );
          on-error;
            @@fpag = 0;
          endmon;
       endif;

       if %check('0123456789':%trim(ncuo)) <> *zeros;
          @@ncuo = 0;
       else;
          monitor;
            @@ncuo = %int( %trim(ncuo) );
          on-error;
            @@ncuo = 0;
          endmon;
       endif;

       if %check('0123456789':%trim(nrsc)) <> *zeros;
          @@nrsc = 0;
       else;
          monitor;
            @@nrsc = %int( %trim(nrsc) );
          on-error;
            @@nrsc = 0;
          endmon;
       endif;

       if %check('0123456789':%trim(fvcu)) <> *zeros;
          @@fvcu = 0;
       else;
          monitor;
            @@fvcu = %int( %trim(fvcu) );
          on-error;
            @@fvcu = 0;
          endmon;
       endif;

       exsr MueveDatosDS;
       if not SVPMPO_setPahmpo( DsMpo );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'MPO0001' : peMsgs );
         exsr setError;
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray('resultado');
         REST_writeXmlLine('ok' : '1');
       REST_endArray('resultado');

       clear peMsgs;
       Data = '<br><br><b>WSRMPO-Mercado Pago       '
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
       begsr MueveDatosDS;

         clear DsMpo;

         DsMpo.mpEmpr = Empr;
         DsMpo.mpsucu = Sucu;
         DsMpo.mpTdoc = @@Tdoc;
         DsMpo.mpNdoc = @@Ndoc;
         DsMpo.mpRama = @@Rama;
         DsMpo.mpPoli = @@Poli;
         DsMpo.mpArcd = @@Arcd;
         DsMpo.mpSpol = @@Spol;
         DsMpo.mpSspo = @@Sspo;
         DsMpo.mpImcu = @@Imcu;
         DsMpo.mpFpag = @@Fpag;
         DsMpo.mpNcuo = @@Ncuo;
         DsMpo.mpNrsc = @@Nrsc;
         DsMpo.mpFvcu = @@Fvcu;
         DsMpo.mpProc = '0';
         DsMpo.mpOrig = Orig;
         DsMpo.mpClid = Clid;
         DsMpo.mpClst = Clst;
         DsMpo.mpExre = Exre;
         DsMpo.mpPaty = Paty;
         DsMpo.mpMoid = Moid;
         DsMpo.mpPrid = Prid;
         DsMpo.mpStid = Stid;
         DsMpo.mpPcmo = Prmo;
         DsMpo.mpMaid = Maid;

         if DsMpo.mpclst <> 'APPROVED' and
            DsMpo.mpclst <> 'approved';
            DsMpo.mpProc = '2';
         endif;

       endsr;
       //* ---------------------------------------------------------- *
       begsr setError;

         REST_writeHeader( 400
                         : *omit
                         : *omit
                         : peMsgs.peMsid
                         : peMsgs.peMsev
                         : peMsgs.peMsg1
                         : peMsgs.peMsg2 );

          Data = '<br><br><b>WSRMPO-Mercado de Pago '
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
