     H dftactgrp(*NO) actgrp(*caller)
     H option(*srcstmt: *nodebugio: *noshowcpy)
     H thread(*serialize)
     H bnddir('HDIILE/HDIBDIR':'QC2LE')
      * ************************************************************ *
      * WSRPRD: QUOM Versión 2                                       *
      *         Listado de Productores.                              *
      * ------------------------------------------------------------ *
      * JSN                               *14-Mar-2019               *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      * JSN 03/04/2019 - Se agrega parametro CUIT, y se modifica la  *
      *                  busqueda de los datos del productor.        *
      *                                                              *
      * ************************************************************ *
     fcntnau06  if   e           k disk
     fgnhdaf97  if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpmail_h.rpgle'
     *- ------------------------------------------------ *
     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)
     *****************************************************
     D uri             s            512a
     D url             s           3000a   varying
     D rc              s               n
     D x               s             10i 0
     D rc2             s             10i 0
     D cuit            s             11a
     D @@repl          s          65535a
     D @@Cuit          s             11a
     D @@Pos           s              2  0
     D @@Madd          ds                  likeds(MailAddr_t) dim(100)
     D peMsgs          ds                  likeds(paramMsgs)
     D @@Dcta          s             36a

     D k1yu06          ds                  likerec(c1tnau:*key)
     D k1yf97          ds                  likerec(g1hdaf:*key)

     D

      /free

       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
          return;
       endif;
       url = %trim(uri);

       // ------------------------------------------
       // Obtener parámetro de la URL
       // ------------------------------------------
       cuit = REST_getNextPart(url);

       @@Cuit = cuit;

       for x = 1 to %len(%trim(@@Cuit));
         @@Pos  = %check('0123456789':@@cuit);
         if @@Pos > *zeros;
           @@Cuit = %replace('0':@@Cuit:(@@Pos));
         else;
           leave;
         endif;
       endfor;

       k1yf97.dfCuit = @@Cuit;
       setll %kds( k1yf97 : 1 ) gnhdaf97;
       if not %equal( gnhdaf97 );
         @@repl = cuit;
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'PRD0003'
                      : peMsgs
                      : %trim(@@repl)
                      : %len(%trim(@@repl)) );
         rc = REST_writeHeader( 400
                              : *omit
                              : *omit
                              : 'PRD0003'
                              : peMsgs.peMsev
                              : peMsgs.peMsg1
                              : peMsgs.peMsg2 );
         REST_end();
         close *all;
         return;
       else;
         REST_writeHeader();
         REST_writeEncoding();
         REST_writeXmlLine( 'productores' : '*BEG' );
       endif;

       reade %kds( k1yf97 : 1 ) gnhdaf97;
       dow not %eof( gnhdaf97 );

         k1yu06.naEmpr = 'A';
         k1yu06.naSucu = 'CA';
         k1yu06.naNrdf = dfNrdf;
         setll %kds( k1yu06 : 3 ) cntnau06;
         reade %kds( k1yu06 : 3 ) cntnau06;
         dow not %eof( cntnau06 );

           REST_writeXmlLine( 'productor' : '*BEG' );

            REST_writeXmlLine('nombre':%trim(dfNomb));
            REST_writeXmlLine('codigoMayorAuxiliar':%trim(naComa));
            REST_writeXmlLine('numeroMayorAuxiliar':%trim(%editc(naNrma:'X')));

            clear @@Madd;
            rc2 = SVPMAIL_xProv( naEmpr
                               : naSucu
                               : naComa
                               : naNrma
                               : @@Madd
                               : 20     );

            if rc2 > *zeros;
              REST_writeXmlLine('correo' : %trim(@@Madd(1).Mail));
            else;
              REST_writeXmlLine('correo' : ' ');
           endif;

           REST_writeXmlLine( 'productor' : '*END' );

           reade %kds( k1yu06 : 3 ) cntnau06;
         enddo;

         reade %kds( k1yf97 : 1 ) gnhdaf97;
       enddo;

       REST_writeXmlLine( 'productores' : '*END' );

      /end-free

