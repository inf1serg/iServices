     H option(*srcstmt:*noshowcpy:*nodebugio) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ********************************************************************* *
      * WSRSPE - Suscribe para recibir poliza en PDF                          *
      *          RM#01148 Generar servicio REST lista de pólizas              *
      * --------------------------------------------------------------------- *
      * Gio Nicolini                                            * 27-Jul-2018 *
      * --------------------------------------------------------------------- *
      * Modificaciones :                                                      *
      *                                                                       *
      *                                                                       *
      * ********************************************************************* *

     Fset001    if   e           k disk
     Fpahed001  if   e           k disk
     Fpahed004  if   e           k disk
     Fpahec1    if   e           k disk
     Fpahaag    if   e           k disk

      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/svppol_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)
     D  JobName                      10a   overlay(PsDs:244)
     D  UsrName                      10a   overlay(PsDs:*next)
     D  JobNbr                        6  0 overlay(PsDs:*next)
     D  CurUsr                       10a   overlay(PsDs:358)

     D lda             ds                  qualified dtaara(*lda)
     D   empr                         1a   overlay(lda:401)
     D   sucu                         2a   overlay(lda:402)

     D k1hed001        ds                  likerec(p1hed001:*key)
     D k1hed004        ds                  likerec(p1hed004:*key)
     D k1haag          ds                  likerec(p1haag:*key)

     D uri             s            512a
     D url             s           3000a   varying
     D @@Rc1           s              1n
     D @@Rc2           s             10i 0

     D tdoc            s              2a
     D ndoc            s             11a
     D empr            s              1a
     D sucu            s              2a
     D arcd            s              6a
     D spol            s              9a
     D rama            s              2a
     D arse            s              2a
     D oper            s              7a
     D poli            s              7a
     D susc            s              1a
     D mail            s             50a

     D @@Msgs          ds                  likeds(paramMsgs)
     D @@repl          s          65535a
     D @@Tdoc          s              2  0
     D @@Ndoc          s             11  0
     D @@Arcd          s              6  0
     D @@Spol          s              9  0
     D @@Rama          s              2  0
     D @@Arse          s              2  0
     D @@Oper          s              7  0
     D @@Poli          s              7  0
     D peMsgs          ds                  likeds(paramMsgs)

     D @@TdocCUIT      s              2  0 inz(98)

      /free

        *inlr = *on;

          @@Rc1  = REST_getUri( psds.this : uri );
          if not @@Rc1;
            return;
          endif;
          url = %trim(uri);

          // Obtener los parámetros de la URL
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
          susc = REST_getNextPart(url);
          mail = REST_getNextPart(url);

          in lda;
          lda.empr = empr;
          lda.sucu = sucu;
          out lda;

          if %check( '0123456789' : %trim(tdoc) ) <> 0;
            clear @@repl;
            @@repl = tdoc;
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'AAG0001'
                         : @@Msgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            @@Rc1 = REST_writeHeader( 204
                                    : *omit
                                    : *omit
                                    : 'AAG0001'
                                    : @@Msgs.peMsev
                                    : @@Msgs.peMsg1
                                    : @@Msgs.peMsg2 );
            REST_end();
            close *all;
            return;
          endif;

          monitor;
            @@Tdoc = %dec(tdoc:2:0);
          on-error;
            @@Tdoc = 0;
          endmon;

          @@Rc1 = *Off;
          if @@Tdoc = @@TdocCUIT or SVPVAL_tipoDeDocumento(@@Tdoc);
            @@Rc1 = *On;
          endif;

          if not @@Rc1;
            clear @@repl;
            @@repl = tdoc;
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'AAG0001'
                         : @@Msgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            @@Rc1 = REST_writeHeader( 204
                                    : *omit
                                    : *omit
                                    : 'AAG0001'
                                    : @@Msgs.peMsev
                                    : @@Msgs.peMsg1
                                    : @@Msgs.peMsg2 );
            REST_end();
            close *all;
            return;
          endif;

          if %check( '0123456789' : %trim(ndoc) ) <> 0;
            clear @@repl;
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'AAG0002'
                         : @@Msgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            @@Rc1 = REST_writeHeader( 204
                                    : *omit
                                    : *omit
                                    : 'AAG0002'
                                    : @@Msgs.peMsev
                                    : @@Msgs.peMsg1
                                    : @@Msgs.peMsg2 );
            REST_end();
            close *all;
            return;
          endif;

          monitor;
            @@Ndoc = %dec(ndoc:11:0);
          on-error;
            @@Ndoc = 0;
          endmon;

          @@Rc1 = *Off;
          if ( @@Tdoc = @@TdocCUIT and @@Ndoc > 10000000000 ) or
             ( @@Tdoc <> @@TdocCUIT and @@Ndoc < 100000000 ) ;
            @@Rc1 = *On;
          endif;

          if not @@Rc1;
            clear @@repl;
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'AAG0002'
                         : @@Msgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            @@Rc1 = REST_writeHeader( 204
                                    : *omit
                                    : *omit
                                    : 'AAG0002'
                                    : @@Msgs.peMsev
                                    : @@Msgs.peMsg1
                                    : @@Msgs.peMsg2 );
            REST_end();
            close *all;
            return;
          endif;

          if SVPREST_chkCliente( empr
                               : sucu
                               : tdoc
                               : ndoc
                               : peMsgs ) = *Off;
             REST_writeHeader( 204
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

          if SVPREST_chkPolizaCliente( empr
                                     : sucu
                                     : arcd
                                     : spol
                                     : rama
                                     : poli
                                     : tdoc
                                     : ndoc
                                     : peMsgs ) = *off;
             REST_writeHeader( 204
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

          @@Rc1 = COWLOG_logConAutoGestion( empr
                                          : sucu
                                          : @@Tdoc
                                          : @@Ndoc
                                          : psds.this);

          if %check( '0123456789' : %trim(arcd) ) <> 0;
            clear @@repl;
            @@repl = arcd;
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'ART0001'
                         : @@Msgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            @@Rc1 = REST_writeHeader( 204
                                    : *omit
                                    : *omit
                                    : 'ART0001'
                                    : @@Msgs.peMsev
                                    : @@Msgs.peMsg1
                                    : @@Msgs.peMsg2 );
            REST_end();
            close *all;
            return;
          endif;

          monitor;
            @@Arcd = %dec(arcd:6:0);
          on-error;
            @@Arcd = 0;
          endmon;

          if %check( '0123456789' : %trim(spol) ) <> 0;
            clear @@repl;
            %subst(@@repl:1:6) = arcd;
            %subst(@@repl:7:9) = spol;
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'PQW0003'
                         : @@Msgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            @@Rc1 = REST_writeHeader( 204
                                    : *omit
                                    : *omit
                                    : 'PQW0003'
                                    : @@Msgs.peMsev
                                    : @@Msgs.peMsg1
                                    : @@Msgs.peMsg2 );
            REST_end();
            close *all;
            return;
          endif;

          monitor;
            @@Spol = %dec(spol:9:0);
          on-error;
            @@Spol = 0;
          endmon;

          if %check( '0123456789' : %trim(rama) ) <> 0;
            clear @@repl;
            @@repl = rama;
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'RAM0001'
                         : @@Msgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            @@Rc1 = REST_writeHeader( 204
                                    : *omit
                                    : *omit
                                    : 'RAM0001'
                                    : @@Msgs.peMsev
                                    : @@Msgs.peMsg1
                                    : @@Msgs.peMsg2 );
            REST_end();
            close *all;
            return;
          endif;

          monitor;
            @@Rama = %dec(rama : 2 : 0);
          on-error;
            @@Rama = 0;
          endmon;

          setll @@Rama set001;
          if not %equal(set001);
            clear @@repl;
            @@repl = rama;
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'RAM0001'
                         : @@Msgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            @@Rc1 = REST_writeHeader( 204
                                    : *omit
                                    : *omit
                                    : 'RAM0001'
                                    : @@Msgs.peMsev
                                    : @@Msgs.peMsg1
                                    : @@Msgs.peMsg2 );
            REST_end();
            close *all;
            return;
          endif;

          monitor;
            @@Arse = %dec(arse:2:0);
          on-error;
            @@Arse = 0;
          endmon;

          monitor;
            @@Oper = %dec(oper:7:0);
          on-error;
            @@Oper = 0;
          endmon;

          k1hed001.d0empr = empr;
          k1hed001.d0sucu = sucu;
          k1hed001.d0arcd = @@Arcd;
          k1hed001.d0spol = @@Spol;
          chain %kds(k1hed001:4) pahec1;
          if not %found(pahec1);
            clear @@repl;
            %subst(@@repl: 1:6) = arcd;
            %subst(@@repl: 7:9) = spol;
            %subst(@@repl:16:2) = rama;
            %subst(@@repl:18:2) = arse;
            %subst(@@repl:20:7) = oper;
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'POL0014'
                         : @@Msgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            @@Rc1 = REST_writeHeader( 204
                                    : *omit
                                    : *omit
                                    : 'POL0014'
                                    : @@Msgs.peMsev
                                    : @@Msgs.peMsg1
                                    : @@Msgs.peMsg2 );
            REST_end();
            close *all;
            return;
          endif;

          @@Rc1 = *Off;
          k1hed001.d0empr = empr;
          k1hed001.d0sucu = sucu;
          k1hed001.d0arcd = @@Arcd;
          k1hed001.d0spol = @@Spol;
          setgt %kds(k1hed001:4) pahed001;
          dou %eof(pahed001);
            readpe %kds(k1hed001:4) pahed001;
            if not %eof(pahed001);
              if d0rama = @@Rama and d0arse = @@Arse and d0oper = @@oper;
                @@Rc1 = *On;
                leave;
              endif;
            endif;
          enddo;

          if not @@Rc1;
            clear @@repl;
            %subst(@@repl: 1:6) = arcd;
            %subst(@@repl: 7:9) = spol;
            %subst(@@repl:16:2) = rama;
            %subst(@@repl:18:2) = arse;
            %subst(@@repl:20:7) = oper;
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'POL0014'
                         : @@Msgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            @@Rc1 = REST_writeHeader( 204
                                    : *omit
                                    : *omit
                                    : 'POL0014'
                                    : @@Msgs.peMsev
                                    : @@Msgs.peMsg1
                                    : @@Msgs.peMsg2 );
            REST_end();
            close *all;
            return;
          endif;

          if not SPVSPO_chkSpol(empr : sucu : @@Arcd : @@Spol);
            clear @@repl;
            %subst(@@repl:1:6) = arcd;
            %subst(@@repl:7:9) = spol;
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'SPO0001'
                         : @@Msgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            @@Rc1 = REST_writeHeader( 204
                                    : *omit
                                    : *omit
                                    : 'SPO0001'
                                    : @@Msgs.peMsev
                                    : @@Msgs.peMsg1
                                    : @@Msgs.peMsg2 );
            REST_end();
            close *all;
            return;
          endif;

          if %check( '0123456789' : %trim(poli) ) <> 0;
            clear @@repl;
            %subst(@@repl:1:2) = rama;
            %subst(@@repl:3:7) = poli;
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'POL0009'
                         : @@Msgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            @@Rc1 = REST_writeHeader( 204
                                    : *omit
                                    : *omit
                                    : 'POL0009'
                                    : @@Msgs.peMsev
                                    : @@Msgs.peMsg1
                                    : @@Msgs.peMsg2 );
            REST_end();
            close *all;
            return;
          endif;

          monitor;
            @@Poli = %dec(poli : 7 : 0);
          on-error;
            @@poli = 0;
          endmon;

          k1hed004.d0empr = empr;
          k1hed004.d0sucu = sucu;
          k1hed004.d0rama = @@Rama;
          k1hed004.d0poli = @@Poli;
          setgt  %kds(k1hed004:4) pahed004;
          readpe %kds(k1hed004:4) pahed004;
          if %eof(pahed004);
            clear @@repl;
            %subst(@@repl:1:2) = rama;
            %subst(@@repl:3:7) = poli;
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'POL0009'
                         : @@Msgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            @@Rc1 = REST_writeHeader( 204
                                    : *omit
                                    : *omit
                                    : 'POL0009'
                                    : @@Msgs.peMsev
                                    : @@Msgs.peMsg1
                                    : @@Msgs.peMsg2 );
            REST_end();
            close *all;
            return;
          endif;

          k1haag.agempr = empr;
          k1haag.agsucu = sucu;
          k1haag.agarcd = @@Arcd;
          k1haag.agspol = @@Spol;
          k1haag.agrama = @@Rama;
          k1haag.agpoli = @@Poli;
          k1haag.agtdoc = @@Tdoc;
          k1haag.agndoc = @@Ndoc;
          setll %kds(k1haag) pahaag;
          if not %equal(pahaag);
            clear @@repl;
            %subst(@@repl:1:7) = poli;
            %subst(@@repl:8:2) = tdoc;
            %subst(@@repl:10:11) = ndoc;
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'POL0015'
                         : @@Msgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            @@Rc1 = REST_writeHeader( 204
                                    : *omit
                                    : *omit
                                    : 'POL0015'
                                    : @@Msgs.peMsev
                                    : @@Msgs.peMsg1
                                    : @@Msgs.peMsg2 );
            REST_end();
            close *all;
            return;
          endif;

          if susc <> 'S' and susc <> 'N';
            clear @@repl;
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'AAG0004'
                         : @@Msgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            @@Rc1 = REST_writeHeader( 204
                                    : *omit
                                    : *omit
                                    : 'AAG0004'
                                    : @@Msgs.peMsev
                                    : @@Msgs.peMsg1
                                    : @@Msgs.peMsg2 );
            REST_end();
            close *all;
            return;
          endif;

          mail = %trim(mail);
          if susc = 'S' and mail = *blanks;
            clear @@repl;
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'AAG0003'
                         : @@Msgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            @@Rc1 = REST_writeHeader( 204
                                    : *omit
                                    : *omit
                                    : 'AAG0003'
                                    : @@Msgs.peMsev
                                    : @@Msgs.peMsg1
                                    : @@Msgs.peMsg2 );
            REST_end();
            close *all;
            return;
          endif;



          @@Rc1 = SVPPOL_setSuscripcionPolizaElectronica( empr
                                                        : sucu
                                                        : @@Arcd
                                                        : @@Spol
                                                        : @@Rama
                                                        : @@Arse
                                                        : @@Oper
                                                        : @@Poli
                                                        : susc
                                                        : mail );



          REST_writeHeader();
          REST_writeEncoding();

          REST_writeXmlLine( 'suscripcionPolizaElectronica' : '*BEG');

          REST_writeXmlLine( 'Resultado' : 'OK' );

          REST_writeXmlLine( 'suscripcionPolizaElectronica' : '*END');

          REST_end();



        close *all;
        return;


      /end-free

