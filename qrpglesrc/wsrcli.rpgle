     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRCLI: QUOM Versión 2                                       *
      *         Lista de asegurados por intermediario                *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *08-Ago-2017            *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      *   JSN 29/01/2019 - Nuevos tag <codigoDeBloqueo>              *
      *                               <fechaDeNacimiento>            *
      *   JSN 23/03/2021 - Se agrega Tipo de Persona 'C' = Consorcio *
      * ************************************************************ *
     Fgntnac    if   e           k disk
     Fgntloc    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D WSLCLI          pr                  ExtPgm('WSLCLI')
     D  peBase                             likeds(paramBase) const
     D  peCant                       10i 0 const
     D  peRoll                        1a   const
     D  peOrde                       10a   const
     D  pePosi                             likeds(keycli_t) const
     D  pePreg                             likeds(keycli_t)
     D  peUreg                             likeds(keycli_t)
     D  peLase                             likeds(pahase_t) dim(99)
     D  peLaseC                      10i 0
     D  peMase                             likeds(dsMail_t) dim(99)
     D  peMaseC                      10i 0
     D  peMore                        1n
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D asen            s              7a
     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D @@asen          s              7  0
     D peOrde          s             10a
     D @@fnac          s             10a

     D CRLF            c                   x'0d25'

     D peBase          ds                  likeds(paramBase)
     D pePosi          ds                  likeds(keycli_t)
     D pePreg          ds                  likeds(keycli_t)
     D peUreg          ds                  likeds(keycli_t)
     D peLase          ds                  likeds(pahase_t) dim(99)
     D peMase          ds                  likeds(dsMail_t) dim(99)
     D peMsgs          ds                  likeds(paramMsgs)
     D peRoll          s              1a
     D @@loca          s             50a
     D peMore          s              1n
     D peLaseC         s             10i 0
     D peMaseC         s             10i 0
     D peErro          s             10i 0
     D x               s             10i 0

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

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
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       nivt = REST_getNextPart(url);
       nivc = REST_getNextPart(url);
       nit1 = REST_getNextPart(url);
       niv1 = REST_getNextPart(url);
       if url <> *blanks;
          asen = REST_getNextPart(url);
        else;
          asen = '0000000';
       endif;

       monitor;
          @@asen = %dec(asen:7:0);
        on-error;
          @@asen = 0;
       endmon;

       if SVPREST_chkBase(empr:sucu:nivt:nivc:nit1:niv1:peMsgs) = *off;
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
       endif;

       clear peBase;
       clear pePosi;
       clear peUreg;
       clear pePreg;

       peRoll = 'I';
       peOrde = 'NOMBREASEG';
       if @@asen > 0;
          peOrde = 'CODIGOASEG';
          pePosi.asasen = @@asen;
       endif;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       REST_writeHeader();
       REST_writeEncoding();

       REST_writeXmlLine( 'asegurados' : '*BEG' );

       dou peMore = *off;
           WSLCLI( peBase
                 : 99
                 : peRoll
                 : peOrde
                 : pePosi
                 : pePreg
                 : peUreg
                 : peLase
                 : peLaseC
                 : peMase
                 : peMaseC
                 : peMore
                 : peErro
                 : peMsgs      );

           pePosi = peUreg;
           peRoll = 'F';

        if peErro = 0;
           for x = 1 to peLaseC;
            chain peLase(x).ascnac gntnac;
            if not %found;
               acdnac = *blanks;
            endif;
            @@loca = %trim(peLase(x).asproc)
                   + '-'
                   + %trim(%char(peLase(x).ascopo))
                   + '-'
                   + %editc(peLase(x).ascops:'X');
            REST_writeXmlLine('asegurado':'*BEG');
            REST_writeXmlLine('codigo':%char(peLase(x).asasen) );
            REST_writeXmlLine('nombre': peLase(x).asnomb);
            REST_writeXmlLine('tipoDeDocumento':%char(peLase(x).astido) );
            REST_writeXmlLine('numeroDeDocumento':%char(peLase(x).asnrdo));
            REST_writeXmlLine('cbuSiniestros':%char(peLase(x).ascbus) );
            REST_writeXmlLine('codigoEstadoCivil':%char(peLase(x).ascesc) );
            REST_writeXmlLine('estadoCivil':peLase(x).asdesc );
            REST_writeXmlLine('codigoDeIva':%char(peLase(x).asciva) );
            REST_writeXmlLine('descripcionIva':peLase(x).asncil);
            REST_writeXmlLine('codigoDeNacionalidad':%char(peLase(x).ascnac) );
            REST_writeXmlLine('nacionalidad':acdnac);
            REST_writeXmlLine('codigoPostal':%char(peLase(x).ascopo) );
            REST_writeXmlLine('localidad':@@loca);
            REST_writeXmlLine('sufijoCodigoPostal':%char(peLase(x).ascops) );
            REST_writeXmlLine('codigoDeProfesion':%char(peLase(x).ascprf) );
            REST_writeXmlLine('descripcionDeProfesion':peLase(x).asdprf );
            REST_writeXmlLine('cuil':%char(peLase(x).ascuil) );
            REST_writeXmlLine('cuit':peLase(x).ascuit );
            REST_writeXmlLine('domicilio':peLase(x).asdomi );
            REST_writeXmlLine('descripcionDeSexo':peLase(x).asdsex );
            REST_writeXmlLine('codigoDeSexo':%char(peLase(x).assexo) );
            REST_writeXmlLine('descripcionTipoSociedad':peLase(x).asdtis );
            REST_writeXmlLine('codigoTipoSociedad':%char(peLase(x).astiso));
            REST_writeXmlLine('codigoDeEmpresa':peLase(x).asempr );
            REST_writeXmlLine('ramaActividadEconomica':%trim(peLase(x).asdeae));
            select;
              when peLase(x).astiso = 80 or peLase(x).astiso = 81;
                REST_writeXmlLine('tipoDePersona': 'C');
              when peLase(x).astiso = 98;
                REST_writeXmlLine('tipoDePersona': 'F');
              other;
                REST_writeXmlLine('tipoDePersona': 'J');
            endsl;
            REST_writeXmlLine('codigoDeProvincia':%trim(peLase(x).asproc));
            REST_writeXmlLine('codigoDeBloqueo': peLase(x).asbloq);
            monitor;
              @@fnac = %char(%date(peLase(x).asfnac:*iso):*iso);
             on-error;
              @@fnac = '0001-01-01';
            endmon;
            REST_writeXmlLine('fechaDeNacimiento':%trim(@@fnac));
            chain (peLase(x).ascopo:peLase(x).ascops) gntloc;
            if %found;
               REST_writeXmlLine( 'zonaRiesgoAutos' : %editc(loscta:'X') );
             else;
               REST_writeXmlLine( 'zonaRiesgoAutos' : '0' );
            endif;
            REST_writeXmlLine('asegurado':'*END');
           endfor;
        endif;

       enddo;

       REST_writeXmlLine( 'asegurados' : '*END' );

       return;

