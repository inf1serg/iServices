     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRDSI: QUOM Versión 2                                       *
      *         Retorna datos de Siniestro para armar denuncia en    *
      *         PDF.                                                 *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *14-Abr-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpmail_h.rpgle'
      /copy './qcpybooks/svppol_h.rpgle'
      /copy './qcpybooks/svpint_h.rpgle'

     D WSRDSI          pr                  extpgm('WSRDSI')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peRama                        2  0 const
     D  peSini                        7  0 const
     D  peTipo                        1a   const

     D WSRDSI          pi
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peRama                        2  0 const
     D  peSini                        7  0 const
     D  peTipo                        1a   const

     D peDsCd          ds                  likeds( DsPahscd_t )
     D peDsCd1         ds                  likeds( DsPahsc1_t )
     D @@ds001         ds                  likeds( DsSet001_t )
     D peDsSd1         ds                  likeds( DsPahsd1_t )
     D rc              s               n
     D peMsgs          ds                  likeds(paramMsgs)
     D peDsD0          ds                  likeds( DsPahed0_t ) dim(999)
     D peDsD0C         s             10i 0
     D peDsC1          ds                  likeds( DsPahec1_t ) dim(999)
     D peDsC1C         s             10i 0


     D @@Repl          s          65535a
     D fecha           s              8  0
     D rama            s              2a
     D sini            s              7a
     D fecha1          s             10

      * Para SVPDAF_getDatoFiliatorio...

     D peNomb          ds                  likeDs(dsNomb_t)
     D peDomi          ds                  likeDs(dsDomi_t)
     D peDocu          ds                  likeDs(dsDocu_t)
     D peCont          ds                  likeDs(dsCont_t)
     D peDape          ds                  likeDs(dsDape_t)
     D peNaci          ds                  likeDs(dsNaci_t)
     D peMarc          ds                  likeDs(dsMarc_t)
     D peCbuS          ds                  likeDs(dsCbuS_t)
     D peClav          ds                  likeDs(dsClav_t)
     D peText          s             79    dim(999)
     D peTextC         s             10i 0
     D peProv          ds                  likeDs(dsProI_t) dim(999)
     D peProvC         s             10i 0
     D peMail          ds                  likeds(Mailaddr_t) dim(100)
     D peMailC         s             10i 0
      *** Datos del Conductor - GNHDAF

     D p1nomb          s             40a
     D p1Domi          s             35
     D p1Ndom          s              5  0
     D p1Piso          s              3  0
     D p1Deto          s              4
     D p1Copo          s              5  0
     D p1Cops          s              1  0
     D p1Teln          s              7  0
     D p1Faxn          s              7  0
     D p1Tiso          s              2  0
     D p1Tido          s              2  0
     D p1Nrdo          s              8  0
     D p1Cuit          s             11
     D p1Njub          s             11  0
     D p1Dtdo          s             20
     D p1CuiL          s             11  0
     D p1rpro          s              2  0
     D p1Mail          ds                  likeds(Mailaddr_t) dim(100)
     D p1MailC         s             10i 0

      *** Datos del Conductor - GNHDA1

     D p1Noma          s             40
     D p1Doma          s             35
     D p1Cop1          s              5  0
     D p1Cos1          s              1  0
     D p1Tel1          s              7  0
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
     D @1Fnac          s             10
     D @2Fnac          s             10
     D @1Freg          s              8  0
     D @2Freg          s             10
     D @1Fena          s             10
     D @3Freg          s             10

      *** Datos del VEHICULO - PAHSVA

     D   pePoco        s              6  0
     D   pePaco        s              3  0
     D   peVhmc        s              3
     D   peVhmo        s              3
     D   peVhcs        s              3
     D   peVsec        s              2  0
     D   peDsVa        ds                  likeds ( DsPahsva_t ) dim(999)
     D   peDsVaC       s             10i 0
     D   pePate        s             25

      ***
     D @@rvas          s             15  2
     D X               s              4  0
     D Y               s              4  0
     D Z               s              4  0
     D sello           s             20a
     D hora            s             10a
     D encon_tercero   s                   like(*in50)
     D encon_terc_Veh  s                   like(*in50)
     D T               s              4  0
     D U               s              4  0
     D texto           s            512a
      ***

      *** Datos de los BENEFICIARIOS -

     D   peDsBe        ds                  likeds ( DsPahsbe_t ) dim(999)
     D   peDsBeC       s             10i 0


      *** Datos del CONDUCTOR - TERCERO

     D   peDsB2        ds                  likeds ( DsPahsb2_t ) dim(999)
     D   peDsB2C       s             10i 0

      *** Datos del VEHICULO - TERCERO

     D   peDsB4        ds                  likeds ( DsPahsb4_t ) dim(999)
     D   peDsB4C       s             10i 0

      *** Datos del VEHICULO - TEXTOS

     D   peDstc        ds                  likeds ( DsPahstc_t ) dim(999)
     D   peDstcC       s             10i 0

      * Relato del Hecho
     D peDss0          ds                  likeds(DsPahsd0_t) dim(999)
     D peDss0C         s             10i 0
     D h               s             10i 0
     D primero         s              1n

      /free

       *inlr = *on;

       if SVPSIN_getCaratula2( peEmpr
                             : peSucu
                             : peRama
                             : peSini
                             : peDscd ) = *off;
          %subst(@@repl:1:2) = rama;
          %subst(@@repl:3:7) = sini;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl))  );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          return;
       endif;

         rc =  SVPTAB_getSet001( peRama
                               : @@Ds001);

         rc = SVPSIN_getPahsc1( peEmpr
                               : peSucu
                               : peRama
                               : peSini
                               : peDscd1 );

         exsr relatoHecho;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'denunciaSiniestro' );

       select;
        when @@Ds001.t@rame = 4;
         exsr $auto;
        when @@Ds001.t@rame = 18 or @@Ds001.t@rame = 21;
        other;
         exsr $rgva;
       endsl;

       REST_endArray( 'denunciaSiniestro' );

       return;

       begsr $auto;

      ***************************
      *** Datos del Siniestro ***
      ***************************

         REST_writeXmlLine( 'poliza'    : %char(peDscd.cdpoli) );
         REST_writeXmlLine( 'siniestro' : %char(peSini)        );
         REST_startArray( 'fechaDelSiniestro' );
          fecha = (peDscd.cdfsia * 10000)
                + (peDscd.cdfsim *   100)
                +  peDscd.cdfsid;
          if peTipo = 'P';
             REST_writeXmlLine( 'fecha' : SVPREST_editFecha( fecha ) );
           else;
             REST_writeXmlLine( 'fecha'
                              : %editc(peDscd.cdfsid:'X')
                              + '/'
                              + %editc(peDscd.cdfsim:'X')
                              + '/'
                              + %editc(peDscd.cdfsia:'X')  );
          endif;
          fecha = (peDscd.cdfdea * 10000)
                + (peDscd.cdfdem *   100)
                +  peDscd.cdfded;
          if peTipo = 'P';
             REST_writeXmlLine( 'fechaSello' : SVPREST_editFecha( fecha ) );
           else;
             sello = %editc(peDscd.cdfded:'X')
                   + '-';
             select;
              when peDscd.cdfdem = 01;
                   sello = %trim(sello)
                         + 'ENE-';
              when peDscd.cdfdem = 02;
                   sello = %trim(sello)
                         + 'FEB-';
              when peDscd.cdfdem = 03;
                   sello = %trim(sello)
                         + 'MAR-';
              when peDscd.cdfdem = 04;
                   sello = %trim(sello)
                         + 'ABR-';
              when peDscd.cdfdem = 05;
                   sello = %trim(sello)
                         + 'MAY-';
              when peDscd.cdfdem = 06;
                   sello = %trim(sello)
                         + 'JUN-';
              when peDscd.cdfdem = 07;
                   sello = %trim(sello)
                         + 'JUL-';
              when peDscd.cdfdem = 08;
                   sello = %trim(sello)
                         + 'AGO-';
              when peDscd.cdfdem = 09;
                   sello = %trim(sello)
                         + 'SEP-';
              when peDscd.cdfdem = 10;
                   sello = %trim(sello)
                         + 'OCT-';
              when peDscd.cdfdem = 11;
                   sello = %trim(sello)
                         + 'NOV-';
              when peDscd.cdfdem = 12;
                   sello = %trim(sello)
                         + 'DIC-';
             endsl;
             sello = %trim(sello)
                   + %editc(peDscd.cdfdea:'X');
             REST_writeXmlLine( 'fechaSello' : sello );
          endif;
          REST_writeXmlLine( 'estadoDelTiempo' :
          SVPDES_estadoDelTiempo( peEmpr : peSucu : peDsCd1.cd1cdes ));
          REST_writeXmlLine( 'diurnoNocturno':  peDsCd1.cd1mar1 );
          REST_writeXmlLine( 'hora' :  %editw(peDscd.cdhsin:'  :  '));
         REST_endArray( 'fechaDelSiniestro' );

         REST_startArray( 'lugarDelSiniestro' );
          exsr LugarDelSiniestro;
         REST_endArray  ( 'lugarDelSiniestro' );

      ***************************
      *** Datos del Conductor ***
      ***************************

         REST_startArray( 'conductor' );
          exsr GetConductor;
         REST_endArray  ( 'conductor' );

      ***************************
      *** Datos del Asegurado ***
      ***************************

         REST_startArray( 'asegurado' );
          exsr GetAsegurado;
         REST_endArray  ( 'asegurado' );

      *********************************
      *** Datos Vehiculo Asegurado  ***
      *********************************

         REST_startArray( 'vehiculoAsegurado' );
          exsr GetVehAse;
         REST_endArray  ( 'vehiculoAsegurado' );

      ********************************
      *** Datos de Otros Vehículos ***
      ********************************

         REST_startArray( 'otrosVehiculos' );

         clear x;
         clear y;
         clear z;
         encon_tercero = *off;
         encon_terc_Veh = *off;
         exsr $clear;

         RC =  SVPSIN_getBeneficiarios( peEmpr
                                      : peSucu
                                      : peRama
                                      : peSini
                                      : peDsCd.cdnops
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : peDsBe
                                      : peDsBeC ) = *on;

           for y = 1 to peDsBeC;
            if peDsBe(y).bemar2 = '2';
            encon_tercero = *on;
             rc = SVPDAF_getDatoFiliatorio( peDsBe(y).benrdf
                                          : peNomb
                                          : peDomi
                                          : peDocu
                                          : peCont
                                          : peNaci
                                          : peMarc
                                          : peCbus
                                          : peDape
                                          : peClav
                                          : peText
                                          : peTextC
                                          : peProv
                                          : peProvC
                                          : peMail
                                          : peMailC);

             clear peDsB4;

             rc = SVPSIN_getVehiculoTercero( pedsbe(y).beempr
                                           : peDsBe(y).besucu
                                           : peDsBe(y).berama
                                           : peDsBe(y).besini
                                           : peDsBe(y).benops
                                           : peDsBe(y).bepoco
                                           : peDsBe(y).bepaco
                                           : peDsBe(y).beriec
                                           : peDsBe(y).bexcob
                                           : peDsBe(y).benrdf
                                           : peDsBe(y).besebe
                                           : peDsB4
                                           : peDsB4C);
             if peDsB4C <> *zeros;
              REST_startArray( 'vehiculo' );
                 for x = 1 to peDsB4C;
                 encon_terc_Veh = *on;
                  exsr GetVehTer;
                 endfor;
              REST_endArray  ( 'vehiculo' );
            endif;
           endif;
           endfor;

           if encon_terc_veh = *off;
              REST_startArray( 'vehiculo' );
               exsr GetVehVac;
              REST_endArray  ( 'vehiculo' );
           endif;

         REST_endArray  ( 'otrosVehiculos' );


      ********************************
      ***        Datos Cosas       ***
      ********************************

        REST_startArray( 'cosas' );
              exsr GetCosasVac;
        REST_endArray  ( 'cosas' );

      ********************************
      ***  Datos Caracteristcas    ***
      ********************************

         REST_startArray( 'caracteristicas' );
          REST_writeXmlLine( 'tipoAccidentes':
                                    %char(peDscd1.cd1cdcs));
          REST_writeXmlLine( 'lugar':
                                    %char(peDscd1.cd1clug));
          REST_writeXmlLine( 'colision':
                                    %char(peDscd1.cd1ctco));

          REST_write( '<detalles>' );
          if texto <> *blanks;
             REST_write( %trim(texto) );
          endif;
          REST_write( '</detalles>' );

          REST_writeXmlLine( 'denunciaPolicial':
                                      peDscd1.cd1denp     );
          REST_writeXmlLine( 'comisaria':
                                      peDscd1.cd1comi     );
          REST_writeXmlLine( 'testigo': *blanks           );
          REST_writeXmlLine( 'domicilio': *blanks         );
         REST_endArray  ( 'caracteristicas' );

      ********************************
      ***  Datos Denunciante       ***
      ********************************

         REST_startArray( 'denunciante' );
          REST_writeXmlLine( 'esAsegurado': *blanks     );
          REST_writeXmlLine( 'nombre': *blanks          );
          REST_writeXmlLine( 'genero': *blanks          );
          REST_writeXmlLine( 'tipoDocumento': *blanks   );
          REST_writeXmlLine( 'numeroDocumento': *blanks );
          REST_writeXmlLine( 'telefono': *blanks        );
          REST_writeXmlLine( 'domicilio': *blanks       );
          REST_writeXmlLine( 'codigoPostal': *blanks    );
          REST_writeXmlLine( 'localidad': *blanks       );
          REST_writeXmlLine( 'provincia': *blanks       );
          REST_writeXmlLine( 'pais': *blanks            );
          REST_writeXmlLine( 'estadoCivil': *blanks     );
          REST_writeXmlLine( 'nacionalidad': *blanks    );
         REST_endArray  ( 'denunciante' );

      ********************************
      *** Datos Declaracion Jurada ***
      ********************************

        exsr declJurada;


      ********************************
      *** Datos Lesiones           ***
      ********************************

         //
         // HARDCODEO DATOS PARA PRUEBA
         //

        REST_startArray( 'lesiones' );
         for T = 1 to 3;
          REST_startArray( 'lesionado' );
           REST_writeXmlLine( 'nombreApellido': *blanks         );
           REST_writeXmlLine( 'genero' : *blanks                );
           REST_writeXmlLine( 'tipoDocumento': *blanks          );
           REST_writeXmlLine( 'numeroDocumento': *blanks        );
           REST_writeXmlLine( 'telefono': *blanks               );
           REST_writeXmlLine( 'domicilio': *blanks              );
           REST_writeXmlLine( 'codigoPostal': *blanks           );
           REST_writeXmlLine( 'localidad': *blanks              );
           REST_writeXmlLine( 'provincia': *blanks              );
           REST_writeXmlLine( 'pais':  *blanks                  );
           REST_writeXmlLine( 'estadoCivil':  *blanks           );
           REST_writeXmlLine( 'fechaNacimiento': *blanks        );
           REST_writeXmlLine( 'email': *blanks                  );
           REST_writeXmlLine( 'nacionalidad': *blanks           );
           REST_writeXmlLine( 'conductorHabitual': *blanks      );
           REST_writeXmlLine( 'relacion': *blanks               );
           REST_writeXmlLine( 'tipoDeLesion': *blanks           );
           REST_writeXmlLine( 'examenAlcoholemia': *blanks      );
           REST_writeXmlLine( 'centoAsistencial': *blanks         );
             REST_startArray( 'denunciaPolicial' );
              REST_writeXmlLine( 'hubo': *blanks                );
              REST_writeXmlLine( 'comisaria': *blanks           );
             REST_endArray  ( 'denunciaPolicial' );
             REST_startArray( 'sumario' );
              REST_writeXmlLine( 'hubo': *blanks                );
              REST_writeXmlLine( 'juzgado': *blanks             );
             REST_endArray  ( 'sumario' );
             REST_startArray( 'testigo' );
              REST_writeXmlLine( 'nombreApellido': *blanks);
              REST_writeXmlLine( 'domicilio': *blanks   );
             REST_endArray  ( 'testigo' );
          REST_endArray  ( 'lesionado' );
         endfor;
        REST_endArray  ( 'lesiones' );
       endsr;

      ***********************************************************
       begsr $clear;
      ***********************************************************

          clear peNomb;
          clear peDomi;
          clear peDocu;
          clear peCont;
          clear peNaci;
          clear peMarc;
          clear peCbus;
          clear peDape;
          clear peClav;
          clear peText;
          clear peTextC;
          clear peProv;
          clear peProvC;
          clear peMail;
          clear peMailC;


       endsr;

      ***********************************************************
       begsr LugardelSiniestro;
      ***********************************************************

          REST_writeXmlLine( 'localidad' :
              SVPDES_localidad( peDscd.cdcopo : peDscd.cdcops )   );
          REST_writeXmlLine( 'provincia' :
                              SVPDES_provinciaInder(peDscd.cdrpro));
          REST_writeXmlLine( 'pais'      :
                              SVPDES_paisDeNac(peDscd1.cd1pain)   );
          REST_writeXmlLine( 'calle'     : peDscd.cdludi          );
          if peTipo = 'P';
             REST_writeXmlLine( 'numero'    : *blanks                );
           else;
             REST_writeXmlLine( 'numero'    : *blanks                );
          endif;
          REST_writeXmlLine( 'interseccionDe'  : *blanks          );
          REST_writeXmlLine( 'interseccionEntre'  : *blanks       );
          if peTipo = 'P';
             if peDscd1.cd1ruta <= 0;
                REST_writeXmlLine( 'rutaNumero' : *blanks );
              else;
                REST_writeXmlLine( 'rutaNumero'
                                 : %trim(%char(peDscd1.cd1ruta)));
             endif;
             if peDscd1.cd1nrkm <= 0;
                REST_writeXmlLine( 'kilometro' : *blanks );
              else;
                REST_writeXmlLine( 'kilometro'
                                 : %trim(%char(peDscd1.cd1nrkm)));
             endif;
           else;
             REST_writeXmlLine( 'rutaNumero'
                              : %trim(%char(peDscd1.cd1ruta)));
             REST_writeXmlLine( 'kilometro'
                              : %trim(%char(peDscd1.cd1nrkm)));
          endif;
          if peDscd1.cd1mar2 = 'N' ;
          REST_writeXmlLine( 'nacional'   : peDscd1.cd1mar2       );
          REST_writeXmlLine( 'provincial' : *blanks               );
          else;
          REST_writeXmlLine( 'nacional'   : *blanks               );
          REST_writeXmlLine( 'provincial' : peDscd1.cd1mar2       );
          endif;
          REST_writeXmlLine( 'cruceConRuta':%editc(peDscd1.cd1rut2:'Z'));
          REST_writeXmlLine( 'senalizado'   : peDscd1.cd1mar3     );
          REST_writeXmlLine( 'cruceEnTren'  : peDscd1.cd1mar4     );
          REST_writeXmlLine( 'barrera'      : peDscd1.cd1mar5     );
          REST_writeXmlLine( 'barreraSenalizada' : peDscd1.cd1mar6);
          REST_writeXmlLine( 'barreraEstado' : peDscd1.cd1esta    );
          REST_writeXmlLine( 'semaforo'      : peDscd1.cd1mar7    );
          REST_writeXmlLine( 'semaforoFunciona' : peDscd1.cd1mar8 );
          REST_writeXmlLine( 'semaforoColor' : peDscd1.cd1colo    );
          REST_writeXmlLine( 'tipoCalzada' : peDscd1.cd1tcal      );
          REST_writeXmlLine( 'estadoCalzada': peDscd1.cd1ecal     );

       endsr;

      ***********************************************************
       begsr getConductor;
      ***********************************************************

          exsr $clear;

          rc = SVPDAF_getDatoFiliatorio( peDscd.cdnrdf
                                       : peNomb
                                       : peDomi
                                       : peDocu
                                       : peCont
                                       : peNaci
                                       : peMarc
                                       : peCbus
                                       : peDape
                                       : peClav
                                       : peText
                                       : peTextC
                                       : peProv
                                       : peProvC
                                       : peMail
                                       : peMailC  );

          REST_writeXmlLine( 'nombreApellido': peDscd.cdncon   );
          REST_writeXmlLine( 'genero' : %editc(peDape.sexo:'X'));
          REST_writeXmlLine( 'tipoDocumento':
                            SVPDES_tipoDocumento( peDocu.tido ));
          if peTipo = 'P';
             REST_writeXmlLine( 'numeroDocumento':
                                  %trim(%char((peDocu.nrdo))));
             REST_writeXmlLine( 'telefono'
                              : %editc(peCont.teln:'Z'));
           else;
             REST_writeXmlLine( 'numeroDocumento':
                                  %editc(peDocu.nrdo:'Z'));
             if peCont.teln <= 0;
                REST_writeXmlLine( 'telefono' : *blanks );
              else;
                REST_writeXmlLine( 'telefono'
                                 : %editc(peCont.teln:'Z')      );
             endif;
          endif;
          REST_writeXmlLine( 'domicilio': pedomi.domi          );
          REST_writeXmlLine( 'codigoPostal'
                           : %subst(%editc(peDomi.copo:'X'):2:4));
          REST_writeXmlLine( 'localidad':
                  SVPDES_localidad( peDomi.copo : peDomi.cops ));
          p1Rpro = SVPDES_getProvinciaPorLocalidad( peDomi.Copo
                                                  : peDomi.Cops);
          REST_writeXmlLine( 'provincia':
                                  SVPDES_provinciaInder(p1Rpro));
          REST_writeXmlLine( 'pais':
                           SVPDES_paisDeNac(peDscd1.cd1pain)   );
          REST_writeXmlLine( 'email': peMail(1).mail           );

           monitor;
           fecha1 = %char( %date( %char( peNaci.fnac ):*iso0));
         //fecha1 = %date(peNaci.fnac:*iso);
           on-error;
           peNaci.fnac = 19010101;
           endmon;

           if peNaci.fnac <> 00000000;

             if peTipo = 'P';
                @1Fnac = %char( %date( %char( peNaci.fnac ):*iso0));
              else;
                @1Fnac = %editc(peNaci.fnac:'X');
                @2Fnac = %subst(@1Fnac:7:2)
                       + '/'
                       + %subst(@1Fnac:5:2)
                       + '/'
                       + %subst(@1Fnac:1:4);
                @1Fnac = @2Fnac;
             endif;
            else;
             if peTipo = 'P';
                @1Fnac = '1901-01-01';
              else;
                @1Fnac = *blanks;
             endif;
           endif;
             REST_writeXmlLine( 'fechaNacimiento': @1Fnac         );
          REST_writeXmlLine( 'estadoCivil':
                          SVPDES_estadoCivil( peDape.esci )    );
          REST_writeXmlLine( 'nacionalidad':
                           SVPDES_nacionalidad( peNaci.cnac )  );
          REST_writeXmlLine( 'examenAlcoholemia':
                                               peDscd1.cd1mar9 );
          REST_writeXmlLine( 'conductorHabitual': peDscd.cdctco);
           REST_startArray( 'registro' );
            if peDscd.cdnrcv = 0;
               REST_writeXmlLine( 'numero': *blanks);
             else;
               REST_writeXmlLine( 'numero': %editc(peDscd.cdnrcv:'X'));
            endif;
            @1Freg=(peDscd.cdfrva*10000) +
                   (peDscd.cdfrvm*100)   + peDscd.cdfrvd ;
             if @1Freg <> 00000000;
               @2Freg = %char( %date( %char( @1Freg ): *iso0 ) );
              else;
               if peTipo = 'P';
                  @2Freg = '1901-01-01';
                else;
                  @2Freg = *blanks;
               endif;
             endif;
             if peTipo = 'P';
                if peDscd.cdnrcv = 0;
                   REST_writeXmlLine( 'vencimiento': *blanks );
                 else;
                   REST_writeXmlLine( 'vencimiento': @2freg           );
                endif;
              else;
                REST_writeXmlLine( 'vencimiento': @2freg           );
             endif;
           REST_endArray  ( 'registro' );
          if peDscd.cdasen = peDscd.cdnrdf;
             REST_writeXmlLine( 'esAsegurado': 'S'  );
           else;
             REST_writeXmlLine( 'esAsegurado': 'N'  );
          endif;
          REST_writeXmlLine( 'relacion':
          SVPDES_relacionConAsegurado( peEmpr
                                     : peSucu
                                     : peDscd1.cd1rela));

       endsr;

      ***********************************************************
       begsr getAsegurado;
      ***********************************************************

          exsr $clear;

          rc = SVPDAF_getDatoFiliatorio( peDscd.cdasen
                                       : peNomb
                                       : peDomi
                                       : peDocu
                                       : peCont
                                       : peNaci
                                       : peMarc
                                       : peCbus
                                       : peDape
                                       : peClav
                                       : peText
                                       : peTextC
                                       : peProv
                                       : peProvC
                                       : peMail
                                       : peMailC  );

          REST_writeXmlLine( 'nombreApellido': peNomb.Nomb   );
          REST_writeXmlLine( 'tipoDocumento':
                          SVPDES_tipoDocumento( peDocu.tido ));
          REST_writeXmlLine( 'numeroDocumento':
                             %editc(peDocu.nrdo:'Z'));
          if peCont.teln <= 0;
             REST_writeXmlLine( 'telefono': *blanks);
           else;
             REST_writeXmlLine( 'telefono': %editc(peCont.teln:'Z'));
          endif;
          REST_writeXmlLine( 'domicilio': peDomi.domi        );
          REST_writeXmlLine( 'codigoPostal':
                              %subst(%editc(peDomi.copo:'X'):2:4));
          REST_writeXmlLine( 'localidad':
                SVPDES_localidad( peDomi.copo : peDomi.cops ));

          p1Rpro = SVPDES_getProvinciaPorLocalidad(peDomi.Copo
                                                 :pedomi.Cops);
          REST_writeXmlLine( 'provincia':
                                SVPDES_provinciaInder(p1Rpro));
          REST_writeXmlLine( 'pais': SVPDES_paisDeNac(p1pain));
          REST_writeXmlLine( 'email': peMail(1).mail         );
          REST_writeXmlLine( 'nacionalidad':
                           SVPDES_nacionalidad( peNaci.cnac ));

       endsr;

      ***********************************************************
       begsr getVehAse;
      ***********************************************************

         RC = SVPSIN_getVehiculo( peempr
                                : pesucu
                                : perama
                                : pesini
                                : peDscd.cdnops
                                : *omit
                                : *omit
                                : *omit
                                : *omit
                                : *omit
                                : *omit
                                : peDsVa
                                : peDsVaC);

          if peDsVaC = *zeros;
          clear peDsVa;
          Endif;

          REST_writeXmlLine( 'marca':
                               SVPDES_marca(peDsVa(1).vaVhmc));
          REST_writeXmlLine( 'modelo':
                              SVPDES_modelo(peDsVa(1).vaVhmo));
          REST_writeXmlLine( 'tipo':
                   SVPDES_getTipoDeVehiculo(peDsVa(1).vaVhct));
          pePate = (peDsVa(1).vaPanl) +
                   %editc((peDsVa(1).vaPann):'X');
          REST_writeXmlLine( 'dominio': (peDsVa(1).vaNmat)   );
          REST_writeXmlLine( 'anio':
                               %editc((peDsVa(1).vaVhaÑ):'X'));
          REST_writeXmlLine( 'motor': (peDsVa(1).vaMoto)     );
          REST_writeXmlLine( 'chasis': (peDsVa(1).vaChas)    );
          REST_writeXmlLine( 'uso':
                      SVPDES_usoDelVehiculo(peDsVa(1).vaVhuv));
          REST_writeXmlLine( 'coberturaAfectada':
                                             peDsVa(1).vaHecg);
          REST_writeXmlLine( 'detalleDanios': *blanks        );

          @@rvas = SVPSIN_getRvaActStro(peEmpr
                                       :peSucu
                                       :peRama
                                       :peSini
                                       :peDscd.cdnops
                                       :*omit);

          REST_writeXmlLine( 'montoAproximado':
                             '$' + %trim(%editc(@@rvas:'4')));
          REST_writeXmlLine( 'taller': *blanks               );
          REST_writeXmlLine( 'lugarFecha': *blanks           );

       endsr;

      ***********************************************************
       begsr getVehTer;
      ***********************************************************

           REST_writeXmlLine( 'propietario': peNomb.nomb   );
           REST_writeXmlLine( 'genero':
                                    %editc(peDape.sexo:'X'));
           REST_writeXmlLine( 'tipoDocumento':
                     SVPDES_tipoDocumento( peDocu.tido )   );
           if peDocu.nrdo <= 0;
              REST_writeXmlLine( 'numeroDocumento': ' '    );
            else;
              REST_writeXmlLine( 'numeroDocumento'
                               : %editc(peDocu.nrdo:'X')   );
           endif;
           if pecont.teln <= 0;
              REST_writeXmlLine( 'telefono': ' '           );
            else;
              REST_writeXmlLine( 'telefono':
                                %editc(peCont.teln:'X')    );
           endif;
           REST_writeXmlLine( 'domicilio': peDomi.domi     );
           REST_writeXmlLine( 'codigoPostal':
                                    %editc(peDomi.copo:'X'));
           REST_writeXmlLine( 'localidad':
              SVPDES_localidad( peDomi.copo : peDomi.cops ));
           p1Rpro=SVPDES_getProvinciaPorLocalidad(peDomi.Copo
                                               :pedomi.Cops);
           REST_writeXmlLine( 'provincia':
                              SVPDES_provinciaInder(p1Rpro));
           REST_writeXmlLine( 'pais':
                       SVPDES_paisDeNac(peNaci.Pain)       );
           REST_writeXmlLine( 'email': peMail(1).mail      );
           REST_writeXmlLine( 'nacionalidad':
                       SVPDES_nacionalidad( peNaci.cnac )  );
           REST_writeXmlLine( 'marca':
                             SVPDES_marca(peDsB4(x).b4Vhmc));
           REST_writeXmlLine( 'modelo':
                            SVPDES_modelo(peDsB4(x).b4Vhmo));
           REST_writeXmlLine( 'tipo':
                 SVPDES_getTipoDeVehiculo(peDsB4(x).b4Vhct));
           REST_writeXmlLine( 'dominio': (peDsB4(x).b4Nmat));
           REST_writeXmlLine( 'anio':
                             %editc((peDsB4(x).b4VhaÑ):'X'));
           REST_writeXmlLine( 'motor': (peDsB4(x).b4Moto)  );
           REST_writeXmlLine( 'chasis': (peDsB4(x).b4Chas) );
           REST_writeXmlLine( 'uso':
                    SVPDES_usoDelVehiculo(peDsB4(x).b4Vhuv));
           REST_writeXmlLine( 'detalleDanios': *blanks     );
           REST_writeXmlLine( 'examenAlcoholemia': *blanks );
           REST_writeXmlLine( 'espropietario': *blanks     );
            Exsr GetConTer;

       endsr;

      ***********************************************************
       begsr getConTer;
      ***********************************************************

        exsr $clear;

        exsr GetFilVehTerdir;

           select;

      **---------------------------------------------------------
           When peDsb2(1).b2nrd1 = *zeros and rc='1';

            REST_startArray( 'Conductor' );
             REST_writeXmlLine( 'nombre': peDsb2(1).b2nomb );
             REST_writeXmlLine( 'genero':
                               %editc(peDsB2(1).b2csex:'X'));
             REST_writeXmlLine( 'tipoDocumento':
                   SVPDES_tipoDocumento( peDsB2(1).b2tido ));
              if peDsB2(1).b2nrdo <= 0;
                REST_writeXmlLine( 'numeroDocumento': ' '  );
               else;
                REST_writeXmlLine( 'numeroDocumento':
                               %editc(peDsB2(1).b2nrdo:'X'));
              endif;
             REST_writeXmlLine( 'telefono':  peDsB2(1).b2ntel);
             REST_writeXmlLine( 'domicilio': peDsB2(1).b2domi);
             REST_writeXmlLine( 'codigoPostal':
                               %editc(peDsB2(1).b2copo:'X'));
             REST_writeXmlLine( 'localidad':
              SVPDES_localidad( peDsb2(1).b2copo
                              : peDsB2(1).b2cops ));
             p1Rpro=SVPDES_getProvinciaPorLocalidad(
                            peDsB2(1).b2Copo:peDsB2(1).b2Cops);
             REST_writeXmlLine( 'provincia':
                              SVPDES_provinciaInder(p1Rpro));
             REST_writeXmlLine( 'pais':
                          SVPDES_paisDeNac(peDsB2(1).b2Pain));
             REST_writeXmlLine( 'estadoCivil':
                        SVPDES_estadoCivil( peDsB2(1).b2cesc));
           if peDsb2(1).b2fena <> 00000000;
             @1Fena = %char( %date( %char( peDsB2(1).b2fena ):*iso0));
            else;
             if peTipo = 'P';
                @1Fena = '1901-01-01';
              else;
                @1Fena = *blanks;
             endif;
           endif;
             REST_writeXmlLine( 'fechaNacimiento': @1fena    );
             REST_writeXmlLine( 'nacionalidad': *blanks      );
             REST_writeXmlLine( 'conductorHabitual':
                                             peDsb2(y).b2mar1);
              REST_startArray( 'registro' );
               REST_writeXmlLine( 'numero':
                                 %editc(peDsB2(1).B2nrcv:'X'));
             if peDsB2(y).b2frcv <> 00000000;
               @3Freg = %char( %date( %char( peDsB2(1).b2frcv ): *iso0 ) );
              else;
               if peTipo = 'P';
                  @3Freg = '1901-01-01';
                else;
                  @3Freg = *blanks;
               endif;
             endif;
               REST_writeXmlLine( 'vencimiento': @3freg      );
              REST_endArray  ( 'registro' );
            REST_endArray  ( 'Conductor' );

      **---------------------------------------------------------
           When peDsb2(1).b2nrd1 <> *zeros and rc = '1';

            exsr $clear;

            exsr GetFilVehTerSb2;

            REST_startArray( 'Conductor' );
             REST_writeXmlLine( 'nombre': peNomb.Nomb      );
             REST_writeXmlLine( 'genero':
                                    %editc(peDape.sexo:'X'));
             REST_writeXmlLine( 'tipoDocumento':
                        SVPDES_tipoDocumento( peDocu.tido ));
              if peDocu.nrdo <= 0;
                REST_writeXmlLine( 'numeroDocumento': ' '  );
               else;
                REST_writeXmlLine( 'numeroDocumento':
                                    %editc(peDocu.nrdo:'X'));
              endif;
             REST_writeXmlLine( 'telefono': %editc(peCont.teln:'X'));
             REST_writeXmlLine( 'domicilio': pedomi.domi     );
             REST_writeXmlLine( 'codigoPostal':
                               %editc(peDomi.copo:'X'));
             REST_writeXmlLine( 'localidad':
              SVPDES_localidad( peDomi.copo
                              : peDomi.cops ));
             p1Rpro=SVPDES_getProvinciaPorLocalidad(
                            peDomi.copo:peDomi.cops);
             REST_writeXmlLine( 'provincia':
                              SVPDES_provinciaInder(p1Rpro));
             REST_writeXmlLine( 'pais':
                          SVPDES_paisDeNac(peNaci.Pain));
             REST_writeXmlLine( 'estadoCivil':
                        SVPDES_estadoCivil( peDape.esci )    );
           if peNaci.fnac <> 00000000;
             @1Fena = %char( %date( %char( peNaci.fnac ):*iso0));
            else;
             if peTipo = 'P';
                @1Fena = '1901-01-01';
              else;
                @1Fena = *blanks;
             endif;
           endif;
             REST_writeXmlLine( 'fechaNacimiento': @1fena    );
             REST_writeXmlLine( 'nacionalidad': *blanks      );
             REST_writeXmlLine( 'conductorHabitual':
                                                peDscd.cdctco);
              REST_startArray( 'registro' );
              if peTipo = 'P';
               REST_writeXmlLine( 'numero': %editc(peDscd.cdnrcv:'X'));
              else;
               if peDscd.cdnrcv = 0;
                  REST_writeXmlLine( 'numero': *blanks);
                else;
                  REST_writeXmlLine( 'numero': %editc(peDscd.cdnrcv:'X'));
               endif;
              endif;
              @1Freg=(peDscd.cdfrva*10000) +
                     (peDscd.cdfrvm*100)   + peDscd.cdfrvd ;
             if @1freg <> 00000000;
               @3Freg = %char( %date( %char( @1freg ): *iso0 ) );
              else;
               if peTipo = 'P';
                  @3Freg = '1901-01-01';
                else;
                  @3Freg = *blanks;
               endif;
             endif;
               REST_writeXmlLine( 'vencimiento': @3freg      );
              REST_endArray  ( 'registro' );
            REST_endArray  ( 'Conductor' );

      **---------------------------------------------------------
           other;

            exsr $clear;

            exsr GetFilVehTerSbe;

            REST_startArray( 'Conductor' );
             REST_writeXmlLine( 'nombre': peNomb.Nomb      );
             REST_writeXmlLine( 'genero':
                                    %editc(peDape.sexo:'X'));
             REST_writeXmlLine( 'tipoDocumento':
                        SVPDES_tipoDocumento( peDocu.tido ));
              if peDocu.nrdo <= 0;
                REST_writeXmlLine( 'numeroDocumento': ' '  );
               else;
                REST_writeXmlLine( 'numeroDocumento':
                                    %editc(peDocu.nrdo:'X'));
              endif;
             REST_writeXmlLine( 'telefono': %editc(peCont.teln:'X'));
             REST_writeXmlLine( 'domicilio': pedomi.domi     );
             REST_writeXmlLine( 'codigoPostal':
                               %editc(peDomi.copo:'X'));
             REST_writeXmlLine( 'localidad':
              SVPDES_localidad( peDomi.copo
                              : peDomi.cops ));
             p1Rpro=SVPDES_getProvinciaPorLocalidad(
                            peDomi.copo:peDomi.cops);
             REST_writeXmlLine( 'provincia':
                              SVPDES_provinciaInder(p1Rpro));
             REST_writeXmlLine( 'pais':
                          SVPDES_paisDeNac(peNaci.Pain));
             REST_writeXmlLine( 'estadoCivil':
                        SVPDES_estadoCivil( peDape.esci )    );
           if peNaci.fnac <> 00000000;
             @1Fena = %char( %date( %char( peNaci.fnac ):*iso0));
            else;
             if peTipo = 'P';
                @1Fena = '1901-01-01';
              else;
                @1Fena = *blanks;
             endif;
           endif;
             REST_writeXmlLine( 'fechaNacimiento': @1fena    );
             REST_writeXmlLine( 'nacionalidad': *blanks      );
             REST_writeXmlLine( 'conductorHabitual':
                                                peDscd.cdctco);
              REST_startArray( 'registro' );
              if peTipo = 'P';
               REST_writeXmlLine( 'numero': %editc(peDscd.cdnrcv:'X'));
              else;
               if peDscd.cdnrcv = 0;
                  REST_writeXmlLine( 'numero': *blanks);
                else;
                  REST_writeXmlLine( 'numero': %editc(peDscd.cdnrcv:'X'));
               endif;
              endif;
              @1Freg=(peDscd.cdfrva*10000) +
                     (peDscd.cdfrvm*100)   + peDscd.cdfrvd ;
             if @1freg <> 00000000;
               @3Freg = %char( %date( %char( @1freg ): *iso0 ) );
              else;
               if peTipo = 'P';
                  @3Freg = '1901-01-01';
                else;
                  @3Freg = *blanks;
               endif;
             endif;
               REST_writeXmlLine( 'vencimiento': @3freg      );
              REST_endArray  ( 'registro' );
            REST_endArray  ( 'Conductor' );

           endsl;

       endsr;

      ***********************************************************
       begsr GetFilVehTerDir;
      ***********************************************************

          clear peDsB2;
          clear peDsB2C;

          rc = SVPSIN_getConductorTercero( peDsbe(y).beempr
                                         : peDsBe(y).besucu
                                         : peDsBe(y).berama
                                         : peDsBe(y).besini
                                         : peDsBe(y).benops
                                         : peDsBe(y).bepoco
                                         : peDsBe(y).bepaco
                                         : peDsBe(y).beriec
                                         : peDsBe(y).bexcob
                                         : peDsBe(y).benrdf
                                         : peDsBe(y).besebe
                                         : peDsB2
                                         : peDsB2C);

       endsr;

      ***********************************************************
       begsr GetFilVehTerSbe;
      ***********************************************************

          rc = SVPDAF_getDatoFiliatorio( peDsbe(y).benrdf
                                       : peNomb
                                       : peDomi
                                       : peDocu
                                       : peCont
                                       : peNaci
                                       : peMarc
                                       : peCbus
                                       : peDape
                                       : peClav
                                       : peText
                                       : peTextC
                                       : peProv
                                       : peProvC
                                       : peMail
                                       : peMailC  );

       endsr;

      ***********************************************************
       begsr GetFilVehTerSb2;
      ***********************************************************

          rc = SVPDAF_getDatoFiliatorio( peDsb2(x).b2nrd1
                                       : peNomb
                                       : peDomi
                                       : peDocu
                                       : peCont
                                       : peNaci
                                       : peMarc
                                       : peCbus
                                       : peDape
                                       : peClav
                                       : peText
                                       : peTextC
                                       : peProv
                                       : peProvC
                                       : peMail
                                       : peMailC  );

       endsr;

      ***********************************************************
       begsr GetFilVehTer;
      ***********************************************************

          rc = SVPDAF_getDatoFiliatorio( peDsbe(x).benrdf
                                       : peNomb
                                       : peDomi
                                       : peDocu
                                       : peCont
                                       : peNaci
                                       : peMarc
                                       : peCbus
                                       : peDape
                                       : peClav
                                       : peText
                                       : peTextC
                                       : peProv
                                       : peProvC
                                       : peMail
                                       : peMailC  );

       endsr;

      ***********************************************************
       begsr getVehVac;
      ***********************************************************

           REST_writeXmlLine( 'propietario': *blanks       );
           REST_writeXmlLine( 'genero': *blanks            );
           REST_writeXmlLine( 'tipoDocumento': *blanks     );
           REST_writeXmlLine( 'numeroDocumento': *blanks   );
           REST_writeXmlLine( 'telefono': *blanks          );
           REST_writeXmlLine( 'domicilio': *blanks         );
           REST_writeXmlLine( 'codigoPostal': *blanks      );
           REST_writeXmlLine( 'localidad': *blanks         );
           REST_writeXmlLine( 'provincia': *blanks         );
           REST_writeXmlLine( 'pais': *blanks              );
           REST_writeXmlLine( 'email': *blanks             );
           REST_writeXmlLine( 'nacionalidad': *blanks      );
           REST_writeXmlLine( 'marca': *blanks             );
           REST_writeXmlLine( 'modelo': *blanks            );
           REST_writeXmlLine( 'tipo':  *blanks             );
           REST_writeXmlLine( 'dominio': *blanks           );
           REST_writeXmlLine( 'anio': *blanks              );
           REST_writeXmlLine( 'motor': *blanks             );
           REST_writeXmlLine( 'chasis': *blanks            );
           REST_writeXmlLine( 'uso': *blanks               );
           REST_writeXmlLine( 'detalleDanios': *blanks     );
           REST_writeXmlLine( 'examenAlcoholemia': *blanks );
           REST_writeXmlLine( 'espropietario': *blanks     );
            REST_startArray( 'Conductor' );
             REST_writeXmlLine( 'nombre': *blanks            );
             REST_writeXmlLine( 'genero': *blanks            );
             REST_writeXmlLine( 'tipoDocumento': *blanks     );
             REST_writeXmlLine( 'numeroDocumento': *blanks   );
             REST_writeXmlLine( 'telefono': *blanks          );
             REST_writeXmlLine( 'domicilio': *blanks         );
             REST_writeXmlLine( 'codigoPostal': *blanks      );
             REST_writeXmlLine( 'localidad': *blanks         );
             REST_writeXmlLine( 'provincia': *blanks         );
             REST_writeXmlLine( 'pais': *blanks              );
             REST_writeXmlLine( 'estadoCivil': *blanks       );
             REST_writeXmlLine( 'fechaNacimiento': *blanks   );
             REST_writeXmlLine( 'nacionalidad': *blanks      );
             REST_writeXmlLine( 'conductorHabitual': *blanks );
              REST_startArray( 'registro' );
               REST_writeXmlLine( 'numero': *blanks          );
               REST_writeXmlLine( 'vencimiento': *blanks     );
              REST_endArray  ( 'registro' );
            REST_endArray  ( 'Conductor' );

       endsr;

      ***********************************************************
       begsr GetCosasCar;
      ** NO SE UTILIZA ESTA RUTINA - SE DEJA ESCRITA PARA UN   **
      ** FUTURO                                                **
      ***********************************************************

          REST_startArray( 'cosa' );
          REST_writeXmlLine( 'propietario': peNomb.nomb   );
          REST_writeXmlLine( 'genero':
                                   %editc(peDape.sexo:'X'));
          REST_writeXmlLine( 'tipoDocumento':
                     SVPDES_tipoDocumento( peDocu.tido )  );
           if peDocu.nrdo <= 0;
              REST_writeXmlLine( 'numeroDocumento': ' '   );
            else;
              REST_writeXmlLine( 'numeroDocumento'
                               : %editc(peDocu.nrdo:'X')  );
           endif;
           if pecont.teln <= 0;
              REST_writeXmlLine( 'telefono': ' '          );
            else;
              REST_writeXmlLine( 'telefono':
                                %editc(peCont.teln:'X')   );
           endif;
          REST_writeXmlLine( 'domicilio': peDomi.domi     );
          REST_writeXmlLine( 'codigoPostal':
                                   %editc(peDomi.copo:'X'));
          REST_writeXmlLine( 'localidad':
             SVPDES_localidad( peDomi.copo : peDomi.cops ));
          p1Rpro=SVPDES_getProvinciaPorLocalidad(peDomi.Copo
                                              :pedomi.Cops);
          REST_writeXmlLine( 'provincia':
                             SVPDES_provinciaInder(p1Rpro));
          REST_writeXmlLine( 'pais':
                      SVPDES_paisDeNac(peNaci.Pain)       );
          REST_writeXmlLine( 'email': peMail(1).mail      );
          REST_writeXmlLine( 'nacionalidad':
                       SVPDES_nacionalidad( peNaci.cnac ) );
          REST_writeXmlLine( 'detalleDanios': *blanks     );
          REST_endArray  ( 'cosa' );
       endsr;

      ***********************************************************
       begsr GetCosasVac;
      ***********************************************************

          REST_startArray( 'cosa' );
          REST_writeXmlLine( 'propietario': *blanks       );
          REST_writeXmlLine( 'genero': *blanks            );
          REST_writeXmlLine( 'tipoDocumento': *blanks     );
          REST_writeXmlLine( 'numeroDocumento': *blanks   );
          REST_writeXmlLine( 'telefono': *blanks          );
          REST_writeXmlLine( 'domicilio': *blanks         );
          REST_writeXmlLine( 'codigoPostal': *blanks      );
          REST_writeXmlLine( 'localidad': *blanks         );
          REST_writeXmlLine( 'provincia': *blanks         );
          REST_writeXmlLine( 'pais': *blanks              );
          REST_writeXmlLine( 'email': *blanks             );
          REST_writeXmlLine( 'nacionalidad': *blanks      );
          REST_writeXmlLine( 'detalleDanios': *blanks     );
          REST_endArray  ( 'cosa' );

       endsr;

      *---------------------------------------------------------*
       begsr $rgva;
      *---------------------------------------------------------*

          rc = SVPDAF_getDatoFiliatorio( peDscd.cdasen
                                       : peNomb
                                       : peDomi
                                       : peDocu
                                       : peCont
                                       : peNaci
                                       : peMarc
                                       : peCbus
                                       : peDape
                                       : peClav
                                       : peText
                                       : peTextC
                                       : peProv
                                       : peProvC
                                       : peMail
                                       : peMailC  );

         REST_writeXmlLine( 'seccion'   : @@Ds001.t@ramd              );
         REST_writeXmlLine( 'siniestro' : %char(peSini)               );
          fecha = (peDscd.cdfdea * 10000)
                + (peDscd.cdfdem *   100)
                +  peDscd.cdfded;
          if peTipo = 'P';
             REST_writeXmlLine( 'fechaSello' : SVPREST_editFecha( fecha ) );
           else;
             sello = %editc(peDscd.cdfded:'X')
                   + '-';
             select;
              when peDscd.cdfdem = 01;
                   sello = %trim(sello)
                         + 'ENE-';
              when peDscd.cdfdem = 02;
                   sello = %trim(sello)
                         + 'FEB-';
              when peDscd.cdfdem = 03;
                   sello = %trim(sello)
                         + 'MAR-';
              when peDscd.cdfdem = 04;
                   sello = %trim(sello)
                         + 'ABR-';
              when peDscd.cdfdem = 05;
                   sello = %trim(sello)
                         + 'MAY-';
              when peDscd.cdfdem = 06;
                   sello = %trim(sello)
                         + 'JUN-';
              when peDscd.cdfdem = 07;
                   sello = %trim(sello)
                         + 'JUL-';
              when peDscd.cdfdem = 08;
                   sello = %trim(sello)
                         + 'AGO-';
              when peDscd.cdfdem = 09;
                   sello = %trim(sello)
                         + 'SEP-';
              when peDscd.cdfdem = 10;
                   sello = %trim(sello)
                         + 'OCT-';
              when peDscd.cdfdem = 11;
                   sello = %trim(sello)
                         + 'NOV-';
              when peDscd.cdfdem = 12;
                   sello = %trim(sello)
                         + 'DIC-';
             endsl;
             sello = %trim(sello)
                   + %editc(peDscd.cdfdea:'X');
             REST_writeXmlLine( 'fechaSello' : sello );
          endif;

          REST_startArray( 'asegurado' );
           REST_writeXmlLine( 'nombreApellido': peNomb.nomb   );
           REST_writeXmlLine( 'poliza' : %char(peDscd.cdpoli) );
           REST_writeXmlLine( 'domicilio': peDomi.domi        );
           REST_writeXmlLine( 'localidad':
                 SVPDES_localidad( peDomi.copo : peDomi.cops ));
           p1Rpro = SVPDES_getProvinciaPorLocalidad( peDomi.Copo
                                                 : peDomi.Cops);
           REST_writeXmlLine( 'provincia':
                                 SVPDES_provinciaInder(p1Rpro));
           REST_writeXmlLine( 'codigoPostal':
                                       %editc(peDomi.copo:'Z'));
           REST_writeXmlLine( 'telefono':
                                  %editc(peCont.teln:'Z')     );
           REST_writeXmlLine( 'email': peMail(1).mail         );
           REST_writeXmlLine( 'nacionalidad':
                           SVPDES_nacionalidad( peNaci.cnac ) );
           REST_writeXmlLine( 'tipoDocumento':
                           SVPDES_tipoDocumento( peDocu.tido ));
           REST_writeXmlLine( 'numeroDocumento':
                                       %editc(peDocu.nrdo:'Z'));
           REST_writeXmlLine( 'cuit': peDocu.cuit             );
            REST_startArray( 'representanteLegal' );
             REST_writeXmlLine( 'nombre': *blanks             );
             REST_writeXmlLine( 'documento': *blanks          );
             REST_writeXmlLine( 'cuit': *blanks               );
            REST_endArray  ( 'representanteLegal' );
          REST_endArray  ( 'asegurado' );

          REST_startArray( 'riesgoAsegurado' );
           REST_writeXmlLine( 'ubicacion': peDscd.cdludi      );
           REST_writeXmlLine( 'localidad':
             SVPDES_localidad( peDscd.cdcopo : peDscd.cdcops) );
           rc =  SVPPOL_getPolizadesdeSuperPoliza( peDscd.cdEmpr
                                                 : peDscd.cdSucu
                                                 : peDscd.cdArcd
                                                 : peDscd.cdSpol
                                                 : peDscd.cdSspo
                                                 : *omit
                                                 : *omit
                                                 : *omit
                                                 : *omit
                                                 : peDsD0
                                                 : peDsD0C );

          fecha = (peDsD0(1).d0fioa * 10000)
                + (peDsD0(1).d0fiom *   100)
                +  peDsD0(1).d0fiod;

          if petipo = 'P';
             REST_writeXmlLine( 'vigenciaDesde'
                              : SVPREST_editFecha( fecha ));
           else;
             REST_writeXmlLine( 'vigenciaDesde'
                              : %editc(peDsD0(1).d0fiod:'X')
                              + '/'
                              + %editc(peDsD0(1).d0fiom:'X')
                              + '/'
                              + %editc(peDsD0(1).d0fioa:'X') );
          endif;
          fecha = (peDsD0(1).d0fvoa * 10000)
                + (peDsD0(1).d0fvom *   100)
                +  peDsD0(1).d0fvod;

          if petipo = 'P';
           REST_writeXmlLine( 'vigenciaHasta':
                                    SVPREST_editFecha( fecha ));
           else;
             REST_writeXmlLine( 'vigenciaHasta'
                              : %editc(peDsD0(1).d0fvod:'X')
                              + '/'
                              + %editc(peDsD0(1).d0fvom:'X')
                              + '/'
                              + %editc(peDsD0(1).d0fvoa:'X') );
          endif;
           rc =  SPVSPO_getCabeceraSuplemento ( peDscd.cdEmpr
                                              : peDscd.cdSucu
                                              : peDscd.cdArcd
                                              : peDscd.cdSpol
                                              : peDscd.cdSspo
                                              : peDsC1
                                              : peDsC1C );
           REST_writeXmlLine( 'productor':
                         SVPINT_getNombre ( peDsC1(1).c1Empr
                                          : peDsC1(1).c1Sucu
                                          : peDsC1(1).c1Nivt
                                          : peDsC1(1).c1Nivc ));
           REST_writeXmlLine( 'personaContactar': *blanks     );
           REST_writeXmlLine( 'telefono': *blanks             );
          REST_endArray  ( 'riesgoAsegurado' );


          REST_startArray( 'detallesHecho' );
          fecha = (peDscd.cdfsia * 10000)
                + (peDscd.cdfsim *   100)
                +  peDscd.cdfsid;
           if petipo = 'P';
              REST_writeXmlLine( 'fecha': SVPREST_editFecha( fecha ));
            else;
              REST_writeXmlLine( 'fecha'
                               : %editc(peDscd.cdfsid:'X')
                               + '/'
                               + %editc(peDscd.cdfsim:'X')
                               + '/'
                               + %editc(peDscd.cdfsia:'X') );
           endif;
           REST_writeXmlLine( 'hora':%editc(peDscd.cdhsin:'X'));
           REST_writeXmlLine( 'tipoDePerdida': *blanks        );

           REST_write( '<descripcion>');
           if texto <> *blanks;
              REST_write( %trim(texto) );
           endif;
           REST_write( '</descripcion>');
           REST_writeXmlLine( 'quienDescubrio': *blanks       );
            REST_startArray( 'denunciaPolicial' );
             REST_writeXmlLine( 'hubo': *blanks               );
             REST_writeXmlLine( 'comisaria': *blanks          );
            REST_endArray  ( 'denunciaPolicial' );
            REST_startArray( 'denunciaBomberos' );
             REST_writeXmlLine( 'hubo': *blanks               );
             REST_writeXmlLine( 'central': *blanks            );
            REST_endArray  ( 'denunciaBomberos' );
            REST_startArray( 'sumario' );
             REST_writeXmlLine( 'hubo': *blanks               );
             REST_writeXmlLine( 'juzgado': *blanks            );
            REST_endArray  ( 'sumario' );
          REST_endArray  ( 'detallesHecho' );

          REST_startArray( 'elementos' );
           REST_startArray( 'elemento' );
            REST_writeXmlLine( 'cantidad': '0'            );
            REST_writeXmlLine( 'descripcion': *blanks         );
            REST_writeXmlLine( 'modeloSerie': *blanks          );
            REST_writeXmlLine( 'importeEstimado': '0.00'        );
           REST_endArray  ( 'elemento' );
          REST_endArray  ( 'elementos' );

          exsr declJurada;

       endsr;

       begsr declJurada;
        fecha = (peDscd.cdfdea * 10000)
              + (peDscd.cdfdem *   100)
              +  peDscd.cdfded;
         REST_startArray( 'declaracionJurada' );
          REST_writeXmlLine( 'lugar': 'BUENOS AIRES'    );
          if peTipo = 'P';
             REST_writeXmlLine( 'fecha': SVPREST_editFecha(fecha) );
           else;
             REST_writeXmlLine( 'fecha'
                              : %editc(peDscd.cdfded:'X')
                              + '/'
                              + %editc(peDscd.cdfdem:'X')
                              + '/'
                              + %editc(peDscd.cdfdea:'X') );
          endif;
          hora = %editc(peDscd.cdtime:'X');
          REST_writeXmlLine( 'hora'
                           : %subst(hora:1:2)
                           + ':'
                           + %subst(hora:3:2)
                           + ':'
                           + %subst(hora:5:2) );
         REST_endArray  ( 'declaracionJurada' );
       endsr;

       begsr relatoHecho;
         clear peDss0;
         clear texto;
         peDss0c = 0;
         primero = *off;
         h = 0;
         rc = SVPSIN_getPahsd0( peEmpr
                              : peSucu
                              : peRama
                              : peSini
                              : peDscd.cdnops
                              : peDss0
                              : peDss0C );
         for u = 1 to peDss0C;
             if peDss0(u).d0retx <> *blanks;
                if not primero;
                   texto = %trim(peDss0(u).d0retx);
                   primero = *on;
                 else;
                   texto = %trim(texto)
                         + ' '
                         + %trim(peDss0(u).d0retx);
                endif;
                h += 1;
             endif;
             if h = 6;
                leavesr;
             endif;
         endfor;
       endsr;

      /end-free

