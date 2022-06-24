     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLAGE : WebService - Retorna lista de Agencias.             *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                            02/06/2015    *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SFA 17/07/2015 - Se modifica logica sobre peMore             *
      * ************************************************************ *
     Fsehnid    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLAGE          pr                  ExtPgm('WSLAGE')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keyage_t) const
     D   pePreg                            likeds(keyage_t)
     D   peUreg                            likeds(keyage_t)
     D   peLage                            likeds(sehnid_t) dim(99)
     D   peLageC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLAGE          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keyage_t) const
     D   pePreg                            likeds(keyage_t)
     D   peUreg                            likeds(keyage_t)
     D   peLage                            likeds(sehnid_t) dim(99)
     D   peLageC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@Repl          s          65535a
     D @@Leng          s             10i 0
     D @@more          s               n

     D khnid           ds                  likerec(d1hnid:*key)

     D agencias        ds                  likerec(d1hnid)

     D finArc          pr              n

     D @@cant          s             10i 0

       *inLr = *On;

       clear peLage;
       clear peLageC;
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

      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       exsr leeArc;

       exsr priReg;

       dow ( ( not finArc ) and ( peLageC < @@cant ) );

         peLageC += 1;

         peLage(peLageC).idnrag = agencias.idnrag;
         peLage(peLageC).idnoag = agencias.idnoag;
         peLage(peLageC).idbloq = agencias.idbloq;

         exsr UltReg;

         exsr leeArc;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( sehnid );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

      *- Rutina de Posicionamiento de Archivo. Segun pePosi, peRoll
       begsr posArc;

        khnid.idempr = peBase.peEmpr;
        khnid.idsucu = peBase.peSucu;
        khnid.idnrag = pePosi.idnrag;

       if ( peRoll = 'F' );
          setgt %kds ( khnid : 3 ) sehnid;
       else;
          setll %kds ( khnid : 3 ) sehnid;
       endif;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

       reade %kds ( khnid : 2 ) sehnid agencias;

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;

       readpe %kds ( khnid : 2 ) sehnid;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

       setll %kds ( khnid : 3 ) sehnid;

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

       pePreg.idnrag = agencias.idnrag;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

       peUreg.idnrag = agencias.idnrag;

       endsr;

      *- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

       return %eof ( sehnid );

     P finArc          E
