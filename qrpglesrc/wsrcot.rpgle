     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRCOT: QUOM Versión 2                                       *
      *         Listado de Propuestas guardadas/en proceso           *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *02-Jun-2017            *
      * ------------------------------------------------------------ *
      * Modificaciones :                                             *
      * LRG 13/12/2017 : Se valida si API esta habilitada para       *
      *                  retomar WEB                                 *
      * LRG 31/10/2019 : A pedido de Lara se devuele marca de        *
      *                  scoring en cotizacion                       *
      *                                                              *
      * ************************************************************ *
     Fsehni2    if   e           k disk
     Fctwet0    if   e           k disk
     Fctw000    if   e           k disk

      /copy './qcpybooks/svpart_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'

     D LISTAR          pr                  ExtPgm(pgmnam)
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   peOrde                      10a   const
     D   pePosi                            likeds(keycot_t) const
     D   pePreg                            likeds(keycot_t)
     D   peUreg                            likeds(keycot_t)
     D   peLcot                            likeds(ctw000_t) dim(99)
     D   peLcotC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D tipo            s              1a

     D pgmnam          s             10a
     D uri             s            512a
     D url             s           3000a   varying
     D nomb            s             40a
     D arcd            s              6a
     D fing            s             10d
     D nctw            s              7a
     D soln            s              7a
     D dsop            s             30a
     D dest            s             50a
     D c               s             10i 0
     D rc              s              1n
     D rc2             s             10i 0
     D @@nit1          s              1  0
     D @@niv1          s              5  0
     D @@repl          s          65535a
     D @@cert          s              1a
     D @@reco          s              1a
     D @@reto          s              1a
     D @@cons          s              1a
     D peRoll          s              1a
     D peLcotC         s             10i 0
     D peMore          s               n
     D peErro          s             10i 0
     D x               s             10i 0
     D carga           s              1n
     D arno            s             50a
     D fdes            s              8a
     D fhas            s              8a
     D Habilita_API    s               n
     D @@ValSys        S            512
     D @@base          ds                  likeds( paramBase )
     D @@scor          s              1a

     D pePosi          ds                  likeds(keycot_t)
     D pePreg          ds                  likeds(keycot_t)
     D peUreg          ds                  likeds(keycot_t)
     D peLcot          ds                  likeds(ctw000_t) dim(99)
     D peMsgs          ds                  likeds(paramMsgs)
     D peBase          ds                  likeds(paramBase)
     D k1hni2          ds                  likerec(s1hni2:*key)
     D k1wet0          ds                  likerec(c1wet0:*key)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

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
       tipo = REST_getNextPart(url);
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       nivt = REST_getNextPart(url);
       nivc = REST_getNextPart(url);
       nit1 = REST_getNextPart(url);
       niv1 = REST_getNextPart(url);

       if SVPREST_chkBase(empr:sucu:nivt:nivc:nit1:niv1:peMsgs) = *off;
          rc = REST_writeHeader( 400
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

       if tipo <> 'G' and tipo <> 'P';
          tipo = 'G';
       endif;

       clear @@ValSys;
       rc = sVPVLS_getValSys( 'HAPIRETWEB':*omit:@@ValSys );
       Habilita_API = %trim( @@Valsys ) = 'S';

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec( nivt : 1 : 0 );
       peBase.peNivc = %dec( nivc : 5 : 0 );
       peBase.peNit1 = %dec( nit1 : 1 : 0 );
       peBase.peNiv1 = %dec( niv1 : 5 : 0 );

       COWLOG_logcon( 'WSRCOT' : peBase );

       clear pePosi;
       clear pePreg;
       clear peUreg;
       clear peLcot;
       clear peMsgs;

       peErro = 0;
       c = 0;
       peRoll = 'I';

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'cotizaciones' : '*BEG');

       if tipo = 'G';
          PGMNAM = 'WSLCOT';
        else;
          PGMNAM = 'WSLCO2';
       endif;

       dou peMore = *off;

           LISTAR( peBase
                 : 99
                 : peRoll
                 : 'NUMEROCOTI'
                 : pePosi
                 : pePreg
                 : peUreg
                 : peLcot
                 : peLcotC
                 : peMore
                 : peErro
                 : peMsgs );

          if peLcotC <= 0;
             leave;
          endif;

          peRoll = 'F';
          pePosi = peUreg;
          c     += peLcotC;

          for x = 1 to peLcotC;

              carga = *on;
              if tipo = 'G';
                 if peLcot(x).w0cest = 7 and
                    (peLcot(x).w0cses = 4 or peLcot(x).w0cses = 5);
                    carga = *off;
                 endif;
              endif;

            if carga;
              nomb = peLcot(x).w0nomb;
              arcd = %char(peLcot(x).w0arcd);
              arno = %trim(peLcot(x).w0arno);
              fing = %date(peLcot(x).w0fctw);
              nctw = %char(peLcot(x).w0nctw);
              soln = %char(peLcot(x).w0soln);
              dsop = peLcot(x).w0dsop;
              dest = peLcot(x).w0dest;
              fdes = %editc(peLcot(x).w0vdes:'X');
              fhas = %editc(peLcot(x).w0vhas:'X');
              REST_writeXmlLine( 'cotizacion' : '*BEG' );
               REST_writeXmlLine( 'numeroCotizacion' : %trim(nctw) );
               REST_writeXmlLine( 'asegurado' : %trim(nomb) );
               REST_writeXmlLine( 'articulo'  : %trim(arcd) );
               REST_writeXmlLine('descripcionArticulo':%trim(arno));
               REST_writeXmlLine( 'fechaIngr' : %trim(%char(fing:*iso)) );
               REST_writeXmlLine( 'propuesta' : %trim(soln) );
               REST_writeXmlLine( 'operacion' : %trim(dsop) );
               REST_writeXmlLine( 'estado'    : %trim(dest) );
               @@reto = 'N';
               @@reco = 'N';
               @@cert = 'N';
               @@cons = 'N';
               @@scor = 'N';
               select;
                when peLcot(x).w0cest = 1 and peLcot(x).w0cses = 2;
                 @@reto = 'S';
                when peLcot(x).w0cest = 1 and peLcot(x).w0cses = 9;
                 @@reco = 'S';
                when peLcot(x).w0cest = 7 and peLcot(x).w0cses = 6;
                 @@reco = 'S';
                when peLcot(x).w0cest = 7 and peLcot(x).w0cses = 4;
                 @@cert = 'S';
                when peLcot(x).w0cest = 7 and peLcot(x).w0cses = 5;
                 @@cert = 'S';
               endsl;
               k1wet0.t0empr = peLcot(x).w0empr;
               k1wet0.t0sucu = peLcot(x).w0sucu;
               k1wet0.t0nivt = peLcot(x).w0nivt;
               k1wet0.t0nivc = peLcot(x).w0nivc;
               k1wet0.t0nctw = peLcot(x).w0nctw;
               chain %kds(k1wet0:5) ctwet0;
               if %found(ctwet0);
                 if SVPART_chkScoring( peLcot(x).w0arcd
                                     : t0rama
                                     : t0arse           );
                   @@scor = 'S';
                 endif;
                 @@cons = 'S';
               endif;
               @@base.peEmpr = peLcot(x).w0empr;
               @@base.peSucu = peLcot(x).w0sucu;
               @@base.peNivt = peLcot(x).w0nivt;
               @@base.peNivc = peLcot(x).w0nivc;
               @@base.peNit1 = peLcot(x).w0nivt;
               @@base.peNiv1 = peLcot(x).w0nivc;
               if COWGRAI_chkCotizacionAPI( @@base
                                          : peLcot(x).w0nctw )
                                          and not Habilita_API;
                   @@reto = 'N';
                   @@reco = 'N';
                   @@cert = 'N';
                   @@cons = 'N';
               endif;
               REST_writeXmlLine('retomar':@@reto);
               REST_writeXmlLine('recotizar':@@reco);
               REST_writeXmlLine('certificado':@@cert);
               REST_writeXmlLine('constancia':@@cons);
               REST_writeXmlLine('vigenciaDesde':fdes);
               REST_writeXmlLine('vigenciaHasta':fhas);
               REST_writeXmlLine('scoring':@@scor);
              REST_writeXmlLine( 'cotizacion' : '*END' );
            endif;

          endfor;

          if peMore = *off;
             leave;
          endif;

        enddo;

       REST_writeXmlLine( 'cantidad' : %trim(%char(c)) );
       REST_writeXmlLine( 'cotizaciones' : '*END' );

       REST_end();

       close *all;

       return;

      /end-free
