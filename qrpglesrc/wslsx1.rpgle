     H option(*nodebugio:*noshowcpy:*srcstmt)
     H dftactgrp(*no) actgrp(*new)
      * ************************************************************ *
      * WSLSX1  : Tareas generales.                                  *
      *           WebService - Retorna Saldo Cta.Cte x Mayor         *
      *                        auxiliar.                             *
      * ------------------------------------------------------------ *
      * ACLARACION: Como WebService existía el WSLSXM que recibía a  *
      * qué fecha se quería el saldo.                                *
      * A pedido de Pablo Silvestre, en web sólo debe mostrarse el   *
      * saldo al último mes cerrado.                                 *
      * Este WebService se deja como wrapper de WSLSXM pero se encar-*
      * ga de buscar último mes cerrado y enviarlo a WSLSXM.         *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                               *02-Sep-2016  *
      * ------------------------------------------------------------ *
      * NWN - 13/10/2016 - Agregado de Archivos CNHSX1 - GNTMON      *
      * SGF - 22/03/2017 - Cambio SET301 por CNCEMP y rescato la fe- *
      *                    cha del último subdiario definitivo.      *
      *                                                              *
      * ************************************************************ *
     Fcncemp    if   e           k disk
     Fgntmon    if   e           k disk
     Fcnhsx1    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLSX1          pr                  ExtPgm('WSLSX1')
     D   peBase                            likeds(paramBase) const
     D   peComa                       2a   const
     D   peNrma                       7  0 const
     D   peFsal                       6  0
     D   peMone                       2a
     D   peNmol                      30a
     D   peNmoc                       5a
     D   peSald                      15  2
     D   peDeha                       1  0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLSX1          pi
     D   peBase                            likeds(paramBase) const
     D   peComa                       2a   const
     D   peNrma                       7  0 const
     D   peFsal                       6  0
     D   peMone                       2a
     D   peNmol                      30a
     D   peNmoc                       5a
     D   peSald                      15  2
     D   peDeha                       1  0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D SPLSTDAY        pr                  ExtPgm('SPLSTDAY')
     D  peFemm                        2  0 const
     D  peFema                        4  0 const
     D  peFemd                        2  0

     D peFemd          s              2  0
     D peFdes          s              8  0
     D peFhas          s              8  0

     D k1temp          ds                  likerec(c1cemp:*key)
     D k1hsx1          ds                  likerec(c1hsx1:*key)
     D k1tmon          ds                  likerec(g1tmon:*key)

      /free

       *inlr = *On;

       peFsal = 0;
       peMone = '00';
       peNmol = *blanks;
       peNmoc = *blanks;
       peSald = 0;
       peDeha = 0;
       peErro = 0;
       clear peMsgs;

       k1temp.emempr = peBase.peEmpr;
       chain %kds(k1temp) cncemp;
       if not %found;
          emusda = %subdt(%date():*y);
          emusdm = %subdt(%date():*m);
       endif;

       SPLSTDAY( emusdm : emusda: peFemd );
       peFhas = (emusda * 10000) + (emusdm * 100) + peFemd;
       peFdes = peFhas;
       peFsal = ( emusdm * 10000 ) + emusda;

       k1hsx1.x1empr = pebase.peEmpr;
       k1hsx1.x1sucu = pebase.peSucu;
       k1hsx1.x1coma = peComa;
       k1hsx1.x1nrma = peNrma;
       k1hsx1.x1ffaa = emusda;
       k1hsx1.x1ffmm = emusdm;
       k1hsx1.x1mone = peMone;
       chain %kds(k1hsx1) cnhsx1;
       if %found;
          eval peDeha = 1;
          if x1imau < 0;
          x1imau = x1imau * -1;
          eval peDeha = 2;
          endif;
          peSald = x1imau;
       endif;

       k1tmon.mocomo = peMone;
       chain %kds(k1tmon) gntmon;
       if %found;
       peNmol = moNmol;
       peNmoc = moNmoc;
       endif;
       return;

      /end-free
