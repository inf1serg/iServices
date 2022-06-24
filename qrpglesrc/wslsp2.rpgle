     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLSP2 : WebService - Retorna propuestas por intermediario.  *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                            01/09/2015    *
      * ------------------------------------------------------------ *
      * SGF 24/11/2015: Diferentes ordenamientos.                    *
      *                                                              *
      * ************************************************************ *
     Fpahsp2    if   e           k disk
     Fpahsp201  if   e           k disk    rename(p1hsp2:p1hsp201)
     Fpahsp202  if   e           k disk    rename(p1hsp2:p1hsp202)

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLSP2          pr                  ExtPgm('WSLSP2')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   peOrde                      10a   const
     D   pePosi                            likeds(keysp2_t) const
     D   pePreg                            likeds(keysp2_t)
     D   peUreg                            likeds(keysp2_t)
     D   peLprp                            likeds(pahsp2_t) dim(99)
     D   peLprpC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLSP2          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   peOrde                      10a   const
     D   pePosi                            likeds(keysp2_t) const
     D   pePreg                            likeds(keysp2_t)
     D   peUreg                            likeds(keysp2_t)
     D   peLprp                            likeds(pahsp2_t) dim(99)
     D   peLprpC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@Repl          s          65535a
     D @@Leng          s             10i 0
     D @@more          s               n

     D*khsp2           ds                  likerec(p1hsp2:*key)
     D k0hsp2          ds                  likerec(p1hsp2:*key)
     D k1hsp2          ds                  likerec(p1hsp2:*key)
     D k2hsp2          ds                  likerec(p1hsp201:*key)
     D k3hsp2          ds                  likerec(p1hsp202:*key)

     D finArc          pr              n

     D @@cant          s             10i 0

       *inLr = *On;

       clear peLprp;
       clear peLprpC;
       clear peErro;
       clear peMsgs;

       @@more = *On;

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

      *- Valido Parametro Forma de Paginado
       if not SVPWS_chkRoll ( peRoll : peMsgs );
         peErro = -1;
         return;
       endif;

      *- Valido Cantidad de Lineas a Retornar
       @@cant = peCant;
       if ( ( peCant <= *Zeros ) or ( peCant > 99 ) );
         @@cant = 99;
       endif;

      *- Valido Orden de Lectura
       if not SVPWS_chkOrde ( 'WSLSP2' : peOrde : peMsgs );
         peErro = -1;
         return;
       endif;

      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       exsr leeArc;

       exsr priReg;

       dow ( ( not finArc ) and ( peLprpC < @@cant ) );

         peLprpC += 1;

         peLprp(peLprpC).swarcd = swarcd;
         peLprp(peLprpC).swspol = swspol;
         peLprp(peLprpC).swrama = swrama;
         peLprp(peLprpC).swramd = swramd;
         peLprp(peLprpC).swsoln = swsoln;
         peLprp(peLprpC).swpoli = swpoli;
         peLprp(peLprpC).swtiou = swtiou;
         peLprp(peLprpC).swstou = swstou;
         peLprp(peLprpC).swdtop = swdtop;
         peLprp(peLprpC).swdsop = swdsop;
         peLprp(peLprpC).swfvdp = swfvdp;
         peLprp(peLprpC).swfvhp = swfvhp;
         peLprp(peLprpC).swfvde = swfvde;
         peLprp(peLprpC).swfvhe = swfvhe;
         peLprp(peLprpC).swnivt = swnivt;
         peLprp(peLprpC).swnivc = swnivc;
         peLprp(peLprpC).swnivd = swnivd;
         peLprp(peLprpC).swased = swased;
         peLprp(peLprpC).swcuit = swcuit;
         peLprp(peLprpC).swpatc = swpatc;
         peLprp(peLprpC).swesta = swesta;
         peLprp(peLprpC).swprog = swprog;
         peLprp(peLprpC).swrame = swrame;
         peLprp(peLprpC).swmar1 = swmar1;
         peLprp(peLprpC).swmar2 = swmar2;
         peLprp(peLprpC).swmar3 = swmar3;
         peLprp(peLprpC).swmar4 = swmar4;
         peLprp(peLprpC).swmar5 = swmar5;
         peLprp(peLprpC).swmar6 = swmar6;
         peLprp(peLprpC).swmar7 = swmar7;
         peLprp(peLprpC).swmar8 = swmar8;
         peLprp(peLprpC).swmar9 = swmar9;
         peLprp(peLprpC).swnctz = swnctz;

         exsr UltReg;

         exsr leeArc;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when finArc;
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

      *- Rutina de Posicionamiento de Archivo. Segun pePosi, peRoll
       begsr posArc;

        k0hsp2.swempr = peBase.peEmpr;
        k0hsp2.swsucu = peBase.peSucu;
        k0hsp2.swnivt = peBase.peNivt;
        k0hsp2.swnivc = peBase.peNivc;

        select;
         when (peOrde = 'INTERMRAMA');
              k1hsp2.swempr = peBase.peEmpr;
              k1hsp2.swsucu = peBase.peSucu;
              k1hsp2.swnivt = peBase.peNivt;
              k1hsp2.swnivc = peBase.peNivc;
              k1hsp2.swrama = pePosi.rama;
              k1hsp2.swsoln = pePosi.soln;
              if ( peRoll = 'F' );
                 setgt %kds(k1hsp2:6) pahsp2;
               else;
                 setll %kds(k1hsp2:6) pahsp2;
              endif;
         when (peOrde = 'INTERMASED');
              k2hsp2.swempr = peBase.peEmpr;
              k2hsp2.swsucu = peBase.peSucu;
              k2hsp2.swnivt = peBase.peNivt;
              k2hsp2.swnivc = peBase.peNivc;
              k2hsp2.swased = pePosi.ased;
              k2hsp2.swrama = pePosi.rama;
              k2hsp2.swsoln = pePosi.soln;
              if ( peRoll = 'F' );
                 setgt %kds(k2hsp2:7) pahsp201;
               else;
                 setll %kds(k2hsp2:7) pahsp201;
              endif;
         when (peOrde = 'INTERMPATE');
              k3hsp2.swempr = peBase.peEmpr;
              k3hsp2.swsucu = peBase.peSucu;
              k3hsp2.swnivt = peBase.peNivt;
              k3hsp2.swnivc = peBase.peNivc;
              k3hsp2.swpatc = pePosi.patc;
              k3hsp2.swrama = pePosi.rama;
              k3hsp2.swsoln = pePosi.soln;
              if ( peRoll = 'F' );
                 setgt %kds(k3hsp2:7) pahsp202;
               else;
                 setll %kds(k3hsp2:7) pahsp202;
              endif;
        endsl;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

         select;
          when ( peOrde = 'INTERMRAMA' );
               reade %kds ( k0hsp2 : 4 ) pahsp2;
          when ( peOrde = 'INTERMASED' );
               reade %kds ( k0hsp2 : 4 ) pahsp201;
          when ( peOrde = 'INTERMPATE' );
               reade %kds ( k0hsp2 : 4 ) pahsp202;
         endsl;

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;

         select;
          when ( peOrde = 'INTERMRAMA' );
               readpe %kds(k0hsp2:4) pahsp2;
          when ( peOrde = 'INTERMASED' );
               readpe %kds(k0hsp2:4) pahsp201;
          when ( peOrde = 'INTERMPATE' );
               readpe %kds(k0hsp2:4) pahsp202;
         endsl;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

         select;
          when ( peOrde = 'INTERMRAMA' );
               setll %kds(k0hsp2:4) pahsp2;
          when ( peOrde = 'INTERMASED' );
               setll %kds(k0hsp2:4) pahsp201;
          when ( peOrde = 'INTERMPATE' );
               setll %kds(k0hsp2:4) pahsp202;
         endsl;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr retPag;

       if ( peRoll = 'R' );
         exsr retArc;
         dow ( ( not finArc ) and ( @@cant > 0 ) );
           @@cant -= 1;
           exsr retArc;
         enddo;
         if finArc;
           @@more = *Off;
           exsr priArc;
         endif;
         @@cant = peCant;
         if (@@cant <= 0 or @@cant > 99);
            @@cant = 99;
         endif;
       endif;

       endsr;

      *- Rutina que graba el Primer Registro
       begsr priReg;

       pePreg.rama = swrama;
       pePreg.soln = swsoln;
       pePreg.ased = swased;
       pePreg.patc = swpatc;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

       peUreg.rama = swrama;
       peUreg.soln = swsoln;
       peUreg.ased = swased;
       peUreg.patc = swpatc;

       endsr;

      *- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

         select;
           when ( peOrde = 'INTERMRAMA' );
             return %eof ( pahsp2 );
           when ( peOrde = 'INTERMASED' );
             return %eof ( pahsp201 );
           when ( peOrde = 'INTERMPATE' );
             return %eof ( pahsp202 );
         endsl;

     P finArc          E
