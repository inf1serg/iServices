     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRAG1: Producción Por Artículos                             *
      *         Producción diaria por servicio rest (diario)         *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *01-Abr-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fpahpdg    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'

     D PAX534E         pr                  extpgm('PAX534E')
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
     D peFemi          s              8  0
     D z               s             10i 0

     D t_cand          s             10i 0
     D t_prid          s             15  2
     D t_pred          s             15  2
     D t_comd          s             15  2
     D t_recd          s             15  2
     D t_canm          s             10i 0
     D t_prim          s             15  2
     D t_prem          s             15  2
     D t_comm          s             15  2
     D t_recm          s             15  2
     D aux             s             29  9
     D por             s              9  2

     D agrus           s              3  0 dim(7) ctdata perrcd(7)
     D agrud           s             40a   dim(7) ctdata perrcd(1)
     D fema            s              4  0
     D femm            s              2  0
     D femd            s              2  0
     D hoy             s              8  0

     D k1hpdg          ds                  likerec(p1hpdg:*key)

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

       k1hpdg.dgfemi = peFemi;
       setll %kds(k1hpdg:1) pahpdg;
       if not %equal;
          REST_writeHeader();
          REST_writeEncoding();
          REST_startArray( 'registros' );
          REST_endArray( 'registros' );
          return;
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray('agrupamientos');

       for z = 1 to %elem(agrus);
           t_cand = 0;
           t_prid = 0;
           t_pred = 0;
           t_comd = 0;
           t_recd = 0;
           t_canm = 0;
           t_prim = 0;
           t_prem = 0;
           t_comm = 0;
           t_recm = 0;
           REST_startArray('agrupamiento');
           REST_writeXmlLine('nombre':agrud(z) );
           k1hpdg.dgagru = agrus(z);
           REST_startArray('detalles');
           setll %kds(k1hpdg:2) pahpdg;
           reade %kds(k1hpdg:2) pahpdg;
           dow not %eof;
               exsr $deta;
            reade %kds(k1hpdg:2) pahpdg;
           enddo;
           REST_endArray('detalles');
           //REST_startArray('totales');
           //exsr $tota;
           //REST_endArray('totales');
           REST_endArray('agrupamiento');
       endfor;

       REST_endArray('agrupamientos');

       return;

       begsr $deta;
        REST_startArray('detalle');
         REST_writeXmlLine( 'ramaCodigo' : %char(dgrama) );
         REST_writeXmlLine('descricpionRama' : dgramd );
         REST_writeXmlLine('descripcionCortaRama' : dgramb );
         REST_writeXmlLine('rama' : dgrdis);

         REST_writeXmlLine('cantidadDia' : %char(dgcand));
         REST_writeXmlLine('primaNetaDia' : SVPREST_editImporte(dgprid));
         if dgxdia = 0;
            REST_writeXmlLine( 'porcRecaDia' : '.00' );
          else;
            REST_writeXmlLine( 'porcRecaDia'
                             : %editw(dgxdia:'     0 .  ')    );
         endif;
         REST_writeXmlLine('primaRecargoDia'
                          :SVPREST_editImporte(dgpred));

         REST_writeXmlLine('comisionPrimaRecargoDia'
                          :SVPREST_editImporte(dgcomd));

         if dgxcod = 0;
            REST_writeXmlLine( 'porcComiDia' : '.00' );
          else;
            REST_writeXmlLine( 'porcComiDia'
                             : %editw(dgxcod:'     0 .  ')    );
         endif;
         REST_writeXmlLine('recargosDia' : SVPREST_editImporte(dgrecd));

         REST_writeXmlLine('cantidadMes' : %char(dgcanm));
         REST_writeXmlLine('primaNetaMes' : SVPREST_editImporte(dgprim));
         if dgxdim = 0;
            REST_writeXmlLine( 'porcRecaMes' : '.00' );
          else;
            REST_writeXmlLine( 'porcRecaMes'
                             : %editw(dgxdim:'     0 .  ')    );
         endif;
         REST_writeXmlLine('primaRecargoMes'
                          :SVPREST_editImporte(dgprem));
         if dgxcom = 0;
            REST_writeXmlLine( 'porcComiMes' : '.00' );
          else;
            REST_writeXmlLine( 'porcComiMes'
                             : %editw(dgxcom:'     0 .  ')    );
         endif;
         REST_writeXmlLine('comisionPrimaRecargoMes'
                          :SVPREST_editImporte(dgcomm));
         REST_writeXmlLine('recargosMes' : SVPREST_editImporte(dgrecm));

        REST_endArray('detalle');

        t_cand += dgcand;
        t_prid += dgprid;
        t_pred += dgpred;
        t_comd += dgcomd;
        t_recd += dgrecd;
        t_canm += dgcanm;
        t_prim += dgprim;
        t_prem += dgprem;
        t_comm += dgcomm;
        t_recm += dgrecm;

       endsr;

       begsr $tota;
        REST_startArray('total');
         REST_writeXmlLine( 'ramaCodigo' :'0'            );
         REST_writeXmlLine('descricpionRama' : 'Totales:' );
         REST_writeXmlLine('descripcionCortaRama' : 'Total');
         REST_writeXmlLine('rama' : 'Totales:' );

         REST_writeXmlLine('cantidadDia' : %char(t_cand));
         REST_writeXmlLine('primaNetaDia' : SVPREST_editImporte(t_prid));
         if t_prid <> 0;
            aux =(t_recd/t_prid) * 100;
            monitor;
               por = %dech(aux:9:2);
             on-error;
               por = 0;
            endmon;
          else;
            por = 0;
         endif;
         if por = 0;
            REST_writeXmlLine( 'porcRecaDia' : '.00' );
          else;
            REST_writeXmlLine( 'porcRecaDia'
                             : %editw(por:'     0 .  ')    );
         endif;
         REST_writeXmlLine('primaRecargoDia'
                          :SVPREST_editImporte(t_pred));
         if t_prid <> 0;
            aux =(t_comd/t_prid) * 100;
            monitor;
               por = %dech(aux:9:2);
             on-error;
               por = 0;
            endmon;
          else;
            por = 0;
         endif;
         if por = 0;
            REST_writeXmlLine( 'porcComiDia' : '.00' );
          else;
            REST_writeXmlLine( 'porcComiDia'
                             : %editw(por:'     0 .  ')    );
         endif;
         REST_writeXmlLine('comisionPrimaRecargoDia'
                          :SVPREST_editImporte(t_comd));
         REST_writeXmlLine('recargosDia'
                          :SVPREST_editImporte(t_recd));

         REST_writeXmlLine('cantidadMes' : %char(t_canm));
         REST_writeXmlLine('primaNetaMes' : SVPREST_editImporte(t_prim));
         if t_prim <> 0;
            aux =(t_recm/t_prim) * 100;
            monitor;
               por = %dech(aux:9:2);
             on-error;
               por = 0;
            endmon;
          else;
            por = 0;
         endif;
         if por = 0;
            REST_writeXmlLine( 'porcRecaMes' : '.00' );
          else;
            REST_writeXmlLine( 'porcRecaMes'
                             : %editw(por:'     0 .  ')    );
         endif;

         REST_writeXmlLine('primaRecargoMes'
                          :SVPREST_editImporte(t_prem));
         REST_writeXmlLine('comisionPrimaRecargoMes'
                          :SVPREST_editImporte(t_comm));
         if t_prim <> 0;
            aux =(t_comm/t_prim) * 100;
            monitor;
               por = %dech(aux:9:2);
             on-error;
               por = 0;
            endmon;
          else;
            por = 0;
         endif;
         if por = 0;
            REST_writeXmlLine( 'porcComiMes' : '.00' );
          else;
            REST_writeXmlLine( 'porcComiMes'
                             : %editw(por:'     0 .  ')    );
         endif;
         REST_writeXmlLine('recargosMes'
                          :SVPREST_editImporte(t_recm));

        REST_endArray('total');

       endsr;

      /end-free

**
001005010015020025999
**
TOTAL FRONTING
TOTAL BANCOS
TOTAL RESTO CF + GBA1
TOTAL RESTO GBA2 + INTERIOR
TOTAL WEB (QUOM)
TOTAL WEBSERVICES/API
TOTAL GENERAL DE PRODUCCION
