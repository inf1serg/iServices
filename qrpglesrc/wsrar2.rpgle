     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H*option(*srcstmt) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRAR2: QUOM Versión 2                                       *
      *         Elimina solicitud de arrepentimiento                 *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *04-Ago-2021            *
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

     D arrepentimiento_t...
     D                 ds                  qualified template
     D  empresa                       1a
     D  sucursal                      2a
     D  nivt                          1  0
     D  nivc                          5  0
     D  nit1                          1  0
     D  niv1                          5  0
     D  idTramite                    30a
     D  texto                       300a
     D  archivo                     300a

     D request         ds                  likeds(arrepentimiento_t)

     d buffer          s          65535a
     d rc              s               n
     d peValu          s           1024a
     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D nres            s             30a
     D obse            s            300a
     D varc            s            300a
     D options         s            100a

     D @@repl          s          65535a
     D url             s           3000a   varying
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

     D WSLOG           pr                  extpgm('QUOMDATA/WSLOG')
     D  peMsg                       512a   const

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
     D @@DsArC         s             10i 0
     D @@DsAgC         s             10i 0
     D @@Arcd          s              6  0
     D @@Spol          s              9  0
     D @@Rama          s              2  0
     D @@Arse          s              2  0
     D @@Oper          s              7  0
     D @@Poli          s              7  0
     D @@Endo          s              7  0
     D @@Esta          s              1    inz('4')
     D @@Nivt          s              1  0
     D @@Nivc          s              5  0
     D peVsys          s            512a

      * Estructuras ------------------------------------------------ *
     D @@DsAr          ds                  likeds( dsPahtan_t ) dim(999)
     D @@DsAg          ds                  likeds( dsPahag4_t ) dim(999)

      /free

       *inlr = *on;

        options = 'doc=string path=arrepentimiento +
                   case=any allowextra=yes allowmissing=yes';

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

        rc1= REST_readStdInput( %addr(buffer): %len(buffer) );

        monitor;
          xml-into request %xml(buffer : options);
        on-error;
          REST_writeHeader( 204
                          : *omit
                          : *omit
                          : 'RPG0000'
                          : 40
                          : 'Se encontro un error en el requerimiento'
                          : 'Comunicarse con SISTEMAS' );
          REST_end();
          SVPREST_end();
          return;
        endmon;

       empr = request.empresa;
       sucu = request.sucursal;
       nivt = %editc(request.nivt:'X');
       nivc = %editc(request.nivc:'X');
       nit1 = %editc(request.nit1:'X');
       niv1 = %editc(request.niv1:'X');
       nres = request.idTramite;
       obse = request.texto;
       varc = request.archivo;

       clear @@Arcd;
       clear @@Spol;
       clear @@Rama;
       clear @@Arse;
       clear @@Oper;
       clear @@Poli;
       clear @@Endo;

       @@Nivt = %dec(nivt:1:0);
       @@Nivc = %dec(nivc:5:0);

       if not SVPAGA_chkSolicitudXNres( empr
                                      : sucu
                                      : %trim(nres)
                                      : @@Arcd
                                      : @@Spol
                                      : @@Rama
                                      : @@Arse
                                      : @@Oper
                                      : @@Poli
                                      : @@Endo      );

         rc = REST_writeHeader( 204
                              : *omit
                              : *omit
                              : 'TAB0001'
                              : 40
                              : 'No se encontraron datos para actualizar'
                              : 'Verifique la informacion solicitada ') ;
         REST_end();
         return;
       endif;

       if SVPAGA_updEstatusPahag4( Empr
                                 : Sucu
                                 : @@Arcd
                                 : @@Spol
                                 : @@Rama
                                 : @@Arse
                                 : @@Oper
                                 : @@Poli
                                 : @@Endo
                                 : @@Esta );

         @@DsArC = 0;
         clear @@DsAr;
         if SVPAGA_getListaArrepentimiento( Empr
                                          : Sucu
                                          : @@Nivt
                                          : @@Nivc
                                          : @@Arcd
                                          : @@Spol
                                          : @@Rama
                                          : @@Arse
                                          : @@Oper
                                          : @@Poli
                                          : @@Endo
                                          : @@DsAr
                                          : @@DsArC );

           @@DsAr(@@DsArC).anMar0 = @@Esta;
           @@DsAr(@@DsArC).anObse = Obse;
           @@DsAr(@@DsArC).anArch = Varc;
           if SVPAGA_updPahtan( @@DsAr(@@DsArC) );
             //Armado de XML ...
             REST_writeHeader();
             REST_writeEncoding();
             REST_writeXmlLine( 'eliminarSolicitud' : '*BEG');
               REST_writeXmlLine( 'solicitud' : %trim(Nres) );
               REST_writeXmlLine( 'resultado' : 'OK' );
             REST_writeXmlLine( 'eliminarSolicitud' : '*END');
             REST_end();

             return;
           endif;
         endif;
       endif;

       //Armado de XML ...
       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'eliminarSolicitud' : '*BEG');
         REST_writeXmlLine( 'solicitud' : %trim(Nres) );
         REST_writeXmlLine( 'resultado' : 'ERROR' );
       REST_writeXmlLine( 'eliminarSolicitud' : '*END');

       REST_end();

       return;

