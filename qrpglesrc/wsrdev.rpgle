     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRDEV: QUOM Versión 2                                       *
      *         Pólizas con Deuda Vencida                            *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *22-Jun-2017            *
      * ------------------------------------------------------------ *
      * LRG 02-02-2018: Se agrega nuevo parámetro para enviar        *
      *                 "Toda la Deuda" o "Deuda Vencida"            *
      * NWN - 01/06/2018 : Agregado de control por DXP021 mas Valor  *
      *                    del SISTEMA HDEVANULAD mas Variable       *
      *                    peTipo.                                   *
      * ************************************************************ *
     Fpawdvd    if   e           k disk
     Fpawdvd03  if   e           k disk    rename(p1wdvd:p1wdvd03)
     Fgntmon    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'

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
     D  peMore                        1n
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)
     D  peTipo                        1a   const options(*nopass:*omit)

     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D tipo            s              1a

     D uri             s            512a
     D url             s           3000a   varying
     D c               s             10i 0
     D rc              s              1n
     D rc2             s             10i 0
     D @@nit1          s              1  0
     D @@niv1          s              5  0
     D @@repl          s          65535a
     D fulp            s             10a
     D dm90            s             30a
     D dh90            s             30a
     D dh60            s             30a
     D dh30            s             30a
     D deav            s             30a
     D defp            s             50a

     D  pePosi         ds                  likeds(keydev_t)
     D  pePreg         ds                  likeds(keydev_t)
     D  peUreg         ds                  likeds(keydev_t)
     D  peLdev         ds                  likeds(pawdvd_t) dim(99)
     D  peLdevC        s             10i 0
     D  peLdet         ds                  likeds(pawdvt_t) dim(10)
     D  peLdetC        s             10i 0
     D  x              s             10i 0
     D  peFpro         s             10a
     D  peHpro         s              8a
     D  peCol1         s             20a
     D  peCol2         s             20a
     D  peCol3         s             20a
     D  peRoll         s              1a
     D  peErro         s             10i 0
     D  peMore         s              1n
     D  @i             s              5i 0
     D  @@dm90         s             15  2 dim(4)
     D  @@dh90         s             15  2 dim(4)
     D  @@dh60         s             15  2 dim(4)
     D  @@dh30         s             15  2 dim(4)
     D  @@deav         s             15  2 dim(4)
     D  AÑo            s              4  0
     D  Mes            s              2  0
     D  Dia            s              2  0
     D  s1anul         s              1a
     D  s1fpgm         s              3a
     D  peVsys         s            512

     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D k1wdvd          ds                  likerec(p1wdvd:*key)

     Ddxp021           pr                  extpgm('DXP021')
     D a                                   like(vdempr) const
     D a                                   like(vdsucu) const
     D a                                   like(vdarcd)
     D a                                   like(vdspol)
     D                                4  0
     D                                2  0
     D                                2  0
     D                                1a
     D                                3a

     D PAR310X3        pr                  extpgm('PAR310X3')
     D                                1a
     D                                4  0
     D                                2  0
     D                                2  0

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

      /free

       *inlr = *on;

       REST_getUri( psds.this : uri );
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       nivt = REST_getNextPart(url);
       nivc = REST_getNextPart(url);
       nit1 = REST_getNextPart(url);
       niv1 = REST_getNextPart(url);
       tipo = REST_getNextPart(url);

       if tipo <> 'T' and tipo <> 'V';
          tipo = 'T';
       endif;


          PAR310X3( peBase.peEmpr
                  : AÑo
                  : Mes
                  : Dia );

          SVPVLS_getValSys( 'HDEVANULAD'
                          : *omit
                          : peVsys);

       if SVPREST_chkBase(empr:sucu:nivt:nivc:nit1:niv1:peMsgs) = *off;
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          close *all;
          return;
       endif;

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'polizasDeudaVencida' : '*BEG');

       clear peBase;
       clear pePosi;
       clear pePreg;
       clear peUreg;
       clear peLdev;
       clear peLdet;
       clear peMsgs;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       COWLOG_logcon('WSRDEV':peBase);

       peRoll = 'I';

       // --------------------------------------
       // Primer llamada
       // --------------------------------------
       WSLDEV( peBase
             : 99
             : peRoll
             : 'RAMAPOLIZA'
             : pePosi
             : pePreg
             : peUreg
             : peLdev
             : peLdevC
             : peLdet
             : peLdetC
             : peFpro
             : peHpro
             : peCol1
             : peCol2
             : peCol3
             : peMore
             : peErro
             : peMsgs
             : tipo    );

       REST_writeXmlLine( 'cabecera' : '*BEG');
        REST_writeXmlLine( 'firstColumn' : %trim(peCol1) );
        REST_writeXmlLine( 'secondColumn': %trim(peCol2) );
        REST_writeXmlLine( 'thirdColumn' : %trim(peCol3) );
        REST_writeXmlLine( 'fechaProceso': %trim(peFpro) );
        REST_writeXmlLine( 'horaProceso' : %trim(peHpro) );
       REST_writeXmlLine( 'cabecera' : '*END');

       REST_writeXmlLine( 'detalles' : '*BEG');

       k1wdvd.vdempr = empr;
       k1wdvd.vdsucu = sucu;
       k1wdvd.vdnivt = %dec(nivt:1:0);
       k1wdvd.vdnivc = %dec(nivc:5:0);

       if tipo = 'T';
          setll %kds(k1wdvd:4) pawdvd;
          reade %kds(k1wdvd:4) pawdvd;
          dow not %eof;
              exsr graba_linea;
           reade %kds(k1wdvd:4) pawdvd;
          enddo;
        else;
          setll %kds(k1wdvd:4) pawdvd03;
          reade %kds(k1wdvd:4) pawdvd03;
          dow not %eof;
           if not polianul;
              exsr graba_linea;
           endif;
           reade %kds(k1wdvd:4) pawdvd03;
          enddo;
       endif;

       REST_writeXmlLine( 'detalles' : '*END');

       REST_writeXmlLine('totales': '*BEG');
       for x = 1 to peLdetC;
           select;
            when peLdet(x).mone = '00' or peLdet(x).mone = '01';
                 peLdet(x).dm90 = @@dm90(1);
                 peLdet(x).dh90 = @@dh90(1);
                 peLdet(x).dh60 = @@dh60(1);
                 peLdet(x).dh30 = @@dh30(1);
                 peLdet(x).deav = @@deav(1);
            when peLdet(x).mone = '51';
                 peLdet(x).dm90 = @@dm90(2);
                 peLdet(x).dh90 = @@dh90(2);
                 peLdet(x).dh60 = @@dh60(2);
                 peLdet(x).dh30 = @@dh30(2);
                 peLdet(x).deav = @@deav(2);
            when peLdet(x).mone = '17';
                 peLdet(x).dm90 = @@dm90(3);
                 peLdet(x).dh90 = @@dh90(3);
                 peLdet(x).dh60 = @@dh60(3);
                 peLdet(x).dh30 = @@dh30(3);
                 peLdet(x).deav = @@deav(3);
           endsl;
           dm90 = %editw(peLdet(x).dm90:'           0 .  ');
           if peLdet(x).dm90 = 0;
              dm90 = '.00';
           endif;
           dh90 = %editw(peLdet(x).dh90:'           0 .  ');
           if peLdet(x).dh90 = 0;
              dh90 = '.00';
           endif;
           if peLdet(x).dm90 < 0;
              dm90 = '-' + %trim(dm90);
           endif;
           dh60 = %editw(peLdet(x).dh60:'           0 .  ');
           if peLdet(x).dh60 = 0;
              dh60 = '.00';
           endif;
           if peLdet(x).dh60 < 0;
              dh60 = '-' + %trim(dh60);
           endif;
           dh30 = %editw(peLdet(x).dh30:'           0 .  ');
           if peLdet(x).dh30 = 0;
              dh30 = '.00';
           endif;
           if peLdet(x).dh30 < 0;
              dh30 = '-' + %trim(dh30);
           endif;
           deav = %editw(peLdet(x).deav:'           0 .  ');
           if peLdet(x).deav = 0;
              deav = '.00';
           endif;
           if peLdet(x).deav < 0;
              deav = '-' + %trim(deav);
           endif;
           REST_writeXmlLine( 'registro': '*BEG');
           REST_writeXmlLine( 'moneda': peLdet(x).nmol);
           REST_writeXmlLine( 'masDeNoventa': dm90);
           REST_writeXmlLine( 'hastaNoventa': dh90);
           REST_writeXmlLine( 'hastaSesenta': dh60);
           REST_writeXmlLine( 'hastaTreinta': dh30);
           REST_writeXmlLine( 'aVencer'     : deav);
           REST_writeXmlLine( 'registro': '*END');
       endfor;

       REST_writeXmlLine('totales': '*END');
       REST_writeXmlLine( 'polizasDeudaVencida' : '*END');

       REST_end();

       close *all;

       return;

       begsr graba_linea;

        dm90 = %editw(vddm90:'           0 .  ');
        if vddm90 = 0;
           dm90 = '.00';
        endif;
        if vddm90 < 0;
           dm90 = '-' + %trim(dm90);
        endif;

        dh90 = %editw(vddh90:'           0 .  ');
        if vddh90 = 0;
           dh90 = '.00';
        endif;
        if vddh90 < 0;
           dh90 = '-' + %trim(dh90);
        endif;

        dh60 = %editw(vddh60:'           0 .  ');
        if vddh60 = 0;
           dh60 = '.00';
        endif;
        if vddh60 < 0;
           dh60 = '-' + %trim(dh60);
        endif;

        dh30 = %editw(vddh30:'           0 .  ');
        if vddh30 = 0;
           dh30 = '.00';
        endif;
        if vddh30 < 0;
           dh30 = '-' + %trim(dh30);
        endif;

        deav = %editw(vddeav:'           0 .  ');
        if vddeav = 0;
           deav = '.00';
        endif;
        if vddeav < 0;
           deav = '-' + %trim(deav);
        endif;

        monitor;
          fulp = %char(%date(vdfulp:*iso):*iso);
         on-error;
          fulp = '00000000';
        endmon;

        REST_writeXmlLine( 'detalle': '*BEG');
        REST_writeXmlLine( 'rama': %char(vdrama));
        REST_writeXmlLine( 'poliza' : %char(vdpoli) );
        REST_writeXmlLine( 'suplem' : %char(vdsuop) );
        REST_writeXmlLine( 'asegurado' : vdnase );
        select;
         when vdfopa = 'CO';
              defp = 'COBRADOR';
         when vdfopa = 'TC';
              defp = 'TARJETA DE CREDITO';
         when vdfopa = 'DB';
              defp = 'DEBITO BANCARIO';
        endsl;
        REST_writeXmlLine( 'formaPago' : defp );
        chain vdmone gntmon;
        if not %found;
           monmol = *blanks;
        endif;
        REST_writeXmlLine( 'moneda' : monmol );
        REST_writeXmlLine( 'impagoDesde' : fulp );
        REST_writeXmlLine( 'masDeNoventa': dm90);
        REST_writeXmlLine( 'hastaNoventa': dh90);
        REST_writeXmlLine( 'hastaSesenta': dh60);
        REST_writeXmlLine( 'hastaTreinta': dh30);
        REST_writeXmlLine( 'aVencer'     : deav);
        REST_writeXmlLine( 'detalle': '*END');

        select;
         when vdmone = '00' or vdmone = '01';
              @i = 1;
         when vdmone = '51';
              @i = 2;
         when vdmone = '17';
              @i = 3;
        endsl;

        @@dm90(@i) += vddm90;
        @@dh90(@i) += vddh90;
        @@dh60(@i) += vddh60;
        @@dh30(@i) += vddh30;
        @@deav(@i) += vddeav;

       endsr;

      /end-free
     P Polianul        B
     D Polianul        pi              n
      *- Rutina que determina si esta anulada o no la Póliza...

          s1anul = ' ';
          s1fpgm = ' ';

          callp dxp021( peBase.peEmpr
                      : peBase.peSucu
                      : vdarcd
                      : vdspol
                      : AÑo
                      : Mes
                      : Dia
                      : s1anul
                      : s1fpgm);

        if Tipo = 'V';
          if s1anul = 'A' and peVsys = 'N';
            return *on;
          endif;
        endif;

       return *off;

     P Polianul        E
