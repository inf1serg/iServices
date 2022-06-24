     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLUBM  : Tareas generales.                                  *
      *           WebService - Retorna Venc. mejoras de una Ubicacion*
      *                                                              *
      * ------------------------------------------------------------ *
      * Jorge Gronda                                   *24-Abr-2015  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SFA 28/05/15 - Tomo datos desde tablas de Gaus               *
      * SFA 17/07/2015 - Se modifica logica sobre peMore             *
      * SGF 25/04/2017 - Estaba pisando la descripción corta con la  *
      *                  larga, que encima la sacaba de tabla y no de*
      *                  póliza.                                     *
      *                                                              *
      * ************************************************************ *
     Fpaher504  if   e           k disk
     Fset001    if   e           k disk    prefix(t1:2)
     Fset161    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLUBM          pr                  ExtPgm('WSLUBM')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keyubm_t) const
     D   pePreg                            likeds(keyubm_t)
     D   peUreg                            likeds(keyubm_t)
     D   peMubi                            likeds(pahrsvs5_t) dim(99)
     D   peMubiC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLUBM          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keyubm_t) const
     D   pePreg                            likeds(keyubm_t)
     D   peUreg                            likeds(keyubm_t)
     D   peMubi                            likeds(pahrsvs5_t) dim(99)
     D   peMubiC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1yer5          ds                  likeRec ( p1her5 : *Key )
     D k1y161          ds                  likeRec ( s1t161 : *Key )

     D fecHoy          s              8  0
     D @@cant          s             10i 0

     D @@repl          s          65535a
     D @@leng          s             10i 0

     D @@more          s               n

       *inLr = *On;

       peErro  = *Zeros;
       peMubiC = *Zeros;

       fecHoy = *Year*10000 + *Month*100 + *Day;

       clear peMubi;
       clear peMsgs;
       clear pePreg;
       clear peUreg;

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

      *- Valido Rama sea Riesgos Varios.
       chain pePosi.r5rama set001;
      if ( t1rame = 4 ) or ( t1rame = 18 ) or ( t1rame =  21 );
         @@Repl =   %editw( pePosi.r5rama : '0 ' )
                +   %editw( pePosi.r5poli : '0      ' );
         @@Leng = %len ( %trimr ( @@repl ) );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0003' :
                           peMsgs : @@Repl  : @@Leng );
         peErro = -1;
         return;
       endif;

      *- Valido Cantidad de Lineas a Retornar
       @@cant = peCant;
       if ( ( peCant <= *Zeros ) or ( peCant > 99 ) );
         @@cant = 99;
       endif;

      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       readpe %kds ( k1yer5 : 6 ) paher504;

      * Guardo Primer Registro
       exsr priReg;

       dow ( not %eof ( paher504 ) ) and ( peMubiC < @@cant );

         peMubiC += 1;

         peMubi( peMubiC ).rscert5 = r5cert;
         peMubi( peMubiC ).rsarcd5 = r5arcd;
         peMubi( peMubiC ).rsarse5 = r5arse;
         peMubi( peMubiC ).rsoper5 = r5oper;
         peMubi( peMubiC ).rssspo5 = r5sspo;
         peMubi( peMubiC ).rssuop5 = r5suop;
         peMubi( peMubiC ).rsmejo5 = r5mejo;

         k1y161.t@rama = r5rama;
         k1y161.t@mejo = r5mejo;
         chain %kds ( k1y161 ) set161;
         if %found ( set161 );
           peMubi( peMubiC ).rsmejd5 = t@mejd;
         else;
           peMubi( peMubiC ).rsmejd5 = *Blanks;
           peMubi( peMubiC ).rsmejl5 = *Blanks;
         endif;

         peMubi( peMubiC ).rsmejl5 = r5mejl;
         monitor;
           peMubi( peMubiC ).rsfvto5 = %date( r5fvto : *iso );
         on-error;
           peMubi( peMubiC ).rsfvto5 = %date( 00010101 : *iso );
         endmon;

         monitor;
           peMubi( peMubiC ).rsfcum5 = %date( r5fcum : *iso );
         on-error;
           peMubi( peMubiC ).rsfcum5 = %date( 00010101 : *iso );
         endmon;

         peMubi( peMubiC ).rsemej5 = r5emej;

         select;
           when ( r5emej = '0' );
             if ( r5fvto < fecHoy );
               peMubi( peMubiC ).rsemed5 = 'VENCIDA';
             else;
               peMubi( peMubiC ).rsemed5 = 'A VENCER';
             endif;
           when ( r5emej = '1' );
             peMubi( peMubiC ).rsemed5 = 'CUMPLIDA';
           when ( r5emej = '9' );
             peMubi( peMubiC ).rsemed5 = 'DADA DE BAJA';
         endsl;

         peMubi( peMubiC ).rsmar15 = r5mar1;
         peMubi( peMubiC ).rsmar25 = r5mar2;
         peMubi( peMubiC ).rsmar35 = r5mar3;
         peMubi( peMubiC ).rsmar45 = r5mar4;
         peMubi( peMubiC ).rsmar55 = r5mar5;
         peMubi( peMubiC ).rsmar65 = r5mar6;
         peMubi( peMubiC ).rsmar75 = r5mar7;
         peMubi( peMubiC ).rsmar85 = r5mar8;
         peMubi( peMubiC ).rsmar95 = r5mar9;
         peMubi( peMubiC ).rsmar05 = r5mar0;

         exsr UltReg;

         reade %kds ( k1yer5 : 6 ) paher504;

         if not %eof ( paher504 );
           k1yer5.r5mejo = r5mejo;
           setgt %kds ( k1yer5 : 7 ) paher504;

           readpe %kds ( k1yer5 : 6 ) paher504;
         endif;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( paher504 );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

      *- Rutina de Posicionamiento de Archivo. Segun pePosi, peRoll
       begsr posArc;

         k1yer5.r5empr = peBase.peEmpr;
         k1yer5.r5sucu = peBase.peSucu;
         k1yer5.r5rama = pePosi.r5rama;
         k1yer5.r5poli = pePosi.r5poli;
         k1yer5.r5spol = pePosi.r5spol;
         k1yer5.r5poco = pePosi.r5poco;
         k1yer5.r5mejo = pePosi.r5mejo;

         if ( peRoll = 'F' );
           setgt %kds ( k1yer5 : 7 ) paher504;
         else;
           setll %kds ( k1yer5 : 7 ) paher504;
         endif;

         reade %kds ( k1yer5 : 6 ) paher504;
         k1yer5.r5mejo = r5mejo;
         setgt %kds ( k1yer5 : 7 ) paher504;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr retPag;

         if ( peRoll = 'R' );
           readpe %kds ( k1yer5 : 6 ) paher504;
           k1yer5.r5mejo = r5mejo;
           setll %kds ( k1yer5 : 7 ) paher504;
           readpe %kds ( k1yer5 : 6 ) paher504;
           dow ( ( not %eof ( paher504 ) ) and ( @@cant > 0 ) );
             @@cant -= 1;
             k1yer5.r5mejo = r5mejo;
             setll %kds ( k1yer5 : 7 ) paher504;
             readpe %kds ( k1yer5 : 6 ) paher504;
           enddo;
           if %eof ( paher504 );
             @@more = *Off;
             setll %kds ( k1yer5 : 6 ) paher504;
             reade %kds ( k1yer5 : 6 ) paher504;
             k1yer5.r5mejo = r5mejo;
             setgt %kds ( k1yer5 : 7 ) paher504;
           endif;
           @@cant = peCant;
           if (@@cant <= 0 or @@cant > 99);
              @@cant = 99;
           endif;
         endif;

       endsr;

      *- Rutina que graba el Primer Registro
       begsr priReg;

         pePreg.r5rama = r5rama;
         pePreg.r5poli = r5poli;
         pePreg.r5spol = r5spol;
         pePreg.r5poco = r5poco;
         pePreg.r5mejo = r5mejo;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

         peUreg.r5rama = r5rama;
         peUreg.r5poli = r5poli;
         peUreg.r5spol = r5spol;
         peUreg.r5poco = r5poco;
         peUreg.r5mejo = r5mejo;

       endsr;
