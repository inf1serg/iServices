      * ************************************************************ *
      * WSRAPD: BPM Siniestros                                       *
      *         Obtener póliza vigente a fecha de Siniestro          *
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

        dcl-f pahet910 disk usage(*input) keyed;

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpemp_h.rpgle'
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/spvfec_h.rpgle'
      /copy './qcpybooks/svpsuc_h.rpgle'

       dcl-pr SPVIG3 extpgm('SPVIG3');
              peArcd   packed(6:0);
              peSpol   packed(9:0);
              peRama   packed(2:0);
              peArse   packed(2:0);
              peOper   packed(7:0);
              pePoco   packed(4:0);
              peFech   packed(8:0);
              peFemi   packed(8:0) const;
              peStat   ind;
              peSspo   packed(3:0);
              peSuop   packed(3:0);
              peFpgm   char(3) const;
              peVig2   ind const;
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
       dcl-s pate     char(25);

       dcl-s rc       ind;
       dcl-s hoy      packed(8:0);
       dcl-s @@repl   char(65535);
       dcl-s @hsin    packed(4:0);
       dcl-s peStat   ind;
       dcl-s peFsin   packed(8:0);
       dcl-s peHsin   packed(6:0);
       dcl-s p@Sspo   packed(3:0);
       dcl-s p@Suop   packed(3:0);

       dcl-ds k1het9  likerec(p1het9:*key);

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
       pate = REST_getNextPart(url);

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

       if pate = 'A/D';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN2000'
                       : peMsgs     );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'SIN2000'
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

       k1het9.t9empr = empr;
       k1het9.t9sucu = sucu;
       k1het9.t9nmat = pate;
       setll %kds(k1het9:3) pahet910;
       reade %kds(k1het9:3) pahet910;
       dow not %eof;
           SPVIG3( t9arcd
                 : t9spol
                 : t9rama
                 : t9arse
                 : t9oper
                 : t9poco
                 : peFsin
                 : 99999999
                 : peStat
                 : p@sspo
                 : p@suop
                 : *blanks
                 : *on        );
           if peStat;
              WSRAP1( t9empr
                    : t9sucu
                    : t9arcd
                    : t9spol
                    : p@sspo
                    : t9rama
                    : t9poli
                    : t9arse
                    : t9oper
                    : p@suop
                    : peFsin
                    : peHsin
                    : pate     );
              REST_end();
              close *all;
              return;
           endif;
        reade %kds(k1het9:3) pahet910;
       enddo;

       @@repl = *blanks;
       %subst(@@repl:1:2) = %subst(fsin:7:2);
       %subst(@@repl:4:2) = %subst(fsin:5:2);
       %subst(@@repl:7:4) = %subst(fsin:1:4);
       %subst(@@repl:3:1) = '/';
       %subst(@@repl:6:1) = '/';
       %subst(@@repl:11:25) = %subst(pate:1:25);
       SVPWS_getMsgs( '*LIBL'
                    : 'WSVMSG'
                    : 'SIN0005'
                    : peMsgs
                    : %trim(@@repl)
                    : %len(%trim(@@repl)) );
       rc = REST_writeHeader( 400
                            : *omit
                            : *omit
                            : 'SIN0005'
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
       REST_end();
       close *all;

       return;

      /end-free

