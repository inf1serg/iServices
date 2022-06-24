     H option(*srcstmt) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRRRC: QUOM Versión 2                                       *
      *         Lista planes por productor RC.                       *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *18-May-2021            *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      *                                                              *
      * ************************************************************ *
     Fset100    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpprd_h.rpgle'
      /copy './qcpybooks/wsltab_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D rama            s              2a
     D arcd            s              6a
     D mone            s              2a
     D tipo            s              1a

     D url             s           3000a   varying
     D rc              s              1n
     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0
     D pePlan          ds                  likeds(regPlan_t) dim(999)
     D @@Xcob          ds                  likeds(cobert_t) dim(999)
     D @@XcobC         s             10i 0
     D peArcd          s              6  0
     D peRama          s              2  0
     D peFweb          s              1n
     D @@ValSys        s            512a
     D x               s             10i 0
     D i               s             10i 0
     D q               s             10i 0

     D k1t100          ds                  likerec(s1t100:*key)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)
     D  JobName                      10a   overlay(PsDs:244)
     D  JobUser                      10a   overlay(PsDs:254)
     D  JobNbr                        6  0 overlay(PsDs:264)

      /free

       *inlr = *on;

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
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       nivt = REST_getNextPart(url);
       nivc = REST_getNextPart(url);
       nit1 = REST_getNextPart(url);
       niv1 = REST_getNextPart(url);
       rama = REST_getNextPart(url);
       arcd = REST_getNextPart(url);
       mone = REST_getNextPart(url);
       tipo = REST_getNextPart(url);

       if ( tipo <> 'T' and tipo <> 'W' );
          tipo = 'T';
       endif;
       peFweb = *off;
       if tipo = 'W';
          peFweb = *on;
       endif;

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

       monitor;
         peRama = %dec(rama:2:0);
        on-error;
         peRama = 0;
       endmon;
       if peRama = *zeros;
         peRama = 8;
       endif;

       monitor;
         peArcd = %dec(arcd:6:0);
        on-error;
         peArcd = 0;
       endmon;
       if peArcd = *zeros;
         if not SVPVLS_getValSys( 'HARCDRRC':*omit :@@ValSys );
           peErro = -1;
           return;
         else;
           peArcd = %dec( @@ValSys : 6 : 0 );
         endif;
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'planesRC' );

       q = SVPPRD_planesPorProductor( empr
                                    : sucu
                                    : peRama
                                    : peArcd
                                    : %dec(nivt:1:0)
                                    : %dec(nivc:5:0)
                                    : pePlan
                                    : peFweb         );

       for x = 1 to q;
         REST_startArray( 'plan' );
           REST_writeXmlLine( 'PRDL' : pePlan(x).t@prdl        );
           REST_writeXmlLine( 'PRDS' : pePlan(x).t@prds        );
           REST_writeXmlLine( 'XPRO' : %char(pePlan(x).t@xpro) );

           k1t100.t@rama = peRama;
           k1t100.t@xpro = pePlan(x).t@xpro;
           k1t100.t@mone = Mone;
           chain %kds( k1t100 : 3 ) set100;
           if %found;
             REST_writeXmlLine( 'premioAnual': SVPREST_editImporte(t@Prem ) );
           else;
             REST_writeXmlLine( 'premioAnual': '.00' );
           endif;

           clear @@Xcob;
           @@XcobC = 0;
           WSLTAB_coberturasPorPlan( peRama
                                   : t@Xpro
                                   : Mone
                                   : @@Xcob
                                   : @@XcobC          );

           REST_startArray( 'coberturas' );
           for i = 1 to @@XcobC;
             REST_startArray( 'cobertura' );
               REST_writeXmlLine( 'codigo' : %char(@@Xcob(i).xcob));
               REST_writeXmlLine( 'descripcion' : @@Xcob(i).cobd  );
               REST_writeXmlLine( 'sumaAsegurada' :
                                   SVPREST_editImporte(@@Xcob(i).saco) );
             REST_endArray( 'cobertura' );
           endfor;
           REST_endArray( 'coberturas' );
        REST_endArray( 'plan' );
       endfor;

       REST_endArray( 'planesRC' );

       return;
