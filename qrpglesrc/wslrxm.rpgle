     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLRXM  : Tareas generales.                                  *
      *           WebService - ret.efect. a M.Auxiliar x fech        *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                            *30-Abr-2015  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * INF1NORBER 04/06/2015 - Se modifica paginado y parms.        *
      * SFA 17/07/2015 - Se modifica logica sobre peMore             *
      * SFA 02/08/2016 - Se modifica logica de paginado              *
      * NWN 14/11/2016 - Agregado de Nombre de Documento para        *
      *                  Certificados de Retención.                  *
      * NWN 29/03/2017 - Controla que exista en nombre de archivo    *
      *                  para generar el Documento/PDF. (DIPATH)     *
      * SGF 04/05/2017 - Cuando el certificado no está numerado el   *
      *                  ícono para el documento no se debe mostrar. *
      *                  Se mueve una leyenda precedida por # para   *
      *                  que la web muestre un mensaje en la columna *
      *                  donde debería ir el ícono.                  *
      *                  Todo lo que siga al # se muestra como leyen-*
      *                  da.                                         *
      * LRG 24/05/2017 - Cuando no se encuentra el Documento se      *
      *                  devuelve un mensaje.-                       *
      *                                                              *
      * ************************************************************ *
     Fcnhret97  if   e           k disk
     Fcntnau    if   e           k disk
     Fgntdim    if   e           k disk
     Fgntpro01  if   e           k disk
     Fcnhre101  if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/spvfec_h.rpgle'

     D WSLRXM          pr                  ExtPgm('WSLRXM')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keyrxm_t) const
     D   pePreg                            likeds(keyrxm_t)
     D   peUreg                            likeds(keyrxm_t)
     D   peLret                            likeds(cnhret97_t) dim(99)
     D   peLretC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLRXM          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keyrxm_t) const
     D   pePreg                            likeds(keyrxm_t)
     D   peUreg                            likeds(keyrxm_t)
     D   peLret                            likeds(cnhret97_t) dim(99)
     D   peLretC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khret97         ds                  likerec(c1hret:*key)
     D k1hre1          ds                  likerec(c1hre1:*key)

     D ktnau           ds                  likerec(c1tnau:*key)

     D retencion       ds                  likerec(c1hret)

     D                 ds
     D ffamd                          8s 0
     D   ffaa                         4s 0 overlay(ffamd:1)
     D   ffmm                         2s 0 overlay(ffamd:*next)
     D   ffdd                         2s 0 overlay(ffamd:*next)

     D                 ds
     D pfamd                          8s 0
     D   pfaa                         4s 0 overlay(pfamd:1)
     D   pfmm                         2s 0 overlay(pfamd:*next)
     D   pfdd                         2s 0 overlay(pfamd:*next)

     D wfdes           s              8  0
     D wfhas           s              8  0

     D @@cant          s             10i 0
     D respue          s          65536
     D longm           s             10i 0
     D @@more          s               n

     D finArc          pr              n

       *inLr = *On;

       peLretC = *Zeros;
       peMore = *on;
       @@more = *off;
       peErro = *Zeros;

       clear peLret;
       clear peMsgs;
       clear retencion;

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

      *- Valido Parametro Forma de Paginado
       if not SVPWS_chkRoll ( peRoll : peMsgs );
         peErro = -1;
         return;
       endif;

      *- Valido Cantidad de Lineas a Retornar
       @@cant = peCant;
       if ( ( peCant <= *Zeros ) or ( peCant > 99 ) );
         @@cant = 99;
       endif;

      *- Valido Exista Cuenta
       ktnau.naempr = pebase.peEmpr;
       ktnau.nasucu = pebase.peSucu;
       ktnau.nacoma = pePosi.rtComa;
       ktnau.nanrma = pePosi.rtNrma;

       chain %kds (ktnau:4) cntnau;

       if not %found( cntnau );

          respue =  pePosi.rtcoma    +
                    %editC(pePosi.rtnrma:'4':*ASTFILL);
          longm  = 9 ;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'MAY0001' :
                          peMsgs : respue  : longm );
         peErro = -1;
         return;

       endif;

       wfdes = %dec(pePosi.rtfdes:*iso);
       wfhas = %dec(pePosi.rtfhas:*iso);

      *- Valido Fecha Desde Logica
       if not SPVFEC_FechaValida8( wfdes );

          respue = *blank;
          longm  = *Zeros;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'GEN0001' :
                          peMsgs : respue  : longm );
          peErro = -1;
          return;

       endif;

      *- Valido Fecha Hasta Logica
       if not SPVFEC_FechaValida8( wfhas );

          respue = *blank;
          longm  = *Zeros;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'GEN0002' :
                          peMsgs : respue  : longm );
          peErro = -1;
          return;

       endif;

      *- Valido Fecha Hasta no menor a Fecha Desde
       if wfdes > wfhas;

          respue = *blank;
          longm  = *Zeros;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'GEN0003' :
                          peMsgs : respue  : longm );
          peErro = -1;
          return;

       endif;

      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       exsr leeArc;

       if not finArc;
         exsr priReg;
       endif;

       dow ( ( not finArc ) and ( peLretC < @@cant ) and (ffamd <= wfhas) );

           k1hre1.r1empr = retencion.rtempr;
           k1hre1.r1sucu = retencion.rtsucu;
           k1hre1.r1tiic = retencion.rttiic;
           k1hre1.r1fepa = retencion.rtfepa;
           k1hre1.r1fepm = retencion.rtfepm;
           k1hre1.r1coma = retencion.rtcoma;
           k1hre1.r1nrma = retencion.rtnrma;
           k1hre1.r1rpro = retencion.rtrpro;
           k1hre1.r1ivse = retencion.rtivse;
           setll %kds(k1hre1) cnhre101;
           if not %equal;

           peLretC += 1;

           peLret(peLretC).rttiic = retencion.rttiic;
           clear ditiid;
           chain (retencion.rttiic) gntdim;
           peLret(peLretC).rttiid = ditiid;
           peLret(peLretC).rtrpro = retencion.rtrpro;
           clear prprod;
           chain (retencion.rtrpro) gntpro01;
           peLret(peLretC).rtprod = prprod;
           peLret(peLretC).rtbmis = retencion.rtbmis;
           peLret(peLretC).rtiiau = retencion.rtiiau;
           peLret(peLretC).rtirau = retencion.rtirau;
           peLret(peLretC).rtpoim = retencion.rtpoim;
           peLret(peLretC).rtpacp = retencion.rtpacp;
           peLret(peLretC).rtnrrf = retencion.rtnrrf;
           peLret(peLretC).rtfret = %date(ffamd:*iso);
           peLret(peLretC).rtivse = retencion.rtivse;
           if dipath = *blanks;
              peLret(pelretC).rtndoc = '#Retención sin certificado';
           else;
           peLret(pelretC).rtndoc  = 'Certificado' +
                                   '_' + %trim(retencion.rttiic) +
                                   '_' + %trim(retencion.rtempr) +
                                   '_' + %trim(retencion.rtsucu) +
                                   '_' + %trim(retencion.rtcoma) +
                                   '_' + %trim(%editc(retencion.rtnrma:'X')) +
                                   '_' + %trim(%editc(retencion.rtrpro:'X')) +
                                   '_' + %trim(%editc(retencion.rttico:'X')) +
                                   '_' + %trim(%editc(retencion.rtnras:'X')) +
                                   '_' + %trim(%editc(retencion.rtpacp:'X')) +
                                   '_' + %trim(%editc(retencion.rtfepa:'X')) +
                                   '_' + %trim(%editc(retencion.rtfepm:'X')) +
                                   '_' + %trim(%editc(retencion.rtfepd:'X')) +
                                   '_' + %trim(%editc(retencion.rtnrrf:'X')) +
                                   '.pdf' ;
              if retencion.rtpacp <= 0;
                 peLret(pelretC).rtndoc = '#Aún no disponible';
              endif;
           endif;

           exsr UltReg;

           endif;

           exsr leeArc;

       enddo;

       if ( peRoll = 'R' );
         peMore = @@more;
       else;
         select;
         when ( ffamd = *Zeros ) or %eof ( cnhret97 );
           peMore = *Off;
         when not %eof ( cnhret97 ) and ffamd <= wfhas;
           peMore = *On;
         when not %eof ( cnhret97 ) and ffamd > wfhas;
           peMore = *Off;
         endsl;
       endif;

       if peLretC = *Zeros;
         clear pePreg;
         clear peUreg;
       endif;

       return;

      *- Rutina de Posicionamiento de Archivo. Segun pePosi, peRoll
       begsr posArc;

       khret97.rtempr = peBase.peEmpr;
       khret97.rtsucu = peBase.peSucu;
       khret97.rtcoma = pePosi.rtcoma;
       khret97.rtnrma = pePosi.rtnrma;
       pfamd = wfdes;
       khret97.rtfepa = pfaa;
       khret97.rtfepm = pfmm;
       khret97.rtfepd = pfdd;
       khret97.rttiic = pePosi.rttiic;
       khret97.rtrpro = pePosi.rtrpro;
       khret97.rtivse = pePosi.rtivse;


       if ( peRoll = 'F' );
          setgt %kds ( khret97 : 9 ) cnhret97;
       else;
          setll %kds ( khret97 : 9 ) cnhret97;
          if not %equal;
             peMore = *off;
          endif;
       endif;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

       clear retencion;

       dow (retencion.rtiiau <= *zero or retencion.rtirau <= *zero)
          and not finArc;

          reade %kds ( khret97: 4 ) cnhret97 retencion;

       enddo;

       ffaa = retencion.rtfepa;
       ffmm = retencion.rtfepm;
       ffdd = retencion.rtfepd;

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;

       clear retencion.rtiiau;
       clear retencion.rtirau;

       dow (retencion.rtiiau <= *zero or retencion.rtirau <= *zero)
          and not finArc;

          readpe %kds ( khret97: 4 ) cnhret97 retencion;

       enddo;

       ffaa = retencion.rtfepa;
       ffmm = retencion.rtfepm;
       ffdd = retencion.rtfepd;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

       setll %kds ( khret97 : 4 ) cnhret97;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr retPag;

       if ( peRoll = 'R' );
         exsr retArc;
         dow ( ( not finArc ) and ( @@cant > 0 ) and (ffamd >= wfdes) );
           @@cant -= 1;
           exsr retArc;
         enddo;
         if finArc;
           @@more = *Off;
           exsr priArc;
         endif;
         @@cant = peCant;
         if (@@cant <= 0 or @@cant > 99);
            @@cant = 99;
         endif;
       endif;

       endsr;

      *- Rutina que graba el Primer Registro
       begsr priReg;
           pePreg.rtcoma = retencion.rtcoma;
           pePreg.rtnrma = retencion.rtnrma;
           pePreg.rtfdes = %date( (retencion.rtfepa * 10000)
                                + (retencion.rtfepm *   100)
                                +  retencion.rtfepd
                                : *iso            );
           pePreg.rtfhas = %date( wfhas : *iso );
           pePreg.rttiic = retencion.rttiic;
           pePreg.rtrpro = retencion.rtrpro;
           pePreg.rtivse = retencion.rtivse;
       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

        if peLretC > 0;
           peUreg.rtcoma = retencion.rtcoma;
           peUreg.rtnrma = retencion.rtnrma;
           peUreg.rttiic = retencion.rttiic;
           peUreg.rtrpro = retencion.rtrpro;
           peUreg.rtivse = retencion.rtivse;
           peUreg.rtfdes = %date( (retencion.rtfepa * 10000)
                                + (retencion.rtfepm *   100)
                                +  retencion.rtfepd
                                : *iso            );
           peUreg.rtfhas = %date( wfhas : *iso );
        endif;

       endsr;

      *- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

       return %eof ( cnhret97 );

     P finArc          E
