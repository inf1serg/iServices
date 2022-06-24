     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSCOM: BPM                                                  *
      *         Lista de Compañias                                   *
      * ------------------------------------------------------------ *
      * Nestor Nestor                        *31-Ago-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'

     D uri             s            512a
     D url             s           3000a   varying
     D tipo            s              1a

     D x               s             10i 0

     D rc              s              1n
     D peDsCmC         s             10i 0
     D peDsCm          ds                  likeds(dsset120_t) dim(999)

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

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'companias' );
        if SVPTAB_ListaCompanias( peDsCm : peDsCmC );
         for x = 1 to peDsCmC;
           REST_startArray( 'compania' );
             REST_writeXmlLine( 'codCiaCoasegurado'
                                : %editc(peDsCm(x).t@ncoc:'Z'));
             REST_writeXmlLine( 'claveArchDatosFilia'
                                : %editc(peDsCm(x).t@nadf:'Z'));
             REST_writeXmlLine( 'nombreAbreviadoCia'
                                : %trim(peDsCm(x).t@nacc) );
             REST_writeXmlLine( 'numeroCuentaMayor'
                                : %editc(peDsCm(x).t@nrcm:'Z'));
             REST_writeXmlLine( 'codigoMayorAuxiliar'
                                : %trim(peDsCm(x).t@coma) );
             REST_writeXmlLine( 'numeroMayorAuxiliar'
                                : %editc(peDsCm(x).t@nrma:'Z'));
             REST_writeXmlLine( 'especializMayorAuxiliar'
                                : %editc(peDsCm(x).t@esma:'Z'));
             REST_writeXmlLine( 'companiaPropia'
                                : %trim(peDsCm(x).t@ciap) );
             REST_writeXmlLine( 'codigoIva'
                                : %editc(peDsCm(x).t@civa:'Z'));
             REST_writeXmlLine( 'nombreProgAEjecutar'
                                : %trim(peDsCm(x).t@pgal) );
             REST_writeXmlLine( 'nombreDirectorio'
                                : %trim(peDsCm(x).t@ndal) );
             REST_writeXmlLine( 'nombreSubdirectorio'
                                : %trim(peDsCm(x).t@nsal) );
             REST_writeXmlLine( 'nombreProgAEjecutar2'
                                : %trim(peDsCm(x).t@pga2) );
             REST_writeXmlLine( 'nombreDirectorio2'
                                : %trim(peDsCm(x).t@nda2) );
             REST_writeXmlLine( 'nombreSubdirectorio2'
                                : %trim(peDsCm(x).t@nsa2) );
             REST_writeXmlLine( 'variableAlfDe3'
                                : %trim(peDsCm(x).t@nom3) );
             REST_writeXmlLine( 'numeroOperacion'
                                : %editc(peDsCm(x).t@ope1:'Z'));
             REST_writeXmlLine( 'numeroOperacion2'
                                : %editc(peDsCm(x).t@ope2:'Z'));
             REST_writeXmlLine( 'codigoCIASSN'
                                : %editc(peDsCm(x).t@nier:'Z'));
             REST_writeXmlLine( 'CIAAdmiteCleas'
                                : %trim(peDsCm(x).t@clea) );
           REST_endArray  ( 'compania' );
         endfor;
        endif;
       REST_endArray  ( 'companias' );

       return;

