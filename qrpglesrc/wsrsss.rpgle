     H option(*srcstmt:*noshowcpy:*nodebugio:*nounref)
     H actgrp( *new ) dftactgrp( *no )
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRSSS: RM#05872 Requerimiento SSN                           *
      *         AUTOS - Siniestro Dígital SSN.                       *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                               * 09-Dic-2019 *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      *   JSN 30/01/2020 - Se modifica el campo moneda, y se agrega  *
      *                    condiciones cuando el estado sea 3=Juicio *
      *   JSN 31/01/2020 - Se agrega condiciones para patente y cuit *
      *                    para tercero, moneda y montos             *
      *                                                              *
      * ************************************************************ *
     Fssns011   if   e           k disk
     Fssns021   if   e           k disk
     Fssns03    if   e           k disk
     Fpahsc1    if   e           k disk
     Fset204    if   e           k disk
     Fset210    if   e           k disk
     Fset211    if   e           k disk
      * Copy's -------------------------------------------------- *

      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/svpssn_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/svpemp_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/svpdaf_h.rpgle'

      * Parametros de entrada ---------------------------------- *
     D empr            s              1a
     D sucu            s              2a
     D cantReg         s             10a

      * Variables ----------------------------------------------- *
     D @@cant          s             10i 0
     D z               s             10i 0
     D rc              s               n
     D rc1             s             10i 0
     D x               s             10i 0
     D @@Nrdf          s              7  0
     D @@Tido          s              2  0
     D @@Nrdo          s              8  0
     D @@Cuit          s             11
     D @@Cuil          s             11  0
     D @@Dtdo          s             20
     D @@Edad          s              2  0
     D @@Mone          s              2
     D @@Fpgo          s              8  0
     D @@Arcd          s              6  0
     D @@Spol          s              9  0
     D @@Sspo          s              3  0
     D @@Nomb          s             40
     D @@Domi          s             35
     D @@Copo          s              5  0
     D @@Cops          s              1  0
     D @@Teln          s              7  0
     D @@Fnac          s              8  0
     D @@Cprf          s              3  0
     D @@Sexo          s              1  0
     D @@Esci          s              1  0
     D @@Raae          s              3  0
     D @@Ciiu          s              6  0
     D @@Dom2          s             50
     D @@Lnac          s             30
     D @@Pesk          s              5  2
     D @@Estm          s              3  2
     D @@Mfum          s              1
     D @@Mzur          s              1
     D @@Mar1          s              1
     D @@Mar2          s              1
     D @@Mar3          s              1
     D @@Mar4          s              1
     D @@Ccdi          s             11
     D @@Pain          s              5  0
     D @@Cnac          s              3  0
     D @@Year          s              4  0
     D @@Month         s              2  0
     D @@Day           s              2  0
     D TmpFch          s               d   datfmt(*eur) inz
     D peErro          s                   like(paramErro)
     D uri             s            512a
     D url             s           3000a   varying
     D wrepl           s          65535a
     D @@esta          s              3
     D @@tipo          s              3
     D Es_Seg_Reg      s              1
     D xc              s               n
     D Fecha           s              8  0
     D @@Irva          s             15  2
     D @@Pago          s             15  2
     D @@Ifra          s             15  2

      * Datos Output...

      * Empresa...
     D ciaSSN          s             13
     D cuitHDI         s             11

      *Poliza...
     D ramo            s              4
     D subramo         s              6
     D poliza          s             24
     D fechaDesde      s              8
     D fechaHasta      s              8
     D FOcurrencia     s              8
     D FDenuncia       s              8
     D tipoDoc         s              4
     D numDoc          s             11
     D CodPostal       s              8
     D provincia       s              2
     D localidad       s             50
     D moneda          s              2
     D genero          s              1
     D MontoReser      s             50
     D MontoPagad      s             50
     D MontoFranq      s             50
     D NroSini         s             50
     D NroSubsin       s             50
     D Core            s             28

      * Vehiculos...
     D tipoVehiculo    s              2
     D Dominio         s             12
     D marca           s             25
     D modelo          s             50
     D aÑoFabr         s              4
     D motor           s             25
     D chasis          s             25
     D alcance         s              2
     D tipoServicio    s              2
     D destino         s              2
     D combustible     s              1
     D Ruta            s             50
     D TipoLesion      s              1
     D HechoGenr       s              2
     D TerceroAse      s              2
     D DominioTer      s             12
     D CuitTer         s             11
     D EstadoSub       s              1
     D FechaPago       s              8
     D TipoMoneda      s              1

      * Documentos...
     D nombreArchivo   s            100

      *Claves...
     D rama            s             50
     D sini            s             50
     D Nops            s             50

      * Constantes  --------------------------------------------- *
     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')
      * Estructuras --------------------------------------------- *
     D @@DsC1          ds                  likeds( dspahec1_t ) dim(999)
     D @@DsC1C         s             10i 0
     D @@DsVa          ds                  likeds( dsPahsva_t ) dim(999)
     D @@DsVaC         s             10i 0
     D @@DsB4          ds                  likeds( DsPahsb4_t ) dim(999)
     D @@DsB4C         s             10i 0
     D @@DsCd          ds                  likeds( DsPahscd_t )
     D @@DsB1          ds                  likeds( dsPahsb1_t )

      * Informacion de Sistema ---------------------------------- *
     D psds           sds                  qualified
     D  this                         10a   overlay( psds : 1 )

     D Local           ds                  dtaara(*lda) qualified
     D  empr                          1a   overlay(Local:401)
     D  sucu                          2a   overlay(Local:*next)

      * Procedimientos ------------------------------------------ *

      // Log de llamadas...
     D WSLOG           pr                  extpgm('WSLOG')
     D   MS                         512

      // Procedimiento para debug...
     D sleep           pr            10u 0 extproc('sleep')
     D  secs                         10u 0 value

     D PAR310X3        pr                  extpgm('PAR310X3')
     D                                1a   const
     D                                4  0
     D                                2  0
     D                                2  0
      * Claves -------------------------------------------------- *
     D k1ys02          ds                  likerec( s1ns02 : *key )
     D k1ys03          ds                  likerec( s1ns03 : *key )
     D k1ysc1          ds                  likerec( p1hsc1 : *key )
     D k1y204          ds                  likerec( s1t204 : *key )

      /free

        *inlr = *on;

        rc  = REST_getUri( psds.this : uri );
        if rc = *off;
           return;
        endif;
        url = %trim( uri );

        // ------------------------------------------ //
        // Obtener los parámetros de la URL           //
        // ------------------------------------------ //
        empr    = REST_getNextPart(url);
        sucu    = REST_getNextPart(url);
        cantReg = REST_getNextPart(url);

        monitor;
          @@cant = %int(%trim(cantReg));
        on-error;
          @@cant = 0;
        endmon;
        z = *zeros;

        REST_writeHeader();
        REST_writeEncoding();
        REST_startArray( 'siniestros' );

        setll *loval ssns011;
        read  ssns011;
        dow not %eof( ssns011 );


            exsr DatosSiniestro;

            REST_writeXmlLine( 'siniestro'          : '*BEG'            );
            REST_writeXmlLine( 'Compania'           : %trim( CiaSSN  )  );
            REST_writeXmlLine( 'cuit'               : %trim( CuitHDI )  );
            REST_writeXmlLine( 'Ramo'               : %trim( Ramo    )  );
            REST_writeXmlLine( 'Subramo'            : %trim( Subramo )  );
            REST_writeXmlLine( 'campoReservadoSSN1' : ' '               );
            REST_writeXmlLine( 'campoReservadoSSN2' : ' '               );
            REST_writeXmlLine( 'campoReservadoSSN3' : ' '               );
            REST_writeXmlLine( 'campoReservadoSSN4' : ' '               );
            REST_writeXmlLine( 'campoReservadoSSN5' : ' '               );
            REST_writeXmlLine( 'campoReservadoSSN6' : ' '               );
            REST_writeXmlLine( 'nroPoliza'          : %trim( Poliza )   );
            REST_writeXmlLine( 'tipoDocumento'      : %trim( TipoDoc )  );
            REST_writeXmlLine( 'nroDocumento'       : %trim( NumDoc  )  );
            REST_writeXmlLine( 'edad'               : %char( @@Edad )   );
            REST_writeXmlLine( 'genero'             : %trim( genero )   );
            REST_writeXmlLine( 'fechaInicioVigencia': %trim(fechaDesde) );
            REST_writeXmlLine( 'fechaHastaVigencia' : %trim(fechahasta) );

            exsr DatosSin;

           // Clave...
           Rama = %char( s1Rama );
           Sini = %char( s1Sini );
           Nops = %char( s1Nops );

           REST_writeXmlLine( 'clave' : '*BEG' );
            REST_writeXmlLine( 'rama'               : %trim( Rama  ));
            REST_writeXmlLine( 'numSiniestro'       : %trim( Sini  ));
            REST_writeXmlLine( 'nrooperacion'       : %trim( Nops  ));
           REST_writeXmlLine( 'clave' : '*END' );

           REST_writeXmlLine( 'siniestro' : '*END' );


          if @@cant <> 0;
            z += 1;
            if z >= @@cant;
              leave;
            endif;
          endif;

          read ssns011;
        enddo;


        REST_endArray( 'siniestros' );
        REST_end();

      /end-free

      * ------------------------------------------------------- *
      * DatosSiniestro : Datos del Siniestro                    *
      * ------------------------------------------------------- *
       begsr DatosSiniestro;

         exsr clrDatos;

         CiaSSN  = %subst(%editc(SVPEMP_getCompaniaSSN( Empr ):'X'):10:4);
         CuitHDI = SVPEMP_getCUIT( Empr );
         Ramo    = SVPSSN_getRamo( s1Rama );
         Subramo = SVPSSN_getSubramo( s1Rama );

         // Busca Datos de la Caratula de Siniestro...
         rc = SVPSIN_getCaratula( s1Empr
                                : s1Sucu
                                : s1Rama
                                : s1Sini
                                : s1Nops
                                : @@DsCd );

         Poliza  = %char( @@DsCd.cdPoli );

         // Buscar datos del Asegurado...
         @@Nrdf = @@DsCd.cdNrdf;
         if not SVPDAF_chkDaf( @@Nrdf );
           @@Nrdf = @@DsCd.cdAsen;
         endif;

         PAR310X3( s1Empr : @@Year : @@Month : @@Day);
         Fecha = (@@Year * 10000)
               + (@@Month *  100)
               +  @@Day;

         // Busca Documento del Asegurado...
         if SVPDAF_getDocumento( @@Nrdf
                               : @@Tido
                               : @@Nrdo
                               : @@Cuit
                               : @@Cuil
                               : @@Dtdo );

           if @@Cuit <> *blanks and @@Cuit <> '00000000000';
             tipoDoc = 'CUIT';
             numdoc  = %trim(@@Cuit);
           else;
             select;  // Tipo de Documento...
               when @@Tido = 1;
                 tipoDoc = 'LE';
               when @@Tido = 2;
                 tipoDoc = 'LC';
               when @@Tido = 3;
                 tipoDoc = 'CI';
               when @@Tido = 4;
                 tipoDoc = 'DNI';
               when @@Tido = 5;
                 tipoDoc = 'PA';
             endsl;
             numDoc = %char( @@Nrdo );
           endif;

           // Busca Datos del Asegurado...
           if SVPDAF_getDa1( @@Nrdf
                           : @@Nomb
                           : @@Domi
                           : @@Copo
                           : @@Cops
                           : @@Teln
                           : @@Fnac
                           : @@Cprf
                           : @@Sexo
                           : @@Esci
                           : @@Raae
                           : @@Ciiu
                           : @@Dom2
                           : @@Lnac
                           : @@Pesk
                           : @@Estm
                           : @@Mfum
                           : @@Mzur
                           : @@Mar1
                           : @@Mar2
                           : @@Mar3
                           : @@Mar4
                           : @@Ccdi
                           : @@Pain
                           : @@Cnac );

             if @@Fnac <> 00010101 and @@Fnac <> *zeros;
               Monitor;
                 @@Edad = Fecha - @@Fnac;
               on-error;
                 @@Edad = 0;
               endmon;
             endif;

             select;
               when @@Sexo = 1;
                 genero = 'M';
               when @@Sexo = 2;
                 genero = 'F';
             endsl;
           endif;
         endif;

         // Busca los datos Artículo, Superpoliza y Suplemento del Siniestro...
         rc1 = SVPSIN_getSpol( s1Empr
                             : s1Sucu
                             : s1Rama
                             : s1Sini
                             : s1Nops
                             : @@Arcd
                             : @@Spol
                             : @@Sspo );

         // Busca Datos de la Superpoliza...
         rc = SPVSPO_getCabeceraSuplemento( s1Empr
                                          : s1Sucu
                                          : @@Arcd
                                          : @@Spol
                                          : @@Sspo
                                          : @@DsC1
                                          : @@DsC1C );

         // Fecha de Inicio de Vigencia de la Póliza...
         FechaDesde = %editc( @@DsC1(1).c1Fiod : 'X' ) +
                      %editc( @@DsC1(1).c1Fiom : 'X' ) +
                      %editc( @@DsC1(1).c1Fioa : 'X' ) ;

         // Fecha de Hasta de Vigencia de la Póliza...
         FechaHasta = %editc( @@DsC1(1).c1Fvod : 'X' ) +
                      %editc( @@DsC1(1).c1Fvom : 'X' ) +
                      %editc( @@DsC1(1).c1Fvoa : 'X' ) ;

         // Busca Datos del Vehículo del Asegurado...
         rc = SVPSIN_getVehiculo( s1Empr
                                : s1Sucu
                                : s1Rama
                                : s1Sini
                                : s1Nops
                                : *omit
                                : *omit
                                : *omit
                                : *omit
                                : *omit
                                : *omit
                                : @@DsVa
                                : @@DsVaC );

         for x = 1 to @@DsVaC;

           dominio = @@DsVa(x).vaNmat;
           Marca   = SVPDES_marca( @@DsVa(x).vaVhmc );
           Modelo  = SVPDES_modelo( @@DsVa(x).vaVhmo );
           AÑoFabr = %char( @@DsVa(x).vaVhaÑ );
           Motor   = @@DsVa(x).vaMoto;
           Chasis  = @@DsVa(x).vaChas;

           tipoVehiculo = '0';
           chain @@DsVa(x).vaVhct set210;
           if %found( set210 );
             tipoVehiculo = %trim(t@Vhte);
           endif;

           if tipoVehiculo <> '00' and
              tipoVehiculo <> '01' and
              tipoVehiculo <> '02' and
              tipoVehiculo <> '03' and
              tipoVehiculo <> '04' and
              tipoVehiculo <> '05' and
              tipoVehiculo <> '06' and
              tipoVehiculo <> '07' and
              tipoVehiculo <> '08' and
              tipoVehiculo <> '09' and
              tipoVehiculo <> '10' and
              tipoVehiculo <> '20' and
              tipoVehiculo <> '21' and
              tipoVehiculo <> 'M1' and
              tipoVehiculo <> 'M2' and
              tipoVehiculo <> 'M3';
             tipoVehiculo = '0';
           endif;

           // Depurar tipos de vehiculos...
           if tipoVehiculo = '02' or
              tipoVehiculo = '04' or
              tipoVehiculo = '05';
             tipoVehiculo = '0';
           endif;

           if %len(%trim(tipoVehiculo)) = 2 and %subst(tipoVehiculo:1:1) = '0';
             tipoVehiculo = %subst(tipoVehiculo:2:1);
           endif;

           if @@DsVa(x).vaVhct =  41  and
              tipoVehiculo     = 'M1' and
              tipoVehiculo     = 'M2' and
              tipoVehiculo     = 'M3';
             tipoVehiculo = 'M2';
           endif;

           k1y204.t@Vhmc = @@DsVa(x).vaVhmc;
           k1y204.t@Vhmo = @@DsVa(x).vaVhmo;
           k1y204.t@Vhcs = @@DsVa(x).vaVhcs;
           chain %kds( k1y204 : 3 ) set204;
           if %found( set204 );
             select;
               when t@Vhv2 = 1 or t@Vhv2 = 9;
                 Combustible = '3';
               when t@Vhv2 = 5 or t@Vhv2 = 6;
                 Combustible = '1';
               when t@Vhv2 = 7 or t@Vhv2 = 8;
                 Combustible = '2';
             endsl;
           endif;

           if tipoVehiculo = '06'  or
              tipoVehiculo = '10';
              alcance = 'R';
           endif;

           if tipoVehiculo = 'M1'  or
              tipoVehiculo = 'M2'  or
              tipoVehiculo = 'M3';
              alcance = 'U';
           endif;

           if tipoVehiculo = 'M1'  or
              tipoVehiculo = 'M2'  or
              tipoVehiculo = 'M3';

             if @@DsVa(x).vavhuv = 02  or
                @@DsVa(x).vavhuv = 03  or
                @@DsVa(x).vavhuv = 17  or
                @@DsVa(x).vavhuv = 34  or
                @@DsVa(x).vavhuv = 41;
               alcance = 'U';
             endif;

             if @@DsVa(x).vavhuv = 18  or
                @@DsVa(x).vavhuv = 35;
               alcance = 'I' ;
             endif;

             if @@DsVa(x).vavhuv = 93;
               alcance = 'I' ;
             endif;
           endif;

           chain @@DsVa(x).vavhuv set211;
           if %found( set211 );
             destino = t@vhue;
             if @@DsVa(x).vavhmc = '999';
               destino = 'PR';
             endif;
             if destino = *blanks;
               destino = 'PP';
             endif;
           endif;
         endfor;

         NroSini = %char( @@DsCd.cdSini );

         FOcurrencia = %editc( @@DsCd.cdFsid : 'X' ) +
                       %editc( @@DsCd.cdFsim : 'X' ) +
                       %editc( @@DsCd.cdFsia : 'X' ) ;

         FDenuncia = %editc( @@DsCd.cdFded : 'X' ) +
                     %editc( @@DsCd.cdFdem : 'X' ) +
                     %editc( @@DsCd.cdFdea : 'X' ) ;

         k1ysc1.cd1Empr = s1Empr;
         k1ysc1.cd1Sucu = s1Sucu;
         k1ysc1.cd1Rama = s1Rama;
         k1ysc1.cd1Sini = s1Sini;
         k1ysc1.cd1Nops = s1Nops;
         chain %kds( k1ysc1 : 5 ) pahsc1;
         if %found( pahsc1 );
           Ruta = %char(cd1Nrkm);
         endif;

         Localidad = SVPDES_localidad ( @@DsCd.cdCopo : @@DsCd.cdCops );
         CodPostal = %char( @@DsCd.cdCopo );
         Provincia = %char(SVPSSN_getProvincia( @@DsCd.cdProc ));

       endsr;

      * ------------------------------------------------------- *
      * DatosSubsiniestros: Busca Datos del Subsiniestro        *
      * ------------------------------------------------------- *
       begsr DatosSubsiniestros;

         REST_startArray( 'subsiniestros' );

         k1ys02.s2Empr = s1Empr;
         k1ys02.s2Sucu = s1Sucu;
         k1ys02.s2Rama = s1Rama;
         k1ys02.s2Sini = s1Sini;
         k1ys02.s2Nops = s1Nops;
         setll %kds( k1ys02 : 5 ) ssns021;
         reade %kds( k1ys02 : 5 ) ssns021;
         dow not %eof( ssns021 );

           exsr clrDatosSub;

           if SVPSIN_getUltimoSubsiniestro( s2Empr
                                          : s2Sucu
                                          : s2Rama
                                          : s2Sini
                                          : s2Nops
                                          : s2Poco
                                          : s2Paco
                                          : s2Riec
                                          : s2Xcob
                                          : s2Nrdf
                                          : s2Sebe
                                          : @@DsB1 );

             HechoGenr  = @@DsB1.b1Hecg;
             NroSubsin  = %char(s2Ssin);
             EstadoSub  = %trim(%char(@@DsB1.b1Cesi));

             if HechoGenr = '1' or HechoGenr = '2';
               TipoLesion = @@DsB1.b1Ctle;
             endif;

             @@Irva = SVPSIN_getRva( s2Empr
                                   : s2Sucu
                                   : s2Rama
                                   : s2Sini
                                   : s2Nops
                                   : s2Nrdf
                                   : *omit  );

             @@Pago = SVPSIN_getPag( s2Empr
                                   : s2Sucu
                                   : s2Rama
                                   : s2Sini
                                   : s2Nops
                                   : s2Nrdf
                                   : *omit  );

             @@Ifra = SVPSIN_getFra( s2Empr
                                   : s2Sucu
                                   : s2Rama
                                   : s2Sini
                                   : s2Nops
                                   : s2Nrdf
                                   : *omit  );

             if @@Irva = *zeros;
               MontoReser = '0';
             else;
               MontoReser = SVPREST_editImporte(@@Irva);
             endif;

             if @@Pago = *zeros;
               MontoPagad = *blanks;
             else;
               MontoPagad = SVPREST_editImporte(@@Pago);
             endif;

             if @@Ifra = *zeros;
               MontoFranq = '0';
             else;
               MontoFranq = SVPREST_editImporte(@@Ifra);
             endif;

             if SVPSIN_getUltFechaPago( s2Empr
                                      : s2Sucu
                                      : s2Rama
                                      : s2Sini
                                      : s2Nops
                                      : s2Poco
                                      : s2Paco
                                      : s2Nrdf
                                      : s2Sebe
                                      : s2Riec
                                      : s2Xcob
                                      : @@Fpgo
                                      : @@Mone );

               Monitor;
                 TmpFch = %date( %char ( @@Fpgo ) : *iso0 );
                 FechaPago  = %char( TmpFch : *eur0);
               on-error;
                 FechaPago = *blanks;
               endmon;

               TipoMoneda = %subst(SVPSSN_getMoneda( @@Mone ):2:1);
             endif;

             if TipoMoneda = *blanks;
               TipoMoneda = '1';
             endif;

             if EstadoSub = '3';
               MontoReser = '0';
               MontoPagad = *blanks;
               MontoFranq = '0';
               FechaPago  = *blanks;
               TipoMoneda = '1';
             endif;

             if HechoGenr = '3';
               TerceroAse = 'SI';
             else;
               TerceroAse = 'NO';
             endif;

             Core = '0000000000000000000000000000';

             if HechoGenr = '1' or HechoGenr = '2';
               if SVPSIN_getVehiculoTercero( s2Empr
                                           : s2Sucu
                                           : s2Rama
                                           : s2Sini
                                           : s2Nops
                                           : s2Poco
                                           : s2Paco
                                           : s2Riec
                                           : s2Xcob
                                           : s2Nrdf
                                           : s2Sebe
                                           : @@DsB4
                                           : @@DsB4C );

                 DominioTer = %trim(@@DsB4(1).b4Nmat);
               else;
                 DominioTer = 'DESCONOCIDO';
               endif;
               CuitTer = '20222222223';
             endif;

           endif;

           exsr DatosSub;

           reade %kds( k1ys02 : 5 ) ssns021;
         enddo;

         REST_endArray( 'subsiniestros' );

       endsr;

      * ------------------------------------------------------- *
      * ClrDatos: Limpia Campos del Siniestro                   *
      * ------------------------------------------------------- *
       begsr ClrDatos;

         clear @@Fpgo;
         clear @@Mone;
         clear @@DsCd;
         clear @@DsC1;
         clear @@DsC1C;
         clear @@DsVa;
         clear @@DsVaC;

         clear CiaSSN;
         clear CuitHDI;
         clear Ramo;
         clear Subramo;
         clear Poliza;
         clear TipoDoc;
         clear NumDoc;
         clear @@Edad;
         clear Genero;
         clear FechaDesde;
         clear FechaHasta;
         clear Dominio;
         clear Marca;
         clear Modelo;
         clear TipoVehiculo;
         clear AÑoFabr;
         clear Motor;
         clear Chasis;
         clear Combustible;
         clear Alcance;
         clear Destino;
         clear NroSini;
         clear FOcurrencia;
         clear FDenuncia;
         clear Ruta;
         clear Localidad;
         clear CodPostal;
         clear Provincia;

       endsr;

      * ------------------------------------------------------- *
      * ClrDatosSub: Limpia Campos del Subsiniestro             *
      * ------------------------------------------------------- *
       begsr ClrDatosSub;

         clear @@DsB1;
         clear @@DsB4;
         clear @@DsB4C;

         clear HechoGenr;
         clear NroSubsin ;
         clear EstadoSub;
         clear TipoLesion;
         clear MontoReser;
         clear MontoPagad;
         clear MontoFranq;
         clear TmpFch;
         clear FechaPago;
         clear TipoMoneda;
         clear TerceroAse;
         clear DominioTer;
         clear CuitTer;

       endsr;

      * ------------------------------------------------------- *
      * DatosSin : Datos del Vehiculo                           *
      * ------------------------------------------------------- *
       begsr DatosSin;

         REST_writeXmlLine('dominio'           : %trim( dominio )    );
         REST_writeXmlLine('marca'             : %trim( Marca )      );
         REST_writeXmlLine('modelo'            : %trim( Modelo )     );
         REST_writeXmlLine('tipoVehiculo'      : %trim(tipoVehiculo) );
         REST_writeXmlLine('anioFabricacion'   : %trim( AÑoFabr )    );
         REST_writeXmlLine('nroMotor'          : %trim( Motor )      );
         REST_writeXmlLine('nroChasis'         : %trim( Chasis )     );
         REST_writeXmlLine('tipoCombustible'   : %trim( Combustible ));
         REST_writeXmlLine('alcance'           : %trim( Alcance )    );
         REST_writeXmlLine('tipoUsoDestino'    : %trim( destino )    );
         REST_writeXmlLine('nroSiniestro'      : %trim( NroSini )    );
         REST_writeXmlLine('fechaOcur'         : %trim( FOcurrencia ));
         REST_writeXmlLine('fechaDcia'         : %trim( FDenuncia )  );
         REST_writeXmlLine('lugarSiniestro'    : %trim(@@DsCd.cdClos));
         REST_writeXmlLine('calleRuta'         : %trim(@@DsCd.cdLudi));
         REST_writeXmlLine('numeroKm'          : %trim( Ruta )       );
         REST_writeXmlLine('interseccion1'     : ' '                 );
         REST_writeXmlLine('interseccion2'     : ' '                 );
         REST_writeXmlLine('barrio'            : ' '                 );
         REST_writeXmlLine('departamentoPartido': ' '                );
         REST_writeXmlLine('localidad'         : %trim( Localidad )  );
         REST_writeXmlLine('codigoPostal'      : %trim( CodPostal )  );
         REST_writeXmlLine('provincia'         : %trim( Provincia )  );
         REST_writeXmlLine('geolocalizacionSiniestro': ' '           );

         exsr DatosSubsiniestros;

       endsr;

      * ------------------------------------------------------- *
      * DatosSub : Datos del Subsiniestro                       *
      * ------------------------------------------------------- *
       begsr DatosSub;

          REST_writeXmlLine('subsiniestro'      : '*BEG'              );
           REST_writeXmlLine('tipoHechoGenerador': %trim( HechoGenr )  );
           REST_writeXmlLine('nroSubsiniestro'   : %trim( NroSubsin )  );
           REST_writeXmlLine('estadoSubSiniestro': %trim( EstadoSub )  );
           REST_writeXmlLine('tipoLesion'        : %trim( TipoLesion ) );
           REST_writeXmlLine('montoReservado'    : %trim( MontoReser ));
           REST_writeXmlLine('montoPagado'       : %trim( MontoPagad ));
           REST_writeXmlLine('montoFranquiciaCasco':%trim(MontoFranq) );
           REST_writeXmlLine('tipoMoneda'        : %trim( TipoMoneda ) );
           REST_writeXmlLine('fechaPago'         : %trim( FechaPago  ) );
           REST_writeXmlLine('core'              : Core                );
           REST_writeXmlLine('terceroAsegurado'  : %trim( TerceroAse ) );
           REST_writeXmlLine('dominioTercero'    : %trim( DominioTer ) );
           REST_writeXmlLine('cuilTercero'       : %trim( CuitTer )    );
          REST_writeXmlLine( 'subsiniestro' : '*END' );

       endsr;

