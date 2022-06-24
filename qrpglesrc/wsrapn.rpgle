      * ************************************************************ *
      * WSRAPN: BPM Siniestros                                       *
      *         Obtener póliza vigente a fecha de Siniestro          *
      *         Por invocado por Empresa/Sucursal/FechaSini/HoraSin/ *
      *                          Rama/Poliza.                        *
      *                                                              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                               *04-Oct-2021  *
      * ------------------------------------------------------------ *
      * SGF 17/03/2022: Nuevo parámetro para WSRAP1.                 *
      *                                                              *
      * ************************************************************ *

        ctl-opt
               actgrp(*caller)
               bnddir('HDIILE/HDIBDIR')
               option(*srcstmt: *nodebugio: *nounref: *noshowcpy)
               datfmt(*iso) timfmt(*iso);

        dcl-f pahed004 disk usage(*input) keyed;

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpemp_h.rpgle'
      /copy './qcpybooks/svppol_h.rpgle'
      /copy './qcpybooks/spvfec_h.rpgle'
      /copy './qcpybooks/svpsuc_h.rpgle'

       dcl-pr SPVIG2 extpgm('SPVIG2');
              peArcd   packed(6:0);
              peSpol   packed(9:0);
              peRama   packed(2:0);
              peArse   packed(2:0);
              peOper   packed(7:0);
              peFech   packed(8:0);
              peFemi   packed(8:0) const;
              peStat   ind;
              peSspo   packed(3:0);
              peSuop   packed(3:0);
              peFpgm   char(3) const;
       end-pr;

       dcl-pr WSRAP1 extpgm('WSRAP1');
              peEmpr   char(1);
              peSucu   char(2);
              peArcd   packed(6:0);
              peSpol   packed(9:0);
              peSspo   packed(3:0);
              peRama   packed(2:0);
              pePoli   packed(7:0);
              peArse   packed(2:0);
              peOper   packed(7:0);
              peSuop   packed(3:0);
              peFsin   packed(8:0);
              peHsin   packed(6:0);
              peNmat   char(25) const options(*nopass:*omit);
       end-pr;

       dcl-s uri      char(512);
       dcl-s url      varchar(3000);
       dcl-s empr     char(1);
       dcl-s sucu     char(2);
       dcl-s fsin     char(8);
       dcl-s hsin     char(4);
       dcl-s rama     char(2);
       dcl-s poli     char(7);

       dcl-s rc       ind;
       dcl-s hoy      packed(8:0);
       dcl-s @@repl   char(65535);
       dcl-s @hsin    packed(4:0);
       dcl-s peStat   ind;
       dcl-s peFsin   packed(8:0);
       dcl-s peHsin   packed(6:0);
       dcl-s peRama   packed(2:0);
       dcl-s pePoli   packed(7:0);
       dcl-s p@Sspo   packed(3:0);
       dcl-s p@Suop   packed(3:0);

       dcl-ds k1hed0  likerec(p1hed004:*key);

       dcl-ds peMsgs  likeds (paramMsgs);
       dcl-ds peDs456 likeds (DsSet456_t);

       dcl-ds @PsDs psds qualified;
              this  char(10) pos(1);
       end-ds;

      /free

       *inlr = *on;

       if not REST_getUri( @psds.this : uri );
          return;
       endif;
       url = %trim(uri);

       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       fsin = REST_getNextPart(url);
       hsin = REST_getNextPart(url);
       rama = REST_getNextPart(url);
       poli = REST_getNextPart(url);

       if SVPEMP_getDatosDeEmpresa( empr : *omit ) = *off;
          @@repl = empr;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0113'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'COW0113'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       if SVPSUC_getDatosDeSucursal( empr : sucu : *omit ) = *off;
          %subst(@@repl:1:1) = empr;
          %subst(@@repl:2:2) = sucu;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0113'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'COW0113'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       if SVPSIN_getSet456( empr : sucu : peDs456);
          hoy = (peDs456.t@fema * 10000)
              + (peDs456.t@femm *   100)
              +  peDs456.t@femd;
       endif;

       peRama = 0;
       monitor;
         peRama = %dec(rama:2:0);
        on-error;
         peRama = 0;
       endmon;

       if peRama = 0;
          %subst(@@repl:1:2) = rama;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'RAM0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'RAM0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       pePoli = 0;
       monitor;
         pePoli = %dec(poli:7:0);
        on-error;
         pePoli = 0;
       endmon;

       if pePoli = 0;
          %subst(@@repl:1:2) = rama;
          %subst(@@repl:3:7) = poli;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0009'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'POL0009'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       if SVPPOL_chkPoliza( empr
                          : sucu
                          : peRama
                          : pePoli
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit   ) = *off;
          %subst(@@repl:1:2) = rama;
          %subst(@@repl:3:7) = poli;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0009'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'POL0009'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       peFsin = 0;
       monitor;
         peFsin = %dec(fsin:8:0);
        on-error;
         peFsin = 0;
       endmon;

       if peFsin <= 0;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0003'
                       : peMsgs     );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'SIN0003'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       if peFsin > hoy;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0003'
                       : peMsgs     );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'SIN0003'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       if SPVFEC_fechaValida8( peFsin ) = *off;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0003'
                       : peMsgs     );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'SIN0003'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       @hsin = 0;
       monitor;
         @hsin = %dec(hsin:4:0);
        on-error;
         @hsin = 0;
       endmon;

       peHsin = (@hsin * 100);
       if peFsin = hoy;
          if peHsin > %dec(%time():*iso);
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'SIN0007'
                          : peMsgs     );
             rc = REST_writeHeader( 400
                                  : *omit
                                  : *omit
                                  : 'SIN0007'
                                  : peMsgs.peMsev
                                  : peMsgs.peMsg1
                                  : peMsgs.peMsg2 );
             REST_end();
             close *all;
             return;
          endif;
       endif;

       k1hed0.d0empr = empr;
       k1hed0.d0sucu = sucu;
       k1hed0.d0rama = peRama;
       k1hed0.d0poli = pePoli;
       chain %kds(k1hed0:4) pahed004;
       if %found;
          SPVIG2( d0arcd
                : d0spol
                : d0rama
                : d0arse
                : d0oper
                : peFsin
                : 99999999
                : peStat
                : p@sspo
                : p@suop
                : *blanks    );
         if peStat;
            WSRAP1( d0empr
                  : d0sucu
                  : d0arcd
                  : d0spol
                  : p@sspo
                  : d0rama
                  : d0poli
                  : d0arse
                  : d0oper
                  : p@suop
                  : peFsin
                  : peHsin
                  : *omit    );
            REST_end();
            close *all;
            return;
         endif;
       endif;

       %subst(@@repl:1:2) = rama;
       %subst(@@repl:3:7) = poli;
       SVPWS_getMsgs( '*LIBL'
                    : 'WSVMSG'
                    : 'POL0016'
                    : peMsgs
                    : %trim(@@repl)
                    : %len(%trim(@@repl)) );
       rc = REST_writeHeader( 400
                            : *omit
                            : *omit
                            : 'POL0016'
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
       REST_end();
       close *all;

       return;

      /end-free

