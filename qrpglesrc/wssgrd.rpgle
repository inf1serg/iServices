     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSSxxx: QUOM Versión 2                                       *
      *         Retornar Reserva y Franquicia por Defecto            *
      * ------------------------------------------------------------ *
      * Astiz Facundo                        *01/10/2021*            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      *--- Archivos ------------------------------------------------ *
     Fpahet002  if   e           k disk    usropn
     Fset468    if   e           k disk    usropn prefix(t468_)
     Fset470    if   e           k disk    usropn prefix(t470_)
      *------------------------------------------------------------- *

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/cowveh_h.rpgle'
      *------------------------------------------------------------- *

      *--- Variables REST ------------------------------------------ *
     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n
     D @@repl          s          65535a
     D peMsgs          ds                  likeds(paramMsgs)
      *------------------------------------------------------------- *

      *--- SPNFRQ -------------------------------------------------- *
     D spnfrq          pr                  extpgm('SPNFRQ')
     D  peEmpr                        1a
     D  peSucu                        2a
     D  peArcd                        6  0
     D  peSpol                        9  0
     D  peUsa                         1N
      *------------------------------------------------------------- *

      *--- Parametros de Entrada ----------------------------------- *
     D empr            s              1
     D sucu            s              2
     D rama            s              2
     D hecg            s              1
     D ctle            s              1
     D cauc            s              2
     D arcd            s              6
     D spol            s              9
     D sspo            s              3
     D arse            s              2
     D poli            s              7
     D suop            s              3
     D poco            s              4
     D como            s              2
     D tipv            s              1
      *------------------------------------------------------------- *

      *--- Variables de Trabajo ------------------------------------ *
     D p@rama          s              2  0
     D p@cauc          s              2  0
     D p@arcd          s              6  0
     D p@spol          s              9  0
     D p@sspo          s              3  0
     D p@arse          s              2  0
     D p@poli          s              7  0
     D p@suop          s              3  0
     D p@poco          s              4  0
     D @@ifra          s             15  2
     D @@immr          s             15  2
     D @newfrq         s              1N
     D @@DsT0          ds                  likeds(dsPahet0_t)
      *------------------------------------------------------------- *

      *--- Keys ---------------------------------------------------- *
     D k1yet02         ds                  likeRec(p1het002:*Key)
     D k1y468          ds                  likeRec(s1t468:*Key)
     D k1y470          ds                  likeRec(s1t470:*Key)
      *------------------------------------------------------------- *

      *--- Estructura Interna -------------------------------------- *
     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)
     D   JobName                     10a   overlay(PsDs:244)
     D   JobUser                     10a   overlay(PsDs:254)
     D   JobNbr                       6  0 overlay(PsDs:264)
      *------------------------------------------------------------- *

       //------------------------------------------------------//
      /free

       *inlr = *on;


       //Inicio

       // FIJO: Recuperar la URL desde conde se lo llamo
       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
          REST_writeHeader( 204
                          : *omit
                          : *omit
                          : 'RPG0001'
                          : 40
                          : 'Error al parsear URL'
                          : 'Error al parsear URL' );
          REST_end();
          return;
       endif;

       // FIJO: Para la URI a URL
       url = %trim(uri);

       // Obtener los parámetros de la URL
       // Esto es FIJO y es una ejecución por CADA
       // parámetro de la URL
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       rama = REST_getNextPart(url);
       hecg = REST_getNextPart(url);
       ctle = REST_getNextPart(url);
       cauc = REST_getNextPart(url);
       arcd = REST_getNextPart(url);
       spol = REST_getNextPart(url);
       sspo = REST_getNextPart(url);
       arse = REST_getNextPart(url);
       poli = REST_getNextPart(url);
       suop = REST_getNextPart(url);
       poco = REST_getNextPart(url);
       como = REST_getNextPart(url);
       tipv = REST_getNextPart(url);


       //Validacion

       // Valida Rama               Numerico 2/0
       // Valida Causa              Numerico 2/0
       // Valida Articulo           Numerico 6/0
       // Valida Superpoliza        Numerico 9/0
       // Valida Supl. Superpoliza  Numerico 3/0
       // Valida Sec. Rama/Articu.  Numerico 2/0
       // Valida Poliza             Numerico 7/0
       // Valida Supl. Poliza       Numerico 3/0
       // Valida Componente         Numerico 4/0

       //cargo repl antes de error monitor, en caso OK -> blanqueo
       monitor;
          @@repl = rama;
          p@rama = %dec(rama :2 :0);

          @@repl = cauc;
          p@cauc = %dec(cauc :2 :0);

          @@repl = arcd;
          p@arcd = %dec(arcd :6 :0);

          @@repl = spol;
          p@spol = %dec(spol :9 :0);

          @@repl = sspo;
          p@sspo = %dec(sspo :3 :0);

          @@repl = arse;
          p@arse = %dec(arse :2 :0);

          @@repl = poli;
          p@poli = %dec(poli :7 :0);

          @@repl = suop;
          p@suop = %dec(suop :3 :0);

          @@repl = poco;
          p@poco = %dec(poco :4 :0);
       on-error;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'DAF0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'DAF0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2  );
          REST_end();
          SVPREST_end();
          return;
       endmon;
       @@repl = *blanks; // Valid OK, blanquea

       //hecho generador recibido debe existir
       if SVPVAL_hechoGenerador(hecg) = *off;
          @@repl = hecg;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN1000'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'SIN1000'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2  );
          REST_end();
          SVPREST_end();
          return;
       endif;

       //Moneda debe existir
       if SVPVAL_moneda(como) = *off;
          @@repl = como;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0003'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'COW0003'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2  );
          REST_end();
          SVPREST_end();
          return;
       endif;

       //Lesiones recibido debe existir
       if ctle <> *blanks;
          if SVPVAL_tipoDeLesiones(ctle) = *off;
             @@repl = ctle;
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'SIN1001'
                          : peMsgs
                          : %trim(@@repl)
                          : %len(%trim(@@repl)) );
             rc = REST_writeHeader( 400
                                  : *omit
                                  : *omit
                                  : 'SIN1001'
                                  : peMsgs.peMsev
                                  : peMsgs.peMsg1
                                  : peMsgs.peMsg2  );
             REST_end();
             SVPREST_end();
             return;
          endif;
       endif;

       //Tipo de Cambio recibido debe existir
       if SVPVAL_tipoDeCambio(tipv) = *off;
          @@repl = tipv;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN1002'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'SIN1002'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2  );
          REST_end();
          SVPREST_end();
          return;
       endif;

       //vehículo debe existir
       if not SPVVEH_getPahet0( Empr
                              : Sucu
                              : p@arcd
                              : p@spol
                              : p@Rama
                              : p@arse
                              : p@Poco
                              : p@Sspo
                              : @@DsT0 );
          clear @@Repl;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'BIE0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'BIE0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2  );
          REST_end();
          SVPREST_end();
          return;
       endif;

       //Busco Info
       exsr srFranq;
       exsr srImpPorDef;

       // FIJO: Grabar SIEMPRE el header y el encoding
       REST_writeHeader();
       REST_writeEncoding();
       //Amado REST
       REST_startArray( 'reservaDefecto');
          REST_writeXmlLine( 'reserva' : SVPREST_editImporte( @@immr));
          REST_writeXmlLine( 'franquicia' : SVPREST_editImporte( @@ifra ));
       REST_endArray( 'reservaDefecto');
       REST_end();

      *------------------------------------------------------------- *
       begsr srFranq;
          callp spnfrq( empr
                      : sucu
                      : p@arcd
                      : p@spol
                      : @newfrq );

          if @newfrq and hecg = '8';
             k1yet02.t0empr = empr;
             k1yet02.t0sucu = sucu;
             k1yet02.t0arcd = p@arcd;
             k1yet02.t0spol = p@spol;
             k1yet02.t0rama = p@rama;
             k1yet02.t0arse = p@arse;
             k1yet02.t0oper = @@DsT0.t0oper;
             k1yet02.t0poco = p@poco;

             if not %open(pahet002);
                open pahet002;
             endif;

             setgt %kds(k1yet02 : 8) pahet002;
             readpe %kds(k1yet02 : 8) pahet002;
             dow not %eof;
                if t0sspo > p@sspo;
                   leave;
                endif;
                @@ifra = t0ifra;
             readpe %kds(k1yet02 : 8) pahet002;
             enddo;

             if %open(pahet002);
                close pahet002;
             endif;
          endif;
       endsr;
      *------------------------------------------------------------- *
       begsr srImpPorDef;
          // Carga Valor por defecto para el hecho generador,
          //  cuando el mismo este en cero

          if not %open(set468);
             open set468;
          endif;

          k1y468.t468_t@rama = p@rama;
          k1y468.t468_t@Hecg = Hecg;

          setll %kds(k1y468 : 2) set468;
          dou %eof(set468);
             reade %kds(k1y468: 2) set468;
             if not %eof(set468);
                if t468_t@fdes <= %dec(%date():*iso);

                   if not %open(set470);
                      open set470;
                   endif;

                   k1y470.t470_t@rama = p@rama;
                   k1y470.t470_t@Hecg = Hecg;
                   k1y470.t470_t@ctle = ctle;

                   select;
                      when t468_t@mar1 = '1';
                         if ctle = *blanks;
                            *in42 = *on;
                            *in43 = *on;
                            *in44 = *on;
                            *in45 = *on;
                            *in46 = *on;
                            *in47 = *on;
                            *in48 = *on;
                            *in49 = *on;
                            *in50 = *on;
                         else;
                            chain %kds(k1y470 : 3) set470;
                            if %found;
                               @@Immr = t470_t@ires;
                               if t470_t@padi > *zeros;
                                  @@Immr = @@Immr * (1+(t470_t@padi/100));
                               endif;
                            else;
                               *in42 = *on;
                               *in43 = *on;
                               *in44 = *on;
                               *in45 = *on;
                               *in46 = *on;
                               *in47 = *on;
                               *in48 = *on;
                               *in49 = *on;
                               *in50 = *on;
                            endif;
                         endif;

                      when t468_t@mar1 = '2';
                         @@Immr = t468_t@ires;
                         if t468_t@padi > *zeros;
                            @@Immr = @@Immr * (1+(t468_t@padi/100));
                         endif;

                      when t468_t@mar1 = '3';
                         clear @@Immr;

                         k1yet02.t0empr = empr;
                         k1yet02.t0sucu = sucu;
                         k1yet02.t0arcd = p@arcd;
                         k1yet02.t0spol = p@spol;
                         k1yet02.t0rama = p@rama;
                         k1yet02.t0arse = p@arse;
                         k1yet02.t0oper = @@DsT0.t0oper;
                         k1yet02.t0poco = p@poco;

                         if not %open(pahet002);
                            open pahet002;
                         endif;

                         setgt %kds(k1yet02 : 8) pahet002;
                         readpe %kds(k1yet02 : 8) pahet002;
                         dow not %eof;
                            if t0sspo > p@sspo;
                               leave;
                            endif;
                            @@Immr = t0vhvu;
                         readpe %kds(k1yet02 : 8) pahet002;
                         enddo;
                         if t468_t@padi > *zeros;
                            @@Immr = @@Immr * (1+(t468_t@padi/100));
                         endif;

                      when t468_t@mar1 = '4';
                         callp spnfrq( empr
                                     : sucu
                                     : p@arcd
                                     : p@spol
                                     : @newfrq );
                         clear @@Immr;
                         if @newfrq;

                            k1yet02.t0empr = empr;
                            k1yet02.t0sucu = sucu;
                            k1yet02.t0arcd = p@arcd;
                            k1yet02.t0spol = p@spol;
                            k1yet02.t0rama = p@rama;
                            k1yet02.t0arse = p@arse;
                            k1yet02.t0oper = @@DsT0.t0oper;
                            k1yet02.t0poco = p@poco;

                            if not %open(pahet002);
                               open pahet002;
                            endif;

                            setgt %kds(k1yet02 : 8) pahet002;
                            readpe %kds(k1yet02 : 8) pahet002;
                            dow not %eof;
                               if t0sspo > p@sspo;
                                  leave;
                               endif;
                               @@Immr = t0ifra;
                            readpe %kds(k1yet02 : 8) pahet002;
                            enddo;

                            if t468_t@padi > *zeros;
                               @@Immr = @@Immr +
                                    ( t468_t@ires * (1+(t468_t@padi/100)) );
                            else;
                               @@Immr = @@Immr + t468_t@ires;
                            endif;
                         endif;
                   endsl;
                   leave;
                endif;
             endif;
          enddo;

          if %open(set468);
             close set468;
          endif;

          if %open(set470);
             close set470;
          endif;

          if %open(pahet002);
             close pahet002;
          endif;
       endsr;
