     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLZDE : WebService                                          *
      *          Retorna denuncias zamba                             *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                              *15/12/2015    *
      * ------------------------------------------------------------ *
      * SGF 26/10/2016: Mal peMore en DESCRIRAMA.                    *
      *                                                              *
      * ************************************************************ *
     Fpahzde    if   e           k disk
     Fpahzde01  if   e           k disk    rename(p1hzde:p1hzde01)

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLZDE          pr                  ExtPgm('WSLZDE')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   peOrde                      10a   const
     D   pePosi                            likeds(keyzde_t) const
     D   pePreg                            likeds(keyzde_t)
     D   peUreg                            likeds(keyzde_t)
     D   peLden                            likeds(pahzde_t) dim(99)
     D   peLdenC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLZDE          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   peOrde                      10a   const
     D   pePosi                            likeds(keyzde_t) const
     D   pePreg                            likeds(keyzde_t)
     D   peUreg                            likeds(keyzde_t)
     D   peLden                            likeds(pahzde_t) dim(99)
     D   peLdenC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@Repl          s          65535a
     D @@Leng          s             10i 0
     D @@more          s               n

     D k0hzde          ds                  likerec(p1hzde:*key)
     D k1hzde          ds                  likerec(p1hzde:*key)
     D k2hzde          ds                  likerec(p1hzde01:*key)

     D finArc          pr              n

     D @@cant          s             10i 0

       *inLr = *On;

       clear peLden;
       clear peLdenC;
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

      *- Valido Orden de Lectura
       if not SVPWS_chkOrde ( 'WSLZDE' : peOrde : peMsgs );
         peErro = -1;
         return;
       endif;

      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       exsr leeArc;

       if ( not finArc );
         exsr priReg;
       endif;

       dow ( ( not finArc ) and ( peLdenC < @@cant ) );

         peLdenC += 1;

         peLden(peLdenC).deempr = deempr;
         peLden(peLdenC).desucu = desucu;
         peLden(peLdenC).denivt = denivt;
         peLden(peLdenC).denivc = denivc;
         peLden(peLdenC).denivd = denivd;
         peLden(peLdenC).deidre = deidre;
         peLden(peLdenC).derama = derama;
         peLden(peLdenC).deramd = deramd;
         peLden(peLdenC).depoli = depoli;
         peLden(peLdenC).defnot = defnot;
         peLden(peLdenC).defsin = defsin;
         peLden(peLdenC).dehsin = dehsin;
         peLden(peLdenC).denrdf = denrdf;
         peLden(peLdenC).deased = deased;
         peLden(peLdenC).deetap = deetap;

         exsr UltReg;

         exsr leeArc;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( pahzde );
           peMore = *Off;
         when %eof ( pahzde01 );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

      *- Rutina de Posicionamiento de Archivo. Segun pePosi, peRoll
       begsr posArc;

         k0hzde.deempr = peBase.peEmpr;
         k0hzde.desucu = peBase.peSucu;
         k0hzde.denivt = peBase.peNivt;
         k0hzde.denivc = peBase.peNivc;

        select;
         when peOrde = 'CODIGORAMA';
              k1hzde.deempr = peBase.peEmpr;
              k1hzde.desucu = peBase.peSucu;
              k1hzde.denivt = peBase.peNivt;
              k1hzde.denivc = peBase.peNivc;
              k1hzde.deidre = pePosi.idre;
              if ( peRoll = 'F' );
                 setgt %kds ( k1hzde ) pahzde;
               else;
                 setll %kds ( k1hzde ) pahzde;
              endif;
         when peOrde = 'DESCRIRAMA';
              k2hzde.deempr = peBase.peEmpr;
              k2hzde.desucu = peBase.peSucu;
              k2hzde.denivt = peBase.peNivt;
              k2hzde.denivc = peBase.peNivc;
              k2hzde.deidre = pePosi.idre;
              k2hzde.deramd = pePosi.ramd;
              if ( peRoll = 'F' );
                 setgt %kds ( k2hzde ) pahzde01;
               else;
                 setll %kds ( k2hzde ) pahzde01;
              endif;
        endsl;


       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

         select;
          when peOrde = 'CODIGORAMA';
               reade %kds(k0hzde:4) pahzde;
          when peOrde = 'DESCRIRAMA';
               reade %kds(k0hzde:4) pahzde01;
         endsl;

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;

         select;
          when peOrde = 'COGIGORAMA';
               readpe %kds(k0hzde:4) pahzde;
          when peOrde = 'DESCRIRAMA';
               readpe %kds(k0hzde:4) pahzde01;
         endsl;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

         select;
          when peOrde = 'CODIGORAMA';
               setll %kds(k0hzde:4) pahzde;
          when peOrde = 'DESCRIRAMA';
               setll %kds(k0hzde:4) pahzde01;
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

         pePreg.idre = deidre;
         pePreg.ramd = deramd;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

         peUreg.idre = deidre;
         peUreg.ramd = deramd;

       endsr;

      *- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

       select;
          when peOrde = 'CODIGORAMA';
               return %eof ( pahzde );
          when peOrde = 'DESCRIRAMA';
               return %eof ( pahzde01 );
       endsl;

     P finArc          E
