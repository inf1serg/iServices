     H option(*srcstmt:*noshowcpy:*nodebugio)
     H actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRGAL: Galicia                                              *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                     *29-Nov-2018            *
      * ************************************************************ *
     Fset643    uf   e           k disk
     Fset64301  if   e           k disk    rename(s1t643:s1t64301)
     Fset001    uf   e           k disk    prefix(t2:2)
     Fpawgal    if   e           k disk
     Fmailconf  if   e           k disk
     Fgntemp    if   e           k disk
     Fgntsuc    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/mail_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'

     D empr            s              1a
     D sucu            s              2a
     D tipo            s              1a
     D nres            s              7a

     D uri             s            512a
     D url             s           3000a   varying
     D peNres          s              7  0
     D anNivc          s              5  0
     D anPago          s              9
     D rc              s              1n
     D rc2             s             10i 0

     D @@repl          s          65535a

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

     D Archivo         ds                  qualified based(template)
     D  codreg                        1
     D  tipoid                        4
     D  idclie                       15
     D  idinte                       18
     D  tidocu                        2
     D  iddocu                       25
     D  idindo                       30
     D  divisi                        6
     D  moneda                        2
     D  fecpag                        8
     D  sucpag                        3
     D  forpag                        1
     D  idpago                        9
     D  marpag                        1
     D  imppag                       15  2
     D  nroche                        9
     D  fecche                        8
     D  impche                       15  2
     D  codban                        3  0
     D  mcainf                        1
     D  mcaanu                        1
     D  nrdocp                       25
     D  ticanl                        2
     D  descan                       14
     D  nrobol                        9  0
     D  filler                       73

     D  sucursal       s             40
     D  tiene          s               n
     D  x              s             10i 0
     D  Datos          ds                  likeds(Archivo)
     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0
     D directorio      ds                  likeds(DireEnt_t)
     D k1ygal          ds                  likerec(p1wgal:*key)
     D k1y643          ds                  likerec(s1t643:*key)
     D peCprc          s             20a
     D peCspr          s             20a
     D peRprp          ds                  likeds(recprp_t) dim(100)

      /free

       *inlr = *on;

       if not REST_getUri( psds.this : uri );
          return;
       endif;
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       tipo = REST_getNextPart(url);
       nres = REST_getNextPart(url);

       if %scan( ' ' : empr ) > 1;
          %subst(@@repl:1:1) = empr;
          rc2 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0113'
                             : peMsgs
                             : %trim(@@repl)
                             : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'COW0113'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       if %scan( ' ' : sucu ) > 2;
          %subst(@@repl:1:2) = sucu;
          %subst(@@repl:2:1) = empr;
          rc2 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0114'
                             : peMsgs
                             : %trim(@@repl)
                             : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'COW0114'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       setll empr gntemp;
       if not %equal;
          %subst(@@repl:1:1) = empr;
          rc2 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0113'
                             : peMsgs
                             : %trim(@@repl)
                             : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'COW0113'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       setll (empr : sucu) gntsuc;
       if not %equal;
          %subst(@@repl:1:2) = sucu;
          %subst(@@repl:3:1) = empr;
          rc2 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0114'
                             : peMsgs
                             : %trim(@@repl)
                             : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'COW0114'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       if tipo <> 'U' and tipo <> 'G';
         tipo = 'G';
       endif;

       monitor;
          peNres = %dec(nres:7:0);
        on-error;
          peNres = 0;
       endmon;

       if tipo = 'U';
         k1y643.t@empr = empr;
         k1y643.t@sucu = sucu;
         k1y643.t@nres = peNres;
         chain %kds(k1y643:3) set643;
         if not %found;
           rc2 = SVPWS_getMsgs( '*LIBL'
                              : 'WSVMSG'
                              : 'GEN0027'
                              : peMsgs );
           rc = REST_writeHeader( 400
                                : *omit
                                : *omit
                                : 'GEN0027'
                                : peMsgs.peMsev
                                : peMsgs.peMsg1
                                : peMsgs.peMsg2 );
           REST_end();
           close *all;
           return;
         endif;

         if t@mar1 = '9';
          rc2 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'GEN0028'
                             : peMsgs );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'GEN0028'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
         endif;
       endif;

       read mailconf;

       if tipo = 'G';
          exsr $listar;
       endif;

       if tipo = 'U';
          exsr $enviar;
       endif;

       close *all;

       return;

       // -----------------------------------------------
       // Lista peticiones pendientes
       // -----------------------------------------------
       begsr $listar;
        REST_writeHeader();
        REST_writeEncoding();
        REST_startArray('peticiones');
        setll *Start set64301;
        read set64301;
        dow not %eof( set64301 );
          if ( t@mar1 = '0' );
            exsr $datosUsr;
            REST_startArray('peticion');
            exsr $datos;
            REST_startArray('auditoriaDeProcesos' );
            REST_writeXmlLine('numero':%trim(%char(t@nres)));
            REST_writeXmlLine('archivo' : %trim(t@file) );
            REST_writeXmlLine('fecha' : SVPREST_editFecha( t@dat1 ) );
            REST_writeXmlLine('hora':%editW(t@tim1:'  :  :  '));
            REST_writeXmlLine('usuario' : %trim(t@user) );
            REST_writeXmlLine('idbusqueda' : %trim(t@idbq) );
            peCprc = 'INGRESO_VALORES';
            select;
              when t@mar2 = '1';
                REST_writeXmlLine('imprimir' : 'procesado' );
                peCspr = 'INGRESO_VALORES_GAL';
              when t@mar3 = '1';
                REST_writeXmlLine('imprimir' : 'detallePorProductor');
                peCspr = 'INGRESO_VALORES_GAL1';
              when t@mar4 = '1';
                REST_writeXmlLine('imprimir' : 'detallePorIdDePago');
                peCspr = 'INGRESO_VALORES_GAL1';
              other;
                REST_writeXmlLine('imprimir' : 'Indefinido' );
            endsl;

            REST_endArray('auditoriaDeProcesos' );
             rc2= MAIL_getReceipt( peCprc: peCspr: peRprp: *ON);
             REST_startArray('destinatarios');
             for x = 1 to rc2;
               REST_startArray('destinatario');
               select;
                when peRprp(x).rpma01 = '1';
                   //MAIL_NORMAL;
                     REST_writeXmlLine('tipo'   : 'Principal');
                when peRprp(x).rpma01 = '2';
                     //MAIL_CC;
                     REST_writeXmlLine('tipo'   : 'CC');
                when peRprp(x).rpma01 = '3';
                     //MAIL_CCO;
                     REST_writeXmlLine('tipo'   : 'CO');
                other;
                     REST_writeXmlLine('tipo'   : 'Principal');
               endsl;
               if peRprp(x).rpnomb = '*REQUESTER';
                  REST_writeXmlLine('nombre' : %trim(directorio.fuln) );
                  REST_writeXmlLine( 'email'
                                   : %trim(directorio.mail)
                                   + '@'
                                   + %trim(nfdomi)          );
               else;
                 REST_writeXmlLine('nombre' : %trim( peRprp(x).rpnomb));
                 REST_writeXmlLine( 'email' : %trim( peRprp(x).rpmail));
               endif;
              REST_endArray('destinatario');
            endfor;
            REST_endArray('destinatarios');
            REST_endArray('peticion');
          endif;
         read set64301;
        enddo;
        REST_endArray('peticiones');
       endsr;

       begsr $datos;

        anNivc = *Zeros;
        //REST_startArray( 'registros' );
        //REST_startArray( 'registro' );
        REST_startArray( 'productores' );
        REST_startArray( 'productor' );
        k1ygal.w@file = t@file;
        k1ygal.w@secu = t@secu;
        setll %kds(k1ygal:2) pawgal;
        reade %kds(k1ygal:2) pawgal;
        datos = w@dato;
        dow not %eof;
          if ( datos.codReg = 'D' );
            if ( anNivc <> %dec( %trim( datos.idclie ) : 5 : 0 ) );
              if ( anNivc <> *zeros );
                REST_endArray( 'pagos' );
                REST_endArray( 'productor' );
                REST_startArray( 'productor' );
              endif;
              REST_writeXmlLine('idProductor':%trim(datos.idclie));
              REST_writeXmlLine('nomProductor' : %trim(datos.idinte) );
              REST_startArray( 'pagos' );
              anNivc = %dec( %trim( datos.idclie ) : 5 : 0 );
            endif;
            REST_startArray( 'pago' );
            REST_writeXmlLine('id' : %trim(datos.idpago) );
            REST_writeXmlLine('nroOperacion' : %editc(w@ivop:'X') );
            REST_writeXmlLine('nroIngreso' : %editc(w@ivni:'X') );
            REST_writeXmlLine('fecha'
                             : %subst(datos.fecpag:7:2) + '/'
                             + %subst(datos.fecpag:5:2) + '/'
                             + %subst(datos.fecpag:1:4));
            monitor;
              sucursal = SVPDES_sucursalBanco( 7
                        :%dec(datos.sucpag:3:0));
              if sucursal = *blanks or %trim( sucursal ) = 'X';
                 sucursal  = datos.sucpag;
              endif;
              tiene = *off;
              for x = 30 downto 1;
                if %check('1234567890':%subst(sucursal:x:1)) = 0;
                  tiene = *on;
                endif;
              endfor;

              if not tiene;
                sucursal = %trim(
                           %subst( SVPDES_sucursalBanco( 7
                                : %int( datos.sucpag))
                                : 1 : 30 ) )  + ' '
                         + %trim( datos.sucpag );
              endif;

              REST_writeXmlLine('sucursal'
                               : SVPDES_sucursalBanco( 7
                                             :%dec(datos.sucpag:3:0)));
            on-error;
              REST_writeXmlLine('sucursal' : 'Indeterminado' );
            endmon;
            REST_writeXmlLine('canal' : %trim(datos.descan) );


            //Recorro pagos
            anPago = datos.idpago;
            REST_startArray( 'documentos' );
            dow ( anPago = datos.idpago ) and not %eof;
              REST_startArray( 'documento' );
              REST_writeXmlLine('descripcion' : %trim(datos.idindo) );
              select;
                when datos.forpag = '1';
                  REST_writeXmlLine('formaDePago' : 'Efectivo' );
                when datos.forpag = '2';
                  REST_writeXmlLine('formaDePago' : 'Cheque 48hs' );
                when datos.forpag = '3';
                  REST_writeXmlLine('formaDePago' : 'Cheque Diferido' );
                when datos.forpag = '4';
                  REST_writeXmlLine('formaDePago' : 'B to B' );
                when datos.forpag = '5';
                 REST_writeXmlLine('formaDePago' : 'Cheque Galicia o 48hs');
                when datos.forpag = '9';
                  REST_writeXmlLine('formaDePago' : 'Nota de Crédito' );
                other;
                  REST_writeXmlLine('formaDePago' : 'Sin descripción' );
              endsl;
             REST_writeXmlLine('importe':SVPREST_editImporte(datos.imppag));
              REST_writeXmlLine('nroCheque' : %trim(datos.nroche) );
              REST_writeXmlLine('nroBoleto' : %editC(datos.nrobol:'X') );
              monitor;
                REST_writeXmlLine('banco'
                                 : SVPDES_banco( datos.codban ) );
              on-error;
                REST_writeXmlLine('banco' : ' ' );
              endmon;
    R         REST_writeXmlLine('fechaPagoAcreditacion'
                               : %subst(datos.fecche:7:2) + '/'
                               + %subst(datos.fecche:5:2) + '/'
                               + %subst(datos.fecche:1:4));
              REST_endArray( 'documento' );
              reade %kds(k1ygal:2) pawgal;
              datos = w@dato;
            enddo;
            anPago = datos.idpago;
            REST_endArray( 'documentos' );
            REST_endArray( 'pago' );
          else;
            reade %kds(k1ygal:2) pawgal;
            datos = w@dato;
          endif;
        enddo;
        REST_endArray( 'pagos' );
        REST_endArray( 'productor' );
        REST_endArray( 'productores' );
        //REST_endArray( 'registro' );
        //REST_endArray( 'registros' );
       endsr;

       begsr $enviar;
        k1y643.t@empr = empr;
        k1y643.t@sucu = sucu;
        k1y643.t@nres = peNres;
        chain %kds(k1y643:3) set643;
        if %found;
           t@mar1 = '9';
           update s1t643;
        endif;
        REST_writeHeader();
        REST_writeEncoding();
        REST_writeXmlLine('result':'OK');
       endsr;

       begsr $datosUsr;
        directorio = MAIL_getDire(t@user);
       endsr;

      /end-free
