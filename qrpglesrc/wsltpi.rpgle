     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLTPI  : Tareas generales.                                  *
      *           WebService - Retorna total prod.año/mes intermediar*
      *                                                              *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                            *29-Abr-2015  *
      * ------------------------------------------------------------ *
      * Jorge Julio Gronda - Tratamiento de Paginado   *04-May-2015  *
      * SFA 17/07/2015 - Se modifica logica sobre peMore             *
      * SGF 18/08/2016 - PAHPRO se cambia por PAHPR1 y TAB004 por    *
      *                  TAB007.                                     *
      * LRG 31/08/2016 - cambio en clave de reutina priArc           *
      * SGF 29/09/2016 - Cambio PAHPR101 por PAHPR102 para que sea   *
      *                  descendente por fecha.                      *
      *                                                              *
      * ************************************************************ *
     Fpahpr102  if   e           k disk
     Ftab007    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLTPI          pr                  ExtPgm('WSLTPI')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(KEYTPI_t)
     D   pePreg                            likeds(KEYTPI_t)
     D   peUreg                            likeds(KEYTPI_t)
     D   PeFulp                       8  0
     D   peTotp                            likeds(pahpro_t) dim(99)
     D   peTotpC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLTPI          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(KEYTPI_t)
     D   pePreg                            likeds(KEYTPI_t)
     D   peUreg                            likeds(KEYTPI_t)
     D   PeFulp                       8  0
     D   peTotp                            likeds(pahpro_T) dim(99)
     D   peTotpC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpro           ds                  likerec(p1hpr1:*key)
     D k1t004          ds                  likerec(tab007fm:*key)

     D produccion      ds                  likerec(p1hpr1)

     D resPue          s          65536
     D lonGm           s             10i 0

     D finArc          pr              n

     D @@cant          s             10i 0
     D @@more          s               n

       *inLr = *On;

       peTotpC = *Zeros;
       peErro  = *Zeros;
       @@More  = *On;

       // ---------------------------------
       // Fecha del último proceso
       // ---------------------------------
       k1t004.t4secu = 1;
       chain %kds(k1t004) tab007;
       if %found;
          PeFulp  = t4fecpro;
        else;
          PeFulp  = %dec(%date():*iso);
       endif;


       clear peTotp;
       clear peMsgs;

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

      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       exsr leeArc;

       exsr priReg;

       dow ( ( not finArc ) and ( peTotpC < @@cant ) );

         peTotpC += 1;

         peTotp( peTotpC ).prrama   = produccion.prrama;
         petotP( peTotpC ).prcant01 = produccion.prcant01;
         peTotp( peTotpC ).prcant02 = produccion.prcant02;
         peTotp( peTotpC ).prcant03 = produccion.prcant03;
         peTotp( peTotpC ).prcant04 = produccion.prcant04;
         peTotp( peTotpC ).prcant05 = produccion.prcant05;
         peTotp( peTotpC ).prprim   = produccion.prprim;
         peTotp( peTotpC ).prcomi01 = produccion.prcomi01;
         peTotp( peTotpC ).prcomi02 = produccion.prcomi02;
         peTotp( peTotpC ).prcomi03 = produccion.prcomi03;
         peTotp( peTotpC ).prcomi04 = produccion.prcomi04;
         peTotp( peTotpC ).prcomi05 = produccion.prcomi05;
         peTotp( peTotpC ).prcomi06 = produccion.prcomi06;
         peTotp( peTotpC ).prcomi07 = produccion.prcomi07;
         peTotp( peTotpC ).prcomi08 = produccion.prcomi08;
         peTotp( peTotpC ).prcomi09 = produccion.prcomi09;
         peTotp( peTotpC ).prprem   = produccion.prprem;
         peTotp( peTotpC ).prPrco01 = produccion.prprco01;
         peTotp( peTotpC ).prPrco02 = produccion.prprco02;
         peTotp( peTotpC ).prPrco03 = produccion.prprco03;
         peTotp( peTotpC ).prprco04 = produccion.prprco04;
         peTotP( peTotpC ).prprco05 = produccion.prprco05;
         peTotP( peTotpC ).prprco06 = produccion.prprco06;
         peTotp( peTotpC ).prprco07 = produccion.prprco07;
         peTotp( peTotpC ).prprco08 = produccion.prprco08;
         peTotp( peTotpC ).prprco09 = produccion.prprco09;
         peTotp( peTotpC ).prpoco01 = produccion.prpoco01;
         peTotp( peTotpC ).prpoco02 = produccion.prpocO02;
         peTotp( peTotpC ).prpoco03 = produccion.prpocO03;
         peTotp( peTotpC ).prpoco04 = produccion.prpoco04;
         peTotp( peTotpC ).prpoco05 = produccion.prpoco05;
         peTotp( peTotpC ).prpoco06 = produccion.prpoco06;
         peTotp( peTotpC ).prpoco07 = produccion.prpoco07;
         peTotp( peTotpC ).prpoco08 = produccion.prpoco08;
         peTotp( peTotpC ).prpoco09 = produccion.prpoco09;
         peTotp( peTotpC ).prcoco01 = produccion.prcoco01;
         peTotp( peTotpC ).prcoco02 = produccion.prcoco02;
         peTotp( peTotpC ).prcoco03 = produccion.prcoco03;
         peTotp( peTotpC ).prcoco04 = produccion.prcoco04;
         peTotp( peTotpC ).prcoco05 = produccion.prcoco05;
         peTotp( peTotpC ).prcoco06 = produccion.prcoco06;
         peTotp( peTotpC ).prcoco07 = produccion.prcoco07;
         peTotp( peTotpC ).prcoco08 = produccion.prcoco08;
         peTotp( peTotpC ).prcoco09 = produccion.prcoco09;
         peTotp( peTotpC ).prfema   = produccion.prfema;
         peTotp( peTotpC ).prfemm   = produccion.prfemm;

         exsr borCom;

         exsr UltReg;

         exsr leeArc;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( pahpr102 );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

      *- Rutina de Posicionamiento de Archivo. Segun peOrde, pePosi, peRoll
       begsr posArc;

         khpro.prempr  = peBase.peEmpr;
         khpro.prsucu  = peBase.peSucu;
         khpro.prnivt  = peBase.peNivt;
         khpro.prnivc  = peBase.peNivc;
         khpro.prfema  = pePosi.prFema;
         khpro.prfemm  = pePosi.prFemm;
         khpro.prRama  = pePosi.prRama;

             select;
             when (peRoll = 'F' );
               setgt %kds ( khpro : 7 ) pahpr102;
             when (peRoll = 'R' );
               setll %kds ( khpro : 7 ) pahpr102;
             when (peRoll = 'I' );
               setll %kds ( khpro : 7 ) pahpr102;
             endsl;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

       reade %kds ( khpro : 4 ) pahpr102 produccion;

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;

       readpe %kds ( khpro : 4 ) pahpr102;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

       setll %kds ( kHpro   :  4 ) pahpr102;

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

         if not %eof ( pahpr102 );
            pePreg.prfema = produccion.prfema;
            pePreg.prfemm = produccion.prfemm;
            pePreg.prrama = produccion.prrama;
         endif;
       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

         if not %eof ( pahpr102 );
            peUreg.prfema = produccion.prfema;
            peUreg.prfemm = produccion.prfemm;
            peUreg.prrama = produccion.prrama;
         endif;

       endsr;

      *- Borro Comisiones segun peNit1
       begsr borCom;

         select;
           when ( peBase.peNit1 = 1 );
             peTotp( peTotpC ).prcomi02 = *Zeros;
             peTotp( peTotpC ).prcomi03 = *Zeros;
             peTotp( peTotpC ).prcomi04 = *Zeros;
             peTotp( peTotpC ).prcomi05 = *Zeros;
             peTotp( peTotpC ).prcomi06 = *Zeros;
             peTotp( peTotpC ).prcomi07 = *Zeros;
             peTotp( peTotpC ).prcomi08 = *Zeros;
             peTotp( peTotpC ).prcomi09 = *Zeros;
             petotp( peTotpC ).prprco02 = *Zeros;
             peTotp( peTotpC ).prprco03 = *Zeros;
             peTotp( peTotpC ).prprco04 = *Zeros;
             peTotp( peTotpC ).prprco05 = *Zeros;
             peTotp( peTotpC ).prprco06 = *Zeros;
             peTotp( peTotpC ).prprco07 = *Zeros;
             peTotp( peTotpC ).prprco08 = *Zeros;
             peTotp( peTotpC ).prprco09 = *Zeros;
             peTotp( peTotpC ).prpoco02 = *Zeros;
             peTotp( peTotpC ).prpoco03 = *Zeros;
             peTotp( peTotpC ).prpoco04 = *Zeros;
             peTotp( peTotpC ).prpoco05 = *Zeros;
             peTotp( peTotpC ).prpoco06 = *Zeros;
             peTotp( peTotpC ).prpoco07 = *Zeros;
             peTotp( peTotpC ).prpoco08 = *Zeros;
             peTotp( peTotpC ).prpoco09 = *Zeros;
             peTotp( peTotpC ).prcoco02 = *Zeros;
             peTotp( peTotpC ).prcoco03 = *Zeros;
             peTotp( peTotpC ).prcoco04 = *Zeros;
             peTotp( peTotpC ).prcoco05 = *Zeros;
             peTotp( peTotpC ).prcoco06 = *Zeros;
             peTotp( peTotpC ).prcoco07 = *Zeros;
             peTotp( peTotpC ).prcoco08 = *Zeros;
             peTotp( peTotpC ).prcoco09 = *Zeros;
           when ( peBase.peNit1 = 2 );
             peTotp( peTotpC ).prcomi03 = *Zeros;
             peTotp( peTotpC ).prcomi04 = *Zeros;
             peTotp( peTotpC ).prcomi05 = *Zeros;
             peTotp( peTotpC ).prcomi06 = *Zeros;
             peTotp( peTotpC ).prcomi07 = *Zeros;
             peTotp( peTotpC ).prcomi08 = *Zeros;
             peTotp( peTotpC ).prcomi09 = *Zeros;
             peTotp( peTotpC ).prprco03 = *Zeros;
             peTotp( peTotpC ).prprco04 = *Zeros;
             peTotp( peTotpC ).prprco05 = *Zeros;
             peTotp( peTotpC ).prprco06 = *Zeros;
             peTotp( peTotpC ).prprco07 = *Zeros;
             peTotp( peTotpC ).prprco08 = *Zeros;
             peTotp( peTotpC ).prprco09 = *Zeros;
             peTotp( peTotpC ).prpoco03 = *Zeros;
             peTotp( peTotpC ).prpoco04 = *Zeros;
             peTotp( peTotpC ).prpoco05 = *Zeros;
             peTotp( peTotpC ).prpoco06 = *Zeros;
             peTotp( peTotpC ).prpoco07 = *Zeros;
             peTotp( peTotpC ).prpoco08 = *Zeros;
             peTotp( peTotpC ).prpoco09 = *Zeros;
             peTotp( peTotpC ).prcoco03 = *Zeros;
             peTotp( peTotpC ).prcoco04 = *Zeros;
             peTotp( peTotpC ).prcoco05 = *Zeros;
             peTotp( peTotpC ).prcoco06 = *Zeros;
             PeTotp( peTotpC ).prcoco07 = *Zeros;
             peTotp( peTotpC ).prcoco08 = *Zeros;
             peTotp( peTotpC ).prcoco09 = *Zeros;
           when ( peBase.peNit1 = 3 );
             peTotp( peTotpC ).prcomi04 = *Zeros;
             peTotp( peTotpC ).prcomi05 = *Zeros;
             peTotp( peTotpC ).prcomi06 = *Zeros;
             peTotp( peTotpC ).prcomi07 = *Zeros;
             peTotp( peTotpC ).prcomi08 = *Zeros;
             peTotp( peTotpC ).prcomi09 = *Zeros;
             peTotp( peTotpC ).prprco04 = *Zeros;
             peTotp( peTotpC ).prprco05 = *Zeros;
             peTotp( peTotpC ).prprco06 = *Zeros;
             peTotp( peTotpC ).prprco07 = *Zeros;
             peTotp( peTotpC ).prprco08 = *Zeros;
             peTotp( peTotpC ).prprco09 = *Zeros;
             peTotp( peTotpC ).prpoco04 = *Zeros;
             peTotp( peTotpC ).prpoco05 = *Zeros;
             peTotp( peTotpC ).prpoco06 = *Zeros;
             peTotp( peTotpC ).prpoco07 = *Zeros;
             peTotp( peTotpC ).prpoco08 = *Zeros;
             peTotp( peTotpC ).prpoco09 = *Zeros;
             peTotp( peTotpC ).prcoco04 = *Zeros;
             peTotp( peTotpC ).prcoco05 = *Zeros;
             peTotp( peTotpC ).prcoco06 = *Zeros;
             peTotp( peTotpC ).prcoco07 = *Zeros;
             peTotp( peTotpC ).prcoco08 = *Zeros;
             peTotp( peTotpC ).prcoco09 = *Zeros;
           when ( peBase.peNit1 = 4 );
             peTotp( peTotpC ).prcomi05 = *Zeros;
             peTotp( peTotpC ).prcomi06 = *Zeros;
             peTotp( peTotpC ).prcomi07 = *Zeros;
             peTotp( peTotpC ).prcomi08 = *Zeros;
             peTotp( peTotpC ).prcomi09 = *Zeros;
             peTotp( peTotpC ).prprco05 = *Zeros;
             peTotp( peTotpC ).prprco06 = *Zeros;
             peTotp( peTotpC ).prprco07 = *Zeros;
             peTotp( peTotpC ).prprco08 = *Zeros;
             peTotp( peTotpC ).prprco09 = *Zeros;
             peTotp( peTotpC ).prpoco05 = *Zeros;
             peTotp( peTotpC ).prpoco06 = *Zeros;
             peTotp( peTotpC ).prpoco07 = *Zeros;
             peTotp( peTotpC ).prpoco08 = *Zeros;
             peTotp( peTotpC ).prpoco09 = *Zeros;
             peTotp( peTotpC ).prcoco05 = *Zeros;
             peTotp( peTotpC ).prcoco06 = *Zeros;
             peTotp( peTotpC ).prcoco07 = *Zeros;
             peTotp( peTotpC ).prcoco08 = *Zeros;
             peTotp( peTotpC ).prcoco09 = *Zeros;
           when ( peBase.peNit1 = 5 );
             peTotp( peTotpC ).prcomi06 = *Zeros;
             peTotp( peTotpC ).prcomi07 = *Zeros;
             peTotp( peTotpC ).prcomi08 = *Zeros;
             peTotp( peTotpC ).prcomi09 = *Zeros;
             peTotp( peTotpC ).prprco06 = *Zeros;
             peTotp( peTotpC ).prprco07 = *Zeros;
             peTotp( peTotpC ).prprco08 = *Zeros;
             peTotp( peTotpC ).prprco09 = *Zeros;
             peTotp( peTotpC ).prpoco06 = *Zeros;
             peTotp( peTotpC ).prpoco07 = *Zeros;
             peTotp( peTotpC ).prpoco08 = *Zeros;
             peTotp( peTotpC ).prpoco09 = *Zeros;
             peTotp( peTotpC ).prcoco06 = *Zeros;
             peTotp( peTotpC ).prcoco07 = *Zeros;
             peTotp( peTotpC ).prcoco08 = *Zeros;
             peTotp( peTotpC ).prcoco09 = *Zeros;
           when ( peBase.peNit1 = 6 );
             peTotp( peTotpC ).prcomi07 = *Zeros;
             peTotp( peTotpC ).prcomi08 = *Zeros;
             peTotp( peTotpC ).prcomi09 = *Zeros;
             peTotp( peTotpC ).prprco07 = *Zeros;
             peTotp( peTotpC ).prprco08 = *Zeros;
             peTotp( peTotpC ).prprco09 = *Zeros;
             peTotp( peTotpC ).prpoco07 = *Zeros;
             peTotp( peTotpC ).prpoco08 = *Zeros;
             peTotp( peTotpC ).prpoco09 = *Zeros;
             peTotp( peTotpC ).prcoco07 = *Zeros;
             peTotp( peTotpC ).prcoco08 = *Zeros;
             peTotp( peTotpC ).prcoco09 = *Zeros;
           when ( peBase.peNit1 = 7 );
             peTotp( peTotpC ).prcomi08 = *Zeros;
             peTotp( peTotpC ).prcomi09 = *Zeros;
             peTotp( peTotpC ).prprco08 = *Zeros;
             peTotp( peTotpC ).prprco09 = *Zeros;
             peTotp( peTotpC ).prpoco08 = *Zeros;
             peTotp( peTotpC ).prpoco09 = *Zeros;
             peTotp( peTotpC ).prcoco08 = *Zeros;
             peTotp( peTotpC ).prcoco09 = *Zeros;
           when ( peBase.peNit1 = 8 );
             peTotp( peTotpC ).prcomi09 = *Zeros;
             peTotp( peTotpC ).prprco09 = *Zeros;
             peTotp( peTotpC ).prpoco09 = *Zeros;
             peTotp( peTotpC ).prcoco09 = *Zeros;
         endsl;

       endsr;

      *- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

       return %eof ( pahpr102 );

     P finArc          E
