      * ************************************************************ *
      * WSRAP2: BPM Siniestros                                       *
      *         Obtener póliza vigente a fecha de Siniestro          *
      *         Response                                             *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                               *04-Oct-2021  *
      * ------------------------------------------------------------ *
      * SGF 17/03/2022: Si llega patente, va solo esa.               *
      * SGF 02/05/2022: Agrego ultimo suplemento que afecta a cada   *
      *                 vehiculo.                                    *
      * VCM 04/05/2022: Agrego en Tag Vehiculo: descripcionCobertura *
      * DOT 23/05/2022: Se agrega READE en la rutina $suplVeh.       *
      *                                                              *
      * ************************************************************ *

        ctl-opt
               actgrp(*caller)
               bnddir('HDIILE/HDIBDIR')
               option(*srcstmt: *nodebugio: *nounref: *noshowcpy)
               datfmt(*iso) timfmt(*iso);

        dcl-f pahet9 disk usage(*input) keyed;
        dcl-f pahet0 disk usage(*input) keyed;
        dcl-f set409 disk usage(*input) keyed;
        dcl-f set412 disk usage(*input) keyed;

        dcl-f pahed0 disk usage(*input) keyed;

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/spvveh_h.rpgle'
      /copy './qcpybooks/svpint_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'

       dcl-pr WSRAP1 extpgm('WSRAP1');
              peEmpr   char(1);
              peSucu   char(2);
              peArcd   packed(6:0);
              peSpol   packed(9:0);
              peSspo   packed(3:0);
              peRama   packed(2:0);
              pePoli   packed(7:0);
              peArse   packed(2:0);
              peOper   packed(7:0);
              peSuop   packed(3:0);
              peFsin   packed(8:0);
              peHsin   packed(6:0);
              peNmat   char(25) const options(*nopass:*omit);
       end-pr;

       dcl-pi WSRAP1;
              peEmpr   char(1);
              peSucu   char(2);
              peArcd   packed(6:0);
              peSpol   packed(9:0);
              peSspo   packed(3:0);
              peRama   packed(2:0);
              pePoli   packed(7:0);
              peArse   packed(2:0);
              peOper   packed(7:0);
              peSuop   packed(3:0);
              peFsin   packed(8:0);
              peHsin   packed(6:0);
              peNmat   char(25) const options(*nopass:*omit);
       end-pi;

       dcl-pr SPVIG3 extpgm('SPVIG3');
              peArcd   packed(6:0);
              peSpol   packed(9:0);
              peRama   packed(2:0);
              peArse   packed(2:0);
              peOper   packed(7:0);
              pePoco   packed(4:0);
              peFech   packed(8:0);
              peFemi   packed(8:0) const;
              peStat   ind;
              peSspo   packed(3:0);
              peSuop   packed(3:0);
              peFpgm   char(3) const;
              peVig2   ind const;
       end-pr;

       dcl-ds peVehi dim(500) qualified;
              poco packed(4:0);
              nmat char(25);
              cobl char(2);
              vhvu packed(15:2);
              ifra packed(15:2);
              moto char(25);
              chas char(25);
              vhmd char(15);
              vhdm char(15);
              vhdt char(15);
              vhdu char(15);
              vhan char(4);
              sspo packed(3:0);
              suop packed(3:0);
              cobs likeds(coberturas) dim(99);
       end-ds;

       dcl-ds coberturas qualified;
              xcob packed(3:0);
              desc char(20);
              hecg char(1);
       end-ds;

       dcl-ds intermediarios qualified dim(9);
           nivt packed(1:0);
           nivc packed(5:0);
           nomb char(40);
       end-ds;

       dcl-ds k1het9 likerec(p1het9:*key);
       dcl-ds k1het0 likerec(p1het0:*key);
       dcl-ds k1hed0 likerec(p1hed0:*key);

       dcl-s x int(10);
       dcl-s y int(10);
       dcl-s p@sspo packed(3:0);
       dcl-s p@suop packed(3:0);
       dcl-s vd     packed(8:0);
       dcl-s hf     packed(8:0);
       dcl-s peStat ind;
       dcl-s peCade packed(5:0) dim(9);
       dcl-s @@cade packed(5:0) dim(9);
       dcl-s peCobl char(2);
       dcl-s peNomb char(40);

       *inlr = *on;

       clear peVehi;

       REST_writeHeader();
       REST_writeEncoding();

       //
       // Recorrer los autos de la poliza
       //
       k1het9.t9empr = peEmpr;
       k1het9.t9sucu = peSucu;
       k1het9.t9arcd = peArcd;
       k1het9.t9spol = peSpol;
       setll %kds(k1het9:4) pahet9;
       reade %kds(k1het9:4) pahet9;
       dow not %eof;
           SPVIG3( t9arcd
                 : t9spol
                 : t9rama
                 : t9arse
                 : t9oper
                 : t9poco
                 : peFsin
                 : 99999999
                 : peStat
                 : p@sspo
                 : p@suop
                 : *blanks
                 : *on        );
           if peStat;
              exsr vehiculo;
           endif;
        reade %kds(k1het9:4) pahet9;
       enddo;

       @@cade(*) = 0;
       clear intermediarios;
       if SPVSPO_getCadenaComercial( peEmpr
                                   : peSucu
                                   : peArcd
                                   : peSpol
                                   : peCade
                                   : peSspo );
          if SVPINT_getCadena( peEmpr
                             : peSucu
                             : 1
                             : peCade(1)
                             : @@cade    ) = *off;
             y = 0;
             for x = 1 to %elem(@@cade);
                 if @@cade(x) <> 0;
                    y += 1;
                    intermediarios(y).nivt = x;
                    intermediarios(y).nivc = @@cade(x);
                    if x <> 9;
                    intermediarios(y).nomb = SVPINT_getNombre( peEmpr
                                                             : peSucu
                                                             : x
                                                             : @@cade(x));
                     else;
                    intermediarios(y).nomb = SVPINT_getNombre( peEmpr
                                                             : peSucu
                                                             : 1
                                                             : @@cade(x));
                    endif;
                 endif;
             endfor;
          endif;
       endif;

       REST_startArray( 'polizas' );
       REST_startArray( 'poliza' );
       REST_writeXmlLine( 'empresa' : peEmpr );
       REST_writeXmlLine( 'sucursal': peSucu );
       REST_writeXmlLine( 'rama'    : %char(peRama) );
       REST_writeXmlLine( 'numero'  : %char(pePoli) );
       REST_writeXmlLine( 'articulo': %char(peArcd) );
       REST_writeXmlLine( 'superpoliza' : %char(peSpol) );
       REST_writeXmlLine( 'suplSuperpoliza' : %char(peSspo) );
       REST_writeXmlLine( 'suplPoliza' : %char(peSuop) );
       REST_writeXmlLine( 'codigoAsegurado'
                        : %trim(%char( SPVSPO_getAsen( peEmpr
                                                     : peSucu
                                                     : peArcd
                                                     : peSpol
                                                     : peSspo))));
       REST_writeXmlLine( 'articuloRamaSecuencia' : %char(peArse) );
       exsr $cadena;
       REST_startArray( 'vehiculos' );
       for x = 1 to %elem(peVehi);
        if peVehi(x).poco <> 0;
          if (%parms >= 13 and %addr(peNmat) = *null) or
             ( %parms >= 13 and
               %addr(peNmat) <> *null and
               peNmat = peVehi(x).nmat    );
           REST_startArray( 'vehiculo' );
            REST_writeXmlLine( 'componente' : %char(peVehi(x).poco));
            REST_writeXmlLine( 'parentesco' : '1'                  );
            REST_writeXmlLine( 'patente'    : %trim(peVehi(x).nmat));
            REST_writeXmlLine( 'cobertura'  : %trim(peVehi(x).cobl));

            peCobl = peVehi(x).cobl;
            SPVVEH_CheckCobertura( peCobl
                                 : peNomb );
            REST_writeXmlLine( 'descripcionCobertura'
                             : %trim(peNomb) );

            REST_writeXmlLine( 'sumaAsegurada'
                             : SVPREST_editImporte(peVehi(x).vhvu) );
            REST_writeXmlLine( 'franqDanioParcial'
                             : SVPREST_editImporte(peVehi(x).ifra) );
            REST_writeXmlLine( 'motor'  : peVehi(x).moto);
            REST_writeXmlLine( 'chasis' : peVehi(x).chas);
            REST_writeXmlLine( 'marca'  : peVehi(x).vhmd);
            REST_writeXmlLine( 'modelo' : peVehi(x).vhdm);
            REST_writeXmlLine( 'tipo'   : peVehi(x).vhdt);
            REST_writeXmlLine( 'uso'    : peVehi(x).vhdu);
            REST_writeXmlLine( 'anio'   : peVehi(x).vhan);

            exsr $suplVeh;
            REST_writeXmlLine( 'suplSuperpoliza' : %char(peVehi(x).sspo) );
            REST_writeXmlLine( 'suplPoliza'      : %char(peVehi(x).suop) );

            REST_startArray( 'coberturasSsn');
             for y = 1 to 99;
                 if peVehi(x).cobs(y).xcob <> 0;
                    REST_startArray( 'coberturaSsn');
                     REST_writeXmlLine( 'codigo'
                                      : %char(peVehi(x).cobs(y).xcob) );
                     REST_writeXmlLine( 'descripcion'
                                      : %trim(peVehi(x).cobs(y).desc) );
                     REST_writeXmlLine( 'hechoGenerador'
                                      : %trim(peVehi(x).cobs(y).hecg) );
                    REST_endArray( 'coberturaSsn');
                 endif;
             endfor;
            REST_endArray( 'coberturasSsn');

           REST_endArray( 'vehiculo' );
          endif;
        endif;
       endfor;
       REST_endArray( 'vehiculos' );
       REST_endArray( 'poliza' );
       REST_endArray( 'polizas' );

       return;

       begsr vehiculo;
        k1het0.t0empr = t9empr;
        k1het0.t0sucu = t9sucu;
        k1het0.t0arcd = t9arcd;
        k1het0.t0spol = t9spol;
        k1het0.t0sspo = p@sspo;
        k1het0.t0rama = t9rama;
        k1het0.t0arse = t9arse;
        k1het0.t0oper = t9oper;
        k1het0.t0poco = t9poco;
        k1het0.t0suop = p@suop;
        chain %kds(k1het0) pahet0;
        if %found;
           x += 1;
           peVehi(x).poco = t0poco;
           peVehi(x).nmat = t0nmat;
           peVehi(x).cobl = t0cobl;
           peVehi(x).vhvu = t0vhvu;
           peVehi(x).ifra = t0ifra;
           peVehi(x).moto = t0moto;
           peVehi(x).chas = t0chas;
           peVehi(x).vhmd = SVPDES_marca(t0vhmc);
           peVehi(x).vhdm = SVPDES_modelo(t0vhmo);
           peVehi(x).vhdt = SVPDES_getTipoDeVehiculo(t0vhct);
           peVehi(x).vhdu = SVPDES_usoDelVehiculo(t0vhuv);
           peVehi(x).vhan = %editc(t0vhaÑ:'X');
           exsr $coberturas;
        endif;
       endsr;

       begsr $coberturas;
        y = 0;
        setll t0cobl set412;
        reade t0cobl set412;
        dow not %eof;
            y += 1;
            peVehi(x).cobs(y).xcob = t@xcob;
            peVehi(x).cobs(y).hecg = t@hecg;
            chain t@xcob set409;
            if %found;
               peVehi(x).cobs(y).desc = t@cobd;
            endif;
         reade t0cobl set412;
        enddo;
       endsr;

       begsr $cadena;
        REST_startArray( 'intermediarios' );
        for x = 1 to %elem(intermediarios);
        if intermediarios(x).nivc <> 0;
         REST_startArray( 'intermediario' );
          REST_writeXmlLine( 'nivel' : %char(intermediarios(x).nivt));
          REST_writeXmlLine( 'codigo': %char(intermediarios(x).nivc));
          REST_writeXmlLine( 'nombre': %trim(intermediarios(x).nomb));
         REST_endArray( 'intermediario' );
        endif;
        endfor;
        REST_endArray( 'intermediarios' );
       endsr;

       begsr $suplVeh;
        k1hed0.d0empr = peEmpr;
        k1hed0.d0sucu = peSucu;
        k1hed0.d0arcd = peArcd;
        k1hed0.d0spol = peSpol;
        setgt  %kds(k1hed0:4) pahed0;
        readpe %kds(k1hed0:4) pahed0;
        dow not %eof;
            vd = (d0fioa * 10000)
               + (d0fiom *   100)
               +  d0fiod;
            hf = (d0fhfa * 10000)
               + (d0fhfm *   100)
               +  d0fhfd;
            if (peFsin >= vd) and
               (peFsin <= hf);
               k1het0.t0empr = d0empr;
               k1het0.t0sucu = d0sucu;
               k1het0.t0arcd = d0arcd;
               k1het0.t0spol = d0spol;
               k1het0.t0sspo = d0sspo;
               k1het0.t0rama = d0rama;
               k1het0.t0oper = d0oper;
               k1het0.t0poco = peVehi(x).poco;
               k1het0.t0suop = d0suop;
               setll %kds(k1het0) pahet0;
               if %equal;
                  peVehi(x).sspo = d0sspo;
                  peVehi(x).suop = d0suop;
                  leavesr;
               endif;
            endif;

        readpe %kds(k1hed0:4) pahed0;
        enddo;
       endsr;

