     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRPOL: QUOM Versión 2                                       *
      *         Lista de pólizas por intermediario                   *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *26-May-2017            *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * JSN 28/02/2019 - Recompilacion por cambio en la estructura   *
      *                  PAHASE_T                                    *
      * SPV 24/09/2020 - incorpora copy a wsstruc_h actualizado        *
      *                                                              *
      * ************************************************************ *
     Fgnhdaf    if   e           k disk
     Fgnttdo    if   e           k disk
     Fgntnac    if   e           k disk
     Fgnhda1    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'

     D WSLPOL          pr                  ExtPgm('WSLPOL')
     D  peBase                             likeds(paramBase) const
     D  peCant                       10i 0 const
     D  peRoll                        1a   const
     D  peOrde                       10a   const
     D  pePosi                             likeds(keypol_t) const
     D  pePreg                             likeds(keypol_t)
     D  peUreg                             likeds(keypol_t)
     D  peLpol                             likeds(pahpol_t) dim(99)
     D  peLpolC                      10i 0
     D  peMore                         n
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D WSLASE          pr                  ExtPgm('WSLASE')
     D   peBase                            likeds(paramBase) const
     D   peAsen                       7  0 const
     D   peDase                            likeds(pahase_t)
     D   peMase                            likeds(dsMail_t) dim(100)
     D   peMaseC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLNAV          pr                  ExtPgm('WSLNAV')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keynav_t) const
     D   pePreg                            likeds(keynav_t)
     D   peUreg                            likeds(keynav_t)
     D   peNasv                            likeds(pahvid0_t) dim(99)
     D   peNasvC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLRCA          pr                  ExtPgm('WSLRCA')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peLryc                            likeds(pahvid1_t) dim(30)
     D   peLrycC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D rama            s              2a
     D poli            s              7a
     D arcd            s              6a
     D spol            s              9a
     D @@datd          s             20a
     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n
     D @@nrdo          s             11  0
     D rc2             s             10i 0
     D @@fhas          s             10a
     D @@fnac          s             10a
     D @@mail          s             50a
     D peMore          s              1n
     D fecha           s              8  0
     D fnacVida        s             10a
     D fingVida        s             10a
     D fegrVida        s             10a
     D suasVida        s             30a
     D nrdoVida        s             20a
     D @@tipe          s              1a

     D pePosi          ds                  likeds(keypol_t)
     D pePreg          ds                  likeds(keypol_t)
     D peUreg          ds                  likeds(keypol_t)
     D peLpol          ds                  likeds(pahpol_t) dim(99)
     D peLpolC         s             10i 0
     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0
     D peDase          ds                  likeds(pahase_t)
     D peMase          ds                  likeds(dsMail_t) dim(100)
     D peMaseC         s             10i 0
     D nasvPosi        ds                  likeds(keynav_t)
     D nasvPreg        ds                  likeds(keynav_t)
     D nasvUreg        ds                  likeds(keynav_t)
     D peNasv          ds                  likeds(pahvid0_t) dim(99)
     D peNasvC         s             10i 0
     D s               s             10i 0
     D r               s             10i 0
     D peRoll          s              1a
     D muerte          s             30a
     D suasInva        s             30a
     D suasFrac        s             30a
     D suasAsis        s             30a
     D suasRent        s             30a
     D peLryc          ds                  likeds(pahvid1_t) dim(30)
     D peLrycC         s             10i 0

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
       rama = REST_getNextPart(url);
       poli = REST_getNextPart(url);
       arcd = REST_getNextPart(url);
       spol = REST_getNextPart(url);

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
          close *all;
          return;
       endif;

       clear peBase;
       clear pePosi;
       clear pePreg;
       clear peUreg;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       pePosi.porama = %dec(rama:2:0);
       pePosi.popoli = %dec(poli:7:0);

       COWLOG_logcon('WSRABN':peBase);

       WSLPOL( peBase
             : 1
             : 'I'
             : 'RAMAPOLIZA'
             : pePosi
             : pePreg
             : peUreg
             : peLpol
             : peLpolC
             : peMore
             : peErro
             : peMsgs    );

       if peErro = -1;
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          close *all;
          return;
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       chain peLpol(1).poasen gnhdaf;
       if not %found;
          dfnomb = *blanks;
          dftido = 0;
          dfnrdo = 0;
          dfcuit = *all'0';
          dfnjub = 0;
          dftiso = 0;
          dfdomi = *blanks;
       endif;

       chain peLpol(1).poasen gnhda1;
       if not %found;
          acdnac = *blanks;
        else;
          chain dfcnac gntnac;
          if not %found;
             acdnac = *blanks;
          endif;
       endif;

       clear peDase;
       clear peMase;
       peMaseC = 0;
       WSLASE( peBase
             : peLpol(1).poasen
             : peDase
             : peMase
             : peMaseC
             : peErro
             : peMsgs   );

       if peErro = -1;
          clear peDase;
          clear peMase;
          peMaseC = 0;
       endif;
       monitor;
         @@fnac = %char(%date(peDase.asfnac:*iso):*iso);
        on-error;
         @@fnac = *blanks;
       endmon;

       @@mail = *blanks;
       if peMaseC > 0;
          @@mail = peMase(1).mail;
       endif;

       @@datd = *blanks;
       @@nrdo = 0;
       select;
        when dftiso = 98;
             chain dftido gnttdo;
             if not %found;
                gndatd = *blanks;
             endif;
             @@datd = gndatd;
             if dfnrdo > 0;
                @@nrdo = dfnrdo;
              else;
                if dfcuit <> *all'0' and dfcuit <> *blanks;
                   monitor;
                     @@nrdo = %dec(dfcuit:11:0);
                    on-error;
                     @@nrdo = 0;
                     @@datd = *blanks;
                   endmon;
                 else;
                     @@nrdo = dfnjub;
                endif;
             endif;
         other;
             if dfcuit <> *all'0' and dfcuit <> *blanks;
                @@datd = 'CUIT';
                monitor;
                  @@nrdo = %dec(dfcuit:11:0);
                 on-error;
                  @@datd = *blanks;
                  @@nrdo = *zeros;
                endmon;
             endif;
       endsl;

       @@fhas = %char(peLpol(1).pofhas:*iso);

       REST_writeXmlLine('polizas':'*BEG' );
       REST_writeXmlLine('poliza':'*BEG' );
       REST_writeXmlLine('nroPoliza':%trim(poli));
       REST_writeXmlLine('nombreAsegurado':%trim(dfnomb));
       REST_writeXmlLine('nacionalidadAsegurado':%trim(acdnac));
       REST_writeXmlLine('domicilioAsegurado':%trim(dfdomi));
       REST_writeXmlLine('tipoDocAsegurado':%trim(@@datd));
       REST_writeXmlLine('numeroDocAsegurado':%trim(%char(@@nrdo)));
       REST_writeXmlLine('fechaNacimiento':%trim(@@fnac));
       REST_writeXmlLine('provincia':peDase.asprod);
       REST_writeXmlLine('codigoCondicionIva':%char(peDase.astiso));
       REST_writeXmlLine('condicionIva':peDase.asncil);
       REST_writeXmlLine('telefono':peDase.astel2);
       REST_writeXmlLine('localidad':peDase.asloca);
       REST_writeXmlLine('codigoPostal': %char(peDase.ascopo) );
       if peDase.astiso = 98;
          @@tipe = 'F';
        else;
          @@tipe = 'J';
       endif;
       REST_writeXmlLine('tipoPersona':%trim(@@tipe));
       REST_writeXmlLine('mail':@@mail);
       REST_writeXmlLine('fechaVigHast':@@fhas);
       clear nasvPosi;
       clear nasvPreg;
       clear nasvUreg;
       clear peNasv;
       peNasvC = 0;
       peRoll = 'I';
       nasvPosi.v0rama = %dec(rama:2:0);
       nasvPosi.v0poli = %dec(poli:7:0);
       nasvPosi.v0spol = %dec(spol:9:0);
       REST_writeXmlLine('bienesPoliza' : '*BEG');
       dou peMore = *off;
           WSLNAV( peBase
                 : 99
                 : peRoll
                 : nasvPosi
                 : nasvPreg
                 : nasvUreg
                 : peNasv
                 : peNasvC
                 : peMore
                 : peErro
                 : peMsgs   );

           if peErro = 0;
              for s = 1 to peNasvC;
               nrdoVida = %trim(%char(peNasv(s).vdnrdo));
               fnacVida = %char(peNasv(s).vdfnac:*iso);
               suasVida = %editw(peNasv(s).vdsuas:'             .  ');
               fecha = (peNasv(s).vdainn * 10000)
                     + (peNasv(s).vdminn *   100)
                     +  peNasv(s).vddinn;
               monitor;
                 fingVida  = %char(%date(fecha:*iso):*iso);
                on-error;
                 fingVida = *blanks;
               endmon;
               if fingVida = '0001-01-01';
                 fingVida = *blanks;
               endif;
               fecha = (peNasv(s).vdaegn * 10000)
                     + (peNasv(s).vdmegn *   100)
                     +  peNasv(s).vddegn;
               monitor;
                 fegrVida  = %char(%date(fecha:*iso):*iso);
                on-error;
                 fegrVida = *blanks;
               endmon;
               if fegrVida = '0001-01-01';
                 fegrVida = *blanks;
               endif;
               if fegrVida = *blanks;
                exsr $rycVida;
                REST_writeXmlLine( 'bienVida' : '*BEG' );
                REST_writeXmlLine( 'integrVida' : peNasv(s).vdnomb);
                REST_writeXmlLine( 'tipDocVida' : peNasv(s).vddatd);
                REST_writeXmlLine( 'nroDocVida' : nrdoVida);
                REST_writeXmlLine( 'fecNacVida' : fnacVida);
                REST_writeXmlLine( 'sumaMuerte' : muerte);
                REST_writeXmlLine( 'sumaIvalidez' : suasInva);
                REST_writeXmlLine( 'sumaFractura' : suasFrac);
                REST_writeXmlLine( 'sumaAsistMed' : suasAsis);
                REST_writeXmlLine( 'sumaRentaDia' : suasRent);
                REST_writeXmlLine( 'bienVida' : '*END' );
               endif;
              endfor;
           endif;

           peRoll = 'F';
           nasvPosi = nasvUreg;

           if peMore = *off;
              leave;
           endif;
        enddo;

       REST_writeXmlLine('bienesPoliza' : '*END');
       REST_writeXmlLine('poliza':'*END');
       REST_writeXmlLine('polizas':'*END' );

       close *all;

       return;

       begsr $rycVida;

        muerte   = *blanks;
        suasInva = *blanks;
        suasFrac = *blanks;
        suasAsis = *blanks;
        suasRent = *blanks;

        clear peLryc;
        peLrycC = 0;

        WSLRCA( peBase
              : %dec(rama:2:0)
              : %dec(poli:7:0)
              : %dec(spol:9:0)
              : peNasv(s).vdpoco
              : peNasv(s).vdpaco
              : peLryc
              : peLrycC
              : peErro
              : peMsgs     );

        if peErro = 0;
           for r = 1 to peLrycC;
            if peLryc(r).vdxcob = 28;
             muerte = %editw(peLryc(r).vdsaco:'             .  ');
            endif;
            if peLryc(r).vdxcob = 29;
             suasInva = %editw(peLryc(r).vdsaco:'             .  ');
            endif;
            if peLryc(r).vdxcob = 30;
             suasFrac = %editw(peLryc(r).vdsaco:'             .  ');
            endif;
            if peLryc(r).vdxcob = 16 or peLryc(r).vdxcob = 17;
             suasAsis = %editw(peLryc(r).vdsaco:'             .  ');
            endif;
           endfor;
        endif;

       endsr;

