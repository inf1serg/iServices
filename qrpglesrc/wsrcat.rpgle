     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRCAT: QUOM Versión 2                                       *
      *         Constancia de RC póliza en proceso de emisión.       *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *04-Dic-2017            *
      * ------------------------------------------------------------ *
      * SGF 26/04/2018: Pedido 5511 - Se otorga Constancia hasta C+. *
      * JSN 31/08/2018: Se cambia el valor del error 400 por 204 y   *
      *                 se agrega validaciones.                      *
      * SGF 18/01/2019: Si es un endoso, va el número de póliza y no *
      *                 la leyenda "En trámite".                     *
      *                                                              *
      * ************************************************************ *
     Fset225    if   e           k disk
     Fctw000    if   e           k disk
     Fpahed0    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/cowrtv_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'

     D WSLCON6         pr                  ExtPgm('WSLCON6')
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  pePoco                        4  0 const
     D  peData                             likeds(DataCertRc_t)
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D rama            s              2a
     D poco            s              4a
     D nctw            s              7a

     D uri             s            512a
     D url             s           3000a   varying
     D c               s             10i 0
     D rc              s              1n
     D rc2             s             10i 0
     D @@nit1          s              1  0
     D @@niv1          s              5  0
     D @@repl          s          65535a
     D @@acct          s              2a
     D @@accp          s              2a
     D @@inct          s              2a
     D @@incp          s              2a
     D @@robt          s              2a
     D @@robp          s              2a

     D x               s             10i 0
     D z               s             10i 0
     D y               s             10i 0
     D @@cobl          s              2a
     D peErro          s             10i 0
     D @@poli          s             30a
     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peNctw          s              7  0
     D k1w000          ds                  likerec(c1w000:*key)
     D peData          ds                  likeds(DataCertRc_t)
     D peInfV          ds                  likeds(Infvehi2) Dim(10)
     D k1hed0          ds                  likerec(p1hed0:*key)
     D peTiou          s              1  0
     D peStou          s              2  0
     D peStos          s              2  0

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
       nctw = REST_getNextPart(url);

       if SVPREST_chkBase(empr:sucu:nivt:nivc:nit1:niv1:peMsgs) = *off;
          rc = REST_writeHeader( 204
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
       endif;

       monitor;
          peNctw = %dec(nctw:7:0);
        on-error;
          peNctw = 0;
       endmon;

       clear peMsgs;
       clear peBase;
       clear peData;
       clear peInfv;
       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       COWLOG_logcon('WSRCAT':peBase);

       COWRTV_getVehiculos2( peBase
                           : peNctw
                           : peInfv
                           : peErro
                           : peMsgs );

       if peErro = -1;
          rc = REST_writeHeader( 204
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
       endif;

       k1w000.w0empr = peBase.peEmpr;
       k1w000.w0sucu = peBase.peSucu;
       k1w000.w0nivt = peBase.peNivt;
       k1w000.w0nivc = peBase.peNivc;
       k1w000.w0nctw = peNctw;
       chain %kds(k1w000:5) ctw000;
       if not %found;
          %subst(@@repl:1:7) = %trim(%char(peNctw));
          %subst(@@repl:8:1) = %trim(%char(peBase.peNivt));
          %subst(@@repl:9:5) = %trim(%char(peBase.peNivc));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0008'
                       : peMsgs
                       : @@repl
                       : %len(%trim(@@repl)) );

         rc = REST_writeHeader( 204
                              : *omit
                              : *omit
                              : peMsgs.peMsid
                              : peMsgs.peMsev
                              : peMsgs.peMsg1
                              : peMsgs.peMsg2 );
         REST_end();
         SVPREST_end();
         return;
       endif;

       if (w0cest = 5 and w0cses = 3) or
          (w0cest = 5 and w0cses = 4) or
          (w0cest = 7 and w0cses = 4) or
          (w0cest = 7 and w0cses = 5);
        else;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0029'
                       : peMsgs   );

          rc = REST_writeHeader( 204
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
       endif;

       // ---------------------------------------------
       // Si es un endoso, el número de póliza no puede
       // ser "En trámite"; tiene que ser la posta
       // ---------------------------------------------
       rc = COWGRAI_getTipodeOperacion( peBase
                                      : peNctw
                                      : peTiou
                                      : peStou
                                      : peStos );
       if rc = *off;
          peTiou = 1;
          peStou = 0;
          peStos = 0;
       endif;

       if peTiou = 3;
          k1hed0.d0empr = empr;
          k1hed0.d0sucu = sucu;
          k1hed0.d0arcd = COWGRAI_getArticulo( peBase: peNctw );
          k1hed0.d0spol = COWGRAI_getSuperPolizaReno( peBase: peNctw);
          chain %kds(k1hed0:4) pahed0;
          if %found;
             @@poli = %trim(%char(d0poli));
           else;
             @@poli = 'En Trámite';
          endif;
       endif;

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'constanciasAutosRC': '*BEG');

       for z = 1 to 10;

           if peInfv(z).rama = 0 or peInfv(z).poco = 0;
              leave;
           endif;

           WSLCON6( peBase
                  : peNctw
                  : peInfv(z).rama
                  : peInfv(z).poco
                  : peData
                  : peErro
                  : peMsgs  );

           // --------------------------------
           // Verifico cobertura
           // --------------------------------
           for y = 1 to 20;
               if peInfv(z).cobe(y).sele = '1';
                  @@cobl        =  peInfv(z).cobe(y).cobl;
                  leave;
               endif;
           endfor;

           if %subst(@@cobl:1:1) = 'D';
              @@cobl = 'C1';
           endif;

           if %subst(@@cobl:1:1) <> 'A';
              chain @@cobl set225;
              if %found;
                 peData.peCobd = t@cobd;
                 peData.peAcct = t@acct;
                 peData.peAccp = t@accp;
                 peData.peInct = t@inct;
                 peData.peIncp = t@incp;
                 peData.peRobt = t@robt;
                 peData.peRobp = t@robp;
                 peData.peVhvu = %editw(peInfv(z).vhvu:'           0 .  ');
                 if peInfv(z).vhvu = 0;
                    peData.peVhvu = '.00';
                 endif;
                 if peInfv(z).vhvu < 0;
                    peData.peVhvu = '-' + %trim(peData.peVhvu);
                 endif;
              endif;
           endif;

           @@acct = 'No';
           @@accp = 'No';
           @@inct = 'No';
           @@incp = 'No';
           @@robt = 'No';
           @@robp = 'No';
           if peData.peAcct = 'S';
              @@acct = 'Si';
           endif;
           if peData.peAccp = 'S';
              @@accp = 'Si';
           endif;
           if peData.peInct = 'S';
              @@inct = 'Si';
           endif;
           if peData.peIncp = 'S';
              @@incp = 'Si';
           endif;
           if peData.peRobt = 'S';
              @@robt = 'Si';
           endif;
           if peData.peRobp = 'S';
              @@robp = 'Si';
           endif;

           peData.pePoli = @@poli;

           if peErro = 0;
              REST_writeXmlLine( 'constanciaAutosRC': '*BEG');
              REST_writeXmlLine('componente':%char(peInfv(z).poco));
              REST_writeXmlLine('numeroDePoliza' :%trim(peData.pePoli));
              REST_writeXmlLine('nombreAsegurado':%trim(peData.peNase));
              REST_writeXmlLine('horaDesde'      :%trim(peData.peHdes));
              REST_writeXmlLine('fechaDesde'     :%trim(peData.peFdes));
              REST_writeXmlLine('horaHasta'      :%trim(peData.peHhas));
              REST_writeXmlLine('fechaHasta'     :%trim(peData.peFhas));
              REST_writeXmlLine('vehiculo'       :%trim(peData.peVhde));
              REST_writeXmlLine('patente'        :%trim(peData.peNmat));
              REST_writeXmlLine('motor'          :%trim(peData.peMoto));
              REST_writeXmlLine('chasis'         :%trim(peData.peChas));
              REST_writeXmlLine('uso'            :%trim(peData.peVhdu));
              REST_writeXmlLine('sumaAsegurada'  :%trim(peData.peVhvu));
              REST_writeXmlLine('cobertura'      :%trim(peData.peCobd));
              REST_writeXmlLine('accidenteTotal' :%trim(@@Acct));
              REST_writeXmlLine('accidenteParcial':%trim(@@Accp));
              REST_writeXmlLine('incendioTotal'   :%trim(@@Inct));
              REST_writeXmlLine('incendioParcial' :%trim(@@Incp));
              REST_writeXmlLine('roboTotal'       :%trim(@@Robt));
              REST_writeXmlLine('roboParcial'     :%trim(@@Robp));
              REST_writeXmlLine('limiteDeRC'      :%trim(peData.peRcli));
              REST_writeXmlLine( 'constanciaAutosRC': '*END');
           endif;

       endfor;

       REST_writeXmlLine( 'constanciasAutosRC': '*END');

       REST_end();

       return;

      /end-free
