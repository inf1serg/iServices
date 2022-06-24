     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLAXD : WebService - Retorna Aseg.relac.a intermed.x Docum. *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                            23/09/2015    *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SFA 16/01/2016 - Cambio en DS de Asegurado                   *
      * SGF 28/07/2016 - PAHASE es PAHAS1.                           *
      * JSN 28/02/2019 - Recompilacion por cambio en la estructura   *
      *                  PAHASE_T                                    *
      *                                                              *
      * ************************************************************ *
     Fpahas103  if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svpmail_h.rpgle'

     D WSLAXD          pr                  ExtPgm('WSLAXD')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keyaxd_t) const
     D   pePreg                            likeds(keyaxd_t)
     D   peUreg                            likeds(keyaxd_t)
     D   peLase                            likeds(pahase_t) dim(99)
     D   peLaseC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLAXD          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keyaxd_t) const
     D   pePreg                            likeds(keyaxd_t)
     D   peUreg                            likeds(keyaxd_t)
     D   peLase                            likeds(pahase_t) dim(99)
     D   peLaseC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLASE          pr                  ExtPgm('WSLASE')
     D   peBase                            likeds(paramBase) const
     D   peAsen                            like(asasen) const
     D   peDase                            likeds(pahase_t)
     D   peMase                            likeds(dsMail_t) dim(99)
     D   peMaseC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@Repl          s          65535a
     D @@Leng          s             10i 0
     D @@more          s               n

     D khase03         ds                  likerec(p1has1:*key)

     D asegurad        ds                  likeds(pahase_t)

     D peMase          ds                  likeds(dsMail_t) dim(100)
     D peMaseC         s             10i 0

     D finArc          pr              n

     D @@cant          s             10i 0

       *inLr = *On;

       clear peLase;
       clear peLaseC;
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

       dow ( ( not finArc ) and ( peLaseC < @@cant ) );

         peLaseC += 1;

         peLase(peLaseC).asempr = asegurad.asempr;
         peLase(peLaseC).assucu = asegurad.assucu;
         peLase(peLaseC).asnivt = asegurad.asnivt;
         peLase(peLaseC).asnivc = asegurad.asnivc;
         peLase(peLaseC).asasen = asegurad.asasen;
         peLase(peLaseC).asnomb = asegurad.asnomb;
         peLase(peLaseC).asdomi = asegurad.asdomi;
         peLase(peLaseC).asloca = asegurad.asloca;
         peLase(peLaseC).asprod = asegurad.asprod;
         peLase(peLaseC).astido = asegurad.astido;
         peLase(peLaseC).asdatd = asegurad.asdatd;
         peLase(peLaseC).asnrdo = asegurad.asnrdo;
         peLase(peLaseC).ascuit = asegurad.ascuit;
         peLase(peLaseC).ascopo = asegurad.ascopo;
         peLase(peLaseC).ascops = asegurad.ascops;
         peLase(peLaseC).asproc = asegurad.asproc;
         peLase(peLaseC).asciva = asegurad.asciva;
         peLase(peLaseC).asncil = asegurad.asncil;
         peLase(peLaseC).astiso = asegurad.astiso;
         peLase(peLaseC).asdtis = asegurad.asdtis;
         peLase(peLaseC).astel2 = asegurad.astel2;
         peLase(peLaseC).astel3 = asegurad.astel3;
         peLase(peLaseC).astel4 = asegurad.astel4;
         peLase(peLaseC).astel5 = asegurad.astel5;
         peLase(peLaseC).astel6 = asegurad.astel6;
         peLase(peLaseC).astel7 = asegurad.astel7;
         peLase(peLaseC).astel8 = asegurad.astel8;
         peLase(peLaseC).astel9 = asegurad.astel9;
         peLase(peLaseC).aspweb = asegurad.aspweb;
         peLase(peLaseC).asfnac = asegurad.asfnac;
         peLase(peLaseC).asnnib = asegurad.asnnib;
         peLase(peLaseC).assexo = asegurad.assexo;
         peLase(peLaseC).asdsex = asegurad.asdsex;
         peLase(peLaseC).asruta = asegurad.asruta;
         peLase(peLaseC).ascesc = asegurad.ascesc;
         peLase(peLaseC).asdesc = asegurad.asdesc;
         peLase(peLaseC).asmar5 = asegurad.asmar5;
         peLase(peLaseC).ascnac = asegurad.ascnac;
         peLase(peLaseC).asfein = asegurad.asfein;
         peLase(peLaseC).asnrin = asegurad.asnrin;
         peLase(peLaseC).asfeco = asegurad.asfeco;
         peLase(peLaseC).aspaid = asegurad.aspaid;
         peLase(peLaseC).aspain = asegurad.aspain;
         peLase(peLaseC).ascprf = asegurad.ascprf;
         peLase(peLaseC).asdprf = asegurad.asdprf;
         peLase(peLaseC).ascuil = asegurad.ascuil;
         peLase(peLaseC).asraae = asegurad.asraae;
         peLase(peLaseC).asdeae = asegurad.asdeae;
         peLase(peLaseC).aslnac = asegurad.aslnac;

         exsr UltReg;

         exsr leeArc;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( pahas103 );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

      *- Rutina de Posicionamiento de Archivo. Segun pePosi, peRoll
       begsr posArc;

        khase03.asempr = peBase.peEmpr;
        khase03.assucu = peBase.peSucu;
        khase03.asnivt = peBase.peNivt;
        khase03.asnivc = peBase.peNivc;
        khase03.astido = pePosi.astido;
        khase03.asnrdo = pePosi.asnrdo;
        khase03.asasen = pePosi.asasen;

       if ( peRoll = 'F' );
          setgt %kds ( khase03 : 7 ) pahas103;
       else;
          setll %kds ( khase03 : 7 ) pahas103;
       endif;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

       reade %kds ( khase03 : 4 ) pahas103;

       WSLASE( peBase
             : asasen
             : asegurad
             : peMase
             : peMaseC
             : peErro
             : peMsgs );

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;

       readpe %kds ( khase03 : 4 ) pahas103;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

       setll %kds ( khase03 : 4 ) pahas103;

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

       pePreg.astido = asegurad.astido;
       pePreg.asnrdo = asegurad.asnrdo;
       pePreg.asasen = asegurad.asasen;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

       peUreg.astido = asegurad.astido;
       peUreg.asnrdo = asegurad.asnrdo;
       peUreg.asasen = asegurad.asasen;

       endsr;

      *- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

       return %eof ( pahas103 );

     P finArc          E
