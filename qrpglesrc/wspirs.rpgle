     H option(*srcstmt) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ***
      * WSPIRS : Servicio Siniestro - Generar Reserva                *
      * ------------------------------------------------------------ *
      * Facundo Astiz                        28/10/2021              *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      *                                                              *
      * ************************************************************ *
     Fcntnau    if   e           k disk

      * -- Copy H --
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/svpsi1_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/sinest_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'
      /copy './qcpybooks/svpemp_h.rpgle'
      /copy './qcpybooks/spvfec_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/svpdaf_h.rpgle'
      *
      * ATENCION: el likeds dependerá del servicio.
      *           No es siempre la misma.
      *           La ds (en este caso wspIrs_t) debe
      *           existir en el miembro SINEST_H
      *
      * Las variables que siguen aca, deben estar siempre
      * request, buffer, options y rc1
      *
      * -- Variables de Arquitectura --
     D request         ds                  likeds(wspIrs_t)
     D buffer          s           5000a
     D options         s            100a
     D rc1             s             10i 0
     D @@repl          s          65535a
     D data            s          65535a
     D path            s            256a   varying
     D pevalu          s           1024a
     D peMsgs          ds                  likeds(paramMsgs)
     D*
      * -- Variables Validador Caratula --
     D  peRama         s              2  0
     D  peSini         s              7  0
     D  peNops         s              7  0
     D  peMsgf         s              6a
     D  peIdms         s              7a
      *
      * -- Variables Fechas --
     D @@Fech          s              8  0
     D @@Fema          s              4  0
     D @@Femm          s              2  0
     D @@Femd          s              2  0
     D @@DS456         ds                  likeds (DsSet456_t)
     D @@F456          s              8  0
     D*
      * -- Variables de Calculo --
     D @@Psec          s              2  0
     D @@imco          s             15  6
     D @@Imau          s             15  2
     D @@Ract          s             15  2
     D @@Totl          s             15  2
     D @@Recl          s              3  0
     D*
      * -- Variables de conversion
     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')
     D*
      * -- Estructuras
     D @@Dshr          ds                  likeds(DsPahshr_t)
     D @@Dsbe          ds                  likeds(DsPahsbe_t)
     D @@Dsb1          ds                  likeds(DsPahsb1_t)
     D @@Dscd          ds                  likeds(dsPahscd_t) dim(9999) INZ
     D @@DscdC         s             10i 0
     D @@DSMon         ds                  likeds(dsgntmon_t)
     D k1tnau          ds                  likerec(c1tnau:*key)
     D*
     D @@CodM          s              7    inz
     D @x              s             10i 0
     D @ok             s              1
      *
      * -- Estructura Filiatorio --
     D @@DSDaf         ds                  qualified
     D dfNrdf                         7  0
     D dfNomb                        40
     D dfDomi                        35
     D dfNdom                         5p 0
     D dfPiso                         3p 0
     D dfDeto                         4
     D dfCopo                         5p 0
     D dfCops                         1p 0
     D dfTeln                         7p 0
     D dfFaxn                         7p 0
     D dfTiso                         2p 0
     D dfTido                         2p 0
     D dfNrdo                         8p 0
     D dfCuit                        11
     D dfNjub                        11p 0
      *
      * -- Prototipo Validador Caratula --
     D WSPVST          pr                  ExtPgm('WSPVST')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peRama                        2  0 const
     D  peSini                        7  0 const
     D  peNops                        7  0 const
     D  peMsgf                        6a
     D  peIdms                        7a
      *
      *------------------------------------------------------------- *

       /free
       *inlr = *on;


       // -------------------------------------
       // Inicio
       // -------------------------------------


       options = 'path=insertarReserva +
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
        if REST_getEnvVar('WSPIRS_BODY' : peValu );
           buffer = peValu;
           Qp0zDltEnv('WSPIRS_BODY');
         else;
           rc1= REST_readStdInput( %addr(buffer): %len(buffer) );
        endif;

        data = '<pre>'
             + %trim(buffer)
             + '</pre>'
             + '<br>';
        COWLOG_pgmLog( 'WSPIRS' : data  );

       monitor;
          xml-into request %xml(buffer : options);
       on-error;
          @@repl = 'wspIrs_t';
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


       // -------------------
       // valido parseo fecha Movimiento
       monitor;
          @@fech = %dec(%date(request.fechaMovi) : *iso);
       on-error;
        //@@repl = request.fechaMovi;
          @@CodM = 'RPG0001';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endmon;

       // -------------------
       // Mayuscula
       request.caratula.empresa = %xlate(min : may
                                        :request.caratula.empresa);
       request.caratula.sucursal = %xlate(min : may
                                         :request.caratula.sucursal);
       request.bienSiniestrado.riesgo = %xlate(min : may
                                      :request.bienSiniestrado.riesgo);
       request.beneficiario.marEstado = %xlate(min : may
                                      :request.beneficiario.marEstado);
       request.reclamo.tipoLesion = %xlate(min : may
                                  :request.reclamo.tipoLesion);
       request.usuario = %xlate(min : may : request.usuario);

       if request.beneficiario.filiatorio <= 0;
          k1tnau.naempr = request.caratula.empresa;
          k1tnau.nasucu = request.caratula.sucursal;
          k1tnau.nacoma = request.identProveedor.codMayAux;
          k1tnau.nanrma = request.identProveedor.NumMayAux;
          chain %kds(k1tnau:4) cntnau;
          if %found;
             request.beneficiario.filiatorio = nanrdf;
          endif;
       endif;

       // -------------------
       // La caratula debe existir
       perama = request.caratula.rama;
       pesini = request.caratula.siniestro;
       penops = request.caratula.nroOperStro;

       WSPVST( request.caratula.empresa
             : request.caratula.sucursal
             : perama
             : pesini
             : penops
             : peMsgf
             : peIdms );

       if peMsgf <> *blanks ;
          select;
             when peIdms = 'COW0113';
                @@repl = request.caratula.empresa;
             when peIdms = 'COW0114';
                @@repl = request.caratula.sucursal;
             when peIdms = 'RAM0001';
                @@repl = %char(request.caratula.rama);
             when peIdms = 'SIN0001';
                %subst(@@repl:1:2) = %char(request.caratula.rama);
                %subst(@@repl:3:7) = %char(request.caratula.siniestro);
          endsl;
          @@CodM = peIdms;
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       // -------------------
       // El Bien Siniestrado no exite en el siniestro
       if SVPSI1_chkPahsbs( request.caratula.empresa
                          : request.caratula.sucursal
                          : request.caratula.rama
                          : request.caratula.siniestro
                          : request.caratula.nroOperStro
                          : request.bienSiniestrado.componente
                          : request.bienSiniestrado.parentesco
                          : request.bienSiniestrado.riesgo
                          : request.bienSiniestrado.cobertura ) = *off;

          %subst(@@repl:1:2) = %char(request.caratula.rama);
          %subst(@@repl:3:7) = %char(request.caratula.nroOperStro);
          @@CodM = 'SIN0060';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       // -------------------
       // Valida siniestro no terminado
       if SVPSIN_chkFinSini( request.caratula.empresa
                           : request.caratula.sucursal
                           : request.caratula.rama
                           : request.caratula.siniestro
                           : request.caratula.nroOperStro)= *on;
          %subst(@@repl:1:2) = %char(request.caratula.rama);
          %subst(@@repl:3:7) = %char(request.caratula.nroOperStro);
          @@CodM = 'SIN0052';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

        // El Siniestro/caratula tiene Estado inhabilitado para modificacion
       if SVPSIN_chkSinModificable( request.caratula.empresa
                                  : request.caratula.sucursal
                                  : request.caratula.rama
                                  : request.caratula.nroOperStro) = *off;

          %subst(@@repl:1:2) = %char(request.caratula.rama);
          %subst(@@repl:3:7) = %char(request.caratula.nroOperStro);
          @@CodM = 'SIN0052';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       // -------------------
       // Los pasos necesarios deben estar completos
       if SVPSI1_chkPasoDeTrabajo( request.caratula.empresa
                                 : request.caratula.sucursal
                                 : request.caratula.rama
                                 : request.caratula.siniestro
                                 : request.caratula.nroOperStro)= *off;
          @@CodM = 'SIN1004';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       // -------------------
       // El beneficiario del siniestro NO debe existir
       if SVPSI1_chkPahsbe( request.caratula.empresa
                          : request.caratula.sucursal
                          : request.caratula.rama
                          : request.caratula.siniestro
                          : request.caratula.nroOperStro
                          : request.bienSiniestrado.componente
                          : request.bienSiniestrado.parentesco
                          : request.bienSiniestrado.riesgo
                          : request.bienSiniestrado.cobertura
                          : request.beneficiario.filiatorio
                          : request.beneficiario.beneficiario ) = *on;
          %subst(@@repl:1:7)   = %char(request.beneficiario.filiatorio);
          %subst(@@repl:8:13)  = %char(request.beneficiario.beneficiario);
          %subst(@@repl:14:20) = %char(request.caratula.siniestro);
          @@CodM = 'SIN0042';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;


       // -------------------
       // Valido existencia dato filiatorio / beneficiario
       @@DSDaf.dfNrdf = request.beneficiario.filiatorio;
       if SVPDAF_chkDaf( @@DSDaf.dfNrdf ) = *off;
          @@repl = %char(@@DSDaf.dfNrdf);
          @@CodM = 'DAF0001';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       // -------------------
       // Tipo de Beneficiario para autos
       if request.beneficiario.marTipo <> '1' and
          request.beneficiario.marTipo <> '2' and
          request.beneficiario.marTipo <> '3';
          @@repl = request.beneficiario.marTipo;
          @@CodM = 'SIN0045';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       // -------------------
       //recupero Info Benef.
       if SVPDAF_getDaf( @@DSDaf.dfNrdf
                       : @@DSDaf.dfNomb
                       : @@DSDaf.dfDomi
                       : @@DSDaf.dfNdom
                       : @@DSDaf.dfPiso
                       : @@DSDaf.dfDeto
                       : @@DSDaf.dfCopo
                       : @@DSDaf.dfCops
                       : @@DSDaf.dfTeln
                       : @@DSDaf.dfFaxn
                       : @@DSDaf.dfTiso
                       : @@DSDaf.dfTido
                       : @@DSDaf.dfNrdo
                       : @@DSDaf.dfCuit
                       : @@DSDaf.dfNjub);
       endif;

       // -------------------
       //recupero Info Denuncia.
       if SVPSI1_getPahscd( request.caratula.empresa
                          : request.caratula.sucursal
                          : request.caratula.rama
                          : request.caratula.siniestro
                          : request.caratula.nroOperStro
                          : @@DScd
                          : @@DScdC);
       endif;

       // -------------------
       // Busco existencia de beneficiario asegurado
       for @x = 1 to @@DscdC;
          if request.beneficiario.filiatorio = @@DScd(@x).cdAsen;
             @ok = 'S';
             leave;
          endif;
       endfor;

       // -------------------
       // Valido Tipo de dato filiatorio / beneficiario
       if request.beneficiario.marTipo = '1';
          // beneficiario debe ser asegurado
          if @ok <> 'S';
             %subst(@@repl:1:1) = request.beneficiario.marTipo;
             %subst(@@repl:2:7) = %char(request.beneficiario.filiatorio);
             @@CodM = 'SIN0046';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs);
             return;
          endif;
       else;
          // Caso contrario
          if @ok = 'S';
             %subst(@@repl:1:1) = request.beneficiario.marTipo;
             %subst(@@repl:2:7) = %char(request.beneficiario.filiatorio);
             @@CodM = 'SIN0047';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs);
             return;
          endif;
       endif;

       // -------------------
       // codigo de estado de reclamo debe existir
       if SVPVAL_EstadoSin ( request.caratula.empresa
                           : request.caratula.sucursal
                           : request.caratula.rama
                           : request.reclamo.estadoSiniestro) = *off;
          @@repl = %char(request.reclamo.estadoSiniestro);
          @@CodM = 'SIN0048';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       // -------------------
       // Codigo de reclamo
       if request.beneficiario.marTipo = '3';
          // numero de reclamo para proveedor debe existir
          if SVPSI1_chkNumReclamo( request.caratula.empresa
                                 : request.caratula.sucursal
                                 : request.caratula.rama
                                 : request.caratula.siniestro
                                 : request.caratula.nroOperStro
                                 : request.reclamo.reclamo) = *off;
             @@repl = %char(request.reclamo.reclamo);
             @@CodM = 'SIN0056';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs);
             return;
          endif;
       else;
          // numero de reclamo para NO proveedor debe calcularse
          if request.reclamo.reclamo <> 0;
             @@repl = %char(request.reclamo.reclamo);
             @@CodM = 'SIN0055';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs);
             return;
          endif;
       endif;

       // -------------------
       // Hecho Generador debe existir
       if SVPVAL_hechoGenerador( request.reclamo.hechoGenerador) = *off;
          @@repl = request.reclamo.hechoGenerador;
          @@CodM = 'SIN0049';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       // -------------------
       // Hecho Generador debe ser valido para la cobertura
       if SVPVAL_HechoGenCob( request.bienSiniestrado.riesgo
                            : request.bienSiniestrado.cobertura
                            : request.reclamo.hechoGenerador) = *off;
          %subst(@@repl:1:1) = request.reclamo.hechoGenerador;
          %subst(@@repl:2:3) = request.bienSiniestrado.riesgo;
          %subst(@@repl:6:3) = %char(request.bienSiniestrado.cobertura);
          @@CodM = 'SIN0050';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       // -------------------
       // Tipos De Lesiones debe existir
         if request.reclamo.tipoLesion <> *blanks;
            if SVPVAL_tipoDeLesiones( request.reclamo.tipoLesion) = *off;
               @@repl = request.reclamo.tipoLesion;
               @@CodM = 'SIN0051';
               FinErr ( @@repl
                      : @@CodM
                      : peMsgs);
               return;
            endif;
         endif;

       // -------------------
       // Recupero y valido fechaMovi set456
       SVPSIN_getSet456( request.caratula.empresa
                       : request.caratula.sucursal
                       : @@Ds456);
       @@F456 = (@@Ds456.t@fema * 10000)
              + (@@Ds456.t@femm *   100)
              +  @@Ds456.t@femd;
       if @@Fech <> @@F456;
          %subst(@@repl:1:10) = %char(%date(request.fechaMovi) : *iso);
          %subst(@@repl:11:10) = %char(%date(@@F456) : *iso);
          @@CodM = 'SIN0039';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       // -------------------
       // Recupero y valido nro secuencia
       @@Psec = SVPSIN_getSecShr ( request.caratula.empresa
                                 : request.caratula.sucursal
                                 : request.caratula.rama
                                 : request.caratula.siniestro
                                 : request.caratula.nroOperStro
                                 : request.bienSiniestrado.componente
                                 : request.bienSiniestrado.parentesco
                                 : request.beneficiario.filiatorio
                                 : request.beneficiario.beneficiario
                                 : request.bienSiniestrado.riesgo
                                 : request.bienSiniestrado.cobertura
                                 : @@Fech);
       if @@Psec = -1;
          @@repl = %char(@@Psec);
          @@CodM = 'SIN0040';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       // -------------------
       // Recupero y valido codigo de mayor auxiliar

       //  Si no se informo cuenta del Mayor Auxiliar, el Nro.
       //  del Dato Filiatorio debe ser igual al Dato Filiatorio.
       if request.identProveedor.codMayAux = *blanks or
          request.identProveedor.codMayAux = '**'    or
          request.identProveedor.codMayAux = '*1';
          if request.beneficiario.filiatorio <>
          request.identProveedor.NumMayAux;
             %subst(@@repl:1:2) = request.identProveedor.codMayAux;
             %subst(@@repl:3:7) = %char(request.identProveedor.numMayAux);
             @@CodM = 'SIN0041';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs);
             return;
          endif;
       else;
          if SVPVAL_chkMayorAuxiliar( request.caratula.empresa
                                    : request.caratula.sucursal
                                    : request.identProveedor.codMayAux
                                    : request.identProveedor.numMayAux
                                    ) = *off;
             %subst(@@repl:1:2) = request.identProveedor.codMayAux;
             %subst(@@repl:3:7) = %char(request.identProveedor.numMayAux);
             @@CodM = 'SIN0041';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs);
             return;
          endif;
       endif;

       // -------------------
       // Codigo de moneda debe existir
       if SVPVAL_moneda( request.monto.moneda ) = *off;
          @@repl = request.monto.moneda;
          @@CodM = 'COW0003';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;
       // -------------------
       // Importe Distinto a cero
       if request.monto.importe = *zeros;
          @@repl = %char(request.monto.importe);
          @@CodM = 'SIN0064';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;


       // -------------------------------------
       // Calculos sobre los parámetros enviados
       // -------------------------------------

       // -------------------
       // Calcula campos fechas
       @@Fema = SPVFEC_ObtAÑoFecha8 ( @@Fech );
       @@Femm = SPVFEC_ObtMesFecha8 ( @@Fech );
       @@Femd = SPVFEC_ObtDiaFecha8 ( @@Fech );

       // -------------------
       // Importes y monedas de reserva
       // Recupero Registro moneda
       SVPTAB_getGntmon( @@DSMon
                       : request.monto.moneda
                       : *omit  );

       // -------------------
       // Busco Cotizacion de moneda
       if @@DSMon.moMoeq <> 'AU';
          @@Imco = SVPTAB_cotizaMoneda( request.monto.moneda : @@Fech );
       else;
          @@Imco = 1;
       endif;

       if @@Imco = *zeros;
          // error en la cotizacion de moneda
          @@repl = @@DSMon.moMoeq;
          @@CodM = 'SIN0058';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       // -------------------
       // Calcula Importe Moneda Cte.
       @@Imau = request.monto.importe * @@Imco;

       // -------------------
       // Valido importe neto negativo
       if (@@Totl + @@Imau) < *zeros;
          @@CodM = 'SIN0059';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       // -------------------
       // Verifico que la Reserva que quiero insertar no me deje El neto    Reserva - Franquicias
       // - Pagos en negativo. a la fecha solicitada
       // (+RVA -FRA -PAG)-( nueva RES a insertar)
       @@Ract = SVPSIN_getRvaAct( request.caratula.empresa
                                 : request.caratula.sucursal
                                 : request.caratula.rama
                                 : request.caratula.siniestro
                                 : request.caratula.nroOperStro
                                 : request.beneficiario.filiatorio
                                 : @@Fech);

         if (@@Ract + request.monto.importe) < *zero;
            @@CodM = 'SIN0053';
            FinErr ( @@repl
                   : @@CodM
                   : peMsgs);
            return;
         endif;

       // -------------------
       // Calcula Numero de Reclamo
       select;
          when request.beneficiario.marTipo = '1';
             @@Recl = *zeros;
          when request.beneficiario.marTipo = '2';
             @@Recl = SVPSI1_getNumReclamo( request.caratula.empresa
                                          : request.caratula.sucursal
                                          : request.caratula.rama
                                          : request.caratula.siniestro
                                          : request.caratula.nroOperStro);
          when request.beneficiario.marTipo = '3';
             @@Recl = request.reclamo.reclamo;
       endsl;

       if @@Recl = -1;
          // error en numero de reclamo
          @@repl = %char(@@Recl);
          @@CodM = 'SIN0057';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;


       // -------------------------------------
       // Ok - Cargo Estructuras
       // -------------------------------------


       clear @@Dsbe;
       @@Dsbe.beEmpr = request.caratula.empresa;
       @@Dsbe.beSucu = request.caratula.sucursal;
       @@Dsbe.beRama = request.caratula.rama;
       @@Dsbe.beSini = request.caratula.siniestro;
       @@Dsbe.beNops = request.caratula.nroOperStro;
       @@Dsbe.bePoco = request.bienSiniestrado.componente;
       @@Dsbe.bePaco = request.bienSiniestrado.parentesco;
       @@Dsbe.beRiec = request.bienSiniestrado.riesgo;
       @@Dsbe.beXcob = request.bienSiniestrado.cobertura;
       @@Dsbe.beNrdf = request.beneficiario.filiatorio;
       @@Dsbe.beSebe = request.beneficiario.beneficiario;
       @@Dsbe.beTido = @@DSDaf.dfTido;
       @@Dsbe.beNrdo = @@DSDaf.dfNrdo;
       @@Dsbe.beNomb = @@DSDaf.dfNomb;
       @@Dsbe.beCuit = @@DSDaf.dfCuit;
       @@Dsbe.beCuil = @@DSDaf.dfNjub;
       @@Dsbe.beNupe = *zeros;
       @@Dsbe.beNroc = *zeros;
       @@Dsbe.beComa = request.identProveedor.codMayAux;
       @@Dsbe.beNrma = request.identProveedor.numMayAux;
       @@Dsbe.beEsma = *zeros;
       @@Dsbe.beArcd = @@DScd(1).cdArcd;
       @@Dsbe.beSpol = @@DScd(1).cdSpol;
       @@Dsbe.beSspo = @@DScd(1).cdSspo;
       @@Dsbe.beArse = @@DScd(1).cdArse;
       @@Dsbe.beOper = @@DScd(1).cdOper;
       @@Dsbe.beSuop = @@DScd(1).cdSuop;
       @@Dsbe.beCert = @@DScd(1).cdCert;
       @@Dsbe.bePoli = @@DScd(1).cdPoli;
       @@Dsbe.bePart = *zeros; //se calcula adelante
       @@Dsbe.beJuin = *zeros;
       @@Dsbe.beAgec = *zeros;
       @@Dsbe.beMonr = request.monto.moneda;
       @@Dsbe.beImmr = request.monto.importe;
       @@Dsbe.beMoeq = @@DSMon.moMoeq;
       @@Dsbe.beImco = @@Imco;
       @@Dsbe.beImau = @@Imau;
       @@Dsbe.beMar1 = request.beneficiario.marEstado;
       @@Dsbe.beMar2 = request.beneficiario.marTipo;
       @@Dsbe.beMar3 = 'N';
       @@Dsbe.beMar4 = *off;
       @@Dsbe.beMar5 = *off;
       @@Dsbe.beStrg = *off;
       @@Dsbe.beUser = request.usuario;
       @@Dsbe.beTime = %dec(%time():*iso);
       @@Dsbe.beFera = *year;
       @@Dsbe.beFerm = *month;
       @@Dsbe.beFerd = *day;

       clear @@Dsb1;
       @@Dsb1.b1Empr = @@Dsbe.beEmpr;
       @@Dsb1.b1Sucu = @@Dsbe.beSucu;
       @@Dsb1.b1Rama = @@Dsbe.beRama;
       @@Dsb1.b1Sini = @@Dsbe.beSini;
       @@Dsb1.b1Nops = @@Dsbe.beNops;
       @@Dsb1.b1Poco = @@Dsbe.bePoco;
       @@Dsb1.b1Paco = @@Dsbe.bePaco;
       @@Dsb1.b1Riec = @@Dsbe.beRiec;
       @@Dsb1.b1Xcob = @@Dsbe.beXcob;
       @@Dsb1.b1Nrdf = @@Dsbe.beNrdf;
       @@Dsb1.b1Sebe = @@Dsbe.beSebe;
       @@Dsb1.b1Fema = @@Fema;
       @@Dsb1.b1Femm = @@Femm;
       @@Dsb1.b1Femd = @@Femd;
       @@Dsb1.b1Cesi = request.reclamo.estadoSiniestro;
       @@Dsb1.b1Recl = @@Recl;
       @@Dsb1.b1Ctle = request.reclamo.tipoLesion;
       @@Dsb1.b1Hecg = request.reclamo.hechoGenerador;
       @@Dsb1.b1User = request.usuario;
       @@Dsb1.b1Time = %dec(%time():*iso);
       @@Dsb1.b1Fera = *year;
       @@Dsb1.b1Ferm = *month;
       @@Dsb1.b1Ferd = *day;

       clear @@Dshr;
       @@dshr.hrEmpr = request.caratula.empresa;
       @@dshr.hrSucu = request.caratula.sucursal;
       @@dshr.hrRama = request.caratula.rama;
       @@dshr.hrSini = request.caratula.siniestro;
       @@dshr.hrNops = request.caratula.nroOperStro;
       @@dshr.hrPoco = request.bienSiniestrado.componente;
       @@dshr.hrPaco = request.bienSiniestrado.parentesco;
       @@dshr.hrNrdf = request.beneficiario.filiatorio;
       @@dshr.hrSebe = request.beneficiario.beneficiario;
       @@dshr.hrRiec = request.bienSiniestrado.riesgo;
       @@dshr.hrXcob = request.bienSiniestrado.cobertura;
       @@dshr.hrFmoa = @@Fema;
       @@dshr.hrFmom = @@Femm;
       @@dshr.hrFmod = @@Femd;
       @@dshr.hrPsec = @@Psec;
       @@dshr.hrNupe = *zeros;
       @@dshr.hrNroc = *zeros;
       @@dshr.hrComa = request.identProveedor.codMayAux;
       @@dshr.hrNrma = request.identProveedor.numMayAux;
       @@dshr.hrEsma = *zeros;
       @@dshr.hrMonr = request.monto.moneda;
       @@dshr.hrImmr = request.monto.importe;
       @@dshr.hrImnr = *zeros;
       @@dshr.hrMoeq = @@DSMon.moMoeq;
       @@dshr.hrImco = @@Imco;
       @@dshr.hrImau = @@Imau;
       @@dshr.hrImna = *zeros;
       @@dshr.hrMar1 = request.beneficiario.marEstado;//QQQ VAL O GRAB EN 0
       @@dshr.hrMar2 = request.beneficiario.marTipo;
       @@dshr.hrMar3 = 'N';
       @@dshr.hrMar4 = *off;
       @@dshr.hrMar5 = *off;
       @@dshr.hrUser = request.usuario;
       @@dshr.hrTime = %dec(%time():*iso);
       @@dshr.hrFera = *year;
       @@dshr.hrFerm = *month;
       @@dshr.hrFerd = *day;
       @@dshr.hrTifa = *zeros;
       @@dshr.hrNrsf = *zeros;
       @@dshr.hrNrfa = *zeros;

       if SVPSI1_chkPahsbe( @@Dsbe.beEmpr
                          : @@Dsbe.beSucu
                          : @@Dsbe.beRama
                          : @@Dsbe.beSini
                          : @@Dsbe.beNops
                          : @@Dsbe.bePoco
                          : @@Dsbe.bePaco
                          : @@Dsbe.beRiec
                          : @@Dsbe.beXcob
                          : @@Dsbe.beNrdf
                          : @@Dsbe.beSebe )
       or SVPSI1_chkPahsb1( @@Dsb1.b1Empr
                           : @@Dsb1.b1Sucu
                           : @@Dsb1.b1Rama
                           : @@Dsb1.b1Sini
                           : @@Dsb1.b1Nops
                           : @@Dsb1.b1Poco
                           : @@Dsb1.b1Paco
                           : @@Dsb1.b1Riec
                           : @@Dsb1.b1Xcob
                           : @@Dsb1.b1Nrdf
                           : @@Dsb1.b1Sebe
                           : @@Dsb1.b1Fema
                           : @@Dsb1.b1Femm
                           : @@Dsb1.b1Femd )
       or SVPSI1_chkPahshr( @@dshr.hrEmpr
                           : @@dshr.hrSucu
                           : @@dshr.hrRama
                           : @@dshr.hrSini
                           : @@dshr.hrNops
                           : @@dshr.hrPoco
                           : @@dshr.hrPaco
                           : @@dshr.hrNrdf
                           : @@dshr.hrSebe
                           : @@dshr.hrRiec
                           : @@dshr.hrXcob
                           : @@dshr.hrFmoa
                           : @@dshr.hrFmom
                           : @@dshr.hrFmod
                           : @@dshr.hrPsec) = *on;
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit );
          return;
       endif;

       if SVPSI1_setPahsbe(@@Dsbe) and
          SVPSI1_setPahsb1(@@Dsb1) and
          SVPSI1_setPahshr(@@Dshr) = *on;
          if SVPSI1_RecalBenef( request.caratula.empresa
                              : request.caratula.sucursal
                              : request.caratula.rama
                              : request.caratula.siniestro
                              : request.caratula.nroOperStro) = *on;

             SVPSIN_updCtaCte( request.caratula.rama
                             : request.caratula.siniestro
                             : request.caratula.nroOperStro);

             REST_writeHeader( 201
                             : *omit
                             : *omit
                             : *omit
                             : *omit
                             : *omit
                             : *omit );
          else;
             REST_writeHeader( 400
                             : *omit
                             : *omit
                             : *omit
                             : *omit
                             : *omit
                             : *omit);
          endif;
       else;
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit );
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

