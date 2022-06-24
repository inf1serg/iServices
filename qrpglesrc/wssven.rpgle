     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     * Ruta de directorio de enlace de SERVICES PROGRAMS
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
     * ************************************************************ *
     *WSSVEN  BPM  Versión 1                                      *
     *         Retorna Datos de los vehiculos de un endoso          *
     * Método: GET                                                  *
     * Parám.recibir URL: Empresa, Sucursal, Rama, Póliza, Suplemen_*
     *                    to.                                       *
     *                                                              *
     *                                                              *
     *                                                              *
     * ------------------------------------------------------------ *
     * David Tilatti                        *29 Set-2021            *
     * ------------------------------------------------------------ *
     * Modificaciones:                                              *
     *                                                              *
     * ************************************************************ *
     *--- Definiciones DB ----------------------------------------- *
     Fpahet0    if   e           k disk
     Fset412    if   e           k disk
     Fset409    if   e           k disk

     *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/spvveh_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/svppol_h.rpgle'
      //-- Definiciones                      ----------------//
     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n

     * Definiciones variables y array para utilizacion SVP
     D @@repl          s          65535a
     D peMsgs          ds                  likeds(paramMsgs)
     D @@DsD0          ds                  likeds ( dsPahed0_t ) dim( 999 )
     D @@DsD0C         s             10i 0

     * Parametros de llamada
     D empr            s              1a                                        Empresa URL
     D sucu            s              2a                                        Sucursal URL
     D rama            s              2a                                        Rama URL
     D poli            s              7a                                        Poliza URL
     D suop            s              3a                                        Suplemento URL
     * Parametros de llamada Numericos
     D peRama          s              2  0
     D pePoli          s              7  0
     D peSuop          s              3  0
     * Claves
     D k1het0          ds                  likerec(p1het0:*key)
     D k1t412          ds                  likerec(s1t412:*key)
     D*k1t409          ds                  likerec(s1t409:*key)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

       //------      Cuerpo Principal       ------------------//

      /free

       *inlr = *on;

       //Recuperar la URL desde donde se lo llamo
       rc  = REST_getUri( psds.this : uri );

       //Error en la llamada al servicio
       if rc = *off;
          REST_writeHeader( 204
                          : *omit
                          : *omit
                          : 'RPG0001'
                          : 40
                          : 'Error al parsear URL'
                          : 'Error al parsear URL' );
          REST_end();
       //Cierro BD vuelvo al llamador y evito resto de proceso
          close *all;
          return;
       endif;

       // Mueve la URI a URL eliminado blancos
       url = %trim(uri);

       // Obtengo los parámetros tipo string de la URL
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       rama = REST_getNextPart(url);
       poli = REST_getNextPart(url);
       suop = REST_getNextPart(url);

       // Paso a numerico por longitud, monitoreo en caso de error pone valor en 0
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
          peSuop = %dec(suop:3:0);
       on-error;
          peSuop = 0;
       endmon;

       //Valido existencia de poliza
       clear @@DsD0;
       clear @@DsD0C;
       if not SVPPOL_getPoliza( empr
                              : sucu
                              : peRama
                              : pePoli
                              : peSuop
                              : *omit
                              : *omit
                              : *omit
                              : *omit
                              : *omit
                              : @@DsD0
                              : @@DsD0C);
          @@repl = poli;

       //Envio Mensaje de Error POL*
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'POL0008'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2  );
          REST_end();
          SVPREST_end();

       //Cierro BD vuelvo al llamador y evito resto de proceso
          close *all;
          return;
       endif;

       //
       //Armo respuesta
       //
       k1het0.t0empr = empr;
       k1het0.t0sucu = sucu;
       k1het0.t0arcd = SVPPOL_getArticulo( empr
                                         : sucu
                                         : peRama
                                         : pePoli
                                         : peSuop );
       k1het0.t0spol = SVPPOL_getSuperPoliza( empr
                                            : sucu
                                            : peRama
                                            : pePoli
                                            : peSuop );
       k1het0.t0sspo = peSuop;

       setll %kds(k1het0:5) pahet0;
       reade %kds(k1het0:5) pahet0;

       //Arma XML
       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'bienesEndoso' );
       dow not %eof;
           REST_startArray( 'bien' );
            REST_writeXmlLine( 'componente' : %char(t0poco) );
            REST_writeXmlLine( 'marca' : %trim(SVPDES_marca(t0Vhmc)) );
            REST_writeXmlLine( 'modelo' : %trim(SVPDES_modelo(t0Vhmo)) );
            REST_writeXmlLine( 'tipo' : %trim(SVPDES_getTipoDeVehiculo(t0Vhct))
                              );
            REST_writeXmlLine( 'dominio' : %trim(t0nmat) );
            REST_writeXmlLine( 'anio' : %char(t0vhaÑ) );
            REST_writeXmlLine( 'motor' : %trim(t0moto) );
            REST_writeXmlLine( 'chasis' : %trim(t0chas) );
            REST_writeXmlLine( 'cobertura' : %trim(t0cobl) );
            REST_writeXmlLine( 'sumaAseg' : %char(t0vhvu) );


              //Armo clave parcial
              k1t412.t@cobl = t0cobl;
              k1t412.t@xcob = *zero;
              k1t412.t@hecg = *blanks;

              setll %kds(k1t412:3) set412;
              reade %kds(k1t412:1) set412;

              dow not %eof;

              //traigo decripcion Cobertura
               chain (t@xcob) set409;
               if not %found;
               t@cobd = '*Cobertura Inexistente*';
               endif;
       //Armo XML con las coberturas
               REST_startArray( 'coberturasSsn' );
                REST_startArray( 'coberturaSsn' );
                 REST_writeXmlLine( 'codigo' : %char(t@xcob) );
                 REST_writeXmlLine( 'descripcion' : %trim(t@cobd) );
                 REST_writeXmlLine( 'hechGenDefecto' : %trim(t@hecg) );
                REST_endArray( 'coberturaSsn' );
               REST_endArray( 'coberturasSsn' );

              reade %kds(k1t412:1) set412;
              enddo;

           REST_endArray( 'bien' );
        reade %kds(k1het0:5) pahet0;
       enddo;
       REST_endArray( 'bienesEndoso' );

       REST_end();
       close *all;

