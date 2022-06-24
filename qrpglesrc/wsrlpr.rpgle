     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRLPR: BPM                                                  *
      *         Lista de Provincias                                  *
      * ------------------------------------------------------------ *
      * Facundo Astiz                        *29-Nov-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'
      *------------------------------------------------------------- *

      *--- Variables REST ------------------------------------------ *
     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n

      *--- Variables de Trabajo ------------------------------------ *
     D @@DsGp          ds                  likeds ( dsgntpro_t ) dim( 99 )
     D @@DSGPC         s             10i 0
     D @x              s             10i 0

      *--- Estructura Interna -------------------------------------- *
     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)


      *------------------------------------------------------------- *
      /free

       *inlr = *on;

       SVPTAB_getGntpro( @@DsGp
                       : @@DsGpC
                       : *omit);

       REST_writeHeader();
       REST_writeEncoding();


       REST_startArray( 'provincias' );

       for @x = 1 to @@DsGpC;
        REST_startArray( 'provincia' );
         REST_writeXmlLine( 'codigo'       : %trim(@@DsGp(@x).prproc)  );
         REST_writeXmlLine( 'descripcion'  : %trim(@@DsGp(@x).prprod)  );
        REST_endArray( 'provincia' );
       endfor;

       REST_endArray( 'provincias' );
       REST_end();


       //return;

