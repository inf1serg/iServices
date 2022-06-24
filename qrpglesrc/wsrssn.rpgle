     H option(*srcstmt:*noshowcpy:*nodebugio:*nounref)
     H actgrp( *new ) dftactgrp( *no )
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRSSN: RM#03689 Requerimiento SSN                           *
      *         AUTOS - Póliza Dígital SSN.                          *
      * ------------------------------------------------------------ *
      * Luis R. Gómez                                  * 24-Ago-2018 *
      * ------------------------------------------------------------ *
      * Modificiones:                                                *
      * NWN - NWN - 05/11/19 : Agregado de Seguro de Registro.       *
      * NWN - NWN - 21/11/19 : Recompilacion por cambio en ssnf1101  *
      *                        Agrego validación CUIT.               *
      * SGF - SGF - 28/11/19 : Uso GetCadena() para cabecera.        *
      *                        Edito importe franquicia.             *
      * SGF - SGF - 23/12/19 : Agrando array de vehiculos de WSLVHP. *
      * SGF - SGF - 11/12/20 : Nueva version del soft de SSN.        *
      *                        Se agrega Bonificacion, el estado del *
      *                        vehiculo y el nro de orden del auto.  *
      * SGF - SGF - 27/10/21 : Nueva version del soft de SSN.        *
      * ************************************************************ *
     Fssnp0101  if   e           k disk    rename( s1np01 : s1np0101 )
     Fssnp02    if   e           k disk
     Fssnp03    if   e           k disk

      * Parametros de entrada ---------------------------------- *
     D empr            s              1a
     D sucu            s              2a
     D cantReg         s             10a

      * Variables ----------------------------------------------- *
     D @@cant          s             10i 0
     D @@vssn          s              1a
     D @@vsys          s            512a
     D rc              s               n
     D uri             s            512a
     D url             s           3000a   varying
     D z               s             10i 0

     D k1np02          ds                  likerec(s1np02:*key)
     D k1np03          ds                  likerec(s1np03:*key)

      * Informacion de Sistema ---------------------------------- *
     D psds           sds                  qualified
     D  this                         10a   overlay( psds : 1 )

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'

      /free

        *inlr = *on;

        // ------------------------------------------ //
        // Obtener los parámetros de la URL           //
        // ------------------------------------------ //
        rc  = REST_getUri( psds.this : uri );
        if rc = *off;
           return;
        endif;
        url = %trim( uri );
        empr    = REST_getNextPart(url);
        sucu    = REST_getNextPart(url);
        cantReg = REST_getNextPart(url);

        monitor;
          @@cant = %int(%trim(cantReg));
        on-error;
          @@cant = 0;
        endmon;

        //
        // Recuperar version del webservice de ssn
        // ya que en version 2 hay campos nuevos y
        // formas de procesar diferentes
        //
        @@vssn = '1';
        if SVPVLS_getValSys( 'HWEBSSNPOV' : *omit : @@vsys );
           @@vssn = @@vsys;
        endif;

        REST_writeHeader();
        REST_writeEncoding();
        REST_startArray( 'polizas' );
        setll *loval ssnp0101;
        read  ssnp0101;
        dow not %eof( ssnp0101);

            REST_startArray( 'poliza ');

            REST_writeXmlLine( 'codigoCompania': '0335'                 );
            REST_writeXmlLine( 'cuit'               : %trim( p0cuit  )  );
            REST_writeXmlLine( 'codigoRamo'         : %trim( p0ramo  )  );
            REST_writeXmlLine( 'codigoSubramo'      : %trim( p0subr  )  );
            REST_writeXmlLine( 'codigoSeguimiento'  : ' '               );
            REST_writeXmlLine( 'camporeservadoSSN1' : ' '               );
            REST_writeXmlLine( 'camporeservadoSSN2' : ' '               );
            REST_writeXmlLine( 'nroOrdenEndoso'     : %char(p0suop)     );
            REST_writeXmlLine( 'nroPoliza'          : %char(p0poli)     );
            REST_writeXmlLine( 'nroEndoso'          : %char(p0endo)     );
            REST_writeXmlLine( 'tipoEndoso'         : %trim(p0tend)     );
            REST_writeXmlLine( 'coaseguro'          : 'NO'              );
            REST_writeXmlLine( 'piloto'             : 'NO'              );
            REST_writeXmlLine( 'companiaPiloto'     : '0'               );
            REST_writeXmlLine( 'nroPolizaPiloto'    : '0'               );
            REST_writeXmlLine( 'participacion'      : '0'               );
            REST_writeXmlLine( 'nroPolizaRenovacion': %char(p0poan)     );
            REST_writeXmlLine( 'fechaEmision'       :%trim(p0femi)      );
            REST_writeXmlLine( 'fechaDesde'         : %trim(p0fdes)     );
            REST_writeXmlLine( 'fechaHasta'         : %trim(p0fhas)     );
            REST_writeXmlLine( 'tomadorAsegurado'   : 'T'               );
            REST_writeXmlLine( 'razonSocialNomApell': %trim(p0nase)     );
            REST_writeXmlLine( 'tipoDocumento'      : %trim(p0tido)     );
            REST_writeXmlLine( 'nroDocumento'       : %trim(p0nrdo)     );
            REST_writeXmlLine( 'provincia'          : %trim(p0rpro)     );
            REST_writeXmlLine( 'tipoActoAdministrativo' : '38708'       );
            REST_writeXmlLine( 'nroActoAdministrativo'  : '38708'       );
            REST_writeXmlLine( 'esFlota'            :  p0flot           );
            REST_writeXmlLine( 'cantidadRiesgo'     : p0canr            );
            REST_writeXmlLine( 'tipoMoneda'         : %trim(p0mosu)     );
            REST_writeXmlLine( 'seguroDirecto'      : p0dire            );
            REST_writeXmlLine( 'matriculaProdAgentInt': p0mat1          );
            REST_writeXmlLine( 'organizador'        : p0mat3            );
            REST_writeXmlLine( 'primaPura'          : p0prpu            );
            REST_writeXmlLine( 'gastosProduccion' : %trim(p0gpro)       );
            REST_writeXmlLine( 'gastosExplotacion': %trim(p0gexp)       );
            REST_writeXmlLine('primaTarifa'      : %trim(p0prim)        );
            REST_writeXmlLine('recargoFinanciero': %trim(p0refi)        );
            REST_writeXmlLine( 'iva'             : %trim(p0viva)        );
            REST_writeXmlLine( 'ingresosBrutos'  : %trim(p0iibb)        );
            REST_writeXmlLine( 'sellados'        : %trim(p0seri)        );
            REST_writeXmlLine( 'tasaSSN'          : %trim(p0tssn)       );
            REST_writeXmlLine( 'cuotaSocial'      : %trim(p0sers)       );
            REST_writeXmlLine( 'otrosImpuestos'   : %trim(p0oimp)       );
            if @@vssn = '2';
               REST_writeXmlLine( 'bonificacion'  : '.00'               );
            endif;
            REST_writeXmlLine( 'premio'           :  %trim(p0prem)      );
            REST_writeXmlLine( 'formaPago'        : p0cfpg              );
            REST_writeXmlLine( 'periodoFc'        : %trim(p0pecu)       );
            REST_writeXmlLine( 'nombreArchivo'    : 'POLIZA.pdf'        );

            exsr $vehiculos;

            REST_startArray( 'clave' );
             REST_writeXmlLine( 'articulo'           : %char(p0arcd)      );
             REST_writeXmlLine( 'superPoliza'        : %char(p0spol)      );
             REST_writeXmlLine( 'suplemento'         : %char(p0sspo)      );
             REST_writeXmlLine( 'rama'               : %char(p0rama)      );
             REST_writeXmlLine( 'secuenciaArticulo'  : %char(p0arse)      );
             REST_writeXmlLine( 'operacion'          : %char(p0oper)      );
             REST_writeXmlLine( 'suplementoOperacion': %char(p0suop)      );
            REST_endArray    ( 'clave' );

            REST_endArray('poliza');

            if @@cant <> 0;
              z += 1;
              if z >= @@cant;
                leave;
              endif;
            endif;

         read  ssnp0101;
        enddo;
        REST_endArray  ( 'polizas' );

        REST_end();
        return;

        begsr $vehiculos;
         k1np02.p0empr = p0empr;
         k1np02.p0sucu = p0sucu;
         k1np02.p0arcd = p0arcd;
         k1np02.p0spol = p0spol;
         k1np02.p0sspo = p0sspo;
         k1np02.p0rama = p0rama;
         k1np02.p0arse = p0arse;
         k1np02.p0oper = p0oper;
         k1np02.p0suop = p0suop;
         REST_startArray( 'vehiculos' );
         setll %kds(k1np02:9) ssnp02;
         reade %kds(k1np02:9) ssnp02;
         dow not %eof;
             REST_startArray( 'vehiculo' );
              if p0tveh = '00' or
                 p0tveh = '01' or
                 p0tveh = '02' or
                 p0tveh = '03' or
                 p0tveh = '04' or
                 p0tveh = '05' or
                 p0tveh = '06' or
                 p0tveh = '07' or
                 p0tveh = '08' or
                 p0tveh = '09';
                 REST_writeXmlLine('tipoVehiculo':%subst(p0tveh:2:1) );
               else;
                 REST_writeXmlLine('tipoVehiculo': p0tveh );
              endif;
              REST_writeXmlLine('patente'           : p0nmat              );
              REST_writeXmlLine('ubicacionRiesgo'   : p0ubir              );
              REST_writeXmlLine('marca'             : p0vhmd              );
              REST_writeXmlLine('modelo'            : p0vhdm              );
              REST_writeXmlLine('anioFabricacion': %editc(p0vhan:'X')     );
              REST_writeXmlLine('nroMotor'          : p0moto              );
              REST_writeXmlLine('nroChasis'         : p0chas              );
              REST_writeXmlLine('codigoSeguimiento' : *blanks             );
              REST_writeXmlLine('suma'              : p0vhvu              );
              REST_writeXmlLine('tipoMoneda'        : p0mosu              );
              REST_writeXmlLine('prenda'            : p0pren              );
              if @@vssn = '2';
                 REST_writeXmlLine('estadoVehiculo': p0esta  );
                 REST_writeXmlLine('nroOrdenItem'
                                  : %char( p0poco )           );
               else;
                 REST_writeXmlLine('camporeservadoSSN5': *blanks );
                 REST_writeXmlLine('camporeservadoSSN6': *blanks );
              endif;
              REST_writeXmlLine('camporeservadoSSN7': *blanks );
              REST_writeXmlLine('camporeservadoSSN8': *blanks );
              REST_writeXmlLine('provincia'         : p0rpro  );
              REST_writeXmlLine('alcance'           : p0alca  );
              REST_writeXmlLine('jurisdiccionNacional':p0jnac );
              REST_writeXmlLine('tipoServicio'      : p0tser  );
              REST_writeXmlLine('destino'           : p0dest  );
              REST_writeXmlLine('primaTarifa'       : p1prim  );
              REST_writeXmlLine('premio'            : p1prem  );
              exsr $coberturas;
             REST_endArray  ( 'vehiculo' );
          reade %kds(k1np02:9) ssnp02;
         enddo;
         REST_endArray  ( 'vehiculos' );
        endsr;

        begsr $coberturas;
         k1np03.p0empr = p0empr;
         k1np03.p0sucu = p0sucu;
         k1np03.p0arcd = p0arcd;
         k1np03.p0spol = p0spol;
         k1np03.p0sspo = p0sspo;
         k1np03.p0rama = p0rama;
         k1np03.p0arse = p0arse;
         k1np03.p0oper = p0oper;
         k1np03.p0suop = p0suop;
         k1np03.p0poco = p0poco;
         REST_startArray( 'coberturas');
         setll %kds(k1np03:10) ssnp03;
         reade %kds(k1np03:10) ssnp03;
         dow not %eof;
             REST_startArray( 'cobertura');
              REST_writeXmlLine('codigo':p0cobl );
              REST_writeXmlLine('coberturaFranquicia' : p0cfra );
              REST_writeXmlLine('montoFranquicia' : p1ifra );
              REST_writeXmlLine('limiteMaxAcontecimiento' : p0lirc );
             REST_endArray  ( 'cobertura');
           reade %kds(k1np03:10) ssnp03;
         enddo;
         REST_endArray  ( 'coberturas');
        endsr;

      /end-free

