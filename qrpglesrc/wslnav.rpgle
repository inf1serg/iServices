     H*option(*nodebugio:*noshowcpy:*srcstmt)
     H option(*nodebugio:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************** *
      * WSLNAV : WebService - Retorna Lista de Asegurados de Vida.     *
      * -------------------------------------------------------------- *
      * CSz 28/04/2015 - Creacion del programa                         *
      * -------------------------------------------------------------- *
      * Modificaciones:                                                *
      * SFA 28/05/15 - Agrego Paginado y datos desde GAUS              *
      * rdv 03/07/15 -                                                 *
      * SFA 17/07/2015 - Se modifica logica sobre peMore               *
      * SFA 13/07/2016 - Se modifica PAHEV095 por PAHEV094             *
      * SGF 06/09/2016 - Sólo cargar activos.                          *
      * SPV 24/09/2020 - incorpora copy a wsstruc_h actualizado        *
      *                                                                *
      * ************************************************************** *
     Fpahev094  if   e           k disk
     Fpahev102  if   e           k disk
     Fpahed004  if   e           k disk
     Fset001    if   e           k disk
     Fset102    if   e           k disk
     Fgnttdo    if   e           k disk
     Fpahnx1    if   e           k disk

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'

     D WSLNAV          pr                  ExtPgm('WSLNAV')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keynav_t) const
     D   pePreg                            likeds(keynav_t)
     D   peUreg                            likeds(keynav_t)
     D   peNasv                            likeds(pahvid0_t) dim(99)
     D   peNasvC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLNAV          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keynav_t) const
     D   pePreg                            likeds(keynav_t)
     D   peUreg                            likeds(keynav_t)
     D   peNasv                            likeds(pahvid0_t) dim(99)
     D   peNasvC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSXNEX          pr                  ExtPgm('WSXNEX')
     D   xeEmpr                       1    const
     D   xeSucu                       2    const
     D   xeRama                       2  0 const
     D   xePoli                       7  0 const
     D   xeSpol                       9  0 const
     D   xeNomi                       7  0

     D @@Repl          s          65535a
     D @@Leng          s             10i 0
     D @@cant          s             10i 0
     D coNnomi         s              1  0
     D wwisok          s              2
     D xeEmpr          s              1
     D xeSucu          s              2
     D xeRama          s              2  0
     D xePoli          s              7  0
     D xeSpol          s              9  0
     D xeNomi          s              7  0

     D @@more          s               n

     D k1yev0          ds                  likeRec ( p1hev0   : *Key )
     D k1yev1          ds                  likeRec ( p1hev102 : *Key )
     D k1yed0          ds                  likeRec ( p1hed004 : *Key )
     D k1y102          ds                  likeRec ( s1t102   : *Key )
     D k1hnx1          ds                  likeRec ( p1hnx1   : *Key )

       *inLr = *On;
       @@more = *On;

       peErro = *Zeros;
       peNasvC= *Zeros;
       coNnomi= *Zero;

       clear peNasv;
       clear peMsgs;
       clear pePreg;
       clear peUreg;
       clear wwisok;

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

      *- Valido Poliza de Vida
       chain pePosi.v0rama set001;
       if ( t@rame <> 18 ) and ( t@rame <> 21 );
         @@Repl = %editw( pePosi.v0Rama : '0 ' )
                + %editw( pePosi.v0poli : '     0 ' );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0003'
                       : peMsgs  : @@Repl  : @@Leng );
         peErro = -1;
         return;
       endif;

      *- Valido Poliza existente

       k1yed0.d0empr = peBase.peEmpr;
       k1yed0.d0sucu = peBase.peSucu;
       k1yed0.d0rama = pePosi.v0rama;
       k1yed0.d0poli = pePosi.v0poli;

       chain %kds ( k1yed0 : 4 ) pahed004;
       if not %found ( pahed004 );
         @@Repl = %editw( pePosi.v0Rama : '0 ' )
                + %editw( pePosi.v0poli : '     0 ' );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0009'
                       : peMsgs  : @@Repl  : @@Leng );
         peErro = -1;
         return;
       endif;

      *- Valido existencia del componente.

      *- Posicionamiento para saber si la poliza tiene nomina externa.
       exsr posNom;

      *- Posicionamiento en archivo

       if coNnomi = 2;
        exsr posArc1;
        exsr retPag1;
        exsr leoPah;
       else;
        exsr posArc;
       endif;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       reade %kds ( k1yev0 : 8 ) pahev094;

       dow ( not %eof ( pahev094 ) ) and ( peNasvC < @@cant );

       if v0aegn = 0;

         peNasvC += 1;

        if peNasvC = 1;
         exsr priReg;
        endif;

      *- Tomo datos de PAHNX1, porque tiene nomina externa.

        if coNnomi = 2;
          exsr leoPah;
        else;

         peNasv( peNasvC ).vdcert = v0cert;
         peNasv( peNasvC ).vdarcd = v0arcd;
         peNasv( peNasvC ).vdarse = v0arse;
         peNasv( peNasvC ).vdoper = v0oper;
         peNasv( peNasvC ).vdnomb = v0nomb;
         peNasv( peNasvC ).vdtido = v0tido;
         peNasv( peNasvC ).vdpoco = v0poco;
         peNasv( peNasvC ).vdpaco = v0paco;
         peNasv( peNasvC ).vdnaci = v0naci;
         peNasv( peNasvC ).vdacti = v0acti;
         peNasv( peNasvC ).vdcate = v0cate;

      *- Tomo datos de GNTTDO
         chain v0tido gnttdo;
         if %found ( gnttdo );
           peNasv( peNasvC ).vddatd = gndatd;
         else;
           peNasv( peNasvC ).vddatd = *Blanks;
         endif;

         peNasv( peNasvC ).vdnrdo = v0nrdo;

         monitor;
           peNasv( peNasvC ).vdfnac = %date( v0fnaa * 10000 + v0fnam * 100 +
                                             v0fnad : *iso);
         on-error;
           peNasv( peNasvC ).vdfnac = %date( 00010101 : *iso );
         endmon;

         k1yev1.v1empr = peBase.peEmpr;
         k1yev1.v1sucu = peBase.peSucu;
         k1yev1.v1arcd = v0arcd;
         k1yev1.v1spol = v0spol;
         k1yev1.v1rama = v0rama;
         k1yev1.v1arse = v0arse;
         k1yev1.v1oper = v0oper;
         k1yev1.v1poco = 1;
         k1yev1.v1paco = 1;
         setll %kds ( k1yev1 : 9 ) pahev102;
         reade %kds ( k1yev1 : 9 ) pahev102;

         if %found ( pahev102 );
           peNasv( peNasvC ).vdxpro = v1xpro;

           peNasv( peNasvC ).vdsuas = v1suas;

           peNasv( peNasvC ).vdsamo = v1samo;
           k1y102.t@rama = v1rama;
           k1y102.t@xpro = v1xpro;
           chain %kds ( k1y102 ) set102;
           if %found ( set102 );
             peNasv( peNasvC ).vdprds = t@prds;
           else;
             peNasv( peNasvC ).vdprds = *blanks;
           endif;
         else;
           peNasv( peNasvC ).vdxpro = *Zeros;
           peNasv( peNasvC ).vdsuas = *Zeros;
           peNasv( peNasvC ).vdsamo = *Zeros;
           peNasv( peNasvC ).vdprds = *Blanks;
         endif;

           peNasv( peNasvC ).vdsuin = v0suin;
           peNasv( peNasvC ).vdainn = v0ainn;
           peNasv( peNasvC ).vdminn = v0minn;
           peNasv( peNasvC ).vddinn = v0dinn;
           peNasv( peNasvC ).vdsuen = v0suen;
           peNasv( peNasvC ).vdaegn = v0aegn;
           peNasv( peNasvC ).vdmegn = v0megn;
           peNasv( peNasvC ).vddegn = v0degn;
         endif;

         exsr UltReg;

         endif;

         reade %kds ( k1yev0 : 8 ) pahev094;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( pahev094 );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

      *- Rutina de Posicionamiento de Archivo. Segun pePosi, peRoll
       begsr posArc;

         k1yev0.v0empr = peBase.peEmpr;
         k1yev0.v0sucu = peBase.peSucu;
         k1yev0.v0rama = pePosi.v0rama;
         k1yev0.v0poli = pePosi.v0poli;
         k1yev0.v0arcd = d0arcd;
         k1yev0.v0spol = pePosi.v0spol;
         k1yev0.v0arse = 1;
         k1yev0.v0oper = d0oper;
         k1yev0.v0poco = pePosi.v0poco;
         k1yev0.v0paco = pePosi.v0paco;

         if ( peRoll = 'F' );
           setgt %kds ( k1yev0 ) pahev094;
         else;
           setll %kds ( k1yev0 ) pahev094;
         endif;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr retPag;

         if ( peRoll = 'R' );
           readpe %kds ( k1yev0 : 8 ) pahev094;
           dow ( ( not %eof ( pahev094 ) ) and ( @@cant > 0 ) );
             @@cant -= 1;
             readpe %kds ( k1yev0 : 8 ) pahev094;
           enddo;
           if ( %eof ( pahev094 ) );
             @@more = *Off;
             setll %kds ( k1yev0 : 8 ) pahev094;
           endif;
           @@cant = peCant;
           if (@@cant <= 0 or @@cant > 99);
              @@cant = 99;
           endif;
         endif;

       endsr;


      *- Rutina de Posicionamiento de Archivo. Segun pePosi, peRoll
       begsr posArc1;

         k1hnx1.n1Empr = peBase.peEmpr;
         k1hnx1.n1Sucu = peBase.peSucu;
         k1hnx1.n1Nomi = xeNomi;
         k1hnx1.n1Poco = pePosi.v0poco;

         select;
          when peRoll = 'F';
           setgt %kds ( k1hnx1 : 4 ) pahnx1;
          when peRoll = 'I';
           setll %kds ( k1hnx1 : 3 ) pahnx1;
          when peRoll = 'R';
           setll %kds ( k1hnx1 : 4 ) pahnx1;
         endsl;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr retPag1;

       k1hnx1.n1Empr = d0Empr;
       k1hnx1.n1Sucu = d0Sucu;
       k1hnx1.n1nomi = xeNomi;
       k1hnx1.n1Poco = pePosi.v0Poco;

         if ( peRoll = 'R' );
           readpe %kds ( k1hnx1 : 3 ) pahnx1;
           dow ( ( not %eof ( pahnx1 ) ) and ( @@cant > 0 ) );
             @@cant -= 1;
             readpe %kds ( k1hnx1 : 3 ) pahnx1;
           enddo;
           if ( %eof ( pahnx1 ) );
             @@more = *Off;
             setll %kds ( k1hnx1 : 3 ) pahnx1;
           endif;
           @@cant = peCant;
           if (@@cant <= 0 or @@cant > 99);
              @@cant = 99;
           endif;
         endif;

       endsr;

      *- Rutina que graba el Primer Registro
       begsr priReg;

         if coNnomi <> 2;
          pePreg.v0rama = v0rama;
          pePreg.v0poli = v0poli;
          pePreg.v0spol = v0spol;
          pePreg.v0poco = v0poco;
          pePreg.v0paco = v0paco;
         else;
          pePreg.v0rama = n1rama;
          pePreg.v0poli = n1poli;
          pePreg.v0spol = n1spol;
          pePreg.v0poco = n1poco;
          pePreg.v0paco = 1;
         endif;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

         if coNnomi <> 2;
          peUreg.v0rama = v0rama;
          peUreg.v0poli = v0poli;
          peUreg.v0spol = v0spol;
          peUreg.v0poco = v0poco;
          peUreg.v0paco = v0paco;
         else;
          peUreg.v0rama = n1rama;
          peUreg.v0poli = n1poli;
          peUreg.v0spol = n1spol;
          peUreg.v0poco = n1poco;
         endif;

       endsr;

      *- Rutina que verifica si tiene nomina externa.
       begsr posNom;

         xeEmpr = d0Empr;
         xeSucu = d0Sucu;
         xeRama = d0Rama;
         xePoli = d0Poli;
         xeSpol = d0Spol;
         xeNomi = *zeros;

                  WSXNEX (xeEmpr:
                          xeSucu:
                          xeRama:
                          xePoli:
                          xeSpol:
                          xeNomi);

         if ( xeNomi >  0 );
           coNnomi = 2;
         endif;

       endsr;


      *- Rutina que extrae datos si tiene nomina externa.
       begsr leoPah;

       reade %kds ( k1hnx1 : 3 ) pahnx1;

       dow ( not %eof ( pahnx1 ) ) and ( peNasvC < @@cant );

       if n1aegn = 0;

         peNasvC += 1;

        if peNasvC = 1;
         exsr priReg;
        endif;

         peNasv( peNasvC ).vdcert = n1cert;
         peNasv( peNasvC ).vdarcd = n1arcd;
         peNasv( peNasvC ).vdarse = n1arse;
         peNasv( peNasvC ).vdoper = n1oper;
         peNasv( peNasvC ).vdnomb = n1nomb;
         peNasv( peNasvC ).vdtido = n1tido;
         peNasv( peNasvC ).vdpoco = n1poco;
         peNasv( peNasvC ).vdpaco = 1;
         peNasv( peNasvC ).vdnaci = *Blanks;
         peNasv( peNasvC ).vdacti = *Zeros;
         peNasv( peNasvC ).vdcate = *Zeros;

      *- Tomo datos de GNTTDO
         chain n1tido gnttdo;
         if %found ( gnttdo );
           peNasv( peNasvC ).vddatd = gndatd;
         else;
           peNasv( peNasvC ).vddatd = *Blanks;
         endif;

         peNasv( peNasvC ).vdnrdo = n1nrdo;

         monitor;
           peNasv( peNasvC ).vdfnac = %date( n1fnaa * 10000 + n1fnam * 100 +
                                             n1fnad : *iso);
         on-error;
           peNasv( peNasvC ).vdfnac = %date( 00010101 : *iso );
         endmon;

         k1yev1.v1empr = peBase.peEmpr;
         k1yev1.v1sucu = peBase.peSucu;
         k1yev1.v1arcd = n1arcd;
         k1yev1.v1spol = n1spol;
         k1yev1.v1rama = n1rama;
         k1yev1.v1arse = n1arse;
         k1yev1.v1oper = n1oper;
         k1yev1.v1poco = n1poco;
         k1yev1.v1paco = 1;
         setll %kds ( k1yev1 : 9 ) pahev102;
         reade %kds ( k1yev1 : 9 ) pahev102;

         if %found ( pahev102 );
           peNasv( peNasvC ).vdxpro = v1xpro;
           peNasv( peNasvC ).vdsuas = n1suas;
           peNasv( peNasvC ).vdsamo = v1samo;
           k1y102.t@rama = v1rama;
           k1y102.t@xpro = v1xpro;
           chain %kds ( k1y102 ) set102;
           if %found ( set102 );
             peNasv( peNasvC ).vdprds = t@prds;
           else;
             peNasv( peNasvC ).vdprds = *blanks;
           endif;
         else;
           peNasv( peNasvC ).vdxpro = *Zeros;
           peNasv( peNasvC ).vdsuas = *Zeros;
           peNasv( peNasvC ).vdsamo = *Zeros;
           peNasv( peNasvC ).vdprds = *Blanks;
         endif;

           peNasv( peNasvC ).vdsuin = n1suin;
           peNasv( peNasvC ).vdainn = n1ainn;
           peNasv( peNasvC ).vdminn = n1minn;
           peNasv( peNasvC ).vddinn = n1dinn;
           peNasv( peNasvC ).vdsuen = n1suen;
           peNasv( peNasvC ).vdaegn = n1aegn;
           peNasv( peNasvC ).vdmegn = n1megn;
           peNasv( peNasvC ).vddegn = n1degn;
           peNasv( peNasvC ).vdsuin = n1suin;

         exsr UltReg;

       endif;

       reade %kds ( k1hnx1 : 3 ) pahnx1;

       enddo;

       if ( peRoll = 'R' );
         peMore = @@more;
       else;
         peMore = not %eof ( pahnx1 );
       endif;

       return;

       endsr;

