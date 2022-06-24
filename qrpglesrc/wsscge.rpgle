     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSCGE: BPM                                                  *
      *         Lista de Cuentas Contables.                          *
      * ------------------------------------------------------------ *
      * Nestor Nestor                        *31-Ago-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'
      /copy './qcpybooks/svpsuc_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpemp_h.rpgle'

     D uri             s            512a
     D url             s           3000a   varying
     D empr            s              1a
     D sucu            s              2a
     D tipo            s              1a
     D peEmpr          s              1a
     D peSucu          s              2a

     D x               s             10i 0

     D rc              s              1n
     D peDsCgC         s             10i 0
     D peDsCg          ds                  likeds(dscntcge_t) dim(99999)
     D @@DsEmp         ds                  likeds(dsGntemp_t)
     D @@DsSuc         ds                  likeds(dsGntsuc_t)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)


      /free

       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
         REST_writeHeader( 204
                         : *omit
                         : *omit
                         : 'RPG0001'
                         : 40
                         : 'Error al parsear URL'
                         : 'Error al parsear URL' );
         REST_end();
         return;
       endif;
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       peEmpr = *blanks;
       peSucu = *blanks;

         empr = REST_getNextPart(url);
         sucu = REST_getNextPart(url);

         peEmpr = empr ;
         peSucu = sucu ;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'cuentasContables' );
       if SVPEMP_getDatosDeEmpresa( peEmpr : @@DsEmp );
        if SVPSUC_getDatosDeSucursal( peEmpr : peSucu : @@DsSuc );
         if SVPTAB_ListaCuentasContables( peDsCg : peDsCgC );
          for x = 1 to peDsCgC;
           REST_startArray( 'cuentaContable' );
             REST_writeXmlLine( 'empresa'
                                : %trim( @@DsEmp.emempr) );
             REST_writeXmlLine( 'sucursal'
                                : %trim( @@DsSuc.susucu) );
             REST_writeXmlLine( 'numeroCuentaMayor'
                                : %editc(peDsCg(x).cgnrcm:'Z'));
             REST_writeXmlLine( 'digitoVerifCtaMayor'
                                : %trim(peDsCg(x).cgdvcm) );
             REST_writeXmlLine( 'nombreCtaMayorGral'
                                : %trim(peDsCg(x).cgncmc) );
             REST_writeXmlLine( 'tipoCtaMayorGral'
                                : %editc(peDsCg(x).cgticm:'Z'));
             REST_writeXmlLine( 'codigoIndice'
                                : %trim(peDsCg(x).cgindi) );
             REST_writeXmlLine( 'mayorIndividual'
                                : %trim(peDsCg(x).cgmind) );
             REST_writeXmlLine( 'listarMayorAsieTrans'
                                : %trim(peDsCg(x).cglmat) );
             REST_writeXmlLine( 'ctaMayorAsocAMayorAu'
                                : %trim(peDsCg(x).cgasma) );
             REST_writeXmlLine( 'codigoDeBloqueo'
                                : %trim(peDsCg(x).cgbloq) );
             REST_writeXmlLine( 'codigoBalanceSySaldo'
                                : %editc(peDsCg(x).cgcbss:'Z'));
             REST_writeXmlLine( 'altaBajaCambio'
                                : %trim(peDsCg(x).cgabcv) );
             REST_writeXmlLine( 'esCuentaCreditoFiscal'
                                : %trim(peDsCg(x).cgcrfi) );
           REST_endArray  ( 'cuentaContable' );
          endfor;
         endif;
        endif;
       endif;
       REST_endArray  ( 'cuentasContables' );

       return;

