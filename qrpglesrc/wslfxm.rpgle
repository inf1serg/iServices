     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLFXM : WebService - Retorna lista de Facturas de un Mr.Aux *
      * ------------------------------------------------------------ *
      * CSz 28-Abr-2015                                              *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * INF1NORBER 02/06/2015 - Se modifica parms. y paginado.       *
      * SFA 17/07/2015 - Se modifica logica sobre peMore             *
      * ************************************************************ *
     Fpahiva03  if   e           k disk
     Fcntnau    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLFXM          pr                  ExtPgm('WSLFXM')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keyfxm_t) const
     D   pePreg                            likeds(keyfxm_t)
     D   peUreg                            likeds(keyfxm_t)
     D   peLfcp                            likeds(pahiva03_t) dim(99)
     D   peLfcpC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLFXM          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keyfxm_t) const
     D   pePreg                            likeds(keyfxm_t)
     D   peUreg                            likeds(keyfxm_t)
     D   peLfcp                            likeds(pahiva03_t) dim(99)
     D   peLfcpC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@MsgI          s              7a
     D @@Repl          s          65535a
     D @@Leng          s             10i 0
     D @@more          s               n

     D k1yfxm          ds                  likerec(c1tnau:*key)
     D inFxm           ds                  likerec(p1hiva03:*input)
     D k1yiva3         ds                  likerec(p1hiva03:*key)

     D finArc          pr              n

     D @@cant          s             10i 0

     D                 ds
     D pfamd                          8s 0
     D   pfaa                         4s 0 overlay(pfamd:1)
     d   pfmm                         2s 0 overlay(pfamd:*next)
     d   pfdd                         2s 0 overlay(pfamd:*next)

       *inLr = *On;

       clear peLfcp;
       clear peLfcpC;
       clear peErro;
       clear peMsgs;
       clear @@MsgI;

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

       k1yfxm.naempr = peBase.peEmpr;
       k1yfxm.nasucu = peBase.peSucu;
       k1yfxm.nacoma = pePosi.ivcoma;
       k1yfxm.nanrma = pePosi.ivnrma;
       chain %kds ( k1yfxm ) cntnau;
       if not %found ( cntnau );
          @@MsgI = 'MAY0001';
          @@Repl = ( pePosi.ivcoma )
                 + %editw ( pePosi.ivnrma : '     0 ' );

 e4    endif;

 b1    if @@MsgI <> *blank;
          @@Leng = %len ( %trimr ( @@Repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': @@MsgI :
                          peMsgs  : @@Repl  : @@Leng );
          eval peErro = -1;
          return;
 e1    endif;

      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       exsr leeArc;

       exsr priReg;

       dow ( ( not finArc ) and ( peLfcpC < @@cant ) );

         peLfcpC += 1;

         pfaa = inFxm.ivfe1a;
         pfmm = inFxm.ivfe1m;
         pfdd = inFxm.ivfe1d;
         peLfcp(peLfcpC).ivfech = %date(pfamd:*iso);
         peLfcp(peLfcpC).ivigra = inFxm.ivigra;
         peLfcp(peLfcpC).iviiva = inFxm.iviiva;
         peLfcp(peLfcpC).ivitot = inFxm.ivitot;
         peLfcp(peLfcpC).iviret = inFxm.iviret;

         exsr UltReg;

         exsr leeArc;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( pahiva03 );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

      *- Rutina de Posicionamiento de Archivo. Segun pePosi, peRoll
       begsr posArc;

       k1yiva3.ivempr = peBase.peEmpr;
       k1yiva3.ivsucu = peBase.peSucu;
       k1yiva3.ivcoma = pePosi.ivcoma;
       k1yiva3.ivnrma = pePosi.ivnrma;
       k1yiva3.ivFe1a = pePosi.ivfe1a;
       k1yiva3.ivFe1m = pePosi.ivfe1m;
       k1yiva3.ivFe1d = pePosi.ivfe1d;
       k1yiva3.ivC4s2 = pePosi.ivc4s2;

       if ( peRoll = 'F' );
          setgt %kds ( k1yiva3 : 8 ) pahiva03;
       else;
          setll %kds ( k1yiva3 : 8 ) pahiva03;
       endif;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

       reade %kds ( k1yiva3 : 4 ) pahiva03 inFxm;
         if %eof;
            clear inFxm;
         endif;

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;

       readpe %kds ( k1yiva3 : 4 ) pahiva03;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

       setll %kds ( k1yiva3 : 4 ) pahiva03;

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

       pePreg.ivcoma = inFxm.ivcoma;
       pePreg.ivnrma = inFxm.ivnrma;
       pePreg.ivfe1a = inFxm.ivfe1a;
       pePreg.ivfe1m = inFxm.ivfe1m;
       pePreg.ivfe1d = inFxm.ivfe1d;
       pePreg.ivc4s2 = inFxm.ivc4s2;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

       peUreg.ivcoma = inFxm.ivcoma;
       peUreg.ivnrma = inFxm.ivnrma;
       peUreg.ivfe1a = inFxm.ivfe1a;
       peUreg.ivfe1m = inFxm.ivfe1m;
       peUreg.ivfe1d = inFxm.ivfe1d;
       peUreg.ivc4s2 = inFxm.ivc4s2;

       endsr;

      *- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

       return %eof ( pahiva03 );

     P finArc          E
