     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLSUC : WebService - Retorna Sucursales de una Empresa.     *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                            19/11/2015    *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * ************************************************************ *
     Fgntsuc    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLSUC          pr                  ExtPgm('WSLSUC')
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keysuc_t) const
     D   pePreg                            likeds(keysuc_t)
     D   peUreg                            likeds(keysuc_t)
     D   peLsuc                            likeds(gntsuc_t) dim(99)
     D   peLsucC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLSUC          pi
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keysuc_t) const
     D   pePreg                            likeds(keysuc_t)
     D   peUreg                            likeds(keysuc_t)
     D   peLsuc                            likeds(gntsuc_t) dim(99)
     D   peLsucC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@Repl          s          65535a
     D @@Leng          s             10i 0
     D @@more          s               n

     D ksuc            ds                  likerec(g1tsuc:*key)

     D finArc          pr              n

     D @@cant          s             10i 0

       *inLr = *On;

       clear peLsuc;
       clear peLsucC;
       clear peErro;
       clear peMsgs;

       @@more = *On;

      *- Validaciones

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

       dow ( ( not finArc ) and ( peLsucC < @@cant ) );

         peLsucC += 1;

         peLsuc(peLsucC).susucu = susucu;
         peLsuc(peLsucC).sunsul = sunsul;
         peLsuc(peLsucC).sunsuc = sunsuc;

         exsr UltReg;

         exsr leeArc;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( gntsuc );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

      *- Rutina de Posicionamiento de Archivo. Segun pePosi, peRoll
       begsr posArc;

        ksuc.suempr = pePosi.empr;
        ksuc.susucu = pePosi.sucu;

       if ( peRoll = 'F' );
          setgt %kds ( ksuc : 2 ) gntsuc;
       else;
          setll %kds ( ksuc : 2 ) gntsuc;
       endif;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

       reade %kds(ksuc:1) gntsuc;

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;

       readpe %kds(ksuc:1) gntsuc;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

       setll %kds(ksuc:1) gntsuc;

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

       pePreg.empr = suempr;
       pePreg.sucu = susucu;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

       peUreg.empr = suempr;
       peUreg.sucu = susucu;

       endsr;

      *- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

       return %eof ( gntsuc );

     P finArc          E
