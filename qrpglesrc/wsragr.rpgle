     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRAGR: Producción Por Artículos                             *
      *         Producción diaria por servicio rest (agrupada)       *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *27-Mar-2018            *
      * ------------------------------------------------------------ *
      * Modificacion:                                                *
      * LRG 21-22-2019 : Se modifica edicion de campor de porcentaje *
      * ************************************************************ *
     Fpahec105  if   e           k disk
     Fpahed0    if   e           k disk
     Fpahed3    if   e           k disk
     Fset001    if   e           k disk
     Fsahint    if   e           k disk
     Fctw00003  if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'

     D fech            s             10a
     D empr            s              1a
     D sucu            s              2a
     D aÑo             s              4a
     D mes             s              2a
     D dia             s              2a
     D aÑon            s              4  0
     D mesn            s              2  0
     D dian            s              2  0
     D femi            s              8  0
     D fem2            s              8  0
     D uri             s            512a
     D url             s           3000a   varying
     D x               s              5i 0
     D rc              s              1n
     D @@comi          s             15  2
     D @@reca          s             15  2
     D @@aux           s             30  9
     D @@aux3          s              8  2
     D @@ramd          s             30a
     D aux3            s             12a
     D aux4            s             12a
     D aux5            s             12a
     D aux6            s             12a
     D prim            s             30a
     D primm           s             30a
     D prre            s             30a
     D prrem           s             30a
     D comi            s             30a
     D comim           s             30a

     D k1hec1          ds                  likerec(p1hec105:*key)
     D k1hed0          ds                  likerec(p1hed0:*key)
     D k1hed3          ds                  likerec(p1hed3:*key)
     D k1hint          ds                  likerec(s2hint:*key)
     D k1w000          ds                  likerec(c1w000:*key)

      * ------------------------------------------------------------ *
      * Fronting
      * ------------------------------------------------------------ *
     D frontm          ds                  dim(100) qualified inz
     D  rama                          2  0
     D  cant                         10i 0
     D  prim                         15  2
     D  reca                         15  2
     D  prre                         15  2
     D  comi                         15  2
     D  cantm                        10i 0
     D  primm                        15  2
     D  recam                        15  2
     D  prrem                        15  2
     D  comim                        15  2

      * ------------------------------------------------------------ *
      * Bancos
      * ------------------------------------------------------------ *
     D bancom          ds                  dim(100) qualified inz
     D  rama                          2  0
     D  cant                         10i 0
     D  prim                         15  2
     D  reca                         15  2
     D  prre                         15  2
     D  comi                         15  2
     D  cantm                        10i 0
     D  primm                        15  2
     D  recam                        15  2
     D  prrem                        15  2
     D  comim                        15  2

      * ------------------------------------------------------------ *
      * Resto CF + GBA 1
      * ------------------------------------------------------------ *
     D restom          ds                  dim(100) qualified inz
     D  rama                          2  0
     D  cant                         10i 0
     D  prim                         15  2
     D  reca                         15  2
     D  prre                         15  2
     D  comi                         15  2
     D  cantm                        10i 0
     D  primm                        15  2
     D  recam                        15  2
     D  prrem                        15  2
     D  comim                        15  2

      * ------------------------------------------------------------ *
      * Resto Interior
      * ------------------------------------------------------------ *
     D interm          ds                  dim(100) qualified inz
     D  rama                          2  0
     D  cant                         10i 0
     D  prim                         15  2
     D  reca                         15  2
     D  prre                         15  2
     D  comi                         15  2
     D  cantm                        10i 0
     D  primm                        15  2
     D  recam                        15  2
     D  prrem                        15  2
     D  comim                        15  2

      * ------------------------------------------------------------ *
      * WEB
      * ------------------------------------------------------------ *
     D opwebm          ds                  dim(100) qualified inz
     D  rama                          2  0
     D  cant                         10i 0
     D  prim                         15  2
     D  reca                         15  2
     D  prre                         15  2
     D  comi                         15  2
     D  cantm                        10i 0
     D  primm                        15  2
     D  recam                        15  2
     D  prrem                        15  2
     D  comim                        15  2

      * ------------------------------------------------------------ *
      * API
      * ------------------------------------------------------------ *
     D opapim          ds                  dim(100) qualified inz
     D  rama                          2  0
     D  cant                         10i 0
     D  prim                         15  2
     D  reca                         15  2
     D  prre                         15  2
     D  comi                         15  2
     D  cantm                        10i 0
     D  primm                        15  2
     D  recam                        15  2
     D  prrem                        15  2
     D  comim                        15  2

      * ------------------------------------------------------------ *
      * General
      * ------------------------------------------------------------ *
     D generm          ds                  dim(100) qualified inz
     D  rama                          2  0
     D  cant                         10i 0
     D  prim                         15  2
     D  reca                         15  2
     D  prre                         15  2
     D  comi                         15  2
     D  cantm                        10i 0
     D  primm                        15  2
     D  recam                        15  2
     D  prrem                        15  2
     D  comim                        15  2

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

      /free

       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       fech = REST_getNextPart(url);

       aÑo  = %subst(fech:1:4);
       mes  = %subst(fech:6:2);
       dia  = %subst(fech:9:2);
       aÑon = %dec(aÑo:4:0);
       mesn = %dec(mes:2:0);
       dian = %dec(dia:2:0);
       femi = (aÑon * 10000) + (mesn * 100) + dian;
       fem2 = (aÑon * 10000) + (mesn * 100) + 1;

       k1hec1.c1empr = empr;
       k1hec1.c1sucu = sucu;
       k1hec1.c1femi = fem2;

       setll %kds(k1hec1:3) pahec105;
       reade %kds(k1hec1:2) pahec105;
       dow not %eof;

           if c1femi <= femi;
              k1hed0.d0empr = c1empr;
              k1hed0.d0sucu = c1sucu;
              k1hed0.d0arcd = c1arcd;
              k1hed0.d0spol = c1spol;
              k1hed0.d0sspo = c1sspo;
              setll %kds(k1hed0:5) pahed0;
              reade %kds(k1hed0:5) pahed0;
              dow not %eof;

               if d0ciap = '1';
                  if d0come <= 0;
                     d0come = 1;
                  endif;

                  d0prim *= d0come;
                  d0bpri *= d0come;
                  d0dere *= d0come;
                  d0read *= d0come;
                  d0refi *= d0come;

                  @@reca = d0read + d0refi + d0dere;
                  @@comi = 0;
                  k1hed3.d3empr = d0empr;
                  k1hed3.d3sucu = d0sucu;
                  k1hed3.d3arcd = d0arcd;
                  k1hed3.d3spol = d0spol;
                  k1hed3.d3sspo = d0sspo;
                  k1hed3.d3rama = d0rama;
                  k1hed3.d3arse = d0arse;
                  k1hed3.d3oper = d0oper;
                  k1hed3.d3suop = d0suop;
                  setll %kds(k1hed3:9) pahed3;
                  reade %kds(k1hed3:9) pahed3;
                  dow not %eof;
                      d3copr *= d0come;
                      d3ccob *= d0come;
                      d3cfno *= d0come;
                      d3cfnn *= d0come;
                      @@comi += d3copr + d3ccob + d3cfno + d3cfnn;
                   reade %kds(k1hed3:9) pahed3;
                  enddo;

                  exsr sr_acum;
                  exsr acum_gral;

               endif;

               reade %kds(k1hed0:5) pahed0;
              enddo;
           endif;

        reade %kds(k1hec1:2) pahec105;
       enddo;

       REST_writeHeader();
       REST_writeEncoding();

       REST_writeXmlLine( 'produccionDiaria' : '*BEG' );

       // ----------------------------------------------
       // Imprime Fronting
       // ----------------------------------------------
       REST_writeXmlLine( 'agrupamiento' : '*BEG' );
       REST_writeXmlLine( 'nombre' : 'TOTAL FRONTING' );
       REST_writeXmlLine( 'lineas' : '*BEG' );
       for x = 1 to 100;
        if frontm(x).rama <> 0;
         chain frontm(x).rama set001;
         if not %found;
            t@ramd = *blanks;
         endif;
         @@ramd = %editc(frontm(x).rama:'X')
                + ' '
                + %trim(t@ramd);
         if x = 100;
            @@ramd = 'Totales:';
         endif;
         if frontm(x).prim <> 0;
            @@aux  = (frontm(x).reca/frontm(x).prim) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux3 = '.00';
          else;
            aux3 = %trim(SVPREST_editImporte( @@aux3 ));
         endif;
         if frontm(x).prim = 0;
            prim = '.00';
          else;
            prim = %editw(frontm(x).prim: '               0 .  ' );
            if frontm(x).prim < 0;
               prim = '-' + %trim(prim);
            endif;
         endif;
         if frontm(x).primm = 0;
            primm = '.00';
          else;
            primm = %editw(frontm(x).primm: '               0 .  ' );
            if frontm(x).primm < 0;
               primm = '-' + %trim(primm);
            endif;
         endif;
         if frontm(x).prre = 0;
            prre = '.00';
          else;
            prre = %editw(frontm(x).prre: '               0 .  ' );
            if frontm(x).prre < 0;
               prre = '-' + %trim(prre);
            endif;
         endif;
         if frontm(x).prrem = 0;
            prrem = '.00';
          else;
            prrem = %editw(frontm(x).prrem: '               0 .  ' );
            if frontm(x).prrem < 0;
               prrem = '-' + %trim(prrem);
            endif;
         endif;
         if frontm(x).comi = 0;
            comi = '.00';
          else;
            comi = %editw(frontm(x).comi: '               0 .  ' );
            if frontm(x).comi < 0;
               comi = '-' + %trim(comi);
            endif;
         endif;
         if frontm(x).comim = 0;
            comim = '.00';
          else;
            comim = %editw(frontm(x).comim: '               0 .  ' );
            if frontm(x).comim < 0;
               comim = '-' + %trim(comim);
            endif;
         endif;

         if frontm(x).prim <> 0;
            @@aux  = (frontm(x).comi/frontm(x).prim) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux4 = '.00';
          else;
            aux4 = %trim(SVPREST_editImporte( @@aux3 ));
         endif;

         if frontm(x).primm <> 0;
            @@aux  = (frontm(x).recam/frontm(x).primm) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux5 = '.00';
          else;
            aux5 = %trim(SVPREST_editImporte( @@aux3 ));
         endif;

         if frontm(x).primm <> 0;
            @@aux  = (frontm(x).comim/frontm(x).primm) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux6 = '.00';
          else;
            aux6 = %trim(SVPREST_editImporte( @@aux3 ));
         endif;

         REST_writeXmlLine( 'linea' : '*BEG' );
         REST_writeXmlLine( 'rama' : %trim(@@ramd) );

         REST_writeXmlLine( 'cantidadDiaria' : %char(frontm(x).cant) );
         REST_writeXmlLine( 'primaNetaDiaria': %trim(prim) );
         REST_writeXmlLine( 'porcDiario': %trim(aux3) );
         REST_writeXmlLine( 'primaMasRecDiaria': %trim(prre) );
         REST_writeXmlLine( 'porcComiDiario': %trim(aux4) );
         REST_writeXmlLine( 'comisionDiaria': %trim(comi) );

         REST_writeXmlLine( 'cantidadMensual' : %char(frontm(x).cantm) );
         REST_writeXmlLine( 'primaNetaMensual': %trim(primm) );
         REST_writeXmlLine( 'porcMensual': %trim(aux5) );
         REST_writeXmlLine( 'primaMasRecMensual': %trim(prrem) );
         REST_writeXmlLine( 'comisionMensual': %trim(comim) );
         REST_writeXmlLine( 'porcComiMensual': %trim(aux6) );

         REST_writeXmlLine( 'linea' : '*END' );
        endif;
       endfor;

       REST_writeXmlLine( 'lineas' : '*END' );
       REST_writeXmlLine( 'agrupamiento' : '*END' );

       // ----------------------------------------------
       // Imprime Bancos
       // ----------------------------------------------
       REST_writeXmlLine( 'agrupamiento' : '*BEG' );
       REST_writeXmlLine( 'nombre' : 'TOTAL BANCOS' );
       REST_writeXmlLine( 'lineas' : '*BEG' );
       for x = 1 to 100;
        if bancom(x).rama <> 0;
         chain bancom(x).rama set001;
         if not %found;
            t@ramd = *blanks;
         endif;
         @@ramd = %editc(bancom(x).rama:'X')
                + ' '
                + %trim(t@ramd);
         if x = 100;
            @@ramd = 'Totales:';
         endif;
         if bancom(x).prim <> 0;
            @@aux  = (bancom(x).reca/bancom(x).prim) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux3 = '.00';
          else;
            aux3 = %trim(SVPREST_editImporte( @@aux3 ));
         endif;
         if bancom(x).prim = 0;
            prim = '.00';
          else;
            prim = %editw(bancom(x).prim: '               0 .  ' );
            if bancom(x).prim < 0;
               prim = '-' + %trim(prim);
            endif;
         endif;
         if bancom(x).primm = 0;
            primm = '.00';
          else;
            primm = %editw(bancom(x).primm: '               0 .  ' );
            if bancom(x).primm < 0;
               primm = '-' + %trim(primm);
            endif;
         endif;
         if bancom(x).prre = 0;
            prre = '.00';
          else;
            prre = %editw(bancom(x).prre: '               0 .  ' );
            if bancom(x).prre < 0;
               prre = '-' + %trim(prre);
            endif;
         endif;
         if bancom(x).prrem = 0;
            prrem = '.00';
          else;
            prrem = %editw(bancom(x).prrem: '               0 .  ' );
            if bancom(x).prrem < 0;
               prrem = '-' + %trim(prrem);
            endif;
         endif;
         if bancom(x).comi = 0;
            comi = '.00';
          else;
            comi = %editw(bancom(x).comi: '               0 .  ' );
            if bancom(x).comi < 0;
               comi = '-' + %trim(comi);
            endif;
         endif;
         if bancom(x).comim = 0;
            comim = '.00';
          else;
            comim = %editw(bancom(x).comim: '               0 .  ' );
            if bancom(x).comim < 0;
               comim = '-' + %trim(comim);
            endif;
         endif;

         if bancom(x).prim <> 0;
            @@aux  = (bancom(x).comi/bancom(x).prim) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux4 = '.00';
          else;
            aux4 = %trim(SVPREST_editImporte( @@aux3 ));
         endif;

         if bancom(x).primm <> 0;
            @@aux  = (bancom(x).recam/bancom(x).primm) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux5 = '.00';
          else;
            aux5 = %trim(SVPREST_editImporte( @@aux3 ));
         endif;

         if bancom(x).primm <> 0;
            @@aux  = (bancom(x).comim/bancom(x).primm) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux6 = '.00';
          else;
            aux6 = %trim(SVPREST_editImporte( @@aux3 ));
         endif;

         REST_writeXmlLine( 'linea' : '*BEG' );
         REST_writeXmlLine( 'rama' : %trim(@@ramd) );

         REST_writeXmlLine( 'cantidadDiaria' : %char(bancom(x).cant) );
         REST_writeXmlLine( 'primaNetaDiaria': %trim(prim) );
         REST_writeXmlLine( 'porcDiario': %trim(aux3) );
         REST_writeXmlLine( 'primaMasRecDiaria': %trim(prre) );
         REST_writeXmlLine( 'porcComiDiario': %trim(aux4) );
         REST_writeXmlLine( 'comisionDiaria': %trim(comi) );

         REST_writeXmlLine( 'cantidadMensual' : %char(bancom(x).cantm) );
         REST_writeXmlLine( 'primaNetaMensual': %trim(primm) );
         REST_writeXmlLine( 'porcMensual': %trim(aux5) );
         REST_writeXmlLine( 'primaMasRecMensual': %trim(prrem) );
         REST_writeXmlLine( 'comisionMensual': %trim(comim) );
         REST_writeXmlLine( 'porcComiMensual': %trim(aux6) );

         REST_writeXmlLine( 'linea' : '*END' );
        endif;
       endfor;

       REST_writeXmlLine( 'lineas' : '*END' );
       REST_writeXmlLine( 'agrupamiento' : '*END' );

       // ----------------------------------------------
       // Imprime RESTO CF + GBA1
       // ----------------------------------------------
       REST_writeXmlLine( 'agrupamiento' : '*BEG' );
       REST_writeXmlLine( 'nombre' : 'TOTAL RESTO CF + GBA1');
       REST_writeXmlLine( 'lineas' : '*BEG' );
       for x = 1 to 100;
        if restom(x).rama <> 0;
         chain restom(x).rama set001;
         if not %found;
            t@ramd = *blanks;
         endif;
         @@ramd = %editc(restom(x).rama:'X')
                + ' '
                + %trim(t@ramd);
         if x = 100;
            @@ramd = 'Totales:';
         endif;
         if restom(x).prim <> 0;
            @@aux  = (restom(x).reca/restom(x).prim) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux3 = '.00';
          else;
            aux3 = %trim(SVPREST_editImporte( @@aux3 ));
         endif;
         if restom(x).prim = 0;
            prim = '.00';
          else;
            prim = %editw(restom(x).prim: '               0 .  ' );
            if restom(x).prim < 0;
               prim = '-' + %trim(prim);
            endif;
         endif;
         if restom(x).primm = 0;
            primm = '.00';
          else;
            primm = %editw(restom(x).primm: '               0 .  ' );
            if restom(x).primm < 0;
               primm = '-' + %trim(primm);
            endif;
         endif;
         if restom(x).prre = 0;
            prre = '.00';
          else;
            prre = %editw(restom(x).prre: '               0 .  ' );
            if restom(x).prre < 0;
               prre = '-' + %trim(prre);
            endif;
         endif;
         if restom(x).prrem = 0;
            prrem = '.00';
          else;
            prrem = %editw(restom(x).prrem: '               0 .  ' );
            if restom(x).prrem < 0;
               prrem = '-' + %trim(prrem);
            endif;
         endif;
         if restom(x).comi = 0;
            comi = '.00';
          else;
            comi = %editw(restom(x).comi: '               0 .  ' );
            if restom(x).comi < 0;
               comi = '-' + %trim(comi);
            endif;
         endif;
         if restom(x).comim = 0;
            comim = '.00';
          else;
            comim = %editw(restom(x).comim: '               0 .  ' );
            if restom(x).comim < 0;
               comim = '-' + %trim(comim);
            endif;
         endif;

         if restom(x).prim <> 0;
            @@aux  = (restom(x).comi/restom(x).prim) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux4 = '.00';
          else;
            aux4 = %trim(SVPREST_editImporte( @@aux3 ));
         endif;

         if restom(x).primm <> 0;
            @@aux  = (restom(x).recam/restom(x).primm) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux5 = '.00';
          else;
            aux5 = %trim(SVPREST_editImporte( @@aux3 ));
         endif;

         if restom(x).primm <> 0;
            @@aux  = (restom(x).comim/restom(x).primm) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux6 = '.00';
          else;
            aux6 = %trim(SVPREST_editImporte( @@aux3 ));
         endif;

         REST_writeXmlLine( 'linea' : '*BEG' );
         REST_writeXmlLine( 'rama' : %trim(@@ramd) );

         REST_writeXmlLine( 'cantidadDiaria' : %char(restom(x).cant) );
         REST_writeXmlLine( 'primaNetaDiaria': %trim(prim) );
         REST_writeXmlLine( 'porcDiario': %trim(aux3) );
         REST_writeXmlLine( 'primaMasRecDiaria': %trim(prre) );
         REST_writeXmlLine( 'porcComiDiario': %trim(aux4) );
         REST_writeXmlLine( 'comisionDiaria': %trim(comi) );

         REST_writeXmlLine( 'cantidadMensual' : %char(restom(x).cantm) );
         REST_writeXmlLine( 'primaNetaMensual': %trim(primm) );
         REST_writeXmlLine( 'porcMensual': %trim(aux5) );
         REST_writeXmlLine( 'primaMasRecMensual': %trim(prrem) );
         REST_writeXmlLine( 'comisionMensual': %trim(comim) );
         REST_writeXmlLine( 'porcComiMensual': %trim(aux6) );

         REST_writeXmlLine( 'linea' : '*END' );
        endif;
       endfor;

       REST_writeXmlLine( 'lineas' : '*END' );
       REST_writeXmlLine( 'agrupamiento' : '*END' );

       // ----------------------------------------------
       // Imprime Resto Interior
       // ----------------------------------------------
       REST_writeXmlLine( 'agrupamiento' : '*BEG' );
       REST_writeXmlLine( 'nombre' : 'TOTAL RESTO GBA2 + INTERIOR');
       REST_writeXmlLine( 'lineas' : '*BEG' );
       for x = 1 to 100;
        if interm(x).rama <> 0;
         chain interm(x).rama set001;
         if not %found;
            t@ramd = *blanks;
         endif;
         @@ramd = %editc(interm(x).rama:'X')
                + ' '
                + %trim(t@ramd);
         if x = 100;
            @@ramd = 'Totales:';
         endif;
         if interm(x).prim <> 0;
            @@aux  = (interm(x).reca/interm(x).prim) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux3 = '.00';
          else;
            aux3 = %editw(@@aux3:'    0 .  ');
         endif;
         if interm(x).prim = 0;
            prim = '.00';
          else;
            prim = %editw(interm(x).prim: '               0 .  ' );
            if interm(x).prim < 0;
               prim = '-' + %trim(prim);
            endif;
         endif;
         if interm(x).primm = 0;
            primm = '.00';
          else;
            primm = %editw(interm(x).primm: '               0 .  ' );
            if interm(x).primm < 0;
               primm = '-' + %trim(primm);
            endif;
         endif;
         if interm(x).prre = 0;
            prre = '.00';
          else;
            prre = %editw(interm(x).prre: '               0 .  ' );
            if interm(x).prre < 0;
               prre = '-' + %trim(prre);
            endif;
         endif;
         if interm(x).prrem = 0;
            prrem = '.00';
          else;
            prrem = %editw(interm(x).prrem: '               0 .  ' );
            if interm(x).prrem < 0;
               prrem = '-' + %trim(prrem);
            endif;
         endif;
         if interm(x).comi = 0;
            comi = '.00';
          else;
            comi = %editw(interm(x).comi: '               0 .  ' );
            if interm(x).comi < 0;
               comi = '-' + %trim(comi);
            endif;
         endif;
         if interm(x).comim = 0;
            comim = '.00';
          else;
            comim = %editw(interm(x).comim: '               0 .  ' );
            if interm(x).comim < 0;
               comim = '-' + %trim(comim);
            endif;
         endif;

         if interm(x).prim <> 0;
            @@aux  = (interm(x).comi/interm(x).prim) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux4 = '.00';
          else;
            aux4 = %editw(@@aux3:'    0 .  ');
         endif;

         if interm(x).primm <> 0;
            @@aux  = (interm(x).recam/interm(x).primm) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux5 = '.00';
          else;
            aux5 = %editw(@@aux3:'    0 .  ');
         endif;

         if interm(x).primm <> 0;
            @@aux  = (interm(x).comim/interm(x).primm) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux6 = '.00';
          else;
            aux6 = %editw(@@aux3:'    0 .  ');
         endif;

         REST_writeXmlLine( 'linea' : '*BEG' );
         REST_writeXmlLine( 'rama' : %trim(@@ramd) );

         REST_writeXmlLine( 'cantidadDiaria' : %char(interm(x).cant) );
         REST_writeXmlLine( 'primaNetaDiaria': %trim(prim) );
         REST_writeXmlLine( 'porcDiario': %trim(aux3) );
         REST_writeXmlLine( 'primaMasRecDiaria': %trim(prre) );
         REST_writeXmlLine( 'porcComiDiario': %trim(aux4) );
         REST_writeXmlLine( 'comisionDiaria': %trim(comi) );

         REST_writeXmlLine( 'cantidadMensual' : %char(interm(x).cantm) );
         REST_writeXmlLine( 'primaNetaMensual': %trim(primm) );
         REST_writeXmlLine( 'porcMensual': %trim(aux5) );
         REST_writeXmlLine( 'primaMasRecMensual': %trim(prrem) );
         REST_writeXmlLine( 'comisionMensual': %trim(comim) );
         REST_writeXmlLine( 'porcComiMensual': %trim(aux6) );

         REST_writeXmlLine( 'linea' : '*END' );
        endif;
       endfor;

       REST_writeXmlLine( 'lineas' : '*END' );
       REST_writeXmlLine( 'agrupamiento' : '*END' );

       // ----------------------------------------------
       // Imprime WEB
       // ----------------------------------------------
       REST_writeXmlLine( 'agrupamiento' : '*BEG' );
       REST_writeXmlLine( 'nombre' : 'TOTAL WEB (QUOM)');
       REST_writeXmlLine( 'lineas' : '*BEG' );
       for x = 1 to 100;
        if opwebm(x).rama <> 0;
         chain opwebm(x).rama set001;
         if not %found;
            t@ramd = *blanks;
         endif;
         @@ramd = %editc(opwebm(x).rama:'X')
                + ' '
                + %trim(t@ramd);
         if x = 100;
            @@ramd = 'Totales:';
         endif;
         if opwebm(x).prim <> 0;
            @@aux  = (opwebm(x).reca/opwebm(x).prim) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux3 = '.00';
          else;
            aux3 = %editw(@@aux3:'    0 .  ');
         endif;
         if opwebm(x).prim = 0;
            prim = '.00';
          else;
            prim = %editw(opwebm(x).prim: '               0 .  ' );
            if opwebm(x).prim < 0;
               prim = '-' + %trim(prim);
            endif;
         endif;
         if opwebm(x).primm = 0;
            primm = '.00';
          else;
            primm = %editw(opwebm(x).primm: '               0 .  ' );
            if opwebm(x).primm < 0;
               primm = '-' + %trim(primm);
            endif;
         endif;
         if opwebm(x).prre = 0;
            prre = '.00';
          else;
            prre = %editw(opwebm(x).prre: '               0 .  ' );
            if opwebm(x).prre < 0;
               prre = '-' + %trim(prre);
            endif;
         endif;
         if opwebm(x).prrem = 0;
            prrem = '.00';
          else;
            prrem = %editw(opwebm(x).prrem: '               0 .  ' );
            if opwebm(x).prrem < 0;
               prrem = '-' + %trim(prrem);
            endif;
         endif;
         if opwebm(x).comi = 0;
            comi = '.00';
          else;
            comi = %editw(opwebm(x).comi: '               0 .  ' );
            if opwebm(x).comi < 0;
               comi = '-' + %trim(comi);
            endif;
         endif;
         if opwebm(x).comim = 0;
            comim = '.00';
          else;
            comim = %editw(opwebm(x).comim: '               0 .  ' );
            if opwebm(x).comim < 0;
               comim = '-' + %trim(comim);
            endif;
         endif;

         if opwebm(x).prim <> 0;
            @@aux  = (opwebm(x).comi/opwebm(x).prim) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux4 = '.00';
          else;
            aux4 = %editw(@@aux3:'    0 .  ');
         endif;

         if opwebm(x).primm <> 0;
            @@aux  = (opwebm(x).recam/opwebm(x).primm) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux5 = '.00';
          else;
            aux5 = %editw(@@aux3:'    0 .  ');
         endif;

         if opwebm(x).primm <> 0;
            @@aux  = (opwebm(x).comim/opwebm(x).primm) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux6 = '.00';
          else;
            aux6 = %editw(@@aux3:'    0 .  ');
         endif;

         REST_writeXmlLine( 'linea' : '*BEG' );
         REST_writeXmlLine( 'rama' : %trim(@@ramd) );

         REST_writeXmlLine( 'cantidadDiaria' : %char(opwebm(x).cant) );
         REST_writeXmlLine( 'primaNetaDiaria': %trim(prim) );
         REST_writeXmlLine( 'porcDiario': %trim(aux3) );
         REST_writeXmlLine( 'primaMasRecDiaria': %trim(prre) );
         REST_writeXmlLine( 'porcComiDiario': %trim(aux4) );
         REST_writeXmlLine( 'comisionDiaria': %trim(comi) );

         REST_writeXmlLine( 'cantidadMensual' : %char(opwebm(x).cantm) );
         REST_writeXmlLine( 'primaNetaMensual': %trim(primm) );
         REST_writeXmlLine( 'porcMensual': %trim(aux5) );
         REST_writeXmlLine( 'primaMasRecMensual': %trim(prrem) );
         REST_writeXmlLine( 'comisionMensual': %trim(comim) );
         REST_writeXmlLine( 'porcComiMensual': %trim(aux6) );

         REST_writeXmlLine( 'linea' : '*END' );
        endif;
       endfor;

       REST_writeXmlLine( 'lineas' : '*END' );
       REST_writeXmlLine( 'agrupamiento' : '*END' );

       // ----------------------------------------------
       // Imprime API
       // ----------------------------------------------
       REST_writeXmlLine( 'agrupamiento' : '*BEG' );
       REST_writeXmlLine( 'nombre' : 'TOTAL WEBSERVICES/API');
       REST_writeXmlLine( 'lineas' : '*BEG' );
       for x = 1 to 100;
        if opapim(x).rama <> 0;
         chain opapim(x).rama set001;
         if not %found;
            t@ramd = *blanks;
         endif;
         @@ramd = %editc(opapim(x).rama:'X')
                + ' '
                + %trim(t@ramd);
         if x = 100;
            @@ramd = 'Totales:';
         endif;
         if opapim(x).prim <> 0;
            @@aux  = (opapim(x).reca/opapim(x).prim) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux3 = '.00';
          else;
            aux3 = %editw(@@aux3:'    0 .  ');
         endif;
         if opapim(x).prim = 0;
            prim = '.00';
          else;
            prim = %editw(opapim(x).prim: '               0 .  ' );
            if opapim(x).prim < 0;
               prim = '-' + %trim(prim);
            endif;
         endif;
         if opapim(x).primm = 0;
            primm = '.00';
          else;
            primm = %editw(opapim(x).primm: '               0 .  ' );
            if opapim(x).primm < 0;
               primm = '-' + %trim(primm);
            endif;
         endif;
         if opapim(x).prre = 0;
            prre = '.00';
          else;
            prre = %editw(opapim(x).prre: '               0 .  ' );
            if opapim(x).prre < 0;
               prre = '-' + %trim(prre);
            endif;
         endif;
         if opapim(x).prrem = 0;
            prrem = '.00';
          else;
            prrem = %editw(opapim(x).prrem: '               0 .  ' );
            if opapim(x).prrem < 0;
               prrem = '-' + %trim(prrem);
            endif;
         endif;
         if opapim(x).comi = 0;
            comi = '.00';
          else;
            comi = %editw(opapim(x).comi: '               0 .  ' );
            if opapim(x).comi < 0;
               comi = '-' + %trim(comi);
            endif;
         endif;
         if opapim(x).comim = 0;
            comim = '.00';
          else;
            comim = %editw(opapim(x).comim: '               0 .  ' );
            if opapim(x).comim < 0;
               comim = '-' + %trim(comim);
            endif;
         endif;

         if opapim(x).prim <> 0;
            @@aux  = (opapim(x).comi/opapim(x).prim) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux4 = '.00';
          else;
            aux4 = %editw(@@aux3:'    0 .  ');
         endif;

         if opapim(x).primm <> 0;
            @@aux  = (opapim(x).recam/opapim(x).primm) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux5 = '.00';
          else;
            aux5 = %editw(@@aux3:'    0 .  ');
         endif;

         if opapim(x).primm <> 0;
            @@aux  = (opapim(x).comim/opapim(x).primm) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux6 = '.00';
          else;
            aux6 = %editw(@@aux3:'    0 .  ');
         endif;

         REST_writeXmlLine( 'linea' : '*BEG' );
         REST_writeXmlLine( 'rama' : %trim(@@ramd) );

         REST_writeXmlLine( 'cantidadDiaria' : %char(opapim(x).cant) );
         REST_writeXmlLine( 'primaNetaDiaria': %trim(prim) );
         REST_writeXmlLine( 'porcDiario': %trim(aux3) );
         REST_writeXmlLine( 'primaMasRecDiaria': %trim(prre) );
         REST_writeXmlLine( 'porcComiDiario': %trim(aux4) );
         REST_writeXmlLine( 'comisionDiaria': %trim(comi) );

         REST_writeXmlLine( 'cantidadMensual' : %char(opapim(x).cantm) );
         REST_writeXmlLine( 'primaNetaMensual': %trim(primm) );
         REST_writeXmlLine( 'porcMensual': %trim(aux5) );
         REST_writeXmlLine( 'primaMasRecMensual': %trim(prrem) );
         REST_writeXmlLine( 'comisionMensual': %trim(comim) );
         REST_writeXmlLine( 'porcComiMensual': %trim(aux6) );

         REST_writeXmlLine( 'linea' : '*END' );
        endif;
       endfor;

       REST_writeXmlLine( 'lineas' : '*END' );
       REST_writeXmlLine( 'agrupamiento' : '*END' );


       // ----------------------------------------------
       // Imprime Total general
       // ----------------------------------------------
       REST_writeXmlLine( 'agrupamiento' : '*BEG' );
       REST_writeXmlLine( 'nombre' : 'TOTAL GENERAL DE PRODUCCION');
       REST_writeXmlLine( 'lineas' : '*BEG' );
       for x = 1 to 100;
        if generm(x).rama <> 0;
         chain generm(x).rama set001;
         if not %found;
            t@ramd = *blanks;
         endif;
         @@ramd = %editc(generm(x).rama:'X')
                + ' '
                + %trim(t@ramd);
         if x = 100;
            @@ramd = 'Totales:';
         endif;
         if generm(x).prim <> 0;
            @@aux  = (generm(x).reca/generm(x).prim) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux3 = '.00';
          else;
            aux3 = %editw(@@aux3:'    0 .  ');
         endif;
         if generm(x).prim = 0;
            prim = '.00';
          else;
            prim = %editw(generm(x).prim: '               0 .  ' );
            if generm(x).prim < 0;
               prim = '-' + %trim(prim);
            endif;
         endif;
         if generm(x).primm = 0;
            primm = '.00';
          else;
            primm = %editw(generm(x).primm: '               0 .  ' );
            if generm(x).primm < 0;
               primm = '-' + %trim(primm);
            endif;
         endif;
         if generm(x).prre = 0;
            prre = '.00';
          else;
            prre = %editw(generm(x).prre: '               0 .  ' );
            if generm(x).prre < 0;
               prre = '-' + %trim(prre);
            endif;
         endif;
         if generm(x).prrem = 0;
            prrem = '.00';
          else;
            prrem = %editw(generm(x).prrem: '               0 .  ' );
            if generm(x).prrem < 0;
               prrem = '-' + %trim(prrem);
            endif;
         endif;
         if generm(x).comi = 0;
            comi = '.00';
          else;
            comi = %editw(generm(x).comi: '               0 .  ' );
            if generm(x).comi < 0;
               comi = '-' + %trim(comi);
            endif;
         endif;
         if generm(x).comim = 0;
            comim = '.00';
          else;
            comim = %editw(generm(x).comim: '               0 .  ' );
            if generm(x).comim < 0;
               comim = '-' + %trim(comim);
            endif;
         endif;

         if generm(x).prim <> 0;
            @@aux  = (generm(x).comi/generm(x).prim) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux4 = '.00';
          else;
            aux4 = %editw(@@aux3:'    0 .  ');
         endif;

         if generm(x).primm <> 0;
            @@aux  = (generm(x).recam/generm(x).primm) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux5 = '.00';
          else;
            aux5 = %editw(@@aux3:'    0 .  ');
         endif;

         if generm(x).primm <> 0;
            @@aux  = (generm(x).comim/generm(x).primm) * 100;
            @@aux3 = %dech(@@aux:8:2);
          else;
            @@aux3 = 0;
         endif;
         if @@aux3 = 0;
            aux6 = '.00';
          else;
            aux6 = %trim(SVPREST_editImporte( @@aux3 ));
            aux6 = %editw(@@aux3:'    0 .  ');
         endif;

         REST_writeXmlLine( 'linea' : '*BEG' );
         REST_writeXmlLine( 'rama' : %trim(@@ramd) );

         REST_writeXmlLine( 'cantidadDiaria' : %char(generm(x).cant) );
         REST_writeXmlLine( 'primaNetaDiaria': %trim(prim) );
         REST_writeXmlLine( 'porcDiario': %trim(aux3) );
         REST_writeXmlLine( 'primaMasRecDiaria': %trim(prre) );
         REST_writeXmlLine( 'porcComiDiario': %trim(aux4) );
         REST_writeXmlLine( 'comisionDiaria': %trim(comi) );

         REST_writeXmlLine( 'cantidadMensual' : %char(generm(x).cantm) );
         REST_writeXmlLine( 'primaNetaMensual': %trim(primm) );
         REST_writeXmlLine( 'porcMensual': %trim(aux5) );
         REST_writeXmlLine( 'primaMasRecMensual': %trim(prrem) );
         REST_writeXmlLine( 'comisionMensual': %trim(comim) );
         REST_writeXmlLine( 'porcComiMensual': %trim(aux6) );

         REST_writeXmlLine( 'linea' : '*END' );
        endif;
       endfor;

       REST_writeXmlLine( 'lineas' : '*END' );
       REST_writeXmlLine( 'agrupamiento' : '*END' );

       REST_writeXmlLine( 'produccionDiaria' : '*END' );

       return;

       begsr sr_acum;
        k1hint.inempr = c1empr;
        k1hint.insucu = c1sucu;
        k1hint.innivt = c1nivt;
        k1hint.innivc = c1nivc;
        chain %kds(k1hint:4) sahint;
        if not %found;
           leavesr;
        endif;
        // ---------------------------------------
        // Fronting
        // ---------------------------------------
        if inmafr = 'S';
           frontm(d0rama).rama = d0rama;
           frontm(d0rama).cantm += 1;
           frontm(d0rama).primm += (d0prim - d0bpri);
           frontm(d0rama).prrem += (d0prim - d0bpri) + @@reca;
           frontm(d0rama).comim += @@comi;
           frontm(d0rama).recam += @@reca;
           frontm(100).rama = -1;
           frontm(100).cantm += 1;
           frontm(100).primm += (d0prim - d0bpri);
           frontm(100).prrem += (d0prim - d0bpri) + @@reca;
           frontm(100).comim += @@comi;
           frontm(100).recam += @@reca;
           if c1femi = femi;
              frontm(d0rama).cant += 1;
              frontm(d0rama).prim += (d0prim - d0bpri);
              frontm(d0rama).prre += (d0prim - d0bpri) + @@reca;
              frontm(d0rama).comi += @@comi;
              frontm(d0rama).reca += @@reca;
              frontm(100).cant += 1;
              frontm(100).prim += (d0prim - d0bpri);
              frontm(100).prre += (d0prim - d0bpri) + @@reca;
              frontm(100).comi += @@comi;
              frontm(100).reca += @@reca;
           endif;
        endif;

        // ---------------------------------------
        // Bancos
        // ---------------------------------------
        if inmabc = 'S' and inmafr <> 'S';
           bancom(d0rama).rama = d0rama;
           bancom(d0rama).cantm += 1;
           bancom(d0rama).primm += (d0prim - d0bpri);
           bancom(d0rama).prrem += (d0prim - d0bpri) + @@reca;
           bancom(d0rama).comim += @@comi;
           bancom(d0rama).recam += @@reca;
           bancom(100).rama   = -1;
           bancom(100).cantm += 1;
           bancom(100).primm += (d0prim - d0bpri);
           bancom(100).prrem += (d0prim - d0bpri) + @@reca;
           bancom(100).comim += @@comi;
           bancom(100).recam += @@reca;
           if c1femi = femi;
              bancom(d0rama).cant += 1;
              bancom(d0rama).prim += (d0prim - d0bpri);
              bancom(d0rama).prre += (d0prim - d0bpri) + @@reca;
              bancom(d0rama).comi += @@comi;
              bancom(d0rama).reca += @@reca;
              bancom(100).cant += 1;
              bancom(100).prim += (d0prim - d0bpri);
              bancom(100).prre += (d0prim - d0bpri) + @@reca;
              bancom(100).comi += @@comi;
              bancom(100).reca += @@reca;
           endif;
        endif;

        // ---------------------------------------
        // Resto CF + GBA1
        // ---------------------------------------
        if inmafr <> 'S' and inmabc <> 'S';
         if (intipd = 1 or intipd = 2);
          if indiva <> 8;
           restom(d0rama).rama = d0rama;
           restom(d0rama).cantm += 1;
           restom(d0rama).primm += (d0prim - d0bpri);
           restom(d0rama).prrem += (d0prim - d0bpri) + @@reca;
           restom(d0rama).comim += @@comi;
           restom(d0rama).recam += @@reca;
           restom(100).rama   = -1;
           restom(100).cantm += 1;
           restom(100).primm += (d0prim - d0bpri);
           restom(100).prrem += (d0prim - d0bpri) + @@reca;
           restom(100).comim += @@comi;
           restom(100).recam += @@reca;
           if c1femi = femi;
              restom(d0rama).rama = d0rama;
              restom(d0rama).cant += 1;
              restom(d0rama).prim += (d0prim - d0bpri);
              restom(d0rama).prre += (d0prim - d0bpri) + @@reca;
              restom(d0rama).comi += @@comi;
              restom(d0rama).reca += @@reca;
              restom(100).cant += 1;
              restom(100).prim += (d0prim - d0bpri);
              restom(100).prre += (d0prim - d0bpri) + @@reca;
              restom(100).comi += @@comi;
              restom(100).reca += @@reca;
           endif;
          endif;
         endif;
        endif;

        // ---------------------------------------
        // Resto Interior
        // ---------------------------------------
        if inmafr <> 'S' and inmabc <> 'S';
         if (intipd <> 1 and intipd <> 2);
          if indiva <> 8;
           interm(d0rama).rama = d0rama;
           interm(d0rama).cantm += 1;
           interm(d0rama).primm += (d0prim - d0bpri);
           interm(d0rama).prrem += (d0prim - d0bpri) + @@reca;
           interm(d0rama).comim += @@comi;
           interm(d0rama).recam += @@reca;
           interm(100).rama   = -1;
           interm(100).cantm += 1;
           interm(100).primm += (d0prim - d0bpri);
           interm(100).prrem += (d0prim - d0bpri) + @@reca;
           interm(100).comim += @@comi;
           interm(100).recam += @@reca;
           if c1femi = femi;
              interm(d0rama).rama = d0rama;
              interm(d0rama).cant += 1;
              interm(d0rama).prim += (d0prim - d0bpri);
              interm(d0rama).prre += (d0prim - d0bpri) + @@reca;
              interm(d0rama).comi += @@comi;
              interm(d0rama).reca += @@reca;
              interm(100).cant += 1;
              interm(100).prim += (d0prim - d0bpri);
              interm(100).prre += (d0prim - d0bpri) + @@reca;
              interm(100).comi += @@comi;
              interm(100).reca += @@reca;
           endif;
          endif;
         endif;
        endif;

        // ---------------------------------------
        // WEB
        // ---------------------------------------
        if c1sspo = 0;
           k1w000.w0arcd = d0arcd;
           k1w000.w0spol = d0spol;
           k1w000.w0empr = d0empr;
           k1w000.w0sucu = d0sucu;
           setll %kds(k1w000:4) ctw00003;
           if %equal;
              if w0ncta = 0;
                 opwebm(d0rama).rama = d0rama;
                 opwebm(d0rama).cantm += 1;
                 opwebm(d0rama).primm += (d0prim - d0bpri);
                 opwebm(d0rama).prrem += (d0prim - d0bpri) + @@reca;
                 opwebm(d0rama).comim += @@comi;
                 opwebm(d0rama).recam += @@reca;
                 opwebm(100).cantm += 1;
                 opwebm(100).primm += (d0prim - d0bpri);
                 opwebm(100).prrem += (d0prim - d0bpri) + @@reca;
                 opwebm(100).comim += @@comi;
                 opwebm(100).recam += @@reca;
                 opwebm(100).rama   = -1;
               else;
                 opapim(d0rama).rama = d0rama;
                 opapim(d0rama).cantm += 1;
                 opapim(d0rama).primm += (d0prim - d0bpri);
                 opapim(d0rama).prrem += (d0prim - d0bpri) + @@reca;
                 opapim(d0rama).comim += @@comi;
                 opapim(d0rama).recam += @@reca;
                 opapim(100).cantm += 1;
                 opapim(100).primm += (d0prim - d0bpri);
                 opapim(100).prrem += (d0prim - d0bpri) + @@reca;
                 opapim(100).comim += @@comi;
                 opapim(100).recam += @@reca;
                 opapim(100).rama   = -1;
              endif;
           if c1femi = femi;
              if w0ncta = 0;
                 opwebm(d0rama).rama = d0rama;
                 opwebm(d0rama).cant += 1;
                 opwebm(d0rama).prim += (d0prim - d0bpri);
                 opwebm(d0rama).prre += (d0prim - d0bpri) + @@reca;
                 opwebm(d0rama).comi += @@comi;
                 opwebm(d0rama).reca += @@reca;
                 opwebm(100).cant += 1;
                 opwebm(100).prim += (d0prim - d0bpri);
                 opwebm(100).prre += (d0prim - d0bpri) + @@reca;
                 opwebm(100).comi += @@comi;
                 opwebm(100).reca += @@reca;
               else;
                 opapim(d0rama).rama = d0rama;
                 opapim(d0rama).cant += 1;
                 opapim(d0rama).prim += (d0prim - d0bpri);
                 opapim(d0rama).prre += (d0prim - d0bpri) + @@reca;
                 opapim(d0rama).comi += @@comi;
                 opapim(d0rama).reca += @@reca;
                 opapim(100).cant += 1;
                 opapim(100).prim += (d0prim - d0bpri);
                 opapim(100).prre += (d0prim - d0bpri) + @@reca;
                 opapim(100).comi += @@comi;
                 opapim(100).reca += @@reca;
              endif;
           endif;
           endif;
        endif;

       endsr;

       begsr acum_gral;
        generm(d0rama).rama = d0rama;
        generm(d0rama).cantm += 1;
        generm(d0rama).primm += (d0prim - d0bpri);
        generm(d0rama).prrem += (d0prim - d0bpri) + @@reca;
        generm(d0rama).comim += @@comi;
        generm(d0rama).recam += @@reca;
        generm(100).rama   = -1;
        generm(100).cantm += 1;
        generm(100).primm += (d0prim - d0bpri);
        generm(100).prrem += (d0prim - d0bpri) + @@reca;
        generm(100).comim += @@comi;
        generm(100).recam += @@reca;
        if c1femi = femi;
           generm(d0rama).rama = d0rama;
           generm(d0rama).cant += 1;
           generm(d0rama).prim += (d0prim - d0bpri);
           generm(d0rama).prre += (d0prim - d0bpri) + @@reca;
           generm(d0rama).comi += @@comi;
           generm(d0rama).reca += @@reca;
           generm(100).cant += 1;
           generm(100).prim += (d0prim - d0bpri);
           generm(100).prre += (d0prim - d0bpri) + @@reca;
           generm(100).comi += @@comi;
           generm(100).reca += @@reca;
        endif;
       endsr;

      /end-free

