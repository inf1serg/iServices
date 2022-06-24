     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLSXP  : Tareas generales.                                  *
      * WebService: Retorna Siniestros de una Poliza.                *
      *                                                              *
      *                                                              *
      * ------------------------------------------------------------ *
      * Ruben Dario Vinent                             *29-May-2015  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SFA 29/05/2015 - Agrego paginado                             *
      * SFA 17/07/2015 - Se modifica logica sobre peMore             *
      * NWN 21/05/2019 - Subo el nivel de la condición de CDSINI > 0 *
      *                  Lectura del PAHSCD03.                       *
      * ************************************************************ *
     Fpahscd03  if   e           k disk
     Fpahed004  if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLSXP          pr                  ExtPgm('WSLSXP')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keysxp_t) const
     D   pePreg                            likeds(keysxp_t)
     D   peUreg                            likeds(keysxp_t)
     D   peLsin                            likeds(pahstro_t) dim(99)
     D   peLsinC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLSXP          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keysxp_t) const
     D   pePreg                            likeds(keysxp_t)
     D   peUreg                            likeds(keysxp_t)
     D   peLsin                            likeds(pahstro_t) dim(99)
     D   peLsinC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSXSIN          pr                  ExtPgm('WSXSIN')
     D   empr                         1    const
     D   sucu                         2    const
     D   rama                         2  0 const
     D   sini                         7  0 const
     D   nops                         7  0 const
     D   dssi                              likeds( pahstro_t )

     D k1hscd          ds                  likerec(p1hscd03 : *key)

     D khed004         ds                  likerec(p1hed004 : *key)

     D x               s             10i 0
     D fech            s              8  0

     D siniestro       ds                  likeds(pahstro_t)

     D @@cant          s             10i 0
     D @@repl          s          65535a
     D @@leng          s             10i 0
     D cdfden          s              8  0

     D @@more          s               n

      *start = %timestamp();

       *inLr = *On;
       @@more = *On;

       peLsinC = *Zeros;
       peErro  = *Zeros;

       clear peLsin;
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
      *
      *- Valido si existe la poliza en pahed004 *
      *
       exsr verPol;

      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       exsr leeArc;

       dow ( not %eof ( pahscd03 ) ) and ( peLsinC < 99 );

      * Siempre y cuando tenga numero de siniestro

       if ( cdsini > 0 );

      * ejecuto wsxsin

        WSXSIN(
         peBase.peEmpr:
         peBase.peSucu:
         cdrama:
         cdsini:
         cdnops:
         siniestro);


         pelsinc += 1;

       if pelsinc = 1;
         exsr priReg;
       endif;

         cdfden = (cdfdea * 10000)
                + (cdfdem *   100)
                +  cdfded;
         monitor;
            siniestro.stfden = %date(cdfden:*iso);
          on-error;
            siniestro.stfden = %date(00010101:*iso);
        endmon;

         peLsin(peLsinC).stempr    = siniestro.stempr;
         peLsin(peLsinC).stsucu    = siniestro.stsucu;
         peLsin(peLsinC).stnivt    = siniestro.stnivt;
         peLsin(peLsinC).stnivc    = siniestro.stnivc;
         peLsin(peLsinC).strama    = siniestro.strama;
         peLsin(peLsinC).stsini    = siniestro.stsini;
         peLsin(peLsinC).stpoli    = siniestro.stpoli;
         peLsin(peLsinC).stcert    = siniestro.stcert;
         peLsin(peLsinC).starcd    = siniestro.starcd;
         peLsin(peLsinC).stspol    = siniestro.stspol;
         peLsin(peLsinC).starse    = siniestro.starse;
         peLsin(peLsinC).stoper    = siniestro.stoper;
         peLsin(peLsinC).stramd    = siniestro.stramd;
         peLsin(peLsinC).stramb    = siniestro.stramb;
         peLsin(peLsinC).stasen    = siniestro.stasen;
         peLsin(peLsinC).stasno    = siniestro.stasno;
         peLsin(peLsinC).sttido    = siniestro.sttido;
         peLsin(peLsinC).stdatd    = siniestro.stdatd;
         peLsin(peLsinC).stnrdo    = siniestro.stnrdo;
         peLsin(peLsinC).stcuit    = siniestro.stcuit;
         peLsin(peLsinC).stfsin    = siniestro.stfsin;
         peLsin(peLsinC).stfden    = siniestro.stfden;
         peLsin(peLsinC).stbiensin = siniestro.stbiensin;
         peLsin(peLsinC).stcesi    = siniestro.stcesi;
         peLsin(peLsinC).stfecest  = siniestro.stfecest;
         peLsin(peLsinC).stdesi    = siniestro.stdesi;
         peLsin(peLsinC).stjuic    = siniestro.stjuic;
         peLsin(peLsinC).stmar1    = siniestro.stmar1;
         peLsin(peLsinC).stmar2    = siniestro.stmar2;
         peLsin(peLsinC).stmar3    = siniestro.stmar3;
         peLsin(peLsinC).stmar4    = siniestro.stmar4;
         peLsin(peLsinC).stmar5    = siniestro.stmar5;
         peLsin(peLsinC).stmar6    = siniestro.stmar6;
         peLsin(peLsinC).stmar7    = siniestro.stmar7;
         peLsin(peLsinC).stmar8    = siniestro.stmar8;
         peLsin(peLsinC).stmar9    = siniestro.stmar9;
         peLsin(peLsinC).stcauc    = siniestro.stcauc;
         peLsin(peLsinC).stcaud    = siniestro.stcaud;
         peLsin(peLsinC).stpatente = siniestro.stpatente;
         peLsin(peLsinC).stts20    = siniestro.stts20;
         peLsin(peLsinC).stcopo    = siniestro.stcopo;
         peLsin(peLsinC).stcops    = siniestro.stcops;
         peLsin(peLsinC).stloca    = siniestro.stloca;
         peLsin(peLsinC).stproc    = siniestro.stproc;
         peLsin(peLsinC).strpro    = siniestro.strpro;
         peLsin(peLsinC).stprod    = siniestro.stprod;
         peLsin(peLsinC).stclos    = siniestro.stclos;
         peLsin(peLsinC).stdlos    = siniestro.stdlos;
         peLsin(peLsinC).stctco    = siniestro.stctco;
         peLsin(peLsinC).stludi    = siniestro.stludi;
         peLsin(peLsinC).stzami    = siniestro.stzami;
         peLsin(peLsinC).stmar11   = siniestro.stmar11;
         peLsin(peLsinC).stcdes    = siniestro.stcdes;
         peLsin(peLsinC).stddes    = siniestro.stddes;
         peLsin(peLsinC).stpain    = siniestro.stpain;
         peLsin(peLsinC).stpaid    = siniestro.stpaid;
         peLsin(peLsinC).struta    = siniestro.struta;
         peLsin(peLsinC).stnrkm    = siniestro.stnrkm;
         peLsin(peLsinC).stmar21   = siniestro.stmar21;
         peLsin(peLsinC).strut2    = siniestro.strut2;
         peLsin(peLsinC).stmar31   = siniestro.stmar31;
         peLsin(peLsinC).stmar41   = siniestro.stmar41;
         peLsin(peLsinC).stmar51   = siniestro.stmar51;
         peLsin(peLsinC).stmar61   = siniestro.stmar61;
         peLsin(peLsinC).stesta1   = siniestro.stesta1;
         peLsin(peLsinC).stmar71   = siniestro.stmar71;
         peLsin(peLsinC).stmar81   = siniestro.stmar81;
         peLsin(peLsinC).stcolo    = siniestro.stcolo;
         peLsin(peLsinC).sttcal    = siniestro.sttcal;
         peLsin(peLsinC).stecal    = siniestro.stecal;
         peLsin(peLsinC).stpaic    = siniestro.stpaic;
         peLsin(peLsinC).stmar91   = siniestro.stmar91;
         peLsin(peLsinC).strela    = siniestro.strela;
         peLsin(peLsinC).streld    = siniestro.streld;
         peLsin(peLsinC).stcdcs    = siniestro.stcdcs;
         peLsin(peLsinC).stddcs    = siniestro.stddcs;
         peLsin(peLsinC).stctco1   = siniestro.stctco1;
         peLsin(peLsinC).stctcd1   = siniestro.stctcd1;
         peLsin(peLsinC).stclug    = siniestro.stclug;
         peLsin(peLsinC).stdlug    = siniestro.stdlug;
         peLsin(peLsinC).sttotpag  = siniestro.sttotpag;
         peLsin(peLsinC).stnops    = cdnops;

         exsr UltReg;

       endif;


         exsr leeArc;

         if pelsinc = peCant;
          leave;
         endif;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( pahscd03 );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

      *- Rutina de Posicionamiento de Archivo. Segun peBase, pePosi, peRoll
       begsr posArc;

       k1hscd.cdempr = peBase.peEmpr;
       k1hscd.cdsucu = peBase.peSucu;
       k1hscd.cdrama = pePosi.cdrama;
       k1hscd.cdpoli = pePosi.cdpoli;
       k1hscd.cdsini = pePosi.cdsini;

          select;
           when ( peRoll = 'F' );
             setgt %kds ( k1hscd : 5 ) pahscd03;
           when ( peRoll = 'I' );
             setll %kds ( k1hscd : 4 ) pahscd03;
           when ( peRoll = 'R' );
             setll %kds ( k1hscd : 5 ) pahscd03;
          endsl;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

             reade %kds ( k1hscd : 4 ) pahscd03;

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;

             readpe %kds ( k1hscd : 4 ) p1hscd03;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

             setll %kds ( k1hscd : 4 ) pahscd03;

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

      *---------------------------------------------------------------

      *- Rutina que graba el Primer Registro
       begsr priReg;

         pePreg.cdrama = siniestro.strama;
         pePreg.cdpoli = siniestro.stpoli;
         pePreg.cdsini = siniestro.stsini;
         pePreg.cdnops = cdnops;

       endsr;

      *-------------------------------------------------------------

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

         peUreg.cdrama = siniestro.strama;
         peUreg.cdpoli = siniestro.stpoli;
         peUreg.cdsini = siniestro.stsini;
         peUreg.cdnops = cdnops;

       endsr;
      *-------------------------------------------------------------
      *
      *- Rutina de chequeo de poliza en archivo PAHED004
      *
       begsr verPol;

         khed004.d0empr = peBase.peEmpr;
         khed004.d0sucu = peBase.peSucu;
         khed004.d0rama = pePosi.cdrama;
         khed004.d0poli = pePosi.cdpoli;

         chain %kds( khed004 : 4 ) pahed004;
        if not %found ( pahed004 );
         @@Repl =   %editw ( pePosi.cdRama  : '0 ' )
                +   %editw ( pePosi.cdpoli  : '0      ' );

         @@Leng = %len ( %trimr ( @@repl ) );

         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0009' :
                         peMsgs : @@Repl  : @@Leng );
         peErro = -1;
         return;
        endif;

       endsr;
      *------------------------------------------------------------------
      *
      *- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

             return %eof ( pahscd03 );

     P finArc          E
      *------------------------------------------------------------------
