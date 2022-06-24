     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLCCR  : Tareas generales.                                  *
      *           WebService - Retorna Cruce de cartera por rama.    *
      *                                                              *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                            *10-Jun-2015  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SFA 17/07/2015 - Se modifica logica sobre peMore             *
      * SGF 28/07/2016 - PAHASE es PAHAS1.                           *
      * JSN 28/02/2019 - Recompilacion por cambio en la estructura   *
      *                  PAHASE_T                                    *
      *                                                              *
      * ************************************************************ *
     Fpahas1    if   e           k disk
     Fpahpol08  if   e           k disk
     Fset001    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLCCR          pr                  ExtPgm('WSLCCR')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keyccr_t) const
     D   pePreg                            likeds(keyccr_t)
     D   peUreg                            likeds(keyccr_t)
     D   peRami                       2  0 const
     D   peRamx                       2  0 const
     D   peLase                            likeds(ccrase_t) dim(99)
     D   peLaseC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLCCR          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keyccr_t) const
     D   pePreg                            likeds(keyccr_t)
     D   peUreg                            likeds(keyccr_t)
     D   peRami                       2  0 const
     D   peRamx                       2  0 const
     D   peLase                            likeds(ccrase_t) dim(99)
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

     D finArc          pr              n

     D k1yase          ds                  likerec(p1has1:*key)

     D khpol08         ds                  likerec(p1hpol:*key)

     D asegurados      ds                  likeds(pahase_t)

     D peMase          ds                  likeds(dsMail_t) dim(100)
     D peMaseC         s             10i 0

     D @@cant          s             10i 0
     D @@ok            s               n

     D respue          s          65536
     D longm           s             10i 0
     D @@more          s               n

       *inLr = *On;

       peErro  = *Zeros;
       peLaseC = *Zeros;
       @@more  = *On;

       clear peLase;
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

      *- Valido Rama Incluida
       setll (peRami) set001;

       if not %equal(set001);

          respue =  %editC(peRami:'4':*ASTFILL);
          longm  = 2 ;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'RAM0001' :
                          peMsgs : respue  : longm );

         peErro = -1;
         return;

       endif;

      *- Valido Rama Excluida
       setll (peRamx) set001;

       if not %equal(set001);

          respue =  %editC(peRamx:'4':*ASTFILL);
          longm  = 2 ;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'RAM0001' :
                          peMsgs : respue  : longm );

         peErro = -1;
         return;

       endif;

      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       exsr leeArc;

       WSLASE( peBase
             : asasen
             : asegurados
             : peMase
             : peMaseC
             : peErro
             : peMsgs );

       exsr priReg;

       dow ( ( not finArc ) and ( peLaseC < @@cant ) );

         // ------------------------------
         // Muevo Datos directamente de WSLASE
         // ------------------------------
         peLaseC += 1;

         WSLASE( peBase
               : asasen
               : asegurados
               : peMase
               : peMaseC
               : peErro
               : peMsgs );

         peLase( peLaseC ).asempr = asegurados.asempr;
         peLase( peLaseC ).assucu = asegurados.assucu;
         peLase( peLaseC ).asnivt = asegurados.asnivt;
         peLase( peLaseC ).asnivc = asegurados.asnivc;
         peLase( peLaseC ).asasen = asegurados.asasen;
         peLase( peLaseC ).asnomb = asegurados.asnomb;
         peLase( peLaseC ).asdomi = asegurados.asdomi;
         peLase( peLaseC ).asloca = asegurados.asloca;
         peLase( peLaseC ).asprod = asegurados.asprod;
         peLase( peLaseC ).astido = asegurados.astido;
         peLase( peLaseC ).asdatd = asegurados.asdatd;
         peLase( peLaseC ).asnrdo = asegurados.asnrdo;
         peLase( peLaseC ).ascuit = asegurados.ascuit;
         peLase( peLaseC ).ascopo = asegurados.ascopo;
         peLase( peLaseC ).ascops = asegurados.ascops;
         peLase( peLaseC ).asproc = asegurados.asproc;
         peLase( peLaseC ).asciva = asegurados.asciva;
         peLase( peLaseC ).asncil = asegurados.asncil;
         peLase( peLaseC ).astiso = asegurados.astiso;
         peLase( peLaseC ).asdtis = asegurados.asdtis;
         peLase( peLaseC ).astel2 = asegurados.astel2;
         peLase( peLaseC ).astel3 = asegurados.astel3;
         peLase( peLaseC ).astel4 = asegurados.astel4;
         peLase( peLaseC ).astel5 = asegurados.astel5;
         peLase( peLaseC ).astel6 = asegurados.astel6;
         peLase( peLaseC ).astel7 = asegurados.astel7;
         peLase( peLaseC ).astel8 = asegurados.astel8;
         peLase( peLaseC ).astel9 = asegurados.astel9;
         peLase( peLaseC ).aspweb = asegurados.aspweb;
         peLase( peLaseC ).asfnac = asegurados.asfnac;
         peLase( peLaseC ).asnnib = asegurados.asnnib;
         peLase( peLaseC ).assexo = asegurados.assexo;
         peLase( peLaseC ).asdsex = asegurados.asdsex;
         peLase( peLaseC ).asruta = asegurados.asruta;
         peLase( peLaseC ).ascesc = asegurados.ascesc;
         peLase( peLaseC ).asdesc = asegurados.asdesc;
         peLase( peLaseC ).asmar5 = asegurados.asmar5;
         //peLase( peLaseC ).asnaci = asegurados.asnaci;
         peLase( peLaseC ).asfein = asegurados.asfein;
         peLase( peLaseC ).asnrin = asegurados.asnrin;
         peLase( peLaseC ).asfeco = asegurados.asfeco;
         peLase( peLaseC ).aspaid = asegurados.aspaid;
         peLase( peLaseC ).asmail = peMase(1).mail;

         exsr UltReg;

         exsr leeArc;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( pahpol08 );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

      *- Rutina de Posicionamiento de Archivo. Segun pePosi, peRoll
       begsr posArc;

       k1yase.asempr = peBase.peEmpr;
       k1yase.assucu = peBase.peSucu;
       k1yase.asnivt = peBase.peNivt;
       k1yase.asnivc = peBase.peNivc;
       k1yase.asasen = pePosi.asAsen;

       if ( peRoll = 'F' );
          setgt %kds ( k1yase : 5 ) pahas1;
       else;
          setll %kds ( k1yase : 5 ) pahas1;
       endif;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

       @@ok = *off;

       reade %kds ( k1yase : 4 ) pahas1;

       dow not @@ok and not finArc;

          khpol08.poempr = peBase.peEmpr;
          khpol08.posucu = peBase.peSucu;
          khpol08.ponivt = peBase.peNivt;
          khpol08.ponivc = peBase.peNivc;
          khpol08.poasen = asasen;
          khpol08.porama = peRami;

          setll %kds( khpol08:6) pahpol08;

          if %equal (pahpol08);
             @@ok = *on;
          endif;

          khpol08.porama = peRamx;

          setll %kds( khpol08:6) pahpol08;

          if %equal (pahpol08);
             @@ok = *off;
          endif;

          if @@ok;
             leave;
          endif;

          reade %kds ( k1yase : 4 ) pahas1;

       enddo;

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;

       @@ok = *off;

       readpe %kds ( k1yase : 4 ) pahas1;

       dow not @@ok and not finArc;

          khpol08.poempr = peBase.peEmpr;
          khpol08.posucu = peBase.peSucu;
          khpol08.ponivt = peBase.peNivt;
          khpol08.ponivc = peBase.peNivc;
          khpol08.poasen = asasen;
          khpol08.porama = peRami;

          setll %kds( khpol08:6) pahpol08;

          if %equal (pahpol08);
             @@ok = *on;
          endif;

          khpol08.porama = peRamx;

          setll %kds( khpol08:6) pahpol08;

          if %equal (pahpol08);
             @@ok = *off;
          endif;

          if @@ok;
             leave;
          endif;

          readpe %kds ( k1yase : 4 ) pahas1;

       enddo;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

       setll %kds ( k1yase : 4 ) pahas1;

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

       pePreg.asasen = asegurados.asasen;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

       peUreg.asasen = asegurados.asasen;

       endsr;

      *- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

       return %eof ( pahas1 );

     P finArc          E
