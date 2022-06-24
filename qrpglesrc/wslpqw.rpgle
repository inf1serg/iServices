     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLPQW  : WebService - Retorna lista de Preliquidaciones.    *
      * ------------------------------------------------------------ *
      * JSN 01-Feb-2016                                              *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fpahpqc05  if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/spvfec_h.rpgle'

     D WSLPQW          pr                  ExtPgm('WSLPQW')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keypqw_t) const
     D   pePreg                            likeds(keypqw_t)
     D   peUreg                            likeds(keypqw_t)
     D   peLint                            likeds(pahpqc5_t) dim(99)
     D   peLintC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLPQW          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keypqw_t) const
     D   pePreg                            likeds(keypqw_t)
     D   peUreg                            likeds(keypqw_t)
     D   peLint                            likeds(pahpqc5_t) dim(99)
     D   peLintC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@nomb          s             40a
     D @@coma          s              2a
     D @@nrma          s              6  0
     D @@dtip          s             40a
     D @@fech          s              8  0
     D @@fdes          s              8  0
     D @@fhas          s              8  0

     D @@Repl          s          65535a
     D @@Leng          s             10i 0
     D @@cant          s             10i 0

     D @@more          s               n

     D k1ypqc5         ds                  likerec( p1hpqc05 : *key)

       *inLr   = *On;
       @@more  = *On;

       peErro  = *Zeros;
       peLintC = *Zeros;
       peMore  = *Off;

       clear peLint;
       clear peErro;
       clear peMsgs;
       clear pePreg;
       clear peUreg;


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

      * Datos de posicionamiento siempre desde pePosi
       k1ypqc5.qcEmpr = peBase.peEmpr;
       k1ypqc5.qcSucu = peBase.peSucu;
       k1ypqc5.qcNivt = peBase.peNivt;
       k1ypqc5.qcNivc = peBase.peNivc;

       if pePosi.qcFech > 0;
         k1ypqc5.qcFech = pePosi.qcFech;
       else;
         k1ypqc5.qcFech = *hival;
       endif;

       k1ypqc5.qcNrpl = pePosi.qcNrpl;

       exsr posArc;

      * Si Retrocedo puede cambiar la cantidad por fin de archivo
       if ( peRoll = 'R' );
         readpe %kds( k1ypqc5 : 4 ) pahpqc05;
 b2      dow ( not %eof ( pahpqc05 ) ) and ( @@cant > 0 );
           @@cant -= 1;
           readpe %kds( k1ypqc5 : 4 ) pahpqc05;
         enddo;
         if %eof ( pahpqc05 );
           @@more = *Off;
           setll %kds ( k1ypqc5 : 4 ) pahpqc05;
         endif;
         @@cant = peCant;
       endif;

       reade %kds( k1ypqc5 : 4 ) pahpqc05;
       exsr priReg;

 b2    dow ( not %eof ( pahpqc05 ) ) and ( peLintC < @@cant );

         peLintC += 1;

         peLint(peLintC).qcEmpr = peBase.peEmpr;
         peLint(peLintC).qcSucu = peBase.peSucu;
         peLint(peLintC).qcNivt = peBase.peNivt;
         peLint(peLintC).qcNivc = peBase.peNivc;
         peLint(peLintC).qcNrpl = qcNrpl;

         peLint(peLintC).qcFech = qcFech;
         peLint(peLintC).qcFdes = qcFdes;
         peLint(peLintC).qcFhas = qcFhas;

         peLint(peLintC).qcImpb = qcImpb;
         peLint(peLintC).qcImpn = qcImpn;
         peLint(peLintC).qcMarp = qcMarp;
         peLint(peLintC).qeDEst = qeNomb;
         peLint(peLintC).qcTipo = qcTipo;

         select;
           When qcTipo = 'PB';
             @@dtip = 'PAGO BRUTO';
           When qcTipo = 'PN';
             @@dtip = 'PAGO NETO';
           When qcTipo = *BLANKS;
             @@dtip = 'NO DEFINIDO';
         endsl;

         peLint(peLintC).DTip   = @@dtip;
         peLint(peLintC).qcFera = qcFera;
         peLint(peLintC).qcFerm = qcFerm;
         peLint(peLintC).qcFerd = qcFerd;
         peLint(peLintC).qcTime = qcTime;

         @@Fech = SPVFEC_GiroFecha8 ( qcFech : 'DMA' );
         @@Fdes = SPVFEC_GiroFecha8 ( qcFdes : 'DMA' );
         @@Fhas = SPVFEC_GiroFecha8 ( qcFhas : 'DMA' );

         peLint(peLintC).FechTxt = %editw(@@Fech:'  /  /    ') ;
         peLint(peLintC).FdesTxt = %editw(@@Fdes:'  /  /    ') ;
         peLint(peLintC).FhasTxt = %editw(@@Fhas:'  /  /    ') ;

         peLint(peLintC).Impbn   = qcImpb - qcImpn;

         exsr UltReg;

         reade %kds( k1ypqc5 : 4 ) pahpqc05;

 e2    enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( pahpqc05 );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

      *- Rutina de Posicionamiento -----------------------------------

       begsr posArc;

         select;
           when ( peRoll = 'F' );
             setgt %kds ( k1ypqc5 : 6 ) pahpqc05;
           when ( peRoll = 'I' );
             setll %kds ( k1ypqc5 : 5 ) pahpqc05;
           when ( peRoll = 'R' );
             setll %kds ( k1ypqc5 : 5 ) pahpqc05;
         endsl;

       endsr;

      *- Rutina de Primer Registro -----------------------------------

       begsr priReg;

         pePreg.qcFech = qcFech;
         pePreg.qcNrpl = qcNrpl;

       endsr;

      *- Rutina de Ultimo Registro -----------------------------------

       begsr ultReg;

         peUreg.qcFech = qcFech;
         peUreg.qcNrpl = qcNrpl;

       endsr;

