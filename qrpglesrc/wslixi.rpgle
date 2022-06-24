     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLIXI  : WebService - Retorna Intermediarios de un Interm.  *
      * ------------------------------------------------------------ *
      * CSz 28-Abr-2015                                              *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SFA 21/05/2015: Agrego COMA/NRMA y Nombre de intermediario.  *
      *                 Uso likeds en lugar de likerec.              *
      * SFA 17/07/2015 - Se modifica logica sobre peMore             *
      * SGF 04/10/2016: Hay que retornar siempre los dependientes del*
      *                 logueado. Estaba al revés.                   *
      * ************************************************************ *
     Fpahusu302 if   e           k disk
     Fsehni201  if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLIXI          pr                  ExtPgm('WSLIXI')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keyixi_t) const
     D   pePreg                            likeds(keyixi_t)
     D   peUreg                            likeds(keyixi_t)
     D   peLint                            likeds(pahusu3_t) dim(99)
     D   peLintC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLIXI          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keyixi_t) const
     D   pePreg                            likeds(keyixi_t)
     D   peUreg                            likeds(keyixi_t)
     D   peLint                            likeds(pahusu3_t) dim(99)
     D   peLintC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@nomb          s             40a
     D @@coma          s              2a
     D @@nrma          s              6  0

     D @@Repl          s          65535a
     D @@Leng          s             10i 0
     D @@cant          s             10i 0

     D @@more          s               n

     D k1yusu3         ds                  likerec(d1husu3  : *key)
     D k1yni2          ds                  likerec(s1hni201 : *key)

       *inLr   = *On;
       @@more  = *On;

       peErro  = *Zeros;
       peLintC = *Zeros;

       clear peLint;
       clear peErro;
       clear peMsgs;

      * Validaciones...
       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

       if not SVPWS_chkRoll ( peRoll : peMsgs );
         peErro = -1;
         return;
       endif;

       @@cant = peCant;
       if ( ( peCant <= *Zeros ) or ( peCant > 99 ) );
         @@cant = 99;
       endif;


      * Obtengo por unica vez los datos del intermediario de entrada
       k1yni2.n2empr = peBase.peEmpr;
       k1yni2.n2sucu = peBase.peSucu;
       k1yni2.n2nivt = peBase.peNit1;
       k1yni2.n2nivc = peBase.peNiv1;
       chain %kds( k1yni2 : 4 ) sehni201;

       @@nomb = dfnomb;
       @@coma = n2coma;
       @@nrma = n2nrma;

      * Datos de posicionamiento siempre desde pePosi
       k1yusu3.u3nivt = peBase.peNit1;
       k1yusu3.u3nivc = peBase.peNiv1;
       k1yusu3.u3nit1 = pePosi.u3nit1;
       k1yusu3.u3niv1 = pePosi.u3niv1;

       exsr posArc;

      * Si Retrocedo puede cambiar la cantidad por fin de archivo
       if ( peRoll = 'R' );
         readpe %kds( k1yusu3 : 2 ) pahusu302;
 b2      dow ( not %eof ( pahusu302 ) ) and ( @@cant > 0 );
           @@cant -= 1;
           readpe %kds( k1yusu3 : 2 ) pahusu302;
         enddo;
         if %eof ( pahusu302 );
           @@more = *Off;
           setll %kds ( k1yusu3 : 2 ) pahusu302;
         endif;
         @@cant = peCant;
       endif;

       reade %kds( k1yusu3 : 2 ) pahusu302;
       exsr priReg;

 b2    dow ( not %eof ( pahusu302 ) ) and ( peLintC < @@cant );

         peLintC += 1;

         peLint(peLintC).u3nit1 = peBase.peNit1;
         peLint(peLintC).u3niv1 = peBase.peNiv1;
         peLint(peLintC).u3nom1 = @@nomb;
         peLint(peLintC).u3com1 = @@coma;
         peLint(peLintC).u3nrm1 = @@nrma;

         peLint(peLintC).u3nivt = u3nit1;
         peLint(peLintC).u3nivc = u3niv1;

         k1yni2.n2empr = peBase.peEmpr;
         k1yni2.n2sucu = peBase.peSucu;
         k1yni2.n2nivt = u3nit1;
         k1yni2.n2nivc = u3niv1;
         chain %kds( k1yni2 : 4 ) sehni201;

         if %found ( sehni201 );
            peLint(peLintC).u3nomb = dfnomb;
            peLint(peLintC).u3coma = n2coma;
            peLint(peLintC).u3nrma = n2nrma;
          else;
            peLint(peLintC).u3nomb = *all'?';
            peLint(peLintC).u3coma = *blanks;
            peLint(peLintC).u3nrma = *zeros;
         endif;

         exsr UltReg;

         reade %kds( k1yusu3 : 2 ) pahusu302;

 e2    enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( pahusu302 );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

      *- Rutina de Posicionamiento -----------------------------------

       begsr posArc;

         select;
           when ( peRoll = 'F' );
             setgt %kds ( k1yusu3 ) pahusu302;
           other;
             setll %kds ( k1yusu3 ) pahusu302;
         endsl;

       endsr;

      *- Rutina de Primer Registro -----------------------------------

       begsr priReg;

         pePreg.u3nit1 = u3nit1;
         pePreg.u3niv1 = u3niv1;

       endsr;

      *- Rutina de Ultimo Registro -----------------------------------

       begsr ultReg;

         peUreg.u3nit1 = u3nit1;
         peUreg.u3niv1 = u3niv1;

       endsr;

