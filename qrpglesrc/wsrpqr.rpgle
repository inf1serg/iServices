     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRPQR: Solicitudes P/Q/R                                    *
      *         Retorna lista y envia por mail                       *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *04-Ago-2018            *
      * ************************************************************ *
     Fset64201  if   e           k disk    rename(s1t642:s1t64201)
     Fset642    uf   e           k disk
     Fset001    uf   e           k disk    prefix(t2:2)
     Fset6118   if   e           k disk    prefix(t1:2)
     Fmailconf  if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpint_h.rpgle'
      /copy './qcpybooks/mail_h.rpgle'

     D SPCADCOM        pr                  extpgm('SPCADCOM')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peCade                        5  0 dim(9)
     D  peErro                        1a
     D  peEpgm                        3a   const
     D  peNrdf                        7  0 dim(9) options(*nopass)

     D empr            s              1a
     D sucu            s              2a
     D tipo            s              1a
     D nres            s              7a

     D x               s             10i 0
     D y               s             10i 0

     D @@prod          ds                  qualified dim(9)
     D  nomb                         40a
     D  matr                          6  0
     D  nivc                          5  0

     D ramprt          s              2  0 dim(18) ctdata perrcd(18)
     D ramcon          s              2  0 dim(02) ctdata perrcd(02)

     D uri             s            512a
     D url             s           3000a   varying
     D peNres          s              7  0
     D @@cade          s              5  0 dim(9)
     D @@nrdf          s              7  0 dim(9)
     D @@erro          s              1a
     D @@base          s              1a
     D @@dbas          s             30a
     D directorio      ds                  likeds(DireEnt_t)
     D peInte          ds                  likeds( DsSehni2_t )
     D k1t611          ds                  likerec(s1t6118:*key)
     D k1t642          ds                  likerec(s1t642:*key)

     D peFile          s            128a

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

      /free

       *inlr = *on;

       if not REST_getUri( psds.this : uri );
          return;
       endif;
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       tipo = REST_getNextPart(url);
       nres = REST_getNextPart(url);

       monitor;
          peNres = %dec(nres:7:0);
        on-error;
          peNres = 0;
       endmon;

       read mailconf;

       if tipo = 'G';
          exsr $listar;
       endif;

       if tipo = 'U';
          exsr $enviar;
       endif;

       close *all;

       return;

       // -----------------------------------------------
       // Lista peticiones pendientes
       // -----------------------------------------------
       begsr $listar;
        REST_writeHeader();
        REST_writeEncoding();
        REST_startArray('peticiones');
        setll *loval set64201;
        read set64201;
        dow not %eof;
          exsr $datosInt;
          exsr $datosUsr;
          REST_startArray('peticion');
          exsr $datos;
          REST_writeXmlLine('numero':%trim(%char(t@nres)));
          if @@prod(1).nivc <> 0;
             REST_writeXmlLine('codProductor':%char(@@prod(1).nivc));
             REST_writeXmlLine('nomProductor':%trim(@@prod(1).nomb));
             REST_writeXmlLine('matProductor':%char(@@prod(1).matr));
          endif;
          if @@prod(3).nivc <> 0;
             REST_writeXmlLine('codOrganizad':%char(@@prod(3).nivc));
             REST_writeXmlLine('nomOrganizad':%trim(@@prod(3).nomb));
             REST_writeXmlLine('matOrganizad':%char(@@prod(3).matr));
          endif;
          if @@prod(5).nivc <> 0;
             REST_writeXmlLine('codProducto2':%char(@@prod(5).nivc));
             REST_writeXmlLine('nomProducto2':%trim(@@prod(5).nomb));
             REST_writeXmlLine('matProducto2':%char(@@prod(5).matr));
           else;
             REST_writeXmlLine('codProducto2':' ');
             REST_writeXmlLine('nomProducto2':' ');
             REST_writeXmlLine('matProducto2':' ');
          endif;
          REST_startArray('destinatarios');
          REST_startArray('destinatario');
          REST_writeXmlLine('nombre' : %trim(directorio.fuln) );
          REST_writeXmlLine( 'email'
                           : %trim(directorio.mail)
                           + '@'
                           + %trim(nfdomi)          );
          REST_endArray('destinatario');
          REST_endArray('destinatarios');
          REST_startArray('remitente');
          REST_writeXmlLine('nombre' : %trim(nfsysn) );
          REST_writeXmlLine( 'email'
                           : %trim(nfsysm)
                           + '@'
                           + %trim(nfdomi)          );
          REST_endArray('remitente');
          REST_endArray('peticion');
         read set64201;
        enddo;
        REST_endArray('peticiones');
       endsr;

       begsr $datosInt;
        clear @@prod;
        SPCADCOM( t@empr
                : t@sucu
                : t@nivt
                : t@nivc
                : @@cade
                : @@erro
                : *blanks
                : @@nrdf  );
        for x = 1 to 8;
         if @@cade(x) <> 0;
            @@prod(x).nivc = @@cade(x);
            if SVPINT_getIntermediario( t@empr
                                      : t@sucu
                                      : %dec(x:5:0)
                                      : @@prod(x).nivc
                                      : peInte         ) = 0;
               @@prod(x).matr = peInte.n2matr;
               @@prod(x).nomb = SVPINT_getNombre( t@empr
                                                : t@sucu
                                                : %dec(x:5:0)
                                                : @@prod(x).nivc );
            endif;
         endif;
        endfor;
       endsr;

       begsr $datos;
        REST_startArray( 'registros' );
        k1t611.t1empr = t@empr;
        k1t611.t1sucu = t@sucu;
        k1t611.t1nivt = t@nivt;
        k1t611.t1nivc = t@nivc;
        setll %kds(k1t611:4) set6118;
        reade %kds(k1t611:4) set6118;
        dow not %eof;

          REST_startArray( 'registro' );
          REST_writeXmlLine('rama' : %editc(t1rama:'X') );
          chain t1rama set001;
          REST_writeXmlLine('ramaDesc' : %trim(t2ramd) );

          if t2rame = 18 or t2rame = 21;
             REST_writeXmlLine('tipoRama' : 'V' );
           else;
             REST_writeXmlLine('tipoRama' : 'P' );
          endif;

          REST_writeXmlLine('extraPrimaVar':SVPREST_editImporte(t1xrea));
          REST_writeXmlLine('recargoFinanc':SVPREST_editImporte(t1xref));
          REST_writeXmlLine('extraPrimaFij':SVPREST_editImporte(t1dere));
          REST_writeXmlLine('codigoExPaFij':%trim(t1marp)              );
          REST_writeXmlLine('condiciEspRec':%trim(t1mar1)              );
          REST_writeXmlLine('bonifSobPrima':SVPREST_editImporte(t1bpip));
          REST_writeXmlLine('codigoPlanPag':%editc(t1nrpp:'X')         );

          REST_writeXmlLine('formaAcre1'   : t1fac1                    );
          REST_writeXmlLine('formaAcre2'   : t1fac2                    );
          REST_writeXmlLine('formaAcre3'   : t1fac3                    );
          REST_writeXmlLine('formaAcre4'   : t1fac4                    );
          REST_writeXmlLine('formaAcre5'   : t1fac5                    );
          REST_writeXmlLine('formaAcre6'   : t1fac6                    );
          REST_writeXmlLine('formaAcre7'   : t1fac7                    );
          REST_writeXmlLine('formaAcre8'   : t1fac8                    );
          REST_writeXmlLine('formaAcre9'   : t1fac9                    );

          @@base = t1bas1;
          exsr $base;
          REST_writeXmlLine('comisionProd' :SVPREST_editImporte(t1xopr));
          REST_writeXmlLine('baseComiProd' :%trim(@@dbas)              );
          REST_writeXmlLine('prodNivel1'   :SVPREST_editImporte(t1pdn1));
          REST_writeXmlLine('prodNivel2'   :SVPREST_editImporte(t1pdn2));
          REST_writeXmlLine('prodNivel3'   :SVPREST_editImporte(t1pdn3));
          REST_writeXmlLine('prodNivel4'   :SVPREST_editImporte(t1pdn4));
          REST_writeXmlLine('prodNivel5'   :SVPREST_editImporte(t1pdn5));
          REST_writeXmlLine('prodNivel6'   :SVPREST_editImporte(t1pdn6));
          REST_writeXmlLine('prodNivel7'   :SVPREST_editImporte(t1pdn7));
          REST_writeXmlLine('prodNivel8'   :SVPREST_editImporte(t1pdn8));
          REST_writeXmlLine('prodNivel9'   :SVPREST_editImporte(t1pdn9));

          @@base = t1bas2;
          exsr $base;
          REST_writeXmlLine('comisionCobr' :SVPREST_editImporte(t1xcco));
          REST_writeXmlLine('baseComiCobr' :%trim(@@dbas)              );
          REST_writeXmlLine('cobrNivel1'   :SVPREST_editImporte(t1pdc1));
          REST_writeXmlLine('cobrNivel2'   :SVPREST_editImporte(t1pdc2));
          REST_writeXmlLine('cobrNivel3'   :SVPREST_editImporte(t1pdc3));
          REST_writeXmlLine('cobrNivel4'   :SVPREST_editImporte(t1pdc4));
          REST_writeXmlLine('cobrNivel5'   :SVPREST_editImporte(t1pdc5));
          REST_writeXmlLine('cobrNivel6'   :SVPREST_editImporte(t1pdc6));
          REST_writeXmlLine('cobrNivel7'   :SVPREST_editImporte(t1pdc7));
          REST_writeXmlLine('cobrNivel8'   :SVPREST_editImporte(t1pdc8));
          REST_writeXmlLine('cobrNivel9'   :SVPREST_editImporte(t1pdc9));

          @@base = t1bas3;
          exsr $base;
          REST_writeXmlLine('comisionFom1' :SVPREST_editImporte(t1xfno));
          REST_writeXmlLine('baseComiFom1' :%trim(@@dbas)              );
          REST_writeXmlLine('fom1Nivel1'   :SVPREST_editImporte(t1pdf1));
          REST_writeXmlLine('fom1Nivel2'   :SVPREST_editImporte(t1pdf2));
          REST_writeXmlLine('fom1Nivel3'   :SVPREST_editImporte(t1pdf3));
          REST_writeXmlLine('fom1Nivel4'   :SVPREST_editImporte(t1pdf4));
          REST_writeXmlLine('fom1Nivel5'   :SVPREST_editImporte(t1pdf5));
          REST_writeXmlLine('fom1Nivel6'   :SVPREST_editImporte(t1pdf6));
          REST_writeXmlLine('fom1Nivel7'   :SVPREST_editImporte(t1pdf7));
          REST_writeXmlLine('fom1Nivel8'   :SVPREST_editImporte(t1pdf8));
          REST_writeXmlLine('fom1Nivel9'   :SVPREST_editImporte(t1pdf9));

          @@base = t1bas4;
          exsr $base;
          REST_writeXmlLine('comisionFom2' :SVPREST_editImporte(t1xfnn));
          REST_writeXmlLine('baseComiFom2' :%trim(@@dbas)              );
          REST_writeXmlLine('fom2Nivel1'   :SVPREST_editImporte(t1pdg1));
          REST_writeXmlLine('fom2Nivel2'   :SVPREST_editImporte(t1pdg2));
          REST_writeXmlLine('fom2Nivel3'   :SVPREST_editImporte(t1pdg3));
          REST_writeXmlLine('fom2Nivel4'   :SVPREST_editImporte(t1pdg4));
          REST_writeXmlLine('fom2Nivel5'   :SVPREST_editImporte(t1pdg5));
          REST_writeXmlLine('fom2Nivel6'   :SVPREST_editImporte(t1pdg6));
          REST_writeXmlLine('fom2Nivel7'   :SVPREST_editImporte(t1pdg7));
          REST_writeXmlLine('fom2Nivel8'   :SVPREST_editImporte(t1pdg8));
          REST_writeXmlLine('fom2Nivel9'   :SVPREST_editImporte(t1pdg9));

          if %lookup(t1rama:ramprt) <> 0;
             REST_writeXmlLine('seImprime' : 'S' );
           else;
             REST_writeXmlLine('seImprime' : 'N' );
          endif;
          if %lookup(t1rama:ramcon) <> 0;
             REST_writeXmlLine('consultar' : 'S' );
           else;
             REST_writeXmlLine('consultar' : 'N' );
          endif;

          REST_endArray( 'registro' );
         reade %kds(k1t611:4) set6118;
        enddo;
        REST_endArray( 'registros' );
       endsr;

       begsr $base;
        select;
         when @@base = ' ';
              @@dbas = '  NO CALCULA';
         when @@base = '1';
              @@dbas = '1 PRIMA';
         when @@base = '2';
              @@dbas = '2 PREMIO';
         when @@base = '3';
              @@dbas = '3 DER.EMISION';
         when @@base = '4';
              @@dbas = '4 SUMA ASEGURADA';
         when @@base = '5';
              @@dbas = '5 IMPORTE FIJO';
         when @@base = '6';
              @@dbas = '6 PRI+REC.ADM';
         when @@base = '7';
              @@dbas = '7 PRI+ADM+FIN';
         when @@base = '8';
              @@dbas = '8 PRI+ADM+FIN+DER';
         when @@base = '9';
              @@dbas = '9 REC.ADMINISTRA';
         when @@base = 'A';
              @@dbas = 'A REC.FINANCIERO';
         when @@base = 'B';
              @@dbas = 'B PRI+REC.FIN';
         when @@base = 'C';
              @@dbas = 'C REC.ADM+REC.FIN';
        endsl;
       endsr;

       begsr $enviar;
        k1t642.t@empr = empr;
        k1t642.t@sucu = sucu;
        k1t642.t@nres = peNres;
        chain %kds(k1t642:3) set642;
        if %found;
           t@mar1 = '9';
           update s1t642;
        endif;
        REST_writeHeader();
        REST_writeEncoding();
        REST_writeXmlLine('result':'OK');
       endsr;

       begsr $mail;
       endsr;

       begsr $datosUsr;
        directorio = MAIL_getDire(t@user);
       endsr;

      /end-free
**
010305060809121516171826272823808189
**
8081
