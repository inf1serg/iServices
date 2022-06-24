     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLBAV  : Tareas generales.                                  *
      *           WebService - Retorna beneficiarios asegurado vida. *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                            *07-May-2015  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * INF1NORBER 29/05/2015 - Se modifica archivos y parms.        *
      * ************************************************************ *
     Fpahev9    if   e           k disk
     Fpahed004  if   e           k disk
     Fpahev095  if   e           k disk
     Fset001    if   e           k disk
     Fgnttdo    if   e           k disk
     Fset084    if   e           k disk
     Fgntsex    if   e           k disk
     Fgntesc    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLBAV          pr                  ExtPgm('WSLBAV')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peLben                            likeds(beneficiarios_t) dim(100)
     D   peLbenC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLBAV          pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peLben                            likeds(beneficiarios_t) dim(100)
     D   peLbenC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khev9           ds                  likerec(p1hev9:*key)

     D khed004         ds                  likerec(p1hed004:*key)

     D khev095         ds                  likerec(p1hev0:*key)

     D beneficiar      ds                  likerec(p1hev9)

     D                 ds
     D pfamd                          8s 0
     D   pfaa                         4s 0 overlay(pfamd:1)
     D   pfmm                         2s 0 overlay(pfamd:*next)
     D   pfdd                         2s 0 overlay(pfamd:*next)

     D respue          s          65536
     D longm           s             10i 0

       *inLr = *On;

      *- Validaciones
      *- Valido Parametros Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

      *- Valido Existe Poliza
       khed004.d0empr = peBase.peEmpr;
       khed004.d0sucu = peBase.peSucu;
       khed004.d0rama = peRama;
       khed004.d0poli = pePoli;

       setll %kds ( khed004:4 ) pahed004;

       if not %equal(pahed004);

          respue =  %editC(peRama:'4':*ASTFILL) +
                    %editC(pePoli:'4':*ASTFILL);
          longm  = 9 ;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0009' :
                          peMsgs : respue  : longm );
          peErro = -1;
          return;

       endif;

      *- Valido Existe Componente
       khev095.v0empr = peBase.peEmpr;
       khev095.v0sucu = peBase.peSucu;
       khev095.v0rama = peRama;
       khev095.v0poli = pePoli;
       khev095.v0spol = peSpol;
       khev095.v0poco = pePoco;
       khev095.v0paco = pePaco;

       chain %kds ( khev095:7 ) pahev095;

       if not %found(pahev095);

          respue =  %editC(pePoco:'4':*ASTFILL) +
                    %editC(pePaco:'4':*ASTFILL) +
                    %editC(pePoli:'4':*ASTFILL);
          longm  = 16;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0010' :
                          peMsgs : respue  : longm );
          peErro = -1;
          return;

       endif;

      *- Valido Rama Vida
       chain (peRama) set001;

       if (t@rame <> 18 and t@rame <> 21);
          respue =  %editC(peRama:'4':*ASTFILL) +
                    %editC(pePoli:'4':*ASTFILL);
          longm = 9 ;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0003' :
                          peMsgs : respue  : longm );
          peErro = -1;
          return;
       endif;

       peLbenC = *Zeros;
       peErro = *Zeros;

       clear peLben;
       clear peMsgs;

       khev9.v9empr = peBase.peEmpr;
       khev9.v9sucu = peBase.peSucu;
       khev9.v9arcd = v0Arcd;
       khev9.v9spol = peSpol;
       khev9.v9rama = peRama;
       khev9.v9arse = v0Arse;
       khev9.v9oper = v0Oper;
       khev9.v9poco = pePoco;
       khev9.v9paco = pePaco;

       setll %kds ( khev9 : 9 ) pahev9;

       reade %kds ( khev9: 9 ) pahev9 beneficiar;

       dow ( not %eof ( pahev9 ) ) and ( peLbenC < 100 );

          peLbenC += 1;

          peLben(peLbenC).v9nord = beneficiar.v9nord;
          peLben(peLbenC).v9nrdf = beneficiar.v9nrdf;
          peLben(peLbenC).v9nomb = beneficiar.v9nomb;
          peLben(peLbenC).v9tido = beneficiar.v9tido;

          clear gndatd;
          chain (beneficiar.v9tido) gnttdo;
          peLben(peLbenC).v9datd = gndatd;

          peLben(peLbenC).v9nrdo = beneficiar.v9nrdo;
          peLben(peLbenC).v9part = beneficiar.v9part;
          peLben(peLbenC).v9suin = beneficiar.v9suin;

          pfaa = beneficiar.v9ainn;
          pfmm = beneficiar.v9minn;
          pfdd = beneficiar.v9dinn;

          test(de) *iso pfamd;

          if not %error;

      **     %nullind(peLben(peLbenC).v9finn) = *off;
             peLben(peLbenC).v9finn = %date(pfamd:*iso);

          else;

      **     %nullind(peLben(peLbenC).v9finn) = *on;

          endif;

          peLben(peLbenC).v9suen = beneficiar.v9suen;

          pfaa = beneficiar.v9aegn;
          pfmm = beneficiar.v9megn;
          pfdd = beneficiar.v9degn;

          test(de) *iso pfamd;

          if not %error;

      **    %nullind(peLben(peLbenC).v9fegn) = *off;
            peLben(peLbenC).v9fegn = %date(pfamd:*iso);

          else;

      **    %nullind(peLben(peLbenC).v9fegn) = *on;

          endif;

          peLben(peLbenC).v9strg = beneficiar.v9strg;

          if beneficiar.v9strg = '1';

            peLben(peLbenC).v9stat = 'BAJA  ';

          else;

            peLben(peLbenC).v9stat = 'ACTIVO';

          endif;

          peLben(peLbenC).v9tibe = beneficiar.v9tibe;

          if beneficiar.v9tibe = 'P';

            peLben(peLbenC).v9tibd = 'PRIMARIO  ';

          else;

            if beneficiar.v9tibe = 'S';

              peLben(peLbenC).v9tibd = 'SECUNDARIO';

            endif;

          endif;

          peLben(peLbenC).v9pabe = beneficiar.v9pabe;

          clear t@pade;
          chain (beneficiar.v9pabe) set084;

          peLben(peLbenC).v9pade = t@pade;

          peLben(peLbenC).v9sexo = beneficiar.v9sexo;

          clear sedsex;
          chain (beneficiar.v9sexo) gntsex;

          peLben(peLbenC).v9dsex = sedsex;

          peLben(peLbenC).v9esci = beneficiar.v9esci;

          clear esdesc;
          chain (beneficiar.v9esci) gntesc;

          peLben(peLbenC).v9desc = esdesc;

          pfaa = beneficiar.v9fnaa;
          pfmm = beneficiar.v9fnam;
          pfdd = beneficiar.v9fnad;

          test(de) *iso pfamd;

          if not %error;

      **    %nullind(peLben(peLbenC).v9fnac) = *off;
            peLben(peLbenC).v9fnac = %date(pfamd:*iso);

          else;

      **    %nullind(peLben(peLbenC).v9fnac) = *on;

          endif;

          peLben(peLbenC).v9rgln = beneficiar.v9rgln;

          reade %kds ( khev9: 9 ) pahev9 beneficiar;

       enddo;

       return;
