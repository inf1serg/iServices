     H option(*nodebugio:*srcstmt: *noshowcpy)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLPDS  : Tareas generales.                                  *
      *           WebService - Retorna predenuncia de siniestro      *
      *                                                              *
      * ------------------------------------------------------------ *
      * JSN                                            *10-May-2017  *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fpds00001  if   e           k disk    rename(p1ds00:p1ds01)
     Fpds00002  if   e           k disk    rename(p1ds00:p1ds02)
     Fpds00003  if   e           k disk    rename(p1ds00:p1ds03)
     Fpds00004  if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLPDS          pr                  ExtPgm('WSLPDS')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   peOrde                      10a   const
     D   pePosi                            likeds(keypds_t) const
     D   pePreg                            likeds(keypds_t)
     D   peUreg                            likeds(keypds_t)
     D   pePds0                            likeds(pds000_t) dim(99)
     D   pePds0C                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLPDS          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   peOrde                      10a   const
     D   pePosi                            likeds(keypds_t) const
     D   pePreg                            likeds(keypds_t)
     D   peUreg                            likeds(keypds_t)
     D   pePds0                            likeds(pds000_t) dim(99)
     D   pePds0C                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D finArc          pr              n

     D k1pds0          ds                  likerec( p1ds00 : *key )
     D k1pds1          ds                  likerec( p1ds01 : *key )
     D k1pds2          ds                  likerec( p1ds02 : *key )
     D k1pds3          ds                  likerec( p1ds03 : *key )

     D respue          s          65536
     D longm           s             10i 0

     D @@repl          s          65535a
     D @@leng          s             10i 0
     D @@cant          s             10i 0
     D @@more          s               n

       *inLr = *On;

       peErro  = *Zeros;
       pePds0C = *Zeros;
       peMore  = *Off;

       clear pePds0;
       clear peMsgs;
       clear pePreg;
       clear peUreg;

       @@more  = *On;

      *- Valida Parametro Forma de Paginado
       if not SVPWS_chkRoll ( peRoll : peMsgs );
         peErro = -1;
         return;
       endif;

      *- Valida Cantidad de Lineas a Retornar
       @@cant = peCant;
       if ( ( @@Cant <= *Zeros ) or ( @@Cant > 99 ) );
         @@cant = 99;
       endif;

      *- Valida Orden
       if not SVPWS_chkOrde( 'WSLPDS' : peOrde : peMsgs );
          peErro = -1;
          return;
       endif;

      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       exsr leeArc;
       exsr priReg;

       dow ( ( not finArc ) and ( pePds0C < @@cant ) );

         pePds0C += 1;

         pePds0(pePds0C).p0Nomb = p0Nomb;
         pePds0(pePds0C).p0Rama = p0Rama;
         pePds0(pePds0C).p0Poli = p0Poli;
         pePds0(pePds0C).p0Pate = p0Pate;
         pePds0(pePds0C).p0Npds = p0Npds;
         pePds0(pePds0C).p0Nrdf = p0Nrdf;
         pePds0(pePds0C).p0Focu = p0Focu;
         pePds0(pePds0C).p0Hocu = p0Hocu;
         pePds0(pePds0C).p0Caus = p0Caus;
         pePds0(pePds0C).p0Sini = p0Sini;
         pePds0(pePds0C).p0Fpdf = p0Fpdf;
         pePds0(pePds0C).p0Mar1 = p0Mar1;
         pePds0(pePds0C).p0Mar2 = p0Mar2;
         pePds0(pePds0C).p0Mar3 = p0Mar3;
         pePds0(pePds0C).p0Mar4 = p0Mar4;
         pePds0(pePds0C).p0Mar5 = p0Mar5;
         pePds0(pePds0C).p0User = p0User;
         pePds0(pePds0C).p0Date = p0Date;
         pePds0(pePds0C).p0Time = p0Time;

         exsr UltReg;

         exsr leeArc;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when finArc;
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

       // Rutina de Posicionamiento de Archivo. Segun pePosi, peRoll

       begsr posArc;

         k1pds0.p0Empr = peBase.peEmpr;
         k1pds0.p0Sucu = peBase.peSucu;
         k1pds0.p0Nivt = peBase.peNivt;
         k1pds0.p0Nivc = peBase.peNivc;

         Select;

           when ( peOrde = 'PDSRAMAPOL' );
             k1pds0.p0Rama = pePosi.p0Rama;
             k1pds0.p0Poli = pePosi.p0Poli;
             if ( peRoll = 'F' );
               setgt %kds ( k1pds0:6 ) pds00004;
             else;
               setll %kds ( k1pds0:6 ) pds00004;
             endif;
           when ( peOrde = 'PDSPATENTE' );
             k1pds1.p0Empr = peBase.peEmpr;
             k1pds1.p0Sucu = peBase.peSucu;
             k1pds1.p0Nivt = peBase.peNivt;
             k1pds1.p0Nivc = peBase.peNivc;
             k1pds1.p0Pate = pePosi.p0Pate;
             if ( peRoll = 'F' );
               setgt %kds ( k1pds1:5 ) pds00001;
             else;
               setll %kds ( k1pds1:5 ) pds00001;
             endif;
           when ( peOrde = 'PDSSINIEST' );
             k1pds2.p0Empr = peBase.peEmpr;
             k1pds2.p0Sucu = peBase.peSucu;
             k1pds2.p0Nivt = peBase.peNivt;
             k1pds2.p0Nivc = peBase.peNivc;
             k1pds2.p0Sini = pePosi.p0Sini;
             if ( peRoll = 'F' );
               setgt %kds ( k1pds2:5 ) pds00002;
             else;
               setll %kds ( k1pds2:5 ) pds00002;
             endif;
           when ( peOrde = 'PDSASEGURA' );
             k1pds3.p0Empr = peBase.peEmpr;
             k1pds3.p0Sucu = peBase.peSucu;
             k1pds3.p0Nivt = peBase.peNivt;
             k1pds3.p0Nivc = peBase.peNivc;
             k1pds3.p0Nomb = pePosi.p0Nomb;
             if ( peRoll = 'F' );
               setgt %kds ( k1pds3:5 ) pds00003;
             else;
               setll %kds ( k1pds3:5 ) pds00003;
             endif;

         endsl;

       endsr;

       // Rutina que graba el Primer Registro

       begsr priReg;

         pePreg.p0Nomb = p0Nomb;
         pePreg.p0Rama = p0Rama;
         pePreg.p0Poli = p0Poli;
         pePreg.p0Pate = p0Pate;
         pePreg.p0Sini = p0Sini;

       endsr;

       // Rutina que graba el Ultimo Registro

       begsr ultReg;

         peUreg.p0Nomb = p0Nomb;
         peUreg.p0Rama = p0Rama;
         peUreg.p0Poli = p0Poli;
         peUreg.p0Pate = p0Pate;
         peUreg.p0Sini = p0Sini;

       endsr;

       // Rutina de Posicionamiento en Comienzo de Archivo

       begsr retPag;

         if ( peRoll = 'R' );
           exsr retArc;
           dow ( ( not finArc ) and ( @@cant > 0 ) );
             @@cant -= 1;
             exsr retArc;
           enddo;
           if finArc;
             @@more = *off;
             exsr priArc;
           endif;
           @@cant = peCant;
           if (@@cant <= 0 or @@cant > 99);
             @@cant = 99;
           endif;
         endif;

       endsr;

       // Rutina de Lectura para Adelante

       begsr leeArc;

         select;
          when ( peOrde = 'PDSRAMAPOL' );
            reade %kds ( k1pds0:4 ) pds00004;
          when ( peOrde = 'PDSPATENTE' );
            reade %kds ( k1pds1:4 ) pds00001;
          when ( peOrde = 'PDSSINIEST' );
            reade %kds ( k1pds2:4 ) pds00002;
          when ( peOrde = 'PDSASEGURA' );
            reade %kds ( k1pds3:4 ) pds00003;
         endsl;

       endsr;

       // Rutina de Lectura para Atras en caso de Paginado "F"

       begsr retArc;

         select;
          when ( peOrde = 'PDSRAMAPOL' );
            readpe %kds ( k1pds0:4 ) pds00004;
          when ( peOrde = 'PDSPATENTE' );
            readpe %kds ( k1pds1:4 ) pds00001;
          when ( peOrde = 'PDSSINIEST' );
            readpe %kds ( k1pds2:4 ) pds00002;
          when ( peOrde = 'PDSASEGURA' );
            readpe %kds ( k1pds3:4 ) pds00003;
         endsl;

       endsr;

       // Rutina de Posicionamiento en Comienzo de Archivo

       begsr priArc;

         select;
          when ( peOrde = 'PDSRAMAPOL' );
            setll %kds ( k1pds0:4 ) pds00004;
          when ( peOrde = 'PDSPATENTE' );
            setll %kds ( k1pds1:4 ) pds00001;
          when ( peOrde = 'PDSSINIEST' );
            setll %kds ( k1pds2:4 ) pds00002;
          when ( peOrde = 'PDSASEGURA' );
            setll %kds ( k1pds3:4 ) pds00003;
         endsl;

       endsr;

     **- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

          select;
            when ( peOrde = 'PDSRAMAPOL' );
              return %eof ( pds00004 );
            when ( peOrde = 'PDSPATENTE' );
              return %eof ( pds00001 );
            when ( peOrde = 'PDSSINIEST' );
              return %eof ( pds00002 );
            when ( peOrde = 'PDSASEGURA' );
              return %eof ( pds00003 );
          endsl;

     P finArc          E

