     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLSX2  : Tareas generales.                                  *
      *           WebService - Retorna Siniestros de Intermediario   *
      *                                                              *
      * ------------------------------------------------------------ *
      * JSN                                            *08-Feb-2017  *
      * ------------------------------------------------------------ *
      *  Se genera un nuevo WebService que sea identico a WSLSXI,    *
      *  pero que permite tener diferentes ordenamientos: RAMASINI,  *
      *  RAMAPOLI y ASEGURADO                                        *
      * ************************************************************ *
     Fpahstr1   if   e           k disk
     Fpahstr102 if   e           k disk    rename(p1hstr1:p1hstr02)
     Fpahstr103 if   e           k disk    rename(p1hstr1:p1hstr03)
     Fpahscd    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLSX2          pr                  ExtPgm('WSLSX2')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   peOrde                      10a   const
     D   pePosi                            likeds(keysx2_t) const
     D   pePreg                            likeds(keysx2_t)
     D   peUreg                            likeds(keysx2_t)
     D   peLsin                            likeds(pahstro_t) dim(99)
     D   peLsinC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLSX2          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   peOrde                      10a   const
     D   pePosi                            likeds(keysx2_t) const
     D   pePreg                            likeds(keysx2_t)
     D   peUreg                            likeds(keysx2_t)
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

     D k1ysin          ds                  likerec( p1hstr1  : *key )
     D k1ysin2         ds                  likerec( p1hstr02 : *key )
     D k1ysin3         ds                  likerec( p1hstr03 : *key )
     D k1yscd          ds                  likerec( p1hscd   : *Key )

     D finArc          pr              n

     D siniestro       ds                  likeds(pahstro_t)

     D @@cant          s             10i 0
     D @@more          s               n
     D cdfden          s              8  0

       *inLr = *On;
       @@more = *On;

       peLsinC = *Zeros;
       peErro  = *Zeros;

       clear pePreg;
       clear peUreg;
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

      *- Valido Orden de Lectura
       if not SVPWS_chkOrde ( 'WSLSX2' : peOrde : peMsgs );
         peErro = -1;
         return;
       endif;

      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       exsr leeArc;

         WSXSIN( peBase.peEmpr
               : peBase.peSucu
               : strama
               : stsini
               : cdnops
               : siniestro );

       cdfden = (cdfdea * 10000)
              + (cdfdem *   100)
              +  cdfded;
       monitor;
          siniestro.stfden = %date(cdfden:*iso);
        on-error;
          siniestro.stfden = %date(00010101:*iso);
       endmon;

       exsr priReg;

       dow ( ( not finarc() ) and ( peLsinC < @@cant ) );

         peLsinC += 1;

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

         exsr leeArc;

         WSXSIN(
         peBase.peEmpr:
         peBase.peSucu:
         strama:
         stsini:
         cdnops:
         siniestro);

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( pahstr1 );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

      *- Rutina de Posicionamiento de Archivo. Segun pePosi, peRoll
       begsr posArc;

         select;
           when ( peOrde = 'RAMASINI' );
             k1ysin.stempr = peBase.peEmpr;
             k1ysin.stsucu = peBase.peSucu;
             k1ysin.stnivt = peBase.peNivt;
             k1ysin.stnivc = peBase.peNivc;
             k1ysin.strama = pePosi.cdrama;
             k1ysin.stsini = pePosi.cdsini;
             if ( peRoll = 'F' );
                setgt %kds ( k1ysin : 6 ) pahstr1;
             else;
                setll %kds ( k1ysin : 6 ) pahstr1;
             endif;

           when ( peOrde = 'RAMAPOLI' );
             k1ysin2.stempr = peBase.peEmpr;
             k1ysin2.stsucu = peBase.peSucu;
             k1ysin2.stnivt = peBase.peNivt;
             k1ysin2.stnivc = peBase.peNivc;
             k1ysin2.strama = pePosi.cdrama;
             k1ysin2.stpoli = pePosi.cdpoli;
             //*k1ysin2.stsini = pePosi.cdsini;
             if ( peRoll = 'F' );
                setgt %kds ( k1ysin2 : 6 ) pahstr102;
             else;
                setll %kds ( k1ysin2 : 6 ) pahstr102;
             endif;

           when ( peOrde = 'ASEGURADO' );
             k1ysin3.stempr = peBase.peEmpr;
             k1ysin3.stsucu = peBase.peSucu;
             k1ysin3.stnivt = peBase.peNivt;
             k1ysin3.stnivc = peBase.peNivc;
             k1ysin3.stnomb = pePosi.cdNomb;
             //* k1ysin3.strama = pePosi.cdrama;
             //* k1ysin3.stsini = pePosi.cdsini;
             if ( peRoll = 'F' );
                setgt %kds ( k1ysin3 : 5 ) pahstr103;
             else;
                setll %kds ( k1ysin3 : 5 ) pahstr103;
             endif;

         endsl;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

         select;
           when ( peOrde = 'RAMASINI' );
             reade %kds ( k1ysin : 4 ) pahstr1;

           when ( peOrde = 'RAMAPOLI' );
             reade %kds ( k1ysin2: 4 ) pahstr102;

           when ( peOrde = 'ASEGURADO' );
             reade %kds ( k1ysin3: 4 ) pahstr103;

         endsl;

         if not %eof(pahstr1);

           k1yscd.cdempr = peBase.peEmpr;
           k1yscd.cdsucu = peBase.peSucu;
           k1yscd.cdrama = strama;
           k1yscd.cdsini = stsini;

           chain %kds ( k1yscd : 4 ) pahscd;

         endif;

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;

         select;
           when ( peOrde = 'RAMASINI' );
             readpe %kds ( k1ysin : 4 ) pahstr1;

           when ( peOrde = 'RAMAPOLI' );
             readpe %kds ( k1ysin2: 4 ) pahstr102;

           when ( peOrde = 'ASEGURADO' );
             readpe %kds ( k1ysin3: 4 ) pahstr103;

         endsl;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

         select;
           when ( peOrde = 'RAMASINI' );
             setll %kds ( k1ysin : 4 ) pahstr1;

           when ( peOrde = 'RAMAPOLI' );
             setll %kds ( k1ysin2: 4 ) pahstr102;

           when ( peOrde = 'ASEGURADO' );
             setll %kds ( k1ysin3: 4 ) pahstr103;

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

       pePreg.cdrama = siniestro.strama;
       pePreg.cdsini = siniestro.stsini;
       pePreg.cdpoli = siniestro.stpoli;
       pepreg.fsin   = siniestro.stfsin;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

       peUreg.cdrama = siniestro.strama;
       peUreg.cdsini = siniestro.stsini;
       peUreg.cdpoli = siniestro.stpoli;
       peUreg.fsin   = siniestro.stfsin;

       endsr;

      *- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

       select;
         when ( peOrde = 'RAMASINI' );
           return %eof ( pahstr1 );

         when ( peOrde = 'RAMAPOLI' );
           return %eof ( pahstr102 );

         when ( peOrde = 'ASEGURADO' );
           return %eof ( pahstr103 );

       endsl;

     P finArc          E
