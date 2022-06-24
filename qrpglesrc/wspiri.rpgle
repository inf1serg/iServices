     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ***
      * WSPIRI : Servicio Siniestro - Insertar Recibo Indemnizacion  *
      * ------------------------------------------------------------ *
      * Valeria Marquez                      28/12/2021              *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      *                                                              *
      * ************************************************************ *

      * -- Copy H --
      /copy './qcpybooks/sinest_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'
      /copy './qcpybooks/svpsi1_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/svpsuc_h.rpgle'
      /copy './qcpybooks/svpemp_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      *
      * ATENCION: el likeds dependerá del servicio.
      *           No es siempre la misma.
      *           La ds (en este caso wspiri_t) debe
      *           existir en el miembro SINEST_H
      *
      * Las variables que siguen aca, deben estar siempre
      * request, buffer, options y rc1
      *
      * -- Variables de Arquitectura --
     D request         ds                  likeds(wspIri_t)
     D buffer          s           5000a
     D options         s            100a
     D rc1             s             10i 0
     D @@repl          s          65535a
     D path            s            256a   varying
     D pevalu          s           1024a
     D peMsgs          ds                  likeds(paramMsgs)
     D @@MsgF          s             10a
     D x               s             10i 0
     D Z               s             10i 0
     D f               s             10i 0
     D @@CodM          s              7    inz

     D*
      * -- Variables Validador Caratula --
     D  peRama         s              2  0
     D  peSini         s              7  0
     D  peNops         s              7  0
     D  peMsgf         s              6a
     D  peIdms         s              7a
      *
      * -- Variables Utilizadas --
     D  @@rama         s              2  0
     D  @@Nrec         s              7  0
     D*
      * -- Variables de conversion
     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')
     D*
      *
      * Parametros de Beneficiarios del Siniestro
     D @@DsBe          ds                  likeds ( dsPahsbe_t ) dim(9999)
     D @@DsBeC         s             10i 0
      *
      * Parametros de Recibo de Indemnizacion Cabecera
     D @@DsIc          ds                  likeds ( dsCnhric_t )
     D @@DsIcC         s             10i 0
      *
      * Parametros de Recibo de Indemnizacion Detalle
     D @@DsId          ds                  likeds ( dsCnhrid_t )
     D @@DsIdC         s             10i 0
     D*
     D @x              s             10i 0
     D @ok             s              1
      *
       // -------------------------------------
       /free
       *inlr = *on;


       // -------------------------------------
       // Inicio
       // -------------------------------------


       options = 'doc=string path=insertarReciboIndemnizacion +
                  allowmissing=yes allowextra=yes case=any';

       REST_getEnvVar('REQUEST_METHOD':peValu);

       if %trim(peValu) <> 'POST';
          REST_writeHeader( 405
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit  );
          REST_end();
          SVPREST_end();
          return;
       endif;

       // -------------------------------------
       // Lectura y Parseo
       // -------------------------------------

        if REST_getEnvVar('WSPIRI_BODY' : peValu );
           buffer = peValu;
           Qp0zDltEnv('WSPIRI_BODY');
         else;
           rc1= REST_readStdInput( %addr(buffer): %len(buffer) );
        endif;

       monitor;
          xml-into request %xml(buffer : options);
       on-error;
          @@repl = 'wspIri_t';
          rc1 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'RPG0001'
                             : peMsgs
                             : %trim(@@repl)
                             : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'RPG0001'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
       endmon;


       // -------------------------------------
       // Control sobre los parámetros enviados
       // -------------------------------------

       // *--------------------*
       // Convierto a Mayusculas
       // *--------------------*

       request.empresa  = %xlate( min : may
                                : request.empresa);
       request.sucursal = %xlate( min : may
                                : request.sucursal);
       request.usuario  = %xlate( min : may
                                : request.usuario);

       // *----------------------*
       // La caratula debe existir
       // *----------------------*

           if SVPEMP_getDatosDeEmpresa( request.empresa
                                      : *omit ) = *off;
              @@MsgF = 'WSVMSG' ;
              @@CodM = 'COW0113';
              @@repl = request.empresa;
              FinErr ( @@repl
                     : @@CodM
                     : peMsgs
                     : @@MsgF);
              return;
           endif;

           if SVPSUC_getDatosDeSucursal( request.empresa
                                       : request.sucursal
                                       : *omit ) = *off ;
              @@MsgF = 'WSVMSG' ;
              @@CodM = 'COW0114';
              @@repl = request.sucursal;
              FinErr ( @@repl
                     : @@CodM
                     : peMsgs
                     : @@MsgF);
              return;
           endif;

           if SVPTAB_chkSet001( request.rama ) = *on ;
              @@MsgF = 'WSVMSG' ;
              @@CodM = 'RAM0001';
              @@repl = %char(request.rama);
              FinErr ( @@repl
                     : @@CodM
                     : peMsgs
                     : @@MsgF);
              return;
           endif;

          if SVPSI1_chkPahshp01( request.empresa
                               : request.sucursal
                               : request.areaTecnica
                               : request.nroCbatePago ) = *off;
             @@MsgF = 'WSVMSG';
             @@CodM = 'ODP0052';
             %subst(@@repl:1:6) = %char(request.nroCbatePago);
             %subst(@@repl:7:9) = %char(request.areaTecnica);
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs
                    : @@MsgF);
             return;
          endif;

       // *-------------------*
       // Valido Tipo de Recibo
       // *-------------------*

          if SVPTAB_chkSet426( request.rama
                             : request.tipoRecibo ) = *off;
             @@MsgF = 'WSVMSG';
             @@CodM = 'ODP0051';
             @@repl = %char(request.tipoRecibo);
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs
                    : @@MsgF);
             return;
          endif;

       // *-------------------*
       // Obtengo Nro de Recibo
       // *-------------------*

          if request.nroRecibo = *ZEROS;
             @@Nrec = SVPSI1_getVoucher();
          else;
             @@Nrec = request.nroRecibo;
          endif;

       // -------------------------------------
       // Ok - Cargo Estructuras
       // -------------------------------------

       // *------*
       // Cabecera
       // *------*

       clear @@DsIc;
       @@DsIc.icempr = request.empresa;
       @@DsIc.icsucu = request.sucursal;
       @@DsIc.icartc = request.areaTecnica;
       @@DsIc.icpacp = request.nroCbatePago;
       @@DsIc.icivnr = @@Nrec;
       @@DsIc.ictire = request.tipoRecibo;
       @@DsIc.icmar1 = *blanks;
       @@DsIc.icmar2 = *blanks;
       @@DsIc.icmar3 = *blanks;
       @@DsIc.icmar4 = *blanks;
       @@DsIc.icmar5 = *blanks;
       @@DsIc.icmar6 = *blanks;
       @@DsIc.icmar7 = *blanks;
       @@DsIc.icmar8 = *blanks;
       @@DsIc.icmar9 = *blanks;
       @@DsIc.icmar0 = *blanks;
       @@DsIc.icdate = %dec(%date():*iso);
       @@DsIc.ictime = %dec(%time():*iso);
       @@DsIc.icuser = request.usuario;

       if request.nroRecibo = 0;

       // -------------------------------------
       // Realizo Alta Cabecera
       // -------------------------------------

       if SVPSI1_setCnhric(@@DsIc) = *on;

       // *-----*
       // Detalle
       // *-----*

       z = 0;
       for x = 1 to 999;
       if request.lineas.linea(x).texto <> *blanks;
          z += 1;
          clear @@DsId;
          @@DsId.idempr = request.empresa;
          @@DsId.idsucu = request.sucursal;
          @@DsId.idartc = request.areaTecnica;
          @@DsId.idpacp = request.nroCbatePago;
          @@DsId.idivnr = @@Nrec;
          @@DsId.idtpnl = z;
          @@DsId.idtpds = request.lineas.linea(x).texto;
          @@DsId.iddate = %dec(%date():*iso);
          @@DsId.idtime = %dec(%time():*iso);
          @@DsId.iduser = request.usuario;

       // -------------------------------------
       // Realizo Alta Detalle
       // -------------------------------------

          if SVPSI1_setCnhrid(@@DsId) = *on;
             REST_writeHeader( 201
                             : *omit
                             : *omit
                             : *omit
                             : *omit
                             : *omit
                             : *omit );


          // Armo Salida
             REST_writeEncoding();

             REST_startArray( 'reciboIndemnizacion' );
                        REST_writeXmlLine( 'empresa'
                                         : %char(request.empresa) );
                        REST_writeXmlLine( 'sucursal'
                                         : %char(request.sucursal) );
                        REST_writeXmlLine( 'areaTecnica'
                                         : %char(request.areaTecnica) );
                        REST_writeXmlLine( 'nroCbatePago'
                                         : %char(request.nroCbatePago) );
                        REST_writeXmlLine( 'tipoRecibo'
                                         : %char(request.tipoRecibo) );
                        REST_writeXmlLine( 'nroRecibo'
                                         : %char(@@Nrec) );
             REST_endArray  ( 'reciboIndemnizacion');

             REST_end();

          else;
             REST_writeHeader( 400
                             : *omit
                             : *omit
                             : *omit
                             : *omit
                             : *omit
                             : *omit );
          endif;

       endif;
       endfor;

       else;
           REST_writeHeader( 400
                           : *omit
                           : *omit
                           : *omit
                           : *omit
                           : *omit
                           : *omit );
       endif;
       endif;

       return;

      * ------------------------------------------------- *
      *  Funcion Error Salida
     PfinErr           b
      * Interfaz Procedimiento...
     Dfinerr           pi
     D p1repl                     65535a
     D p1CodM                         7
     D p1Msgs                              likeds(paramMsgs)
     D p1MsgF                        10a
      *
          //'WSVMSG'
          rc1 = SVPWS_getMsgs( '*LIBL'
                             : p1Msgf
                             : p1CodM
                             : peMsgs
                             : %trim(p1repl)
                             : %len(%trim(p1repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : p1CodM
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
     PfinErr           e

