
     H option(*srcstmt:*noshowcpy:*nodebugio) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)

      * ********************************************************************* *
      * WSRCFP - Solicitudes cambio forma de pago                             *
      *          RM#01148 Generar servicio REST lista de pólizas              *
      * --------------------------------------------------------------------- *
      * Gio Nicolini                                            * 17-Jul-2018 *
      * --------------------------------------------------------------------- *
      * Modificaciones :                                                      *
      *                                                                       *
      * NWN 11/03/2019 - Se agrega nuevo mensaje de validación en             *
      *                  COWGRAI_chkTarjCredito (TCR0005).                    *
      * JSN 26/02/2021 - Se agrega llamado al PGM WSRCF1 y se elimina las     *
      *                  validaciones y el grabar registro en el archivo      *
      *                  PAHAG1.                                              *
      * ********************************************************************* *

     Fset001    if   e           k disk
     Fpahaag    if   e           k disk
     Fpahag1    o    e             disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/spvcbu_h.rpgle'

     D par310x3        pr                  ExtPgm('PAR310X3')
     D  peEmpr                        1
     D  peFeca                        4  0
     D  peFecm                        2  0
     D  peFecd                        2  0

     D WSRCF1          pr                  extpgm('WSRCF1')

     D spt902          pr                  extpgm('SPT902')
     D  petnum                        1
     D  penres                        7  0

     D spsald          pr                  extpgm('SPSALD')
     D  pearcd                        6  0
     D  pespol                        9  0
     D  perama                        2  0
     D  peanop                        4  0
     D  pemesp                        2  0
     D  pediap                        2  0
     D  pesald                       15  2
     D  peimpr                        2
     D  pefpgm                        3

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)
     D  JobName                      10a   overlay(PsDs:244)
     D  UsrName                      10a   overlay(PsDs:*next)
     D  JobNbr                        6  0 overlay(PsDs:*next)
     D  CurUsr                       10a   overlay(PsDs:358)

     D lda             ds                  qualified dtaara(*lda)
     D   empr                         1a   overlay(lda:401)
     D   sucu                         2a   overlay(lda:402)

     D k1haag          ds                  likerec(p1haag:*key)

     D uri             s            512a
     D url             s           3000a   varying
     D @@Rc1           s              1n
     D @@Rc2           s             10i 0

     D empr            s              1a
     D sucu            s              2a
     D arcd            s              6a
     D spol            s              9a
     D rama            s              2a
     D arse            s              2a
     D oper            s              7a
     D poli            s              7a
     D cfpg            s              1a
     D nrpp            s              3a
     D ctcu            s              3a
     D nrtc            s             20a
     D fvto            s              6a
     D ncbu            s             22a

     D tdoc            s              2a
     D ndoc            s             11a
     D var             s            512a

     D @@a             s              4  0
     D @@m             s              2  0
     D @@Msgs          ds                  likeds(paramMsgs)
     D @@repl          s          65535a
     D @@Arcd          s              6  0
     D @@Spol          s              9  0
     D @@Rama          s              2  0
     D @@Arse          s              2  0
     D @@Oper          s              7  0
     D @@Poli          s              7  0
     D @@Cfpg          s              1  0
     D @@Nrpp          s              3  0
     D @@Ctcu          s              3  0
     D @@Nrtc          s             20  0
     D @@Fvto          s              4  0
     D @@Ncbu          s             22  0
     D @@Nivt          s              1  0
     D @@Nivc          s              5  0
     D @@Info          s            256a
     D @@Npro          s             40a

     D @@FecA          s              4  0
     D @@FecM          s              2  0
     D @@FecD          s              2  0

     D @@Tnum          s              1    inz('0')
     D @@Nres          s              7  0

     D @@anop          s              4  0
     D @@mesp          s              2  0
     D @@diap          s              2  0
     D @@sald          s             15  2
     D @@impr          s              2
     D @@fpgm          s              3

     D @@Base          ds                  likeds(paramBase)
     D @@Nctw          s              7  0

     D @@MsgId         s              7a

     D @@Ivbc          s              3  0
     D @@Ivsu          s              3  0
     D @@Tcta          s              2  0
     D @@Ncta          s             25

     D                 ds
     D dsDtdc                  1     23
     D dsCtcu                  1      3  0
     D dsNrtc                  4     23  0

      /free

        *inlr = *on;

          @@Rc1  = REST_getUri( psds.this : uri );
          if @@Rc1 = *off;
            return;
          endif;
          url = %trim(uri);

          // Obtener los parámetros de la URL
          empr = REST_getNextPart(url);
          sucu = REST_getNextPart(url);
          arcd = REST_getNextPart(url);
          spol = REST_getNextPart(url);
          rama = REST_getNextPart(url);
          arse = REST_getNextPart(url);
          oper = REST_getNextPart(url);
          poli = REST_getNextPart(url);
          cfpg = REST_getNextPart(url);
          nrpp = REST_getNextPart(url);
          ctcu = REST_getNextPart(url);
          nrtc = REST_getNextPart(url);
          fvto = REST_getNextPart(url);
          ncbu = REST_getNextPart(url);

          in lda;
          lda.empr = empr;
          lda.sucu = sucu;
          out lda;

          par310x3(lda.empr : @@FecA : @@FecM : @@FecD);

          // Articulo...
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

          // Número de Superpoliza...
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

          // Rama...
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

          // Valida Rama...
          setll @@Rama set001;
          if not %equal;
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

          // Cant. Pólizas por Rama/Art...
          monitor;
            @@Arse = %dec(arse:2:0);
          on-error;
            @@Arse = 0;
          endmon;

          // Número de Operación...
          monitor;
            @@Oper = %dec(oper:7:0);
          on-error;
            @@Oper = 0;
          endmon;

          // Número de Póliza...
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

          // Código de forma de pago...
          monitor;
            @@Cfpg = %dec(cfpg:1:0);
          on-error;
            @@Cfpg = 0;
          endmon;

          // Número de plan de pago...
          monitor;
            @@Nrpp = %dec(nrpp:3:0);
          on-error;
            @@Nrpp = 0;
          endmon;

          // Código de empresa emisora...
          monitor;
            @@Ctcu = %dec(ctcu:3:0);
          on-error;
            @@Ctcu = 0;
          endmon;

          // Número de tarjeta de credito...
          monitor;
            @@Nrtc = %dec(nrtc:20:0);
          on-error;
            @@Nrtc = 0;
          endmon;

          // Fecha de vencimiento de tarjeta de credito...
          monitor;
            clear @@m;
            clear @@a;
            @@m = %int(%subst(fvto:5:2));
            @@a = %int(%subst(fvto:3:2));
            @@Fvto = ( @@m * 100) + @@a;
          on-error;
            @@Fvto = 0;
          endmon;

          // Número de CBU...
          monitor;
            @@Ncbu = %dec(ncbu:22:0);
          on-error;
            @@Ncbu = 0;
          endmon;

          clear k1haag;
          k1haag.agempr = empr;
          k1haag.agsucu = sucu;
          k1haag.agarcd = @@Arcd;
          k1haag.agspol = @@Spol;
          k1haag.agrama = @@Rama;
          k1haag.agpoli = @@Poli;
          setll %kds(k1haag:6) pahaag;
          if %equal(pahaag);
            dou %eof(pahaag);
              reade %kds(k1haag:6) pahaag;
              if not %eof(pahaag);

                tdoc = %trim(%editw(agtdoc:'  '));
                ndoc = %trim(%editw(agndoc:'           '));

                if SVPREST_chkCliente( empr
                                     : sucu
                                     : tdoc
                                     : ndoc
                                     : @@Msgs ) = *Off;
                  REST_writeHeader( 204
                                  : *omit
                                  : *omit
                                  : @@Msgs.peMsid
                                  : @@Msgs.peMsev
                                  : @@Msgs.peMsg1
                                  : @@Msgs.peMsg2 );
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
                                           : @@Msgs ) = *off;
                  REST_writeHeader( 204
                                  : *omit
                                  : *omit
                                  : @@Msgs.peMsid
                                  : @@Msgs.peMsev
                                  : @@Msgs.peMsg1
                                  : @@Msgs.peMsg2 );
                  REST_end();
                  SVPREST_end();
                  close *all;
                  return;
                endif;

                @@Rc1 = COWLOG_logConAutoGestion( empr
                                                : sucu
                                                : agtdoc
                                                : agndoc
                                                : psds.this);

              endif;
            enddo;
          else;
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

          // Retorna Productor...
          @@Npro = SPVSPO_getProductor( Empr
                                      : Sucu
                                      : @@Arcd
                                      : @@Spol
                                      : *omit
                                      : @@Nivt
                                      : @@Nivc );

          // Mueve datos al campo info dependiendo de la forma de pago...
          select;
            when @@Cfpg = 1;
              dsCtcu = @@Ctcu;
              dsNrtc = @@Nrtc;
              @@info = dsDtdc;
            when @@Cfpg = 2 or @@Cfpg = 3;
              @@info = ncbu;
          endsl;

          var = 'REQUEST_URI=/QUOMREST/WSRCF1/'
              + %trim(Empr)
              + '/'
              + %trim(Sucu)
              + '/'
              + %editc(@@Nivt:'X')
              + '/'
              + %editc(@@Nivc:'X')
              + '/'
              + %editc(@@Nivt:'X')
              + '/'
              + %editc(@@Nivc:'X')
              + '/'
              + %editc(@@Arcd:'X')
              + '/'
              + %editc(@@Spol:'X')
              + '/'
              + %editc(@@Rama:'X')
              + '/'
              + %editc(@@Poli:'X')
              + '/'
              + %trim(Tdoc)
              + '/'
              + %trim(Ndoc)
              + '/'
              + %editc(@@Cfpg:'X')
              + '/'
              + %trim(@@Info)
              + '/'
              + %editc(@@Fvto:'X')
              + '/'
              + 'W'
              + '/'
              + 'A';
          putenv(%trim(var));
          WSRCF1();

          REST_writeHeader();
          REST_writeEncoding();

          REST_writeXmlLine( 'CambioFormaDePago' : '*BEG');
            REST_writeXmlLine( 'Resultado' : 'OK' );
          REST_writeXmlLine( 'CambioFormaDePago' : '*END');

          REST_end();

          close *all;
          return;

      /end-free
