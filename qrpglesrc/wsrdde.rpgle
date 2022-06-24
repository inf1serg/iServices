     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRDIA: Producción Por Artículos                             *
      *         Producción diaria por servicio rest (detalle excel)  *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *27-Mar-2018            *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * JSN 07/03/2019 - Se modifica en la clave k1hec1, usar campo  *
      *                  femi                                        *
      * SGF 05/04/2021 - Agrego usuario.                             *
      *                                                              *
      * ************************************************************ *
     Fpahec105  if   e           k disk
     Fpahec0    if   e           k disk
     Fpahed0    if   e           k disk
     Fpahed3    if   e           k disk
     Fgnhdaf    if   e           k disk
     Fsehni201  if   e           k disk
     Fset001    if   e           k disk
     Fset901    if   e           k disk    prefix(t9:2)

      /copy './qcpybooks/rest_h.rpgle'

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
     D nase            s             40a
     D npro            s             40a
     D tiop            s             10a
     D comi            s             30a
     D prim            s             30a
     D prem            s             30a
     D fpro            s             10a
     D fvig            s             10a
     D fece            s             10a
     D impu            s             30a
     D reca            s             30a
     D laps            s             10a
     D lap1            s             10a
     D @prim           s             15  2
     D @comi           s             15  2
     D @reca           s             15  2
     D @impu           s             15  2
     D @femi           s              8  0
     D @fvig           s              8  0
     D @fpro           s              8  0
     D @lap1           s              5  0
     D @lap2           s              5  0
     D wfpro           s             10d

     D k1hec1          ds                  likerec(p1hec105:*key)
     D k1hec0          ds                  likerec(p1hec0:*key)
     D k1hed0          ds                  likerec(p1hed0:*key)
     D k1hed3          ds                  likerec(p1hed3:*key)

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
       k1hec1.c1femi = femi;

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'detalleDiario': '*BEG' );

       setll %kds(k1hec1:3) pahec105;
       reade %kds(k1hec1:3) pahec105;
       dow not %eof;

           k1hed0.d0empr = c1empr;
           k1hed0.d0sucu = c1sucu;
           k1hed0.d0arcd = c1arcd;
           k1hed0.d0spol = c1spol;
           k1hed0.d0sspo = c1sspo;
           setll %kds(k1hed0:5) pahed0;
           reade %kds(k1hed0:5) pahed0;
           dow not %eof;
               if d0come <= 0;
                  d0come = 1;
               endif;
               d0prim *= d0come;
               d0bpri *= d0come;
               d0dere *= d0come;
               d0read *= d0come;
               d0refi *= d0come;
               d0dere *= d0come;
               d0refi *= d0come;
               d0read *= d0come;
               d0impi *= d0come;
               d0sers *= d0come;
               d0tssn *= d0come;
               d0seri *= d0come;
               d0ipr1 *= d0come;
               d0ipr2 *= d0come;
               d0ipr3 *= d0come;
               d0ipr4 *= d0come;
               d0ipr5 *= d0come;
               d0ipr6 *= d0come;
               d0ipr7 *= d0come;
               d0ipr8 *= d0come;
               d0ipr9 *= d0come;

               @reca = d0read + d0refi + d0dere;
               @impu = d0impi + d0sers + d0tssn
                     + d0seri + d0ipr1 + d0ipr2
                     + d0ipr3 + d0ipr4 + d0ipr5
                     + d0ipr6 + d0ipr7 + d0ipr8
                     + d0ipr9;

               chain c1asen gnhdaf;
               if %found;
                  nase = dfnomb;
                else;
                  nase = *blanks;
               endif;
               chain (c1tiou:c1stou) set901;
               if not %found;
                  t9dsop = *blanks;
               endif;

               tiop = %editc(c1tiou:'X')
                    + ' - '
                    + %editc(c1stou:'X');

               fvig = %editc(d0fioa:'X')
                    + '-'
                    + %editc(d0fiom:'X')
                    + '-'
                    + %editc(d0fiod:'X');

               fece = %editc(c1fema:'X')
                    + '-'
                    + %editc(c1femm:'X')
                    + '-'
                    + %editc(c1femd:'X');

               fpro = '0001-01-01';
               if c1tiou = 1 or c1tiou = 2;
                  k1hec0.c0empr = c1empr;
                  k1hec0.c0sucu = c1sucu;
                  k1hec0.c0arcd = c1arcd;
                  k1hec0.c0spol = c1spol;
                  chain %kds(k1hec0) pahec0;
                  if %found;
                     fpro = %editc(c0fipa:'X')
                          + '-'
                          + %editc(c0fipm:'X')
                          + '-'
                          + %editc(c0fipd:'X');
                  endif;
               endif;

               @prim = d0prim - d0bpri;
               prim = %editw(@prim:'            0.  ');
               if @prim = 0;
                  prim = '.00';
               endif;
               if @prim < 0;
                  prim = '-' + %trim(prim);
               endif;

               prem = %editw(d0prem:'            0.  ');
               if (d0prem) = 0;
                  prem = '.00';
               endif;
               if (d0prem) < 0;
                  prem = '-' + %trim(prem);
               endif;

               npro = *blanks;
               chain (c1empr:c1sucu:c1nivt:c1nivc) sehni201;
               if %found;
                  npro = dfnomb;
               endif;

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
                   @comi += d3copr + d3ccob + d3cfno + d3cfnn;
                reade %kds(k1hed3:9) pahed3;
               enddo;

               comi = %editw(@comi:'            0.  ');
               if @comi = 0;
                  comi = '.00';
               endif;
               if @comi < 0;
                  comi = '-' + %trim(comi);
               endif;

               reca = %editw(@reca:'            0.  ');
               if @reca = 0;
                  reca = '.00';
               endif;
               if @reca < 0;
                  reca = '-' + %trim(reca);
               endif;

               impu = %editw(@impu:'            0.  ');
               if @impu = 0;
                  impu = '.00';
               endif;
               if @impu < 0;
                  impu = '-' + %trim(impu);
               endif;

               @femi = (c1fema * 10000)
                     + (c1femm *   100)
                     +  c1femd;
               @fvig = (c1fioa * 10000)
                     + (c1fiom *   100)
                     +  c1fiod;
               @lap1 = %diff(%date(@femi:*iso):%date(@fvig:*iso):*d);
               if c1tiou <= 2;
                  @fpro = (c0fipa * 10000)
                        + (c0fipm *   100)
                        +  c0fipd;
                  monitor;
                     wfpro = %date(@fpro:*iso);
                     @lap2 = %diff(%date(@femi:*iso):%date(@fpro:*iso):*d);
                   on-error;
                     @lap2  = 0;
                  endmon;
               endif;

               REST_writeXmlLine('linea' : '*BEG');
                REST_writeXmlLine('rama' : %char(d0rama) );
                REST_writeXmlLine('poliza' : %char(d0poli) );
                REST_writeXmlLine('suplemento': %editc(d0suop:'X') );
                REST_writeXmlLine('certificado': %char(c1cert) );
                REST_writeXmlLine('articulo': %char(c1arcd) );
                REST_writeXmlLine('superpoliza': %char(c1spol) );
                REST_writeXmlLine('asegurado': %trim(nase) );
                REST_writeXmlLine('tipoOperacion': tiop );
                REST_writeXmlLine('operacion': t9dsop );
                REST_writeXmlLine('fechaEmision': fece);
                REST_writeXmlLine('fechaVigencia': fvig);
                REST_writeXmlLine('lapso': %char(@lap1));
                REST_writeXmlLine('fechaPropuesta': fpro);
                REST_writeXmlLine('lapsoPropuesta': %char(@lap2));
                REST_writeXmlLine('primaEmitida': prim);
                REST_writeXmlLine('recargosEmitidos': reca);
                REST_writeXmlLine('impuestosEmitidos': impu);
                REST_writeXmlLine('premioEmitido': prem);
                REST_writeXmlLine('comisionesEmitidas': comi);
                REST_writeXmlLine('codigoProductor': %char(c1nivc) );
                REST_writeXmlLine('nombreProductor': %trim(npro) );
                REST_writeXmlLine('usuarior': %trim(d0user) );
               REST_writeXmlLine('linea' : '*END');

               reade %kds(k1hed0:5) pahed0;
              enddo;

        reade %kds(k1hec1:3) pahec105;
       enddo;

       REST_writeXmlLine( 'detalleDiario': '*END' );

       return;

      /end-free

