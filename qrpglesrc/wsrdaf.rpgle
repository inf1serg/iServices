     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRxxx: QUOM Versión 2                                       *
      *         Retornar Datos de un dato filiatorio                 *
      * ------------------------------------------------------------ *
      * Astiz Facundo                        *28/09/2021*            *
      * ------------------------------------------------------------ *
      * SGF 17/03/2022: Agrego fecha de nacimiento, sexo y estado    *
      *                 civil.                                       *
      * SGF 31/03/2022: Agrego localidad.                            *
      *                                                              *
      * ************************************************************ *

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpdaf_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'
      //------------------------------------------------------//
     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n
     D @@repl          s          65535a
     D peMsgs          ds                  likeds(paramMsgs)

     D peNrdf          s              7  0
     D nrdf            s              7a

      //getDaf
     D peNomb          s             40
     D peDomi          s             35
     D peNdom          s              5  0
     D pePiso          s              3  0
     D peDeto          s              4
     D peCopo          s              5  0
     D peCops          s              1  0
     D peTeln          s              7  0
     D peFaxn          s              7  0
     D peTiso          s              2  0
     D peTido          s              2  0
     D peNrdo          s              8  0
     D peCuit          s             11
     D peNjub          s             11  0

      //getDa1
     D p1Nomb          s             40
     D p1Domi          s             35
     D p1Copo          s              5  0
     D p1Cops          s              1  0
     D p1Teln          s              7  0
     D p1Fnac          s              8  0
     D p1Cprf          s              3  0
     D p1Sexo          s              1  0
     D p1Esci          s              1  0
     D p1Raae          s              3  0
     D p1Ciiu          s              6  0
     D p1Dom2          s             50
     D p1Lnac          s             30
     D p1Pesk          s              5  2
     D p1Estm          s              3  2
     D p1Mfum          s              1
     D p1Mzur          s              1
     D p1Mar1          s              1
     D p1Mar2          s              1
     D p1Mar3          s              1
     D p1Mar4          s              1
     D p1Ccdi          s             11
     D p1Pain          s              5  0
     D p1Cnac          s              3  0

     D peTpa1          s             20
     D peTpa2          s             20
     D peTtr1          s             20
     D peTtr2          s             20
     D peTcel          s             20
     D peTpag          s             20
     D peTfa1          s             20
     D peTfa2          s             20
     D peTfa3          s             20
     D pePweb          s             50

     D peMail          ds                  likeds(Mailaddr_t) dim(100)
     D peMailC         s             10i 0

     D   peNcbu        s             22a

     D @@telf          s             20
     D @@Ttel          s              1
     D @x              s             10i 0
     D @@rpro          s              2  0
     D @fnac           s             10d

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)
     D   JobName                     10a   overlay(PsDs:244)
     D   JobUser                     10a   overlay(PsDs:254)
     D   JobNbr                       6  0 overlay(PsDs:264)

       //------------------------------------------------------//
      /free

       *inlr = *on;

       // FIJO: Recuperar la URL desde conde se lo llamo
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

       // FIJO: Para la URI a URL
       url = %trim(uri);

       // Obtener los parámetros de la URL
       // Esto es FIJO y es una ejecución por CADA
       // parámetro de la URL
       nrdf = REST_getNextPart(url);

       // Valida longitud 7
       monitor;
          peNrdf = %dec(nrdf:7:0);
       on-error;
          @@repl = nrdf;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'DAF0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'DAF0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2  );
          REST_end();
          SVPREST_end();
        //  close *all;
          return;
       endmon;

       //Val chk
       if SVPDAF_chkDaf( peNrdf ) = *off;
          @@repl = nrdf;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'DAF0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'DAF0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2  );
          REST_end();
          SVPREST_end();
        //  close *all;
          return;
       endif;

       // FIJO: Grabar SIEMPRE el header y el encoding
       REST_writeHeader();
       REST_writeEncoding();

       // respuesta XML
       // <datoFiliatorio>
       //     <numero></numero>
       //     <nombre></nombre>
       //     <tipoDeSociedad></tipoDeSociedad>
       //     <nacionalidad></nacionalidad>
       //     <cbuStros></cbuStros>
       //     <domicilio>
       //         <calle></calle>
       //         <numero></numero>
       //         <piso></piso>
       //         <codigoPostal></codigoPostal>
       //         <sufijoCodPos></sufijoCodPos>
       //         <provincia></provincia>
       //         <pais></pais>
       //     </domicilio>
       //     <documento>
       //         <tipo></tipo>
       //         <numero></numero>
       //         <cuit></cuit>
       //         <cuil></cuil>
       //     </documento>
       //     <telefonos>
       //         <telefono>
       //             <tipo></tipo>
       //             <numero></numero>
       //         </telefono>
       //     </telefonos>
       //     <emails>
       //         <email>
       //             <tipo></tipo>
       //             <correo></correo>
       //         </email>
       //     </emails>
       // </datoFiliatorio>

       if SVPDAF_getDaf( peNrdf
                       : peNomb
                       : peDomi
                       : peNdom
                       : pePiso
                       : peDeto
                       : peCopo
                       : peCops
                       : peTeln
                       : peFaxn
                       : peTiso
                       : peTido
                       : peNrdo
                       : peCuit
                       : peNjub )
       and SVPDAF_getDa1(peNrdf
                       : p1Nomb
                       : p1Domi
                       : p1Copo
                       : p1Cops
                       : p1Teln
                       : p1Fnac
                       : p1Cprf
                       : p1Sexo
                       : p1Esci
                       : p1Raae
                       : p1Ciiu
                       : p1Dom2
                       : p1Lnac
                       : p1Pesk
                       : p1Estm
                       : p1Mfum
                       : p1Mzur
                       : p1Mar1
                       : p1Mar2
                       : p1Mar3
                       : p1Mar4
                       : p1Ccdi
                       : p1Pain
                       : p1Cnac );

             REST_startArray( 'datoFiliatorio');
                if SVPDAF_getDa8(peNrdf
                               : peNcbu);
                endif;
                REST_writeXmlLine( 'numero'         : %char(peNrdf) );
                REST_writeXmlLine( 'nombre'         : peNomb        );
                REST_writeXmlLine( 'tipoDeSociedad' : %char(peTiso) );
                REST_writeXmlLine( 'nacionalidad'
                                 : SVPDES_nacionalidad(p1cnac)      );
                //REST_writeXmlLine( 'nacionalidad'
                //                 : %char (p1cnac)                   );
                REST_writeXmlLine( 'cbuStros'       : peNcbu        );

                @@rpro = SVPDES_getProvinciaPorLocalidad(peCopo :peCops);
                REST_startArray( 'domicilio');
                   REST_writeXmlLine( 'calle'       : peDomi        );
                   REST_writeXmlLine( 'numero'      : %char(peNdom) );
                   REST_writeXmlLine( 'piso'        : %char(pePiso) );
                   REST_writeXmlLine( 'codigoPostal': %char(peCopo) );
                   REST_writeXmlLine( 'sufijoCodPos': %char(peCops) );
                   REST_writeXmlLine( 'provincia' :
                      SVPDES_provinciaInder(@@rpro) );
                   REST_writeXmlLine( 'pais'        : %char(p1Pain) );
                   REST_writeXmlLine( 'localidad'
                                    : SVPDES_localidad(peCopo:peCops) );
                REST_endArray( 'domicilio');

                REST_startArray( 'documento');
                   REST_writeXmlLine( 'tipo'        : %char(peTido) );
                   REST_writeXmlLine( 'numero'      : %char(peNrdo) );
                   REST_writeXmlLine( 'cuil'        : %char(peNjub) );
                   REST_writeXmlLine( 'cuit'        : peCuit        );
                REST_endArray( 'documento');

                exsr srTelefono;
                REST_startArray( 'telefonos');
                   if @@telf <> *blanks;
                      REST_startArray( 'telefono');
                         REST_writeXmlLine( 'tipo'     : @@Ttel        );
                         REST_writeXmlLine( 'numero'   : @@telf        );
                      REST_endArray( 'telefono');
                   endif;
                REST_endArray( 'telefonos');

                REST_startArray( 'emails');
                   if SVPDAF_getDa7(peNrdf
                                  : peMail
                                  : peMailC);
                      for @x = 1 to peMailC;
                         REST_startArray( 'email');
                          REST_writeXmlLine( 'tipo' : %char(peMail(@x).tipo) );
                            REST_writeXmlLine( 'correo': peMail(@x).mail);
                         REST_endArray( 'email');
                      endfor;
                   endif;
                REST_endArray( 'emails');

                exsr $fechaNac;
                REST_writeXmlLine( 'fechaNacimiento'
                                 : SVPREST_editFecha(p1fnac) );
                REST_writeXmlLine( 'sexo' : %char(p1sexo) );
                REST_writeXmlLine( 'estadoCivil' : %char(p1esci) );


             REST_endArray( 'datoFiliatorio');
          endif;

          REST_end();
        //  close *all;

      //------------------------------------------------------//
       Begsr srTelefono;
          @@telf = *blanks;
          if SVPDAF_getDa6(peNrdf
                         : peTpa1
                         : peTpa2
                         : peTtr1
                         : peTtr2
                         : peTcel
                         : peTpag
                         : peTfa1
                         : peTfa2
                         : peTfa3
                         : pePweb );
             if peTpa1 <> *blanks;
                @@telf = peTpa1;
             endif;

             if @@telf = *blanks;
                if peTpa2 <> *blanks;
                   @@telf = peTpa2;
                endif;
             endif;

             if @@telf = *blanks;
                if peTtr1 <> *blanks;
                   @@telf = peTtr1;
                endif;
             endif;

             if @@telf = *blanks;
                if peTtr2 <> *blanks;
                   @@telf = peTtr2;
                endif;
             endif;

             if @@telf <> *blanks;
                @@Ttel = 'P';
             endif;
          endif;
       Endsr;
      //------------------------------------------------------//
       begsr $fechaNac;
        monitor;
          @fnac = %date(p1fnac:*iso);
         on-error;
          p1fnac = 00010101;
        endmon;
       endsr;
      //------------------------------------------------------//
