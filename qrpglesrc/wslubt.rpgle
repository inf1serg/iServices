     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLUBT  : Tareas generales.                                  *
      *           WebService - Retorna caracteristicas de ubicacion. *
      *                                                              *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                            *23-Abr-2015  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SFA 05/05/15 - Tomo descripcion de caracteristica del bien   *
      * INF1NORBER 28/05/2015 - Se modifica paginado y parms.        *
      * SFA 17/07/2015 - Se modifica logica sobre peMore             *
      * SGF 05/09/2016 - Sólo cargar las que aplican descuento.      *
      * JSN 28/06/2018 - Se agrega campo ma02, y se quita el filtro  *
      *                  de cargar las que aplican descuento.        *
      *                                                              *
      * ************************************************************ *
     Fpaher6    if   e           k disk
     Fpahed004  if   e           k disk
     Fpaher995  if   e           k disk
     Fset001    if   e           k disk    prefix(X_)
     Fset160    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLUBT          pr                  ExtPgm('WSLUBT')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keyubt_t) const
     D   pePreg                            likeds(keyubt_t)
     D   peUreg                            likeds(keyubt_t)
     D   peCubi                            likeds(pahrsvs6_t) dim(99)
     D   peCubiC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLUBT          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keyubt_t) const
     D   pePreg                            likeds(keyubt_t)
     D   peUreg                            likeds(keyubt_t)
     D   peCubi                            likeds(pahrsvs6_t) dim(99)
     D   peCubiC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khed004         ds                  likerec(p1hed004:*key)

     D kher995         ds                  likerec(p1her9:*key)

     D kher6           ds                  likerec(p1her6:*key)

     D kset160         ds                  likerec(s1t160:*key)

     D ubicacs         ds                  likerec(p1her6)

     D @@repl          s          65536
     D @@Leng          s             10i 0
     D @@cant          s             10i 0

     D @@more          s               n

       *inLr = *On;

       peCubiC = *Zeros;
       peErro  = *Zeros;

       @@more  = *On;

       clear peCubi;
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

      *- Valido Existe Poliza
       khed004.d0empr = peBase.peEmpr;
       khed004.d0sucu = peBase.peSucu;
       khed004.d0rama = pePosi.r6Rama;
       khed004.d0poli = pePosi.r6Poli;

       setll %kds ( khed004 : 4 ) pahed004;
       if not %equal ( pahed004 );
         @@Repl =   %editw ( pePosi.r6Rama  : '0 ' )
                +   %editw ( pePosi.r6Poli  : '0      ' );
         @@Leng = %len ( %trimr ( @@repl ) );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0009' :
                         peMsgs : @@Repl  : @@Leng );
         peErro = -1;
         return;
       endif;

      *- Valido Componente (recupero ultimo endoso)
       kher995.r9empr = peBase.peEmpr;
       kher995.r9sucu = peBase.peSucu;
       kher995.r9rama = pePosi.r6Rama;
       kher995.r9poli = pePosi.r6Poli;
       kher995.r9spol = pePosi.r6Spol;
       kher995.r9poco = pePosi.r6Poco;
       clear r9sspo;
       setgt  %kds ( kher995 : 6 ) paher995;
       readpe %kds ( kher995 : 6 ) paher995;
       if %eof ( paher995 );
         @@Repl =   %editw ( pePosi.r6Poco  : '0   ' )
                +   %editw ( pePosi.r6Rama  : '0 ' )
                +   %editw ( pePosi.r6Poli  : '0      ' );

         @@Leng = %len ( %trimr ( @@repl ) );

         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'BIE0001' :
                         peMsgs : @@Repl  : @@Leng );
         peErro = -1;
         return;
       endif;

      *- Valido Rama Riesgos Varios
       chain (pePosi.r6Rama) set001;
       if (X_t@rame = 4 or X_t@rame = 18 or X_t@rame = 21);
          @@repl =  %editC(pePosi.r6Rama:'4':*ASTFILL) +
                    %editC(pePosi.r6Poli:'4':*ASTFILL);
          @@leng = 9 ;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0003' :
                          peMsgs : @@repl  : @@leng );
         peErro = -1;
         return;
       endif;

      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       exsr leeArc;

       exsr priReg;

       dow ( ( not finArc ) and ( peCubiC < @@cant ) );

         peCubiC += 1;

         peCubi( peCubiC ).rsccba = ubicacs.r6ccba;
         peCubi( peCubiC ).rsmar1 = ubicacs.r6mar1;
         peCubi( peCubiC ).rsmar2 = ubicacs.r6ma01;

         clear t@dcba;
         kset160.t@empr = ubicacs.r6empr;
         kset160.t@sucu = ubicacs.r6sucu;
         kset160.t@rama = ubicacs.r6rama;
         kset160.t@ccba = ubicacs.r6ccba;
         chain %kds ( kset160 ) set160;
         peCubi( peCubiC ).rsdcba =t@dcba;

         exsr UltReg;

         exsr leeArc;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( paher6 );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

      *- Rutina de Posicionamiento de Archivo. Segun pePosi, peRoll
       begsr posArc;

       kher6.r6Empr = peBase.peEmpr;
       kher6.r6Sucu = peBase.peSucu;
       kher6.r6Arcd = r9arcd;
       kher6.r6Spol = pePosi.r6spol;
       kher6.r6Sspo = r9sspo;
       kher6.r6Rama = pePosi.r6Rama;
       kher6.r6Arse = r9arse;
       kher6.r6Oper = r9oper;
       kher6.r6Poco = pePosi.r6Poco;
       kher6.r6Suop = r9sspo;
       kher6.r6Ccba = pePosi.r6ccba;

       if ( peRoll = 'F' );
          setgt %kds ( kher6 : 11 ) paher6;
       else;
          setll %kds ( kher6 : 11 ) paher6;
       endif;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

       clear ubicacs;

       reade %kds ( kher6 : 10 ) paher6 ubicacs;

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;

       readpe %kds ( kher6 : 10 ) paher6;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

       setll %kds ( kher6 : 11 ) paher6;

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

       pePreg.r6arcd = ubicacs.r6arcd;
       pePreg.r6spol = ubicacs.r6spol;
       pePreg.r6sspo = ubicacs.r6sspo;
       pePreg.r6rama = ubicacs.r6rama;
       pePreg.r6poli = ubicacs.r6poli;
       pePreg.r6arse = ubicacs.r6arse;
       pePreg.r6oper = ubicacs.r6oper;
       pePreg.r6poco = ubicacs.r6poco;
       pePreg.r6suop = ubicacs.r6suop;
       pePreg.r6ccba = ubicacs.r6ccba;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

       peUreg.r6arcd = ubicacs.r6arcd;
       peUreg.r6spol = ubicacs.r6spol;
       peUreg.r6sspo = ubicacs.r6sspo;
       peUreg.r6rama = ubicacs.r6rama;
       peUreg.r6poli = ubicacs.r6poli;
       peUreg.r6arse = ubicacs.r6arse;
       peUreg.r6oper = ubicacs.r6oper;
       peUreg.r6poco = ubicacs.r6poco;
       peUreg.r6suop = ubicacs.r6suop;
       peUreg.r6ccba = ubicacs.r6ccba;

       endsr;

      *- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

       return %eof ( paher6 );

     P finArc          E
