     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H*option(*srcstmt) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRARR: QUOM Versión 2                                       *
      *         Lista de arrepentimientos                            *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *02-Ago-2021            *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/svpart_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpweb_h.rpgle'
      /copy './qcpybooks/svpase_h.rpgle'
      /copy './qcpybooks/svpaga_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a

     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n
     D rc1             s             10i 0

     D CRLF            c                   x'0d25'

     D peMsgs          ds                  likeds(paramMsgs)
     D peDsWb          ds                  likeds( dsParamWeb_t )
     D peErro          s             10i 0
     D x               s             10i 0
     D i               s             10i 0

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)
     D   JobName                     10a   overlay(PsDs:244)
     D   JobUser                     10a   overlay(PsDs:254)
     D   JobNbr                       6  0 overlay(PsDs:264)

     d WSLOG           pr                  extpgm('QUOMDATA/WSLOG')
     d  msg                         512a   const
     d  peMsg          s            512a

     d sleep           pr            10u 0 extproc('sleep')
     d  secs                         10u 0 value

     DPAR310X3         pr                  extpgm('PAR310X3')
     D                                1a   const
     D                                4  0
     D                                2  0
     D                                2  0
      * ------------------------------------------------------------ *
     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')
      * Variables -------------------------------------------------- *
     D @@Nivt          s              1  0
     D @@Nivc          s              5  0
     D @@Nrdf          s              7  0
     D @@Nomb          s             40a
     D @@Ftra          s             10a
     D @@DsArC         s             10i 0
     D @@List          s              1a
     D @@dd            s              2  0
     D @@mm            s              2  0
     D @@aa            s              4  0
     D @@Fech          s              8  0
     D @@Fec1          s              8  0
     D @@Date          s               d
     D @@Actu          s              1a
     D @@Dsta          s             10a
     D peVsys          s            512a

      * Estructuras ------------------------------------------------ *
     D @@DsAr          ds                  likeds( dsPahtan_t ) dim(999)

      /free

       *inlr = *on;

        //peMsg = PsDs.JobName;
        //WSLOG( peMsg );
        //peMsg = PsDs.JobUser;
        //WSLOG( peMsg );
        //peMsg = %editc(PsDs.JobNbr:'X');
        //WSLOG( peMsg  );
        //sleep(60);

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
         REST_writeHeader( 204
                         : *omit
                         : *omit
                         : 'RPG0001'
                         : 40
                         : 'Error al parsear URL'
                         : 'Error al parsear URL' );
         REST_end();
         return;
       endif;
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       nivt = REST_getNextPart(url);
       nivc = REST_getNextPart(url);
       nit1 = REST_getNextPart(url);
       niv1 = REST_getNextPart(url);

       if not rc;
         rc = REST_writeHeader( 204
                          : *omit
                          : *omit
                          : 'TAB0001'
                          : 40
                          : 'No se encontraron datos para informar'
                          : 'Verifique la informacion solicitada ') ;
         REST_end();
         return;
       endif;

       @@Nivt = %dec(nivt:1:0);
       @@Nivc = %dec(nivc:5:0);

       if SVPVLS_getValSys( 'HLISTAARRE' : *omit : peVsys );
         @@List = %trim(peVsys);
       endif;

       // Obtener lista de arrepentimiento total o por las ultimas 72hrs...

       @@DsArC = 0;
       clear @@DsAr;
       if @@List = 'L';
         if SVPAGA_getListaArrep72hrsXProd( empr
                                          : sucu
                                          : @@Nivt
                                          : @@Nivc
                                          : @@DsAr
                                          : @@DsArC );
         endif;
       else;
         if SVPAGA_getListaArrepXProductor( empr
                                          : sucu
                                          : @@Nivt
                                          : @@Nivc
                                          : @@DsAr
                                          : @@DsArC );
         endif;
       endif;

       //Armado de XML ...
       REST_writeHeader();
       REST_writeEncoding();
       REST_startArray( 'solicitudes' );
       for x = 1 to @@DsArC;
         @@Nrdf = SPVSPO_getAsen( empr
                                : sucu
                                : @@DsAr(x).anArcd
                                : @@DsAr(x).anSpol
                                : *omit            );

         clear @@Nomb;
         @@Nomb = SVPASE_getNombre( @@Nrdf );

         monitor;
           @@Ftra = %char(%date(%char(@@DsAr(x).anFec1): *iso0));
          on-error;
           @@Ftra = '0001-01-01';
         endmon;

           if @@List = 'L';
             @@Dsta = 'PENDIENTE';
             @@Actu = 'S';
           else;
             PAR310X3 ( Empr : @@aa : @@mm : @@dd );
             @@Fech = (@@aa * 10000) + (@@mm * 100) + @@dd;
             @@Date = %date(@@Fech) - %days(3);
             @@Fec1 = %dec(@@Date);

             if @@DsAr(x).anMar0 = '0' and ( @@DsAr(x).anFec1 >= @@Fec1 and
                @@DsAr(x).anFec1 <= @@Fech );
               @@Dsta = 'PENDIENTE';
               @@Actu = 'S';
             else;
               @@Dsta = 'CERRADO';
               @@Actu = 'N';
             endif;
           endif;


           REST_startArray( 'solicitud' );
             REST_writeXmlLine('articulo' : %char(@@DsAr(x).anArcd));
             REST_writeXmlLine('superpoliza' : %char( @@DsAr(x).anSpol));
             REST_writeXmlLine('rama' : %char(@@DsAr(x).anRama));
             REST_writeXmlLine('poliza' : %char(@@DsAr(x).anPoli));
             REST_writeXmlLine('asegurado' : %trim(@@Nomb));
             REST_writeXmlLine('idTramite' : %trim(@@DsAr(x).anNres));
             REST_writeXmlLine('fechaTramite' : @@Ftra );
             REST_writeXmlLine('estado' : %trim(@@Dsta));
             REST_writeXmlLine('permiteActualizar' : @@Actu );
           REST_endArray('solicitud');
       endfor;
       REST_endArray('solicitudes');

       REST_end();

       return;

