     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRAC1: Producción Por Artículos                             *
      *         Producción diaria por servicio rest (diario)         *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *01-Abr-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fpahpda    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'

     D PAX534D         pr                  extpgm('PAX534D')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peFemi                        8  0 const

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  peEmpr                        1a   const
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

     D fech            s              8a
     D empr            s              1a
     D sucu            s              2a
     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n
     D t_canu          s             10i 0
     D t_care          s             10i 0
     D t_caep          s             10i 0
     D t_caen          s             10i 0
     D t_cane          s             10i 0
     D t_panu          s             15  2
     D t_pare          s             15  2
     D t_paep          s             15  2
     D t_paen          s             15  2
     D t_pane          s             15  2
     D t_prex          s             15  2
     D t_comi          s             15  2
     D t_reca          s             15  2
     D peFemi          s              8  0
     D aux             s             29  9
     D por             s              9  2
     D fema            s              4  0
     D femm            s              2  0
     D femd            s              2  0
     D hoy             s              8  0

     D k1hpda          ds                  likerec(p1hpda:*key)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

      /free

       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       url = %trim(uri);

       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       fech = REST_getNextPart(url);

       monitor;
          peFemi = %dec(fech:8:0);
        on-error;
          peFemi = 0;
       endmon;

       PAR310X3( empr : fema : femm : femd );
       hoy = (fema * 10000)
           + (femm *   100)
           +  femd;
       if peFemi = hoy;
          REST_writeHeader();
          REST_writeEncoding();
          REST_startArray( 'registros' );
          REST_endArray( 'registros' );
          return;
       endif;

       k1hpda.dafemi = peFemi;
       k1hpda.datipo = 'ACU';
       setll %kds(k1hpda:2) pahpda;
       if not %equal;
          REST_writeHeader();
          REST_writeEncoding();
          REST_startArray( 'registros' );
          REST_endArray( 'registros' );
          return;
       endif;

       t_canu = 0;
       t_care = 0;
       t_caep = 0;
       t_caen = 0;
       t_cane = 0;
       t_panu = 0;
       t_pare = 0;
       t_paep = 0;
       t_paen = 0;
       t_pane = 0;
       t_prex = 0;
       t_comi = 0;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'registros' );

       setll %kds(k1hpda:2) pahpda;
       reade %kds(k1hpda:2) pahpda;
       dow not %eof;
           exsr $deta;
        reade %kds(k1hpda:2) pahpda;
       enddo;

       //exsr $tota;

       REST_endArray( 'registros' );

       return;

       begsr $deta;
        REST_startArray('registro');
         REST_writeXmlLine('tipoRegistro' : 'D');
         REST_writeXmlLine('ramaCodigo' : %editc(darama:'X') );
         REST_writeXmlLine('descricpionRama' : daramd );
         REST_writeXmlLine('descripcionCortaRama' : daramb );
         REST_writeXmlLine('rama' : dardis);
         REST_writeXmlLine('polizasNuevasCantidad' : %char(dacanu) );
         REST_writeXmlLine('polizasNuevasPrima'
                           : SVPREST_editImporte(dapanu) );
         REST_writeXmlLine('renovacionesCantidad' : %char(dacare) );
         REST_writeXmlLine('renovacionesPrima'
                           : SVPREST_editImporte(dapare) );
         REST_writeXmlLine('endososPositivosCantidad' : %char(dacaep) );
         REST_writeXmlLine('endososPositivosPrima'
                           : SVPREST_editImporte(dapaep) );
         REST_writeXmlLine('endososNegativosCantidad' : %char(dacaen) );
         REST_writeXmlLine('endososNegativosPrima'
                           : SVPREST_editImporte(dapaen) );
         REST_writeXmlLine('primaNetaCantidad' : %char(dacane) );
         REST_writeXmlLine('primaNetaImporte'
                           : SVPREST_editImporte(dapane) );
         if daxpex = 0;
            REST_writeXmlLine( 'primaMasExtraPrimaPorcentaje'
                             : '.00'                          );
          else;
            REST_writeXmlLine( 'primaMasExtraPrimaPorcentaje'
                             : %editw(daxpex:'     0 .  ')    );
         endif;
         REST_writeXmlLine( 'primaMasExtraPrimaImporte'
                          : SVPREST_editImporte(daprex)    );
         if daxcom = 0;
            REST_writeXmlLine( 'comisionesPrimaExPrimaPorc'
                             : '.00'                          );
          else;
            REST_writeXmlLine( 'comisionesPrimaExPrimaPorc'
                             : %editw(daxcom:'     0 .  ')    );
         endif;
         REST_writeXmlLine( 'comisionesPrimaExPrimaImporte'
                          : SVPREST_editImporte(dacomi)    );
         REST_writeXmlLine( 'recargosImporte'
                          : SVPREST_editImporte(dareca)    );

        REST_endArray('registro');

        t_canu += dacanu;
        t_care += dacare;
        t_caep += dacaep;
        t_caen += dacaen;
        t_cane += dacane;
        t_panu += dapanu;
        t_pare += dapare;
        t_paep += dapaep;
        t_paen += dapaen;
        t_pane += dapane;
        t_prex += daprex;
        t_comi += dacomi;
        t_reca += dareca;

       endsr;

       begsr $tota;
        REST_startArray('registro');
         REST_writeXmlLine('tipoRegistro' : 'T');
         REST_writeXmlLine('ramaCodigo' : '0' );
         REST_writeXmlLine('descricpionRama' : 'Totales:' );
         REST_writeXmlLine('descripcionCortaRama' : 'Tota:' );
         REST_writeXmlLine('rama' : 'Totales:' );
         REST_writeXmlLine('polizasNuevasCantidad' : %char(t_canu) );
         REST_writeXmlLine('polizasNuevasPrima'
                           : SVPREST_editImporte(t_panu) );
         REST_writeXmlLine('renovacionesCantidad' : %char(t_care) );
         REST_writeXmlLine('renovacionesPrima'
                           : SVPREST_editImporte(t_pare) );
         REST_writeXmlLine('endososPositivosCantidad' : %char(t_caep) );
         REST_writeXmlLine('endososPositivosPrima'
                           : SVPREST_editImporte(t_paep) );
         REST_writeXmlLine('endososNegativosCantidad' : %char(t_caen) );
         REST_writeXmlLine('endososNegativosPrima'
                           : SVPREST_editImporte(t_paen) );
         REST_writeXmlLine('primaNetaCantidad' : %char(t_cane) );
         REST_writeXmlLine('primaNetaImporte'
                           : SVPREST_editImporte(t_pane) );
         aux = (t_reca/t_pane) * 100;
         por = %dech(aux:9:2);
         if por = 0;
            REST_writeXmlLine( 'primaMasExtraPrimaPorcentaje'
                             : '.00'                          );
          else;
            REST_writeXmlLine( 'primaMasExtraPrimaPorcentaje'
                             : %editw(por:'     0 .  ')    );
         endif;
         REST_writeXmlLine( 'primaMasExtraPrimaImporte'
                          : SVPREST_editImporte(t_prex)    );
         aux = (t_comi/t_pane) * 100;
         por = %dech(aux:9:2);
         if por = 0;
            REST_writeXmlLine( 'comisionesPrimaExPrimaPorc'
                             : '.00'                          );
          else;
            REST_writeXmlLine( 'comisionesPrimaExPrimaPorc'
                             : %editw(por:'     0 .  ')    );
         endif;
         REST_writeXmlLine( 'comisionesPrimaExPrimaImporte'
                          : SVPREST_editImporte(t_comi)    );
         REST_writeXmlLine( 'recargosImporte'
                          : SVPREST_editImporte(t_reca)    );
        REST_endArray('registro');
       endsr;

      /end-free

