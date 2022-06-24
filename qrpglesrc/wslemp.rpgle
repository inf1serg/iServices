     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLEMP : WebService - Retorna Empresas.                      *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                            19/11/2015    *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * ************************************************************ *
     Fgntemp    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLEMP          pr                  ExtPgm('WSLEMP')
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keyemp_t) const
     D   pePreg                            likeds(keyemp_t)
     D   peUreg                            likeds(keyemp_t)
     D   peLemp                            likeds(gntemp_t) dim(99)
     D   peLempC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLEMP          pi
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keyemp_t) const
     D   pePreg                            likeds(keyemp_t)
     D   peUreg                            likeds(keyemp_t)
     D   peLemp                            likeds(gntemp_t) dim(99)
     D   peLempC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@Repl          s          65535a
     D @@Leng          s             10i 0
     D @@more          s               n

     D kemp            ds                  likerec(g1temp:*key)

     D finArc          pr              n

     D @@cant          s             10i 0

       *inLr = *On;

       clear peLemp;
       clear peLempC;
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

       dow ( ( not finArc ) and ( peLempC < @@cant ) );

         peLempC += 1;

         peLemp(peLempC).emempr = emempr;
         peLemp(peLempC).emneml = emneml;
         peLemp(peLempC).emnemc = emnemc;

         exsr UltReg;

         exsr leeArc;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( gntemp );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

      *- Rutina de Posicionamiento de Archivo. Segun pePosi, peRoll
       begsr posArc;

        kemp.emempr = pePosi.empr;

       if ( peRoll = 'F' );
          setgt %kds ( kemp : 1 ) gntemp;
       else;
          setll %kds ( kemp : 1 ) gntemp;
       endif;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

       read gntemp;

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;

       readp gntemp;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

       setll *start gntemp;

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

       pePreg.empr = emempr;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

       peUreg.empr = emempr;

       endsr;

      *- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

       return %eof ( gntemp );

     P finArc          E
