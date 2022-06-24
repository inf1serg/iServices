     H option(*nodebugio:*noshowcpy:*srcstmt)
     H dftactgrp(*no) actgrp(*new)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSLDEV  : Tareas generales.                                  *
      *           WebService - Retorna Pólizas con deuda vencida.    *
      *                                                              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                        *09-May-2017         *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fpawdvd    if   e           k disk
     Fpawdvi    if   e             disk
     Fpawdvd01  if   e           k disk    rename(p1wdvd:p1wdvd01)
     Fpawdvd02  if   e           k disk    rename(p1wdvd:p1wdvd02)
     Fpawdvt    if   e           k disk
     Fset001    if   e           k disk
     Fgntmon    if   e           k disk
     Ftab007    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLDEV          pr                  ExtPgm('WSLDEV')
     D  peBase                             likeds(paramBase) const
     D  peCant                       10i 0 const
     D  peRoll                        1a   const
     D  peOrde                       10a   const
     D  pePosi                             likeds(keydev_t) const
     D  pePreg                             likeds(keydev_t)
     D  peUreg                             likeds(keydev_t)
     D  peLdev                             likeds(pawdvd_t) dim(99)
     D  peLdevC                      10i 0
     D  peLdet                             likeds(pawdvt_t) dim(10)
     D  peLdetC                      10i 0
     D  peFpro                       10a
     D  peHpro                        8a
     D  peCol1                       20a
     D  peCol2                       20a
     D  peCol3                       20a
     D  peMore                         n
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D WSLDEV          pi
     D  peBase                             likeds(paramBase) const
     D  peCant                       10i 0 const
     D  peRoll                        1a   const
     D  peOrde                       10a   const
     D  pePosi                             likeds(keydev_t) const
     D  pePreg                             likeds(keydev_t)
     D  peUreg                             likeds(keydev_t)
     D  peLdev                             likeds(pawdvd_t) dim(99)
     D  peLdevC                      10i 0
     D  peLdet                             likeds(pawdvt_t) dim(10)
     D  peLdetC                      10i 0
     D  peFpro                       10a
     D  peHpro                        8a
     D  peCol1                       20a
     D  peCol2                       20a
     D  peCol3                       20a
     D  peMore                         n
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D k0wdvd          ds                  likerec(p1wdvd:*key)
     D k1wdvd          ds                  likerec(p1wdvd:*key)
     D k2wdvd          ds                  likerec(p1wdvd01:*key)
     D k3wdvd          ds                  likerec(p1wdvd02:*key)
     D k1wdvt          ds                  likerec(p1wdvt:*key)

     D @@cant          s             10i 0
     D @@more          s               n
     D fulp            s              8a
     D @fech           s              8a
     D @hora           s              6a

      /free

       *inlr = *on;

       clear peLdev;
       clear peLdet;
       clear peMsgs;
       clear pePreg;
       clear peUreg;

       peLdevC = 0;
       peLdetC = 0;
       peErro  = 0;
       peCol1  = *blanks;
       peCol2  = *blanks;
       peCol3  = *blanks;
       peFpro = *blanks;
       peHpro = *blanks;
       peMore = *off;

       read tab007;
       if not %eof;
          @fech  = %editc(t4fecpro4:'X');
          peFpro = %subst(@fech:7:2)
                 + '/'
                 + %subst(@fech:5:2)
                 + '/'
                 + %subst(@fech:1:4);
          @hora  = %editc(t4horpro4:'X');
          peHpro = %subst(@hora:1:2)
                 + ':'
                 + %subst(@hora:3:2)
                 + ':'
                 + %subst(@hora:5:2);
       endif;

       @@more = *on;

       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       if not SVPWS_chkRoll ( peRoll : peMsgs );
          peErro = -1;
          return;
       endif;

       @@cant = peCant;
       if ((peCant <= *Zeros ) or (peCant > 99) );
          @@cant = 99;
       endif;

       if not SVPWS_chkOrde('WSLDEV' : peOrde : peMsgs);
          peErro = -1;
          return;
       endif;

       read pawdvi;
       if not %eof;
          peCol1 = vicol1;
          peCol2 = vicol2;
          peCol3 = vicol3;
       endif;

       // ----------------------------------------
       // Totales es estático y se llena siempre
       // ----------------------------------------
       k1wdvt.vtempr = peBase.peEmpr;
       k1wdvt.vtsucu = peBase.peSucu;
       k1wdvt.vtnivt = peBase.peNivt;
       k1wdvt.vtnivc = peBase.peNivc;
       setll %kds(k1wdvt:4) pawdvt;
       reade %kds(k1wdvt:4) pawdvt;
       dow not %eof;
           peLdetC += 1;
           peLdet(peLdetC).mone = vtmone;
           peLdet(peLdetC).dm90 = vtdm90;
           peLdet(peLdetC).dh90 = vtdh90;
           peLdet(peLdetC).dh60 = vtdh60;
           peLdet(peLdetC).dh30 = vtdh30;
           peLdet(peLdetC).deav = vtdeav;
           chain vtmone gntmon;
           if not %found;
              monmol = *blanks;
              monmoc = *blanks;
           endif;
           peLdet(peLdetC).nmol = monmol;
           peLdet(peLdetC).nmoc = monmoc;
           peLdet(peLdetC).dm90a= %trim(monmoc)
                             + %trim(%editw(vtdm90:' .   .   .   . 0 ,  '));
           peLdet(peLdetC).dh90a= %trim(monmoc)
                             + %trim(%editw(vtdh90:' .   .   .   . 0 ,  '));
           peLdet(peLdetC).dh60a= %trim(monmoc)
                             + %trim(%editw(vtdh60:' .   .   .   . 0 ,  '));
           peLdet(peLdetC).dh30a= %trim(monmoc)
                             + %trim(%editw(vtdh30:' .   .   .   . 0 ,  '));
           peLdet(peLdetC).deava= %trim(monmoc)
                             + %trim(%editw(vtdeav:' .   .   .   . 0 ,  '));
        reade %kds(k1wdvt:4) pawdvt;
       enddo;

      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       exsr leeArc;
       exsr priReg;

       dow ( ( not finArc ) and ( peLdevC < @@cant ) );

           peLdevC += 1;
           peLdev(peLdevC).rama = vdrama;
           chain vdrama set001;
           if not %found;
              t@ramd = *blanks;
           endif;
           peLdev(peLdevC).ramd = t@ramd;
           peLdev(peLdevC).poli = vdpoli;
           peLdev(peLdevC).suop = vdsuop;
           peLdev(peLdevC).asen = vdasen;
           peLdev(peLdevC).nase = vdnase;
           peLdev(peLdevC).fulp = vdfulp;
           fulp = %editc(vdfulp:'X');
           if vdfulp <> 0;
              peLdev(peLdevC).fulpa= %subst( fulp : 7 : 2)
                                   + '/'
                                   + %subst( fulp : 5 : 2)
                                   + '/'
                                   + %subst( fulp : 1 : 4);
            else;
              peLdev(peLdevC).fulpa= *blanks;
           endif;
           peLdev(peLdevC).ulcp = vdulcp;
           peLdev(peLdevC).ulcpa= %editc(vdulcp:'X');
           peLdev(peLdevC).cfpg = vdcfpg;
           peLdev(peLdevC).fopa = vdfopa;
           select;
            when vdfopa = 'CO';
                 peLdev(peLdevC).defp = 'COBRADOR';
            when vdfopa = 'TC';
                 peLdev(peLdevC).defp = 'TARJETA DE CREDITO';
            when vdfopa = 'DB';
                 peLdev(peLdevC).defp = 'DEBITO BANCARIO';
           endsl;
           peLdev(peLdevC).mone = vdmone;
           chain vdmone gntmon;
           if not %found;
              monmol = *blanks;
              monmoc = *blanks;
           endif;
           peLdev(peLdevC).nmol = monmol;
           peLdev(peLdevC).nmoc = monmoc;
           peLdev(peLdevC).dm90 = vddm90;
           peLdev(peLdevC).dm90a= %trim(monmoc)
                             + %trim(%editw(vddm90:' .   .   .   . 0 ,  '));
           peLdev(peLdevC).dh90 = vddh90;
           peLdev(peLdevC).dh90a= %trim(monmoc)
                             + %trim(%editw(vddh90:' .   .   .   . 0 ,  '));
           peLdev(peLdevC).dh60 = vddh60;
           peLdev(peLdevC).dh60a= %trim(monmoc)
                             + %trim(%editw(vddh60:' .   .   .   . 0 ,  '));
           peLdev(peLdevC).dh30 = vddh30;
           peLdev(peLdevC).dh30a= %trim(monmoc)
                             + %trim(%editw(vddh30:' .   .   .   . 0 ,  '));
           peLdev(peLdevC).deav = vddeav;
           peLdev(peLdevC).deava= %trim(monmoc)
                             + %trim(%editw(vddeav:' .   .   .   . 0 ,  '));

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

      *- Rutina de Posicionamiento de Archivo. Segun peOrde, pePosi, peRoll
       begsr posArc;

         k0wdvd.vdempr = peBase.peEmpr;
         k0wdvd.vdsucu = peBase.peSucu;
         k0wdvd.vdnivt = peBase.peNivt;
         k0wdvd.vdnivc = peBase.peNivc;

         select;
           when ( peOrde = 'RAMAPOLIZA' );
             k1wdvd.vdempr = peBase.peEmpr;
             k1wdvd.vdsucu = peBase.peSucu;
             k1wdvd.vdnivt = peBase.peNivt;
             k1wdvd.vdnivc = peBase.peNivc;
             k1wdvd.vdrama = pePosi.rama;
             k1wdvd.vdpoli = pePosi.poli;
             k1wdvd.vdsuop = pePosi.suop;
             k1wdvd.vdarcd = pePosi.arcd;
             k1wdvd.vdspol = pePosi.spol;
             k1wdvd.vdsspo = pePosi.sspo;
             if ( peRoll = 'F' );
               setgt %kds ( k1wdvd : 10) pawdvd;
             else;
               setll %kds ( k1wdvd : 10) pawdvd;
             endif;
           when ( peOrde = 'ASEGURADO' );
             k2wdvd.vdempr = peBase.peEmpr;
             k2wdvd.vdsucu = peBase.peSucu;
             k2wdvd.vdnivt = peBase.peNivt;
             k2wdvd.vdnivc = peBase.peNivc;
             k2wdvd.vdrama = pePosi.rama;
             k2wdvd.vdpoli = pePosi.poli;
             k2wdvd.vdsuop = pePosi.suop;
             k2wdvd.vdnase = pePosi.nase;
             k2wdvd.vdarcd = pePosi.arcd;
             k2wdvd.vdspol = pePosi.spol;
             k2wdvd.vdsspo = pePosi.sspo;
             if ( peRoll = 'F' );
               setgt %kds ( k2wdvd : 11) pawdvd01;
             else;
               setll %kds ( k2wdvd : 11) pawdvd01;
             endif;
           when ( peOrde = 'FORMAPAGO' );
             k3wdvd.vdempr = peBase.peEmpr;
             k3wdvd.vdsucu = peBase.peSucu;
             k3wdvd.vdnivt = peBase.peNivt;
             k3wdvd.vdnivc = peBase.peNivc;
             k3wdvd.vdrama = pePosi.rama;
             k3wdvd.vdpoli = pePosi.poli;
             k3wdvd.vdsuop = pePosi.suop;
             k3wdvd.vdfopa = pePosi.fopa;
             k3wdvd.vdarcd = pePosi.arcd;
             k3wdvd.vdspol = pePosi.spol;
             k3wdvd.vdsspo = pePosi.sspo;
             if ( peRoll = 'F' );
               setgt %kds ( k3wdvd : 11) pawdvd02;
             else;
               setll %kds ( k3wdvd : 11) pawdvd02;
             endif;
         endsl;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

         select;
           when ( peOrde = 'RAMAPOLIZA' );
             reade %kds ( k0wdvd : 4 ) pawdvd;
           when ( peOrde = 'ASEGURADO' );
             reade %kds ( k0wdvd : 4 ) pawdvd01;
           when ( peOrde = 'FORMAPAGO' );
             reade %kds ( k0wdvd : 4 ) pawdvd02;
         endsl;

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;

         select;
           when ( peOrde = 'RAMAPOLIZA' );
             readpe %kds ( k0wdvd : 4 ) pawdvd;
           when ( peOrde = 'ASEGURADO' );
             readpe %kds ( k0wdvd : 4 ) pawdvd01;
           when ( peOrde = 'FORMAPAGO' );
             readpe %kds ( k0wdvd : 4 ) pawdvd02;
         endsl;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

         select;
           when ( peOrde = 'RAMAPOLIZA' );
             setll %kds( k0wdvd : 4 ) pawdvd;
           when ( peOrde = 'ASEGURADO' );
             setll %kds( k0wdvd : 4 ) pawdvd01;
           when ( peOrde = 'FORMAPAGO' );
             setll %kds( k0wdvd : 4 ) pawdvd02;
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

         pePreg.rama = vdrama;
         pePreg.poli = vdpoli;
         pePreg.suop = vdsuop;
         pePreg.nase = vdnase;
         pePreg.fopa = vdfopa;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

         peUreg.rama = vdrama;
         peUreg.poli = vdpoli;
         peUreg.suop = vdsuop;
         peUreg.nase = vdnase;
         peUreg.fopa = vdfopa;

       endsr;

      *- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

         select;
           when ( peOrde = 'RAMAPOLIZA' );
             return %eof ( pawdvd );
           when ( peOrde = 'ASEGURADO' );
             return %eof ( pawdvd01 );
           when ( peOrde = 'FORMAPAGO' );
             return %eof ( pawdvd02 );
         endsl;

     P finArc          E
      /end-free
