     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRINT: QUOM Versión 2                                       *
      *         Datos de intermediario                               *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *02-Jun-2017            *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      *   JSN 11/07/2018 - Se agrega los campos: direccion,          *
      *                    codigoTipo y descripcionTipo en EMAILS    *
      *   EXT 20/07/2018 - Nuevo Tag <muestraTelefonos>,             *
      *                    <muestraMails>                            *
      *   EXT 12/09/2018 - Nuevo Tag <polizaElectronica>             *
      *   JSN 29/01/2019 - Nuevo Tag <codigoDeBloqueo>               *
      *                                                              *
      * ************************************************************ *
     Fgntemp    if   e           k disk
     Fgntsuc    if   e           k disk
     Fgnttdo    if   e           k disk
     Fsehni2    if   e           k disk
     Fsehni2p   if   e           k disk
     Fgnhda7    if   e           k disk
     Fgnttce    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/mail_h.rpgle'
      /copy './qcpybooks/svpint_h.rpgle'

     D WSLINT          pr                  ExtPgm('WSLINT')
     D   peBase                            likeds(paramBase) const
     D   peDint                            likeds(pahint_t)
     D   peMint                            likeds(dsMail_t) dim(100)
     D   peMintc                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D fnac            s             10a
     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n
     D c               s             10i 0
     D rc2             s             10i 0

     D CRLF            c                   x'0d25'

     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0
     D peDint          ds                  likeds(pahint_t)
     D peMint          ds                  likeds(dsMail_t) dim(100)
     D peMintc         s             10i 0
     D x               s             10i 0
     D k1hni2          ds                  likerec(s1hni2:*key)
     D k1hni2p         ds                  likerec(s1hni2p:*key)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)
     D  job                          26a   overlay(PsDs:244)

      /free

       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
          return;
       endif;
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

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       COWLOG_logcon('WSRINT':peBase);

       WSLINT( peBase
             : peDint
             : peMint
             : peMintC
             : peErro
             : peMsgs   );

       if peErro = -1;
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       fnac = %editc( peDint.infnaa : 'X' )
            + '-'
            + %editc( peDint.infnam : 'X' )
            + '-'
            + %editc( peDint.infnad : 'X' );

       chain peDint.intido gnttdo;
       if %found;
          gndatd = *blanks;
          gndtdo = *blanks;
       endif;

       REST_writeHeader();
       REST_write( '<?xml version="1.0" encoding="ISO-8859-1"?>');

       REST_writeXmlLine( 'intermediario' : '*BEG' );

        REST_writeXmlLine( 'nombre'   : %trim(peDint.innomb) );
        REST_writeXmlLine( 'fechaNac' : %trim(fnac) );
        REST_writeXmlLine( 'tipoDocumento' : %trim(gndtdo) );
        REST_writeXmlLine( 'nroDocumento' : %trim(%char(peDint.innrdo)) );
        REST_writeXmlLine( 'nroDeIibb' : %trim(%char(peDint.innuib)) );
        REST_writeXmlLine( 'nroMatricula' : %trim(%char(peDint.inmatr)) );
        REST_writeXmlLine( 'nroDeCuit' : %trim(peDint.incuit) );
        REST_writeXmlLine( 'pais' : 'ARGENTINA' );
        REST_writeXmlLine( 'provincia' : %trim(peDint.inprod) );
        REST_writeXmlLine( 'localidad' : %trim(peDint.inloca) );
        REST_writeXmlLine( 'codigoPostal' : %trim(%char(peDint.incopo)) );
        REST_writeXmlLine( 'domicilio' : %trim(peDint.indomi) );
        REST_writeXmlLine( 'telefonoParticular' : %trim(peDint.intel2) );
        REST_writeXmlLine( 'telefonoLaboral' : %trim(peDint.intel4) );
        if peMintC <= 0;
           REST_writeXmlLine( 'correoElectronico' : *blanks);
         else;
           REST_writeXmlLine( 'correoElectronico' : peMint(1).mail );
        endif;
        REST_writeXmlLine( 'nroDeFax' : %trim(peDint.intel8) );

        REST_startArray('correos');
        k1hni2.n2empr = empr;
        k1hni2.n2sucu = sucu;
        k1hni2.n2nivt = %dec(nivt:1:0);
        k1hni2.n2nivc = %dec(nivc:5:0);
        chain %kds(k1hni2) sehni2;
        setll n2nrdf gnhda7;
        reade n2nrdf gnhda7;
        dow not %eof;
          REST_startArray('correo');
          chain dfctce gnttce;
          if not %found;
             cedtce = *blanks;
          endif;
          REST_writeXmlLine( 'direccionCorreo': %trim(dfmail));
          REST_writeXmlLine( 'tipoCorreo':%char(dfctce));
          REST_writeXmlLine( 'descripcionTipo': %trim(CEDTCE) );
          REST_endArray('correo');
         reade n2nrdf gnhda7;
        enddo;

        REST_endArray('correos');

        if SVPINT_isMostrarTelefonos( empr
                                    : sucu
                                    : %dec( nivt : 1 : 0 )
                                    : %dec( nivc : 5 : 0 )
                                    : *Omit );
          REST_writeXmlLine( 'muestraTelefonos' : 'S' );
        else;
          REST_writeXmlLine( 'muestraTelefonos' : 'N' );
        endif;

        if SVPINT_isMostrarMails( empr
                                : sucu
                                : %dec( nivt : 1 : 0 )
                                : %dec( nivc : 5 : 0 )
                                : *Omit );
          REST_writeXmlLine( 'muestraMails' : 'S' );
        else;
          REST_writeXmlLine( 'muestraMails' : 'N' );
        endif;

        REST_startArray( 'polizaElectronica' );
          k1hni2p.npempr = empr;
          k1hni2p.npsucu = sucu;
          k1hni2p.npnivt = %dec(nivt:1:0);
          k1hni2p.npnivc = %dec(nivc:5:0);
          chain %kds( k1hni2p : 4 ) sehni2p;
          if %found;
            REST_writeXmlLine( 'recibe' : 'S' );
            REST_writeXmlLine( 'mail' : %trim( npmail ) );
          else;
            REST_writeXmlLine( 'recibe' : 'N' );
            REST_writeXmlLine( 'mail' : *Blanks );
          endif;
        REST_endArray( 'polizaElectronica' );
        REST_writeXmlLine( 'codigoDeBloqueo' : %char( peDint.inbloq ) );

       REST_writeXmlLine( 'intermediario' : '*END' );

       close *all;

       return;

