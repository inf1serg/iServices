     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRVEH: QUOM Versión 2                                       *
      *         Vehiculos por Año/Marca/Grupo.                       *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *20-Jun-2017            *
      * ------------------------------------------------------------ *
      * SGF 09/11/2020: Elimino acceso a SET200 y uso _getMinMaxSuma *
      *                                                              *
      * ************************************************************ *
     Fset280    if   e           k disk
     Fset20493  if   e           k disk
     Fset2071   if   e           k disk
     Fset205    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpiau_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/spvveh_h.rpgle'

     D empr            s              1a
     D sucu            s              2a
     D vhaÑ            s              4a
     D cmar            s              9a
     D cgru            s              3a

     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D peVhan          s              4  0
     D peCmar          s              9  0
     D peCgru          s              3  0
     D @@mini          s              5  2
     D @@maxi          s              5  2
     D @@cmin          s              5  2
     D @@cmax          s              5  2
     D @@smin          s             15  2
     D @@smax          s             15  2
     D peVehi          ds                  likeds(iauto2_t)
     D peMini          s              5  2
     D peMaxi          s              5  2

     D k1t204          ds                  likerec(s1t204:*key)
     D k1t207          ds                  likerec(s1t207:*key)
     D k1t280          ds                  likerec(s1t280:*key)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

     Is1t204
     I              t@cmar                      t1cmar
     I              t@cmod                      t1cmod

      /free

       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
          return;
       endif;
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       vhaÑ = REST_getNextPart(url);
       cmar = REST_getNextPart(url);
       cgru = REST_getNextPart(url);

       monitor;
         peVhan = %dec(vhaÑ:4:0);
        on-error;
         peVhan = 0;
       endmon;

       monitor;
         peCmar = %dec(cmar:9:0);
        on-error;
         peCmar = 0;
       endmon;

       monitor;
         peCgru = %dec(cgru:3:0);
        on-error;
         peCgru = 0;
       endmon;

       k1t280.t@cmar = peCmar;
       k1t280.t@vhan = peVhan;
       k1t280.t@cgru = peCgru;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'vehiculos' );

       setll %kds(k1t280:3) set280;
       reade %kds(k1t280:3) set280;
       dow not %eof;
           rc2 = SVPIAU_getVehicul2( t@cmar : t@cmod : peVehi );
           if rc2 = 0;
              exsr $cant;
           endif;
        reade %kds(k1t280:3) set280;
       enddo;

       REST_endArray( 'vehiculos' );

       return;

       // --------------------------------------------
       // Ver a cuantos GAUS esta relacionado este
       // INFOAUTO.
       // Debe estar relacionado solo a uno
       // --------------------------------------------
       begsr $cant;
        rc2 = 0;
        k1t204.t@cma1 = t@cmar;
        k1t204.t@cmo1 = t@cmod;
        setll %kds(k1t204:2) set20493;
        reade %kds(k1t204:2) set20493;
        dow not %eof;
            rc2 += 1;
            if rc2 > 1;
               leave;
            endif;
         reade %kds(k1t204:2) set20493;
        enddo;
        if rc2 = 1;
           exsr $vehi;
        endif;
       endsr;

       // --------------------------------------------
       // Busco SET204 para ver si esta excluido de
       // web por el usuario.
       // --------------------------------------------
       begsr $vehi;
        k1t204.t@cma1 = t@cmar;
        k1t204.t@cmo1 = t@cmod;
        chain %kds(k1t204:2) set20493;
        if not %found;
           t@mar1 = 'E';
        endif;
        if t@mar1 = 'I';
           exsr $sumas;
        endif;
       endsr;

       // --------------------------------------------
       // Busco precio
       // --------------------------------------------
       begsr $sumas;
        k1t207.t@vhmc = t@vhmc;
        k1t207.t@vhmo = t@vhmo;
        k1t207.t@vhcs = t@vhcs;
        k1t207.t@vhaÑ = peVhan;
        k1t207.t@vhcr = t@Vhcr;
        chain %kds(k1t207:5) set2071;
        if not %found;
           leavesr;
        endif;
        if SPVVEH_getMinMaxSuma( t@como
                               : t@vhvu
                               : peMini
                               : peMaxi );
           @@mini = peMini;
           @@maxi = peMaxi;
           @@cmin = (100 - @@mini) / 100;
           @@cmax = (@@maxi / 100) + 1;
         else;
           @@cmax = 1;
           @@cmin = 1;
        endif;

        @@smin = (t@vhvu * @@cmin);
        @@smax = (t@vhvu * @@cmax);

        if @@smin <= 0;
           @@smin = t@vhvu;
        endif;

        exsr $auto;

       endsr;

       begsr $auto;
        chain t@vhcr set205;
        if not %found;
           t@vhcd = *blanks;
        endif;
        REST_startArray( 'vehiculo' );
         REST_writeXmlLine( 'codigoMarca' : %char(t@cmar) );
         REST_writeXmlLine( 'codigoModelo': %char(t@cgru) );
         REST_writeXmlLine( 'codigoVersion':%char(t@cmo1) );
         REST_writeXmlLine( 'descripcion' : peVehi.i@dmod );
         REST_writeXmlLine( 'sumaDefecto' : SVPREST_editImporte(t@vhvu) );
         REST_writeXmlLine( 'sumaMinima'  : SVPREST_editImporte(@@smin) );
         REST_writeXmlLine( 'sumaMaxima'  : SVPREST_editImporte(@@smax) );
         REST_writeXmlLine( 'codigoCarroceria' : t@vhcr );
         REST_writeXmlLine( 'descripcionCarroceria' : t@vhcd );
         REST_writeXmlLine( 'codigoTipo' : %char(t@vhct) );
         REST_writeXmlLine( 'descripcionTipo'
                          : SVPDES_getTipoDeVehiculo( t@vhct ) );
         REST_writeXmlLine( 'codigoOrigen' : t@vhni );
         select;
          when t@vhni = 'N';
               REST_writeXmlLine( 'descripcionOrigen' : 'NACIONAL');
          when t@vhni = 'I';
               REST_writeXmlLine( 'descripcionOrigen' : 'IMPORTADO' );
          other;
               REST_writeXmlLine( 'descripcionOrigen' : 'DESCONOCIDO' );
         endsl;
         REST_writeXmlLine( 'codigoMarcaGaus' : t@vhmc );
         REST_writeXmlLine( 'codigoModeloGaus': t@vhmo );
         REST_writeXmlLine( 'codigoVersionGaus' :  t@vhcs );
        REST_endArray( 'vehiculo' );
       endsr;

      /end-free

