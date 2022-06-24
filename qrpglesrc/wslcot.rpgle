     H option(*nodebugio:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLCOT  : Tareas generales.                                  *
      *           WebService - Retorna Lista de Cotizaciuones        *
      *                                                              *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                               *28-Dic-2015  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SGF 13/09/2016: Descendente por Cotizacion.                  *
      * LRG 11/11/2016: Se agregan Filtros : Forma de Pago distinto  *
      *                 de cero                                      *
      * SGF 05/12/2016: Si nombre en blanco, no mostrar.             *
      *                                                              *
      * ************************************************************ *
     Fctw00011  if   e           k disk
     Fctw00007  if   e           k disk    rename(c1w000:c7w000)
     Fctw00008  if   e           k disk    rename(c1w000:c8w000)
     Fpawpc002  if   e           k disk
     Fctw003    if   e           k disk
     Fgnttdo    if   e           k disk
     Fgntloc    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/cowrtv_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'

     D WSLCOT          pr                  ExtPgm('WSLCOT')
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

     D WSLCOT          pi
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

     D finArc          pr              n

     D k0y000          ds                  likerec( c1w000 : *key)
     D k1y000          ds                  likerec( c1w000 : *key)
     D k7w000          ds                  likerec( c7w000 : *key)
     D k8w000          ds                  likerec( c8w000 : *key)
     D k1wpc0          ds                  likerec( p1wpc002 : *key)
     D k1w003          ds                  likerec( c1w003 : *key)
     D k1tloc          ds                  likerec( g1tloc : *key)

     D peImpu          ds                  likeds(PrimPrem) dim(99)

     D @@cant          s             10i 0
     D i               s             10i 0
     D @@more          s               n
     D cargar          s               n

       *inLr = *On;

       peLcotC = *Zeros;
       peErro  = *Zeros;

       @@more  = *On;

       clear peLcot;
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

      *- Valido Orden de Lectura
       if not SVPWS_chkOrde ( 'WSLCOT' : peOrde : peMsgs );
         peErro = -1;
         return;
       endif;

      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       exsr leeArc;
       exsr priReg;

       dow ( ( not finArc ) and ( peLcotC < @@cant ) );

         cargar = *off;

         if w0spol = 0;
            cargar = *on;
          else;
            k1wpc0.w0empr = w0empr;
            k1wpc0.w0sucu = w0sucu;
            k1wpc0.w0arcd = w0arcd;
            k1wpc0.w0spol = w0spol;
            setll %kds(k1wpc0:4) pawpc002;
            if %equal;
               cargar = *on;
            endif;
         endif;

         if w0cest = 1 and w0cses = 1;
            cargar = *off;
         endif;

         if w0nomb = *blanks;
            cargar = *off;
         endif;

         if w0cfpg <= 0;
            cargar = *off;
         endif;

         if cargar;

            peLcotC +=1 ;

            peLcot( peLcotC ).w0empr = w0empr;
            peLcot( peLcotC ).w0sucu = w0sucu;
            peLcot( peLcotC ).w0nivt = w0nivt;
            peLcot( peLcotC ).w0nivc = w0nivc;
            peLcot( peLcotC ).w0nctw = w0nctw;
            peLcot( peLcotC ).w0nit1 = w0nit1;
            peLcot( peLcotC ).w0niv1 = w0niv1;
            peLcot( peLcotC ).w0fctw = w0fctw;
            peLcot( peLcotC ).w0nomb = w0nomb;
            peLcot( peLcotC ).w0soln = w0soln;
            peLcot( peLcotC ).w0fpro = w0fpro;
            peLcot( peLcotC ).w0mone = w0mone;
            peLcot( peLcotC ).w0noml = w0noml;
            peLcot( peLcotC ).w0come = w0come;
            peLcot( peLcotC ).w0copo = w0copo;
            peLcot( peLcotC ).w0cops = w0cops;
            peLcot( peLcotC ).w0loca = w0loca;
            peLcot( peLcotC ).w0arcd = w0arcd;
            peLcot( peLcotC ).w0arno = w0arno;
            peLcot( peLcotC ).w0spol = w0spol;
            peLcot( peLcotC ).w0sspo = w0sspo;
            peLcot( peLcotC ).w0tipe = w0tipe;
            peLcot( peLcotC ).w0civa = w0civa;
            peLcot( peLcotC ).w0ncil = w0ncil;
            peLcot( peLcotC ).w0tiou = w0tiou;
            peLcot( peLcotC ).w0stou = w0stou;
            peLcot( peLcotC ).w0stos = w0stos;
            peLcot( peLcotC ).w0dsop = w0dsop;
            peLcot( peLcotC ).w0spo1 = w0spo1;
            peLcot( peLcotC ).w0cest = w0cest;
            peLcot( peLcotC ).w0cses = w0cses;
            peLcot( peLcotC ).w0dest = SVPDES_estadoCot( w0cest
                                                       : w0cses );
            peLcot( peLcotC ).w0vdes = w0vdes;
            peLcot( peLcotC ).w0vhas = w0vhas;
            peLcot( peLcotC ).w0cfpg = w0cfpg;
            peLcot( peLcotC ).w0defp = w0defp;
            peLcot( peLcotC ).w0ncbu = w0ncbu;
            peLcot( peLcotC ).w0ctcu = w0ctcu;
            peLcot( peLcotC ).w0nrtc = w0nrtc;
            peLcot( peLcotC ).w0fvtc = w0fvtc;
            peLcot( peLcotC ).w0mp01 = w0mp01;
            peLcot( peLcotC ).w0mp02 = w0mp02;
            peLcot( peLcotC ).w0mp03 = w0mp03;
            peLcot( peLcotC ).w0mp04 = w0mp04;
            peLcot( peLcotC ).w0mp05 = w0mp05;
            peLcot( peLcotC ).w0mp06 = w0mp06;
            peLcot( peLcotC ).w0mp07 = w0mp07;
            peLcot( peLcotC ).w0mp08 = w0mp08;
            peLcot( peLcotC ).w0mp09 = w0mp09;
            peLcot( peLcotC ).w0mp10 = w0mp10;
            peLcot( peLcotC ).w0nrpp = w0nrpp;
            peLcot( peLcotC ).w0asen = w0asen;

            k1w003.w3empr = w0empr;
            k1w003.w3sucu = w0sucu;
            k1w003.w3nivt = w0nivt;
            k1w003.w3nivc = w0nivc;
            k1w003.w3nctw = w0nctw;
            k1w003.w3nase = 0;
            chain %kds(k1w003:6) ctw003;
            if %found;
               peLcot( peLcotC ).w0tido = w3tido;
               peLcot( peLcotC ).w0nrdo = w3nrdo;
               peLcot( peLcotC ).w0cuit = w3cuit;
               chain w3tido gnttdo;
               if %found;
                  peLcot( peLcotC ).w0datd = gndatd;
                  peLcot( peLcotC ).w0dtdo = gndtdo;
                else;
                  peLcot( peLcotC ).w0datd = *blanks;
                  peLcot( peLcotC ).w0dtdo = *blanks;
               endif;
             else;
               peLcot( peLcotC ).w0tido = 0;
               peLcot( peLcotC ).w0nrdo = 0;
               peLcot( peLcotC ).w0cuit = *blanks;
               peLcot( peLcotC ).w0datd = *blanks;
               peLcot( peLcotC ).w0dtdo = *blanks;
            endif;

            k1tloc.locopo = w0copo;
            k1tloc.locops = w0cops;
            chain %kds(k1tloc) gntloc;
            if %found;
               peLcot( peLcotC ).w0proc = loproc;
             else;
               peLcot( peLcotC ).w0proc = *blanks;
            endif;

            clear peImpu;
            COWRTV_getImpuestos( peBase
                               : w0nctw
                               : peImpu );
            for i = 1 to 99;
                if peImpu(i).rama <> 0;
                   peLcot( peLcotC ).w0prem += peImpu(i).prem;
                endif;
            endfor;

            exsr UltReg;

         endif;

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

      *- Rutina de Posicionamiento de Archivo. Segun peOrde, pePosi, peRoll
       begsr posArc;

         k0y000.w0empr = peBase.peEmpr;
         k0y000.w0sucu = peBase.peSucu;
         k0y000.w0nivt = peBase.peNivt;
         k0y000.w0nivc = peBase.peNivc;

         select;
           when ( peOrde = 'NUMEROCOTI' );
             k1y000.w0empr = peBase.peEmpr;
             k1y000.w0sucu = peBase.peSucu;
             k1y000.w0nivt = peBase.peNivt;
             k1y000.w0nivc = peBase.peNivc;
             if peposi.w0nctw <= 0;
                k1y000.w0nctw = 9999999;
              else;
                k1y000.w0nctw = pePosi.w0nctw;
             endif;
             if ( peRoll = 'F' );
               setgt %kds ( k1y000 : 5 ) ctw00011;
             else;
               setll %kds ( k1y000 : 5 ) ctw00011;
             endif;
           when ( peOrde = 'ASEGUFECHA' );
             k7w000.w0empr = peBase.peEmpr;
             k7w000.w0sucu = peBase.peSucu;
             k7w000.w0nivt = peBase.peNivt;
             k7w000.w0nivc = peBase.peNivc;
             k7w000.w0nomb = pePosi.w0nomb;
             k7w000.w0fctw = pePosi.w0fctw;
             k7w000.w0nctw = pePosi.w0nctw;
             if ( peRoll = 'F' );
               setll %kds ( k7w000 : 7 ) ctw00007;
             else;
               setgt %kds ( k7w000 : 7 ) ctw00007;
             endif;
           when ( peOrde = 'INTERFECHA' );
             k8w000.w0empr = peBase.peEmpr;
             k8w000.w0sucu = peBase.peSucu;
             k8w000.w0nivt = peBase.peNivt;
             k8w000.w0nivc = peBase.peNivc;
             k8w000.w0fctw = pePosi.w0fctw;
             k8w000.w0nctw = pePosi.w0nctw;
             if ( peRoll = 'F' );
               setgt %kds ( k8w000 : 6 ) ctw00008;
             else;
               setll %kds ( k8w000 : 6 ) ctw00008;
             endif;
         endsl;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

         select;
           when ( peOrde = 'NUMEROCOTI' );
             reade %kds ( k0y000 : 4 ) ctw00011;
           when ( peOrde = 'ASEGUFECHA' );
             readpe %kds ( k0y000 : 4 ) ctw00007;
           when ( peOrde = 'INTERFECHA' );
             reade %kds ( k0y000 : 4 ) ctw00008;
         endsl;

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;

         select;
           when ( peOrde = 'NUMEROCOTI' );
             readpe %kds ( k0y000 : 4 ) ctw00011;
           when ( peOrde = 'ASEGUFECHA' );
             reade %kds ( k0y000 : 4 ) ctw00007;
           when ( peOrde = 'INTERFECHA' );
             readpe %kds ( k0y000 : 4 ) ctw00008;
         endsl;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

         select;
           when ( peOrde = 'NUMEROCOTI' );
             setll %kds( k0y000 : 4 ) ctw00011;
           when ( peOrde = 'ASEGUFECHA' );
             setgt %kds( k0y000 : 4 ) ctw00007;
           when ( peOrde = 'INTERFECHA' );
             setll %kds( k0y000 : 4 ) ctw00008;
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

         pePreg.w0empr = w0empr;
         pePreg.w0sucu = w0sucu;
         pePreg.w0nivt = w0nivt;
         pePreg.w0nivc = w0nivc;
         pePreg.w0nctw = w0nctw;
         pePreg.w0nomb = w0nomb;
         pePreg.w0fctw = w0fctw;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

         peUreg.w0empr = w0empr;
         peUreg.w0sucu = w0sucu;
         peUreg.w0nivt = w0nivt;
         peUreg.w0nivc = w0nivc;
         peUreg.w0nctw = w0nctw;
         peUreg.w0fctw = w0fctw;
         peUreg.w0nomb = w0nomb;

       endsr;

      *- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

         select;
           when ( peOrde = 'NUMEROCOTI' );
             return %eof ( ctw00011 );
           when ( peOrde = 'ASEGUFECHA' );
             return %eof ( ctw00007 );
           when ( peOrde = 'INTERFECHA' );
             return %eof ( ctw00008 );
         endsl;

     P finArc          E
