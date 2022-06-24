     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSPOPG : Generación Orden De Pago Total                      *
      * ------------------------------------------------------------ *
      * Nestor Nelson                        21/12/2021              *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/sinest_h.rpgle'
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/svpemp_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svprvs_h.rpgle'
      /copy './qcpybooks/svpopg_h.rpgle'
      /copy './qcpybooks/sinest_h.rpgle'
      /copy './qcpybooks/svpsi1_h.rpgle'
      /copy './qcpybooks/svpsuc_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'

     D request         ds                  likeds(wspopg_t)
     D buffer          s           5000a
     D options         s            100a
     D rc1             s             10i 0
     D rc              s             10i 0
     D penmro          s              7p 0
     D @@repl          s          65535a
     D path            s            256a   varying
     D pevalu          s           1024a
     D peMsgs          ds                  likeds(paramMsgs)
     d peMsgf          s              6a
     d peIdms          s              7a
     D @@Fact          ds                  likeds(facturaStro_t)
     D @@Riec          s              3a
     D @@Xcob          s              3  0
     D @@Mone          s              2
     D @@Come          s             15  6
     D @@Imau          s             15  2
     D @@Ds65          ds                  likeds(dsGti965_t)
     D @@DsBe          ds                  likeds(dsPahsbe_t) dim( 9999 )
     D @@DsWBe         ds                  likeds(dsPawsbe_t) dim( 9999 )
     D p@DsBe          ds                  likeds(dsPawsbe_t)
     D @@DsBeC         s             10i 0
     D @@DsWBeC        s             10i 0
     D peDsGp          ds                  likeds(dsgntpro_t) dim( 99 )
     D peDsGpC         s             10i 0
     D peProc          s              3a
     D x               s             10i 0
     D z               s             10i 0
     D cant            s             10i 0
     D CantPer         s             10i 0
     D peRpro          s              2  0 dim(25)
     D peProv          s              3a   dim(25)
     D peImpe          s             15  2 dim(25)
     D @@core          s              2  0

     D peTota          s             15  2
     D peViva          s             15  2
     D peSubt          s             15  2
     D peNeto          s             15  2
     D peRetc          ds                  likeds(reteCalc_t) dim(99)
     D pePerc          s             15  2
     D variable        s              2  0
     D peValo          ds                  likeds(valoresOp_t)
     D siniestros      ds                  likeds(siniestroNum_t) dim(999)

     *  Orden de Pago
     D                 ds                  inz
     D $OP                     1      8  0
     D peArtc                  1      2  0
     D pePacp                  3      8  0

      *- Area Local del Sistema. -------------------------- *
     D                sds
     D  ususer               254    263
     D  ususr2               358    367

     d WSPVST          pr                  ExtPgm('WSPVST')
     d  peEmpr                        1a   const
     d  peSucu                        2a   const
     d  peRama                        2  0 const
     d  peSini                        7  0 const
     d  peNops                        7  0 const
     d  peMsgf                        6a
     d  peIdms                        7a

     d*WSPVOP          pr                  ExtPgm('INF1DAVI/WSPVOP')
     d WSPVOP          pr                  ExtPgm('WSPVOP')
     d  peEmpr                        1a   const
     d  peSucu                        2a   const
     d  peRama                        2  0 const
     d  siniestros                         likeds(siniestroNum_t) dim(999)
     D  peCant                       10i 0 const
     D  peTipa                        1    const
     d  peMar2                        1    const
     d  peComa                        2    const
     d  peNrma                        7  0 const
     d  peMone                        2    const
     d  peCome                       15  6 const
     d  peGain                        1    const
     d  peFppg                       10a   const
     d  peCfpg                        2  0 const
     d  peFact                             likeds(facturaStro_t) const
     d  peConc                       75    const
     d  peApol                        1    const
     d  peNomb                       40    const
     d  peCore                        2  0 const
     d  peDeJu                        1    const
     d  peIdms                        7a
     d  peMsgs                             likeds(paramMsgs)

      /free

       *inlr = *on;

       // Inicio

        clear request;
        options = 'path=ordenPagoTotalStro +
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

       // Lectura y Parseo
         if REST_getEnvVar('WSPOPG_BODY' : peValu );
            options = 'doc=file path=ordenPagoTotalStro +
                       case=any allowextra=yes allowmissing=yes';
            monitor;
              xml-into request %xml('/tmp/wspopg.xml' : options);
            on-error;
              exsr $errorParseo;
           endmon;
            Qp0zDltEnv('WSPOPG_BODY');
          else;
            rc = REST_readStdInput( %addr(buffer): %len(buffer) );
            options = 'doc=string path=ordenPagoTotalStro +
                       case=any allowextra=yes allowmissing=yes';
            monitor;
              xml-into request %xml(buffer : options);
            on-error;
              exsr $errorParseo;
           endmon;
         endif;

       // -------------------------------------------------------

          cant = *zeros;
          for x = 1 to 999;
           if request.siniestros.siniestro(x).nroStro <> *blanks;
            siniestros(x).nroStro       =
              %dec(request.siniestros.siniestro(x).nroStro:7:0);
            siniestros(x).nroOperStro   =
              %dec(request.siniestros.siniestro(x).nroOperStro:7:0);
            siniestros(x).codigoriesgo  =
              request.siniestros.siniestro(x).codigoriesgo;
            siniestros(x).codigocobertu =
              %dec(request.siniestros.siniestro(x).codigocobertu:3:0);
            siniestros(x).CodigoMoneda  =
              request.siniestros.siniestro(x).CodigoMoneda;
            siniestros(x).importe       =
              %dec(request.siniestros.siniestro(x).importe:15:2);
            cant += 1;
           else;
            leave;
           endif;
          endfor;

       // -------------------------------------------------------
       // Control sobre los parámetros de entrada enviados
       // -------------------------------------------------------

          for x = 1 to cant;

              wspvst( request.empresa
                    : request.sucursal
                    : %dec(request.rama:2:0)
                    : siniestros(x).nroStro
                    : siniestros(x).nroOperStro
                    : peMsgf
                    : peIdms) ;

              if peMsgf <> *blanks ;

                rc1 = SVPWS_getMsgs( '*LIBL'
                                 : peMsgf
                                 : peIdms
                                 : peMsgs
                                 : *omit
                                 : *omit );

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
          endfor;
       // --------------------------------------------------------------
       // Valida orden de pago
       // --------------------------------------------------------------

         clear @@Fact;
         clear @@Riec;
         clear @@Xcob;
         clear @@Mone;
         clear @@Come;
         clear @@Imau;
         clear @@Core;

         if request.factura.fecha = *blanks;
            request.factura.fecha = '0000-00-00';
         endif;

         @@Fact.tipo         = request.factura.tipo;
         @@Fact.sucursalFact = request.factura.sucursalFact;
         @@Fact.numero       = request.factura.numero;
         @@Fact.fecha        = request.factura.fecha;
         @@Fact.codigoMoneda = request.factura.codigoMoneda;
         @@Fact.importe      = request.factura.importe;

         WSPVOP( request.empresa
               : request.sucursal
               : request.rama
               : siniestros
               : cant
               : request.tipodepago
               : request.tipoBenefPago
               : request.codMayorAux
               : request.nroMayorAux
               : @@Mone
               : @@Come
               : request.gastosIndemni
               : request.fechaProbPago
               : request.formaDePago
               : @@Fact
               : request.concepto
               : request.aplicaAPoliza
               : request.chequeALaOrde
               : @@Core
               : request.depositoJudicial
               : peIdms
               : peMsgs                       );

         if peIdms <> *blanks ;
            rc1 = SVPWS_getMsgs( '*LIBL'
                               : 'WSVMSG'
                               : peIdms
                               : peMsgs
                               : *omit
                               : *omit );

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

       // --------------------------------------------------------------
       // Mueve si tiene percepciones.
       // --------------------------------------------------------------
         clear x;
         clear perpro;
         clear peimpe;

         CantPer = *zeros;
         for x = 1 to 25;
          if REQUEST.PERCEPCIONES.PERCEPCION(X).PROVINCIA    <> *blanks and
            REQUEST.PERCEPCIONES.PERCEPCION(X).PERCEIMPORTE <> *blanks;

            peProc = REQUEST.PERCEPCIONES.PERCEPCION(X).PROVINCIA;
            SVPTAB_getGntpro( peDsGp
                            : peDsGpC
                            : peProc );

            peProv(x) = REQUEST.PERCEPCIONES.PERCEPCION(X).PROVINCIA;
            perpro(x) = peDsGp(1).prrpro;
            peimpe(x) = %dec(REQUEST.PERCEPCIONES.PERCEPCION(X).PERCEIMPORTE
                      : 15 : 2);
            CantPer += 1;

            //perpro(x) = %dec(REQUEST.PERCEPCIONES.PERCEPCION(X).PROVINCIA
            //          : 2 : 0);

          else;
            leave;
          endif;
         endfor;

       // --------------------------------------------------------------
       // Llamo a programa que genera Orden de Pago Total
       // --------------------------------------------------------------
       clear peValo;
       clear $OP;
       $OP = SVPSIN_generarOrdPagStroTotal( request.empresa
                                          : request.sucursal
                                          : request.rama
                                          : siniestros
                                          : cant
                                          : request.tipoBenefPago
                                          : request.codMayorAux
                                          : request.nroMayorAux
                                          : request.tipodepago
                                          : request.factura.importe
                                          : request.gastosIndemni
                                          : request.fechaProbPago
                                          : request.formaDePago
                                          : request.factura.tipo
                                          : request.factura.sucursalFact
                                          : request.factura.numero
                                          : request.factura.fecha
                                          : peRpro
                                          : peImpe
                                          : request.concepto
                                          : request.aplicaAPoliza
                                          : request.chequeALaOrde
                                          : request.depositoJudicial
                                          : %upper(request.usuario)
                                          : peValo );

         if request.tipodepago = 'C';
            peArtc = 0;
            pePacp = 0;
         endif;

          // Armo Salida
          if request.tipodepago = 'P' or
             request.tipodepago = 'T';
             if peArtc <= 0 or pePacp <= 0;
                REST_writeHeader( 400
                                : *omit
                                : *omit
                                : *omit
                                : *omit
                                : *omit
                                : *omit );
                REST_end();
                SVPREST_end();
                return;
             endif;
          endif;

          if peArtc <> 0 and pePacp <> 0;

             for x = 1 to cant;

                 // Cargo Gti965

                 @@Ds65.g5empr = request.empresa;
                 @@Ds65.g5sucu = request.sucursal;
                 @@Ds65.g5rama = request.rama;
                 @@Ds65.g5sini = siniestros(x).nroStro;
                 @@Ds65.g5nops = siniestros(x).nroOperStro;
                 @@Ds65.g5artc = peartc;
                 @@Ds65.g5pacp = pepacp;
                 @@Ds65.g5tipo = 'P';
                 @@Ds65.g5tip2 = request.tipodepago;
                 @@Ds65.g5user = request.usuario;
                 @@Ds65.g5date = %dec(%date():*iso);
                 @@Ds65.g5time = %dec(%time():*iso);

                 SVPSIN_setGti965(@@Ds65);

             endfor;
          endif;

          //recupero valores
          if request.tipodepago = 'C';
             peTota = peValo.total;
             peViva = peValo.valorIva;
             peSubt = peValo.subTotal;
             peNeto = peValo.neto;
             pePerc = peValo.percep;
             //RETENCIONES
             for x = 1 to %elem(peValo.retenciones.retencion);
                peRetc(x).tiic = peValo.retenciones.retencion(x).tiic;
                peRetc(x).tiid = peValo.retenciones.retencion(x).tiid;
                peRetc(x).prod = peValo.retenciones.retencion(x).prod;
                peRetc(x).poim = peValo.retenciones.retencion(x).poim;
                peRetc(x).iiau = peValo.retenciones.retencion(x).iiau;
                peRetc(x).irau = peValo.retenciones.retencion(x).irau;
                peRetc(x).pacp = peValo.retenciones.retencion(x).pacp;
             endfor;
          else;
             SVPOPG_getImportes( request.empresa
                               : request.sucursal
                               : %editc(peArtc:'X')
                               : pePacp
                               : peTota
                               : peViva
                               : peSubt
                               : peRetc
                               : peNeto
                               : pePerc );
          endif;

          REST_writeHeader( 201
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit );
          REST_writeEncoding();

          REST_startArray( 'numeroOrdenDePago' );
           REST_writeXmlLine( 'empresa'
                            : %char(request.empresa) );
           REST_writeXmlLine( 'sucursal'
                            : %char(request.sucursal) );
           REST_writeXmlLine( 'rama'
                            : %char(request.rama) );
           REST_writeXmlLine( 'areaTecnica'
                            : %char(peartc) );
           REST_writeXmlLine( 'nroCbatePago'
                            : %char(pepacp) );

           REST_startArray( 'siniestros' );
           for x = 1 to cant;
             REST_startArray( 'siniestro' );
               REST_writeXmlLine( 'nroStro'
                                : %char(siniestros(x).nroStro ) );
               REST_writeXmlLine( 'nroOperStro'
                                : %char(siniestros(x).nroOperStro ) );
               REST_writeXmlLine( 'codigoRiesgo'
                                : %char(siniestros(x).codigoRiesgo ) );
               REST_writeXmlLine( 'codigoCobertu'
                                : %char(siniestros(x).codigoCobertu ) );
               REST_writeXmlLine( 'codigoMoneda'
                                : %char(siniestros(x).CodigoMoneda  ) );
               REST_writeXmlLine( 'importe'
                                : %char(siniestros(x).importe ) );
             REST_endArray  ( 'siniestro' );
           endfor;
           REST_endArray  ( 'siniestros' );

           REST_startArray( 'percepciones' );
           for x = 1 to CantPer;
             REST_startArray( 'percepcion' );
               REST_writeXmlLine( 'provincia'
                                : %char( peProv(x) ) );
               REST_writeXmlLine( 'perceImporte'
                                : %char( peImpe(x) ) );
             REST_endArray  ( 'percepcion' );
           endfor;
           REST_endArray  ( 'percepciones' );

           REST_startArray( 'valores' );
            REST_writeXmlLine( 'total' : SVPREST_editImporte(peTota) );
            REST_writeXmlLine( 'valorIva' : SVPREST_editImporte(peViva) );
            REST_writeXmlLine( 'subTotal' : SVPREST_editImporte(peSubt) );
            REST_writeXmlLine( 'neto'     : SVPREST_editImporte(peNeto) );
            REST_startArray( 'retenciones');
            for x = 1 to %elem(peRetc);
            if peRetc(x).irau <> 0;
             REST_startArray( 'retencion' );
              REST_writeXmlLine( 'codigo' : peRetc(x).tiic );
              REST_writeXmlLine( 'descripcion' : peRetc(x).tiid );
              REST_writeXmlLine( 'provincia' : peRetc(x).prod );
              REST_writeXmlLine( 'porcentaje'
                               : %editw( peRetc(x).poim : '  0,  ' ));
              REST_writeXmlLine( 'base'
                               : SVPREST_editImporte(peRetc(x).iiau));
              REST_writeXmlLine( 'importe'
                               : SVPREST_editImporte(peRetc(x).irau));
              REST_writeXmlLine( 'numeroCertificado'
                               : %trim(%char(peRetc(x).pacp)));
             REST_endArray  ( 'retencion' );
            endif;
            endfor;
            REST_endArray  ( 'retenciones');
           REST_endArray  ( 'valores' );
          REST_endArray  ( 'numeroOrdenDePago');

          REST_end();

       return;

        begsr $errorParseo;
         @@repl = 'wspopg_t';
         SVPWS_getMsgs( '*LIBL'
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
        endsr;
