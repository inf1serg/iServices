     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLASA : WebService - Retorna Aseg.Adic.de SuperPóliza.      *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                            02/09/2015    *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * JSN 28/02/2019  Recompilacion por cambio en la estructura    *
      *                 PAHASE_T                                     *
      *                                                              *
      * ************************************************************ *
     Fpahec1    if   e           k disk
     Fpahec5    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLASA          pr                  ExtPgm('WSLASA')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keyasa_t) const
     D   pePreg                            likeds(keyasa_t)
     D   peUreg                            likeds(keyasa_t)
     D   peLasa                            likeds(pahec5_t) dim(99)
     D   peLasaC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLASA          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keyasa_t) const
     D   pePreg                            likeds(keyasa_t)
     D   peUreg                            likeds(keyasa_t)
     D   peLasa                            likeds(pahec5_t) dim(99)
     D   peLasaC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLASE          pr                  ExtPgm('WSLASE')
     D   peBase                            likeds(paramBase) const
     D   peAsen                       7  0 const
     D   peDase                            likeds(pahase_t)
     D   peMase                            likeds(dsMail_t) dim(100)
     D   peMaseC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@Repl          s          65535a
     D @@Leng          s             10i 0
     D @@more          s               n
     D peDase          ds                  likeds(pahase_t)
     D peMase          ds                  likeds(dsMail_t) dim(100)
     D peMaseC         s             10i 0
     D peErro1         s                   like(paramErro)
     D peMsgs1         ds                  likeds(paramMsgs)

     D khec1           ds                  likerec(p1hec1:*key)
     D khec5           ds                  likerec(p1hec5:*key)

     D finArc          pr              n

     D @@cant          s             10i 0

       *inLr = *On;

       clear peLasa;
       clear peLasaC;
       clear peErro;
       clear peMsgs;
       clear peUreg;
       clear pePreg;

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

        khec1.c1empr = peBase.peEmpr;
        khec1.c1sucu = peBase.peSucu;
        khec1.c1arcd = pePosi.arcd;
        khec1.c1spol = pePosi.spol;

        setgt  %kds ( khec1 : 4 ) pahec1;
        readpe %kds ( khec1 : 4 ) pahec1;

      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       exsr leeArc;

       exsr priReg;

       dow ( ( not finArc ) and ( peLasaC < @@cant ) );

         clear peDase;
         clear peErro1;
         clear peMsgs1;

         WSLASE( peBase
               : c5asen
               : peDase
               : peMase
               : peMaseC
               : peErro1
               : peMsgs1 );

         if peErro1 = 0;
            peLasaC += 1;
            eval-corr peLasa(peLasaC) = peDase;
            peLasa(peLasaC).c5nord = c5nord;
            peLasa(peLasaC).c5asen = c5asen;
         endif;

         exsr UltReg;

         exsr leeArc;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( pahec5 );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

      *- Rutina de Posicionamiento de Archivo. Segun pePosi, peRoll
       begsr posArc;

        khec5.c5empr = c1empr;
        khec5.c5sucu = c1sucu;
        khec5.c5arcd = c1arcd;
        khec5.c5spol = c1spol;
        khec5.c5sspo = c1sspo;
        khec5.c5nord = pePosi.nord;

       if ( peRoll = 'F' );
          setgt %kds ( khec5 : 6 ) pahec5;
       else;
          setll %kds ( khec5 : 6 ) pahec5;
       endif;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

       reade %kds ( khec5 : 4 ) pahec5;

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;

       readpe %kds ( khec5 : 4 ) pahec5;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

       setll %kds ( khec5 : 4 ) pahec5;

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

       pePreg.arcd = c5arcd;
       pePreg.spol = c5spol;
       pePreg.sspo = c5sspo;
       pePreg.nord = c5nord;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

       peUreg.arcd = c5arcd;
       peUreg.spol = c5spol;
       peUreg.sspo = c5sspo;
       peUreg.nord = c5nord;

       endsr;

      *- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

       return %eof ( pahec5 );

     P finArc          E
