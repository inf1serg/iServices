     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLZDE : WebService                                          *
      *          Retorna inspecciones zamba                          *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                              *15/12/2015    *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fpahzin    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLZIN          pr                  ExtPgm('WSLZIN')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   pePosi                            likeds(keyzin_t) const
     D   pePreg                            likeds(keyzin_t)
     D   peUreg                            likeds(keyzin_t)
     D   peLins                            likeds(pahzin_t) dim(99)
     D   peLinsC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLZIN          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   pePosi                            likeds(keyzin_t) const
     D   pePreg                            likeds(keyzin_t)
     D   peUreg                            likeds(keyzin_t)
     D   peLins                            likeds(pahzin_t) dim(99)
     D   peLinsC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@Repl          s          65535a
     D @@Leng          s             10i 0
     D @@more          s               n

     D k1hzin          ds                  likerec(p1hzin:*key)

     D finArc          pr              n

     D @@cant          s             10i 0

       *inLr = *On;

       clear peLins;
       clear peLinsC;
       clear peErro;
       clear peMsgs;

       @@more = *On;

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

       if ( not finArc );
         exsr priReg;
       endif;

       dow ( ( not finArc ) and ( peLinsC < @@cant ) );

         peLinsC += 1;

         peLins(peLinsC).inempr = inempr;
         peLins(peLinsC).insucu = insucu;
         peLins(peLinsC).inrama = inrama;
         peLins(peLinsC).insini = insini;
         peLins(peLinsC).inidre = inidre;
         peLins(peLinsC).inidin = inidin;
         peLins(peLinsC).inpoli = inpoli;
         peLins(peLinsC).infins = infins;
         peLins(peLinsC).instin = instin;
         peLins(peLinsC).ininsd = ininsd;
         peLins(peLinsC).intdoc = intdoc;

         exsr UltReg;

         exsr leeArc;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( pahzin );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

      *- Rutina de Posicionamiento de Archivo. Segun pePosi, peRoll
       begsr posArc;

         k1hzin.inempr = peBase.peEmpr;
         k1hzin.insucu = peBase.peSucu;
         k1hzin.inrama = peRama;
         k1hzin.insini = peSini;
         k1hzin.inidre = pePosi.idre;
         k1hzin.inidin = pePosi.idin;

         if ( peRoll = 'F' );
            setgt %kds ( k1hzin ) pahzin;
         else;
            setll %kds ( k1hzin ) pahzin;
         endif;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

         reade %kds(k1hzin:5) pahzin;

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;

         readpe %kds(k1hzin:5) pahzin;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

         setll %kds(k1hzin:5) pahzin;

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

         pePreg.idre = inidre;
         pePreg.idin = inidin;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

         peUreg.idre = inidre;
         peUreg.idin = inidin;

       endsr;

      *- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

       return %eof ( pahzin );

     P finArc          E
