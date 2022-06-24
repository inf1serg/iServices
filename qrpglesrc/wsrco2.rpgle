     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRCO2: Portal de Autogestión de Asegurados.                 *
      *         Certificado de Cobertura Hogar/Consorcio.            *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *10-Jul-2018            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fpahec1    if   e           k disk
     Fgntloc02  if   e           k disk
     Fset225    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/wslcer_h.rpgle'

     D WSLCON1         pr                  ExtPgm('WSLCON1')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const options(*omit)
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsFi                            likeds(certAut_t)
     D   peDcob                      80    dim(999)
     D   peDcobC                     10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * URL y URI
      * ------------------------------------------------------------ *
     D uri             s            512a
     D url             s           3000a   varying

      * ------------------------------------------------------------ *
      * Parámetros de URL
      * ------------------------------------------------------------ *
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D rama            s              2a
     D poli            s              7a
     D arcd            s              6a
     D spol            s              9a
     D poco            s              4a

     D x               s             10i 0
     D fecha           s              8a
     D peNivt          s              1  0
     D peNivc          s              5  0
     D peNit1          s              1  0
     D peNiv1          s              5  0
     D peRama          s              2  0
     D pePoli          s              7  0
     D peArcd          s              6  0
     D peSpol          s              9  0
     D pePoco          s              4  0
     D @@des           s             10a
     D rc              s              1n
     D impo            s             30a
     D peDcob          s             80    dim(999)
     D peDcobC         s             10i 0
     D peMsgs          ds                  likeds(paramMsgs)
     D peBase          ds                  likeds(paramBase)
     D peDsFi          ds                  likeds(certAut_t)

     D k1hec1          ds                  likerec(p1hec1:*key)
     D k1tloc          ds                  likerec(g1tloc02:*key)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

      /free

       *inlr = *on;

       REST_getUri( psds.this : uri );
       url = %trim(uri);

       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       nivt = REST_getNextPart(url);
       nivc = REST_getNextPart(url);
       nit1 = REST_getNextPart(url);
       niv1 = REST_getNextPart(url);
       rama = REST_getNextPart(url);
       poli = REST_getNextPart(url);
       arcd = REST_getNextPart(url);
       spol = REST_getNextPart(url);
       poco = REST_getNextPart(url);

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

       monitor;
         peRama = %dec(rama:2:0);
        on-error;
         peRama = 0;
       endmon;

       monitor;
         pePoli = %dec(poli:7:0);
        on-error;
         pePoli = 0;
       endmon;

       monitor;
         peArcd = %dec(arcd:6:0);
        on-error;
         peArcd = 0;
       endmon;

       monitor;
         peSpol = %dec(spol:9:0);
        on-error;
         peSpol = 0;
       endmon;

       monitor;
         pePoco = %dec(poco:4:0);
        on-error;
         pePoco = 0;
       endmon;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       k1hec1.c1empr = empr;
       k1hec1.c1sucu = sucu;
       k1hec1.c1arcd = peArcd;
       k1hec1.c1spol = peSpol;
       setgt  %kds(k1hec1:4) pahec1;
       readpe %kds(k1hec1:4) pahec1;
       if %eof;
          c1sspo = 0;
       endif;

       WSLCON1( peBase
              : peRama
              : pePoli
              : peSpol
              : c1sspo
              : pePoco
              : peDsfi
              : peDcob
              : peDcobC
              : peMsgs  );

       if peMsgs.peMsid <> *blanks;
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

       REST_writeXmlLine('certificadoAutos' : '*BEG' );

        REST_writeXmlLine('empresa'       : %trim(peDsfi.neml) );
        REST_writeXmlLine('rama'          : %trim(peDsfi.ramd) );
        fecha = %editc(peDsfi.ivig:'X');
        @@des = %subst(fecha:1:4)
              + '-'
              + %subst(fecha:5:2)
              + '-'
              + %subst(fecha:7:2);
        REST_writeXmlLine('vigenciaDesde' : %trim(@@des)       );
        fecha = %editc(peDsfi.fvig:'X');
        @@des = %subst(fecha:1:4)
              + '-'
              + %subst(fecha:5:2)
              + '-'
              + %subst(fecha:7:2);
        REST_writeXmlLine('poliza'        : %char(pePoli)      );
        REST_writeXmlLine('vigenciaHasta' : %trim(@@des)       );
        REST_writeXmlLine('nombreAsegurado': %trim(peDsfi.asno) );
        REST_writeXmlLine('suplementoEndoso': %editc(c1sspo:'X'));
        REST_writeXmlLine('direccion': %trim(peDsfi.domi) );
        k1tloc.locopo = peDsfi.copo;
        k1tloc.locops = peDsfi.cops;
        chain %kds(k1tloc) gntloc02;
        if not %found;
           prprod = *blanks;
        endif;
        REST_writeXmlLine('provincia': %trim(prprod)      );
        REST_writeXmlLine('localidad': %trim(peDsfi.loca) );

        REST_writeXmlLine('vehiculo': %trim(peDsfi.vhde) );
        REST_writeXmlLine('anio'    : %char(peDsfi.vhaÑ) );
        REST_writeXmlLine('tipo'    : %trim(peDsfi.cvde) );
        REST_writeXmlLine('uso'     : %trim(peDsfi.vhdu) );
        REST_writeXmlLine('motor'   : %trim(peDsfi.moto) );
        REST_writeXmlLine('chasis'  : %trim(peDsfi.chas) );
        REST_writeXmlLine('carroceria': %trim(peDsfi.vhcd) );
        REST_writeXmlLine('patente' : %trim(peDsfi.nmat) );

        impo = %editw(peDsFi.vhvu:'           0 .  ');
        REST_writeXmlLine('valorAsegurado' : %trim(impo));

        chain peDsfi.cobl set225;
        if not %found;
           t@cobd = *blanks;
        endif;
        REST_writeXmlLine('cobertura': %trim(t@cobd) );
        impo = %editw(peDsFi.ifra:'           0 .  ');
        if peDsFi.ifra <= 0;
           impo = '.00';
        endif;
        REST_writeXmlLine('franquicia' : %trim(impo));

        if peDsFi.apno = '* NO REGISTRA *                         ';
           REST_writeXmlLine('acreedorPrendario': ' ');
         else;
           REST_writeXmlLine('acreedorPrendario': %trim(peDsFi.apno) );
        endif;

        REST_write('<detalle>');
        for x = 1 to peDcobC;
          REST_write(peDcob(x));
        endfor;
        REST_write('</detalle>');

       REST_writeXmlLine('certificadoAutos' : '*END' );

       return;

      /end-free

