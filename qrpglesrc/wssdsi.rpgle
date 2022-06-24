     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSSDSI  BPM  Versión 1                                      *
      *         Retorna Detalle del Siniestro Solicitado             *
      * Método: GET                                                  *
      * Parám.recibir URL: Empresa, Sucursal, Rama, Nro. Siniestro,  *
      *                    Nro Operacion Siniestro.                  *
      *          Objetivo: Retornar un ARRAY de Detalle de Siniestro *
      *                    para mostrar                              *
      *                                                              *
      * ------------------------------------------------------------ *
      * Valeria Marquez                      *01 Dic-2021            *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      *                                                              *
      * ************************************************************ *
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/svpsi1_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'
      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      *--- Utilizados para XML ------------------------------------- *
      /copy './qcpybooks/svppol_h.rpgle'
      /copy './qcpybooks/svpdaf_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/spvveh_h.rpgle'
      *
      // -- llamada programas                 ----------------//

      // -- Definiciones                      ----------------//
     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n
      // -- Informacion para xml
     D @@Direccion     s             50a   inz(*blanks)
     D @@Localidad     s             30a   inz(*blanks)
     D @@Provincia     s             30a   inz(*blanks)
     D @@motorizacion  s              6a   inz(*blanks)
     D @@fDenu         s             10
     D @@fOcur         s             10
     D @@fFact         s             10
     D @@fVige         s              8  0
     D @@Hora          s              6
     D @1Hora          s              8
     D @@rpro          s              2  0
     D @x              s             10i 0
     D @y              s             10i 0
     D @z              s             10i 0

      * Definiciones para funcion
     D fecha           s              8  0
     D fechaIso        s             10

      * Definiciones variables y array para utilizacion SVP
     D @@CodM          s              7    inz
     D @@repl          s          65535a
     D peMsgs          ds                  likeds(paramMsgs)
     D rc1             s             10i 0

      * Parametros de llamada
     D empr            s              1a                                         Empresa URL
     D sucu            s              2a                                         Sucursal URL
     D rama            s              2a                                         Rama URL
     D sini            s              7a                                         Siniestro URL
     D nops            s              7a                                         Nro Operacion URL
      *
      * Parametros de llamada Numericos
     D peRama          s              2  0
     D peSini          s              7  0
     D peNops          s              7  0
      *
      * Variables Validador Caratula
     D  peMsgf         s              6a
     D  peIdms         s              7a
      *
      * Parametros de Caratula de Denuncia
     D @@Dscd          ds                  likeds(dsPahscd_t) dim(9999)
     D @@DsCdC         s             10i 0
      *
      * Parametros de Causa Siniestro
     D peDs01          ds                  likeds(set401_t) dim(9999)
     D peDs01C         s             10i 0
      *
      * Parametros de Causa Siniestro
     D @@Ds402         ds                  likeds( DsSet402_t )
      * Se cambio por bienes Siniestrados en vez de Beneficiarios 8/2/2022 DOT
      * Parametros de Bienes Siniestrados
     D @@DsBs          ds                  likeds ( dsPahsbs_t ) dim(9999)
     D @@DsBsC         s             10i 0
      *
      * Parametros de Poliza
     D @@DsD0          ds                  likeds ( dsPahed0_t ) dim(9999)
     D @@DsD0C         s             10i 0
     D @@fHast         s              8  0
      *
      * Parametros de Asegurado
     D peNomb          s             40
     D peDomi          s             35
     D peNdom          s              5  0
     D pePiso          s              3  0
     D peDeto          s              4
     D peCopo          s              5  0
     D peCops          s              1  0
     D peTeln          s              7  0
     D peFaxn          s              7  0
     D peTiso          s              2  0
     D peTido          s              2  0
     D peNrdo          s              8  0
     D peCuit          s             11
     D peNjub          s             11  0
      *
      * Parametros de Vehiculo
     D @@DsVa          ds                  likeds ( dsPahsva_t ) dim(9999)
     D @@DsVaC         s             10i 0
      *
      * Parametros de Productor
     D peNivt          s              1  0
     D peNivc          s              5  0
     D @@nrdf          s             40
      *
      * Parametros de Prod.Art. Rama Automotores
     D @@DsT0          ds                  likeds ( dsPahet0_t )
      *

      * -- Prototipo Validador Caratula --
     D WSPVST          pr                  ExtPgm('WSPVST')
     D  peEmpr                        1a
     D  peSucu                        2a
     D  peRama                        2  0 const
     D  peSini                        7  0 const
     D  peNops                        7  0 const
     D  peMsgf                        6a
     D  peIdms                        7a
       // -------------------------------------
      *--- Estructura Interna -------------------------------------- *
     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)
      *------------------------------------------------------------- *

       // ------      Cuerpo Principal       ------------------//

      /free

       *inlr = *on;

       // Recuperar la URL desde donde se lo llamo
       rc  = REST_getUri( psds.this : uri );

       // Error en la llamada al servicio
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

       //  Mueve la URI a URL eliminado blancos
       url = %trim(uri);

       //  Obtengo los parámetros tipo string de la URL
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       rama = REST_getNextPart(url);
       sini = REST_getNextPart(url);
       nops = REST_getNextPart(url);

       // ** VALIDACIONES  **

       // Control de Blancos

       @@repl = *blanks;
       if empr = *blanks;
          @@repl = empr;
          peIdms = 'COW0113';
       elseif sucu = *blanks;
          @@repl = sucu;
          peIdms = 'COW0114';
       elseif rama = *blanks;
          @@repl = rama;
          peIdms = 'RAM0001';
       elseif sini = *blanks;
          peSini = 0;
       endif;
       if @@repl <> *blanks;
          @@CodM = peIdms;
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       // Control de Longitud

       @@repl = *blanks;
       monitor;
          peRama = %dec(rama:2:0);
       on-error;
          @@repl = rama;
          @@CodM = 'COW0136';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endmon;

       if Sini <> '0';
          monitor;
              peSini = %dec(sini:7:0);
          on-error;
              @@repl = sini;
              @@CodM = 'COW0136';
              FinErr ( @@repl
                     : @@CodM
                     : peMsgs);
              return;
          endmon;
       endif;

       monitor;
          peNops = %dec(nops:7:0);
       on-error;
          @@repl = nops;
          @@CodM = 'COW0136';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endmon;

       // Control de Existencia en tablas

       WSPVST( empr
             : sucu
             : perama
             : pesini
             : penops
             : peMsgf
             : peIdms );

       if peMsgf <> *blanks ;
          select;
             // Empresa inexistente
             when peIdms = 'COW0113';
                @@repl = empr;
             // Sucursal inexistente
             when peIdms = 'COW0114';
                @@repl = sucu;
             // Rama inexistente
             when peIdms = 'RAM0001';
                @@repl = rama;
             // Siniestro en Rama inexistente
             when peIdms = 'SIN0001';
                %subst(@@repl:1:2) = rama;
                %subst(@@repl:3:7) = sini;
          endsl;
          @@CodM = peIdms;
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       // ** Arma XML **

       REST_writeHeader();
       REST_writeEncoding();

       // Obtiene Caratula de Siniestro
       if SVPSI1_getPahscd( empr
                          : sucu
                          : peRama
                          : peSini
                          : peNops
                          : @@DsCd
                          : @@DsCdC) = *Off;
          rc1 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : peIdms
                             : peMsgs
                             : %trim(@@repl)
                             : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : peIdms
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
       endif;
       // Obtiene Bien siniestrado
       if SVPSI1_getPahsbs( empr
                          : sucu
                          : peRama
                          : peSini
                          : peNops
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : @@DsBs
                          : @@DsBsC);

       endif;

       For @x = 1 to @@DsCdC;

          if SPVVEH_getPahet0( empr
                             : sucu
                             : @@DsCd(@x).cdArcd
                             : @@DsCd(@x).cdSpol
                             : peRama
                             : @@DsCd(@x).cdArse
                             : @@DsBs(1).bsPoco
                             : @@DsCd(@x).cdSspo
                             : @@DsT0   );
          endif;

       REST_startArray( 'detalleSiniestro' );

           REST_writeXmlLine( 'empresa'     : empr  );
           REST_writeXmlLine( 'sucursal'    : sucu  );
           REST_writeXmlLine( 'rama'        : rama  );
           REST_writeXmlLine( 'siniestro'   : sini  );
           REST_writeXmlLine( 'nroOperStro' : nops  );

           @@fOcur = fecIso( @@DsCd(@x).cdfsia
                           : @@DsCd(@x).cdfsim
                           : @@DsCd(@x).cdfsid );
           REST_writeXmlLine( 'fechaOcurrencia' : @@fOcur );
           @@Hora = %char(@@DsCd(@x).cdHsin * 100);
           @1Hora = %subst(@@Hora:1:2)
                    + ':'
                    + %subst(@@Hora:3:2)
                    + ':'
                    + %subst(@@Hora:5:2);
           REST_writeXmlLine( 'horaOcurrencia' : %char(@1Hora ) );

           @@fDenu = fecIso( @@DsCd(@x).cdfdea
                           : @@DsCd(@x).cdfdem
                           : @@DsCd(@x).cdfded );
           REST_writeXmlLine( 'fechaDenuncia'   : @@fDenu );

           if SVPTAB_getCausas( peDs01
                              : peDs01C
                              : peRama
                              : @@DsCd(@x).cdCauc ) = *on;
           endif;
           REST_writeXmlLine( 'causa'  : %char( @@DsCd(@x).cdcauc ) );
           REST_writeXmlLine( 'descripcionCausa'
                            : %trim(peDs01(1).t@Caud) );

           if SVPSIN_getSet402( Empr
                              : Sucu
                              : peRama
                              : @@DsCd(@x).cdcesi
                              : @@Ds402) = *on;
           endif;
           REST_writeXmlLine( 'estado' : %char( @@DsCd(@x).cdcesi ) );
           REST_writeXmlLine( 'descripcionEstado'
                            : %char( @@Ds402.t@Desi ) );

           if SVPPOL_getPoliza( empr
                              : sucu
                              : peRama
                              : @@DsCd(@x).cdPoli
                              : @@DsCd(@x).cdSuop
                              : @@DsCd(@x).cdArcd
                              : @@DsCd(@x).cdSpol
                              : @@DsCd(@x).cdSspo
                              : @@DsCd(@x).cdArse
                              : @@DsCd(@x).cdOper
                              : @@DsD0
                              : @@DsD0C);

           For @y = 1 to @@DsD0C;

           REST_startArray( 'poliza' );
               REST_writeXmlLine( 'numero': %char(@@DsD0(@y).d0poli));
               REST_writeXmlLine( 'rama'  : %char(@@DsD0(@y).d0rama));

               @@nrdf = SPVSPO_getProductor( empr
                                           : sucu
                                           : @@DsCd(@x).cdArcd
                                           : @@DsCd(@x).cdSpol
                                           : @@DsCd(@x).cdSspo
                                           : peNivt
                                           : peNivc );
               if @@nrdf <> *blanks;

               REST_startArray( 'productor' );
                   REST_writeXmlLine( 'nivel'  : %char(peNivt) );
                   REST_writeXmlLine( 'codigo' : %char(peNivc) );
                   REST_writeXmlLine( 'nombre' : @@nrdf        );
               REST_endArray( 'productor' );

               endif;

               @@fFact = fecIso( @@DsD0(@y).d0fhfa
                               : @@DsD0(@y).d0fhfm
                               : @@DsD0(@y).d0fhfd );
               REST_writeXmlLine( 'fechaFacturacion': @@fFact );

            // @@fVige = fecIso( @@DsD0(@y).d0fioa
            //                 : @@DsD0(@y).d0fiom
            //                 : @@DsD0(@y).d0fiod );
               SPVSPO_getFecVig( Empr
                               : Sucu
                               : @@DsCd(@x).cdArcd
                               : @@DsCd(@x).cdSpol
                               : @@fVige
                               : @@fHast);
               REST_writeXmlLine( 'vigenciaDesde'
                                : SVPREST_editFecha(@@fVige) );
               REST_writeXmlLine( 'vigenciaHasta'
                                : SVPREST_editFecha(@@fHast) );

               REST_writeXmlLine( 'nroOperacion'    : %char(@@DsD0(@y).d0oper));
               REST_writeXmlLine( 'superPoliza'     : %char(@@DsD0(@y).d0spol));
               REST_writeXmlLine( 'suplSuperPoliza' : %char(@@DsD0(@y).d0sspo));
               REST_writeXmlLine( 'articulo'        : %char(@@DsD0(@y).d0arcd));

               REST_writeXmlLine( 'cobertura'
               : %trim(@@DsBs(1).bsriec)
               + '-'
               + %trim(SVPDES_coberturaVehiculo (%trim(@@DsBs(1).bsriec))));
               REST_writeXmlLine( 'sumaAsegurada'   : %char(@@DsT0.t0VHVU));
               REST_writeXmlLine( 'ValorFranquicia' : %char(@@DsT0.t0IFRA));
               REST_writeXmlLine( 'descripcionArticulo'
                                : SVPDES_articulo(@@dsd0(@y).d0arcd) );

           REST_endArray( 'poliza' );

           endfor;

           endif;

           if SVPDAF_getDaf( @@DsCd(@x).cdasen
                           : peNomb
                           : peDomi
                           : peNdom
                           : pePiso
                           : peDeto
                           : peCopo
                           : peCops
                           : peTeln
                           : peFaxn
                           : peTiso
                           : peTido
                           : peNrdo
                           : peCuit
                           : peNjub );

           REST_startArray( 'asegurado' );
               REST_writeXmlLine( 'codigo':%char(@@DsCd(@x).cdasen) );
               REST_writeXmlLine( 'nombre'          : peNomb        );
               REST_writeXmlLine( 'tipoDocumento'   : %char(peTido) );
               REST_writeXmlLine( 'descripcionTipoDocumento'
                                : SVPDES_tipoDocumento( peTido ) );
               REST_writeXmlLine( 'numeroDocumento' : %char(peNrdo) );
               REST_writeXmlLine( 'cuit'            : peCuit        );
               REST_writeXmlLine( 'telefono'        : %char(peTeln) );

               exsr srDomicilio;
               REST_writeXmlLine( 'direccion'       : @@Direccion   );
               REST_writeXmlLine( 'localidad'       : @@Localidad   );
               REST_writeXmlLine( 'provincia'       : @@Provincia   );

               REST_writeXmlLine( 'sufijoCodPos'    : %char(peCops) );
               REST_writeXmlLine( 'codigoPostal'    : %char(peCopo) );
           REST_endArray( 'asegurado' );
           endif;

           if SVPSIN_getVehiculo( empr
                                : sucu
                                : peRama
                                : peSini
                                : peNops
                                : *omit
                                : *omit
                                : *omit
                                : *omit
                                : *omit
                                : *omit
                                : @@DsVa
                                : @@DsVaC);

           For @z = 1 to @@DsVaC;

           REST_startArray( 'vehiculo' );
               REST_writeXmlLine( 'componente'   : %char(@@DsVa(@z).vapoco) );
               REST_writeXmlLine( 'marca'        : @@DsVa(@z).vavhmc        );
               REST_writeXmlLine( 'modelo'       : @@DsVa(@z).vavhmo        );
               REST_writeXmlLine( 'subModelo'    : @@DsVa(@z).vavhcs        );
               REST_writeXmlLine( 'anio'         : %char(@@DsVa(@z).vavhaÑ) );
               REST_writeXmlLine( 'tipoPatente'  : @@DsVa(@z).vatmat        );
               REST_writeXmlLine( 'patente'      : @@DsVa(@z).vanmat        );
               REST_writeXmlLine( 'motor'        : @@DsVa(@z).vamoto        );
               REST_writeXmlLine( 'chasis'       : @@DsVa(@z).vachas        );
               REST_writeXmlLine( 'tipoVehiculo' : %char(@@DsVa(@z).vavhct) );
               REST_writeXmlLine( 'uso'          : %char(@@DsVa(@z).vavhuv) );
               REST_writeXmlLine( 'descripcionUso'
                              : SVPDES_usoDelVehiculo (@@DsVa(@z).vavhuv));
               REST_writeXmlLine( 'carroceria'   : @@DsVa(@z).vavhcr        );
               exsr srMotorizacion;
               REST_writeXmlLine( 'motorizacion' : @@motorizacion );
               REST_writeXmlLine( 'descripcionTipoVeh'
                         : SVPDES_getTipoDeVehiculo(@@DsVa(@z).vavhct));
           REST_endArray( 'vehiculo' );
           endfor;
           endif;


       REST_endArray( 'detalleSiniestro' );
       endfor;

       REST_end();

      //-----------------------------------------------------------------
       Begsr srDomicilio;
           @@Direccion = peDomi + ' '
                       + %char ( peNdom ) + ' '
                       + %char ( pePiso ) + ' '
                       + peDeto ;
           @@Localidad =  SVPDES_localidad( peCopo
                                          : peCops );
           @@rpro = SVPDES_getProvinciaPorLocalidad( peCopo
                                                   : peCops );
           @@Provincia =  SVPDES_provinciaInder( @@rpro );
       Endsr;
      //-----------------------------------------------------------------
       Begsr srMotorizacion;

          @@motorizacion = *blanks;
          if @@DsT0.t0vhv2 = 5 or @@DsT0.t0vhv2 = 6;
             @@motorizacion = 'GNC';
          elseif @@DsT0.t0vhv2 = 7 or @@DsT0.t0vhv2 = 8;
                 @@motorizacion = 'DIESEL';
          else;
              @@motorizacion = 'NAFTA';
          endif;


       Endsr;
      * ------------------------------------------------- *
      *  Funcion Fecha
     PfecIso           b
      * Interfaz Procedimiento...
     DfecIso           pi            10
     D p1anio                         4  0
     D p1mes                          2  0
     D p1dia                          2  0

          fecha = ( p1anio * 10000 ) + ( p1mes * 100 ) + p1dia;
          fechaIso = SVPREST_editFecha(fecha);
          return fechaIso;
     PfecIso           e
      * ------------------------------------------------- *
      *  Funcion Error Salida
     PfinErr           b
      * Interfaz Procedimiento...
     Dfinerr           pi
     D p1repl                     65535a
     D p1CodM                         7
     D p1Msgs                              likeds(paramMsgs)
      *

          rc1 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
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

