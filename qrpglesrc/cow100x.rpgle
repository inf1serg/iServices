     H dftactgrp(*NO)
     H option(*srcstmt: *nodebugio: *noshowcpy)
     H thread(*serialize)
     H bnddir('HDIILE/HDIBDIR')
      **********************************************************************
      *  Listado de Cotizaciones Excel                                     *
      *                                                                    *
      *  Alvarez Fernando - 18/01/2016                                     *
      **********************************************************************
      * Modificaciones                                                     *
      * Gio 2017-09-07 Inclusion del listado de accidentes personales      *
      * LRG 2018-09-27 Se agregan campos al Excel                          *
      **********************************************************************
     Fpawed0    if   e           k disk
     Fpahed0    if   e           k disk
     Fpahet0    if   e           k disk
     Fpahec1    if   e           k disk
     Fsehni2    if   e           k disk
     Fset201    if   e           k disk
     Fset202    if   e           k disk
     Fset203    if   e           k disk
     Fset225    if   e           k disk
     Fgnhdaf    if   e           k disk
     Fctw00009  if   e           k disk
     Fctwins    if   e           k disk

      /copy './qcpybooks/hssf_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svpint_h.rpgle'

     DCOW100X          pr                  EXTPGM('COW100X')
     D  tipo                          1    const

     DCOW100X          pi
     D  peTipo                        1    const

     D SndMail         pr                  extpgm('SNDMAIL')
     D  peCprc                       20a   const
     D  peCspr                       20a   const options(*nopass:*omit)
     D  peMens                      512a   varying options(*nopass:*omit)
     D  peLmsg                     5000a   options(*nopass:*omit)

     DchkWeb           pr              n
     D empr                           1    const
     D sucu                           2    const
     D arcd                           6  0 const
     D spol                           9  0 const

     D addcpath        pr                  ExtPgm('TAATOOL/ADDCPATH')

      // Prototye
     D CreateCellStyles...
     D                 pr
     D FormatColumns   pr
     D   sheet                             like(ssSheet)
     D SetHeadings     pr
     D   sheet                             like(ssSheet)

      // Variables
     D book            s                   like(SSWorkbook)
     D TitColumn       s                   like(SSCellStyle)
     D CellNumer       s                   like(SSCellStyle)
     D CellNu152       s                   like(SSCellStyle)
     D CellTexto       s                   like(SSCellStyle)
     D CellDates       s                   like(SSCellStyle)
     D Sheet           s                   like(SSSheet)
     D row             s                   like(SSRow)
     D rowcount        s             10i 0
     D x               s             10i 0

     D rama            s              1
     D @@nom3          s             42
     D @@hdes          s              6  0
     D @@hhas          s              6  0

     D k1y000          ds                  likerec(c1w000:*key)
     D k1yec1          ds                  likerec(p1hec1:*key)
     D k1yni2          ds                  likerec(s1hni2:*key)
     D k1yet0          ds                  likerec(p1het0:*key)
     D k1yed0          ds                  likerec(p1hed0:*key)
     D k1yins          ds                  likerec(c1wins:*key)

       ADDCPATH ( );

       ss_begin_object_group(100);
       book = new_XSSFWorkbook();
       CreateCellStyles();
       Sheet = SS_newSheet(book: 'Hoja1');
       // FormatColumns( sheet );
       SetHeadings( sheet );

       setll *start pawed0;
       read pawed0;

       dow not %eof ( pawed0 );

         rama = SVPWS_getGrupoRama ( wdrama );

         if ( rama = peTipo );

           if chkWeb ( wdempr : wdsucu : wdarcd : wdspol );

             k1yec1.c1empr = wdempr;
             k1yec1.c1sucu = wdsucu;
             k1yec1.c1arcd = wdarcd;
             k1yec1.c1spol = wdspol;
             k1yec1.c1sspo = wdsspo;
             chain %kds ( k1yec1 ) pahec1;

             k1yni2.n2empr = wdempr;
             k1yni2.n2sucu = wdsucu;
             k1yni2.n2nivt = c1nivt;
             k1yni2.n2nivc = c1nivc;
             chain %kds ( k1yni2 ) sehni2;

             chain n2nrdf gnhdaf;

             k1yed0.d0empr = wdempr;
             k1yed0.d0sucu = wdsucu;
             k1yed0.d0arcd = wdarcd;
             k1yed0.d0spol = wdspol;
             k1yed0.d0sspo = wdsspo;
             k1yed0.d0rama = wdrama;
             k1yed0.d0arse = wdarse;
             k1yed0.d0oper = wdoper;
             k1yed0.d0suop = wdsuop;
             chain %kds ( k1yed0 ) pahed0;

             select;
               // Autos
               when ( rama = 'A' );
                 exsr ConfAutos;
               // Hogar
               when ( rama = 'H' );
                 exsr ConfHogar;
               // Accidentes Personales
               when ( rama = 'V' );
                 exsr ConfAccPe;
             endsl;

           endif;

         endif;

         read pawed0;

       enddo;

       if ( rowcount > *Zeros );

         for x = 0 to 50;
           SSSheet_autoSizeColumn( sheet : x );
         endfor;

         select;
           when ( peTipo = 'A' );
             SS_save(book: '/tmp/confAutos.xls' );
             SNDMAIL ( 'EMISION WEB' : 'AUTOS CONF' );
           when ( peTipo = 'H' );
             SS_save(book: '/tmp/confHogar.xls' );
             SNDMAIL ( 'EMISION WEB' : 'HOGAR CONF' );
           when ( peTipo = 'V' );
             SS_save(book: '/tmp/confAp.xlsx' );
             SNDMAIL ( 'EMISION WEB' : 'ACCPE CONF' );
         endsl;
       endif;

       ss_end_object_group();

       *inlr = *on;

       begsr confAutos;

         k1yet0.t0empr = wdempr;
         k1yet0.t0sucu = wdsucu;
         k1yet0.t0arcd = wdarcd;
         k1yet0.t0spol = wdspol;
         k1yet0.t0sspo = wdsspo;
         k1yet0.t0rama = wdrama;
         k1yet0.t0arse = wdarse;
         k1yet0.t0oper = wdoper;

         setll %kds ( k1yet0  : 8 ) pahet0;
         reade %kds ( k1yet0  : 8 ) pahet0;

         dow not %eof ( pahet0 );

           rowcount += 1;
           row = SSSheet_createRow(sheet: rowcount);

           ss_num ( row: 00: wdpoli : CellNumer);
           ss_text( row: 01: %trim ( w0nomb ) : CellTexto);
           ss_num ( row: 02: c1nivc : CellNumer);
           ss_text( row: 03: %trim ( dfnomb ) : CellTexto);

           ss_num ( row: 04: c1niv3 : CellNumer);
           @@nom3 = SVPINT_GetNombre( c1empr : c1sucu : 3 : c1niv3 );
           ss_text( row: 05: %trim ( dfnomb ) : CellTexto);

           ss_text( row: 06: %trim ( t0cobl ) : CellTexto);
           chain t0cobl set225;
           ss_text( row: 07: %trim ( t@cobd ) : CellTexto);

           ss_text( row: 08: %trim ( t0vhmc ) : CellTexto);

           chain t0vhmc set201;
           ss_text( row: 09: %trim ( t@vhmd ) : CellTexto);
           ss_text( row: 10: %trim ( t0vhmo ) : CellTexto);
           chain t0vhmo set202;
           ss_text( row: 11: %trim ( t@vhdm ) : CellTexto);
           ss_text( row: 12: %trim ( t0vhcs ) : CellTexto);
           chain t0vhmo set203;
           ss_text( row: 13: %trim ( t@vhds ) : CellTexto);

           ss_text( row: 14: %trim ( t0nmat ) : CellTexto);
           ss_text( row: 15: %trim ( t0moto ) : CellTexto);
           ss_text( row: 16: %trim ( t0chas ) : CellTexto);
           ss_num ( row: 17: t0vhvu : CellNumer);

           ss_num ( row: 18: d0prim : CellNumer);
           ss_num ( row: 19: d0prem : CellNumer);

           ss_num ( row: 20: t0ctre : CellNumer);

           ss_text( row: 21: *blanks          : CellTexto);
           ss_text( row: 22: *blanks          : CellTexto);
           ss_text( row: 23: *blanks          : CellTexto);
           ss_text( row: 24: *blanks          : CellTexto);
           ss_text( row: 25: *blanks          : CellTexto);
           ss_text( row: 26: *blanks          : CellTexto);
           k1yins.inempr = wdempr;
           k1yins.insucu = wdsucu;
           k1yins.innivt = w0nivt;
           k1yins.innivc = w0nivc;
           k1yins.innctw = w0nctw;
           k1yins.intipo = 'I';
           chain %kds ( k1yins  : 6 ) ctwins;
           if %found;
             ss_text( row: 21: %trim( inmarc )  : CellTexto);
             ss_text( row: 22: %trim( innomb )  : CellTexto);
             ss_text( row: 23: %trim( indomi ) + ' '
                             + %char( inndom )  : CellTexto);
             ss_text( row: 24: %editW( @@hdes : '  :  :  ') + ' / '
                             + %editW( @@hhas : '  :  :  ') : CellTexto);
             ss_text( row: 25: %editW( infins : '    /  /  ')  : CellTexto);
             ss_text( row: 26: %trim( income )  : CellTexto);
           endif;

           reade %kds ( k1yet0  : 8 ) pahet0;

         enddo;

       endsr;

       begsr confHogar;

         rowcount += 1;
         row = SSSheet_createRow(sheet: rowcount);

         ss_num ( row: 00: wdpoli : CellNumer);
         ss_text( row: 01: %trim ( w0nomb ) : CellTexto);
         ss_num ( row: 02: c1nivc : CellNumer);
         ss_text( row: 03: %trim ( dfnomb ) : CellTexto);

         monitor;
           ss_date( row: 04: %date ( d0fioa * 10000
                                   + d0fiom * 100
                                   + d0fiod ) : CellDates);
         on-error;
           ss_text( row: 04: ''           : CellTexto);
         endmon;

         ss_num ( row: 05: d0prim : CellNumer);
         ss_num ( row: 06: d0prem : CellNumer);

       endsr;

       begsr confAccPe;

         rowcount += 1;
         row = SSSheet_createRow(sheet: rowcount);

         ss_num ( row: 00: wdpoli : CellNumer);
         ss_text( row: 01: %trim ( w0nomb ) : CellTexto);
         ss_num ( row: 02: c1nivc : CellNumer);
         ss_text( row: 03: %trim ( dfnomb ) : CellTexto);

         monitor;
           ss_date( row: 04: %date ( d0fioa * 10000
                                   + d0fiom * 100
                                   + d0fiod ) : CellDates);
         on-error;
           ss_text( row: 04: ''           : CellTexto);
         endmon;

         ss_num ( row: 05: d0prim : CellNumer);
         ss_num ( row: 06: d0prem : CellNumer);

       endsr;

      * ------------------------------------------------------------ *
      * CreateCellStyles(): Crear los estilos de celdas que se van a *
      *                     aplicar a todo el libro                  *
      *                                                              *
      * NOTA: Se usan las siguientes variables globales:             *
      *                                                              *
      *       -- TitColumn: Estilo para los titulos de columna       *
      *       -- CellNumer: Estilo para celdas numéricas             *
      *       -- CellNu152: Estilo para celdas numéricas (15,2)      *
      *       -- CellTexto: Estilo para celdas de texto              *
      *       -- CellDates: Estilo para celdas de fecha              *
      *                                                              *
      * ------------------------------------------------------------ *
     P CreateCellStyles...
     P                 B
     D CreateCellStyles...
     D                 pi

      * Font para los títulos (negrita)
     D TitColFont      s                   like(SSFont)
     D TempStr         s                   like(jString)
     D DataFmt         s                   like(SSDataFormat)
     D NumFmt          s              5i 0
     D DateFmt         s              5i 0

      /free

       //
       //  Crear estilo para los títulos de columna
       //  Negrita y con borde inferior
       //
       // Paso a paso:
       //   -- Creo el CellStyle
       //   -- Creo el font
       //   -- Pongo el font en negrita
       //   -- Asigno el font al CellStylle
       //

       TitColumn  = SSWorkbook_createCellStyle(book);
       TitColFont = SSWorkbook_createFont(book);
       SSFont_setBoldweight(TitColFont: BOLDWEIGHT_BOLD);
       SSCellStyle_setFont(TitColumn: TitColFont);

       //
       //  Crear estilo para las columnas numéricas
       //  Alineación a la derecha, formato #,##0
       //
       // Paso a paso:
       //   -- Creo el CellStyle
       //   -- Creo un formato de datos
       //   -- Creo una string con la máscara
       //   -- Obtengo el número (editc) con el que Excel
       //      representa esa máscara
       //   -- Asigno el formato del dato al cellstyle
       //   -- Asigno la alineacion del cellstyle
       //
       CellNumer = SSWorkbook_createCellStyle(book);
         DataFmt = SSWorkbook_createDataFormat(book);
         TempStr = new_String('#,##0');
         NumFmt  = SSDataFormat_getFormat(DataFmt: TempStr);
       SSCellStyle_setDataFormat(CellNumer: NumFmt);
       SSCellStyle_setAlignment(CellNumer: ALIGN_RIGHT);

       //
       //  Crear estilo para las columnas de texto
       //  Alineado a la izquierda
       //
       // Paso a paso:
       //   -- Creo el CellStyle
       //   -- Asigno la alineacion del cellstyle
       //
       CellTexto = SSWorkbook_createCellStyle(book);
       SSCellStyle_setAlignment(CellNumer: ALIGN_LEFT);

       //
       //  Crear estilo para las columnas numéricas
       //  Alineación a la derecha, formato #,##0.00
       //
       // Paso a paso:
       //   -- Creo el CellStyle
       //   -- Creo un formato de datos
       //   -- Creo una string con la máscara
       //   -- Obtengo el número (editc) con el que Excel
       //      representa esa máscara
       //   -- Asigno el formato del dato al cellstyle
       //   -- Asigno la alineacion del cellstyle
       //
       CellNu152 = SSWorkbook_createCellStyle(book);
         DataFmt = SSWorkbook_createDataFormat(book);
         TempStr = new_String('#,##0.00');
         NumFmt  = SSDataFormat_getFormat(DataFmt: TempStr);
       SSCellStyle_setDataFormat(CellNu152: NumFmt);
       SSCellStyle_setAlignment(CellNu152: ALIGN_RIGHT);

       //
       //  Crear estilo para las columnas de fechas
       //
       // Paso a paso:
       //   -- Creo el CellStyle
       //   -- Creo un formato de datos
       //   -- Creo una string con la máscara que quiero
       //   -- Obtengo el número (editc) con el que Excel
       //      representa esa máscara
       //   -- Asigno el formato del dato al cellstyle
       //
       CellDates = SSWorkbook_createCellStyle(book);
         DataFmt = SSWorkbook_createDataFormat(book);
         TempStr = new_String('dd/mm/yyyy');
         DateFmt = SSDataFormat_getFormat(DataFmt: TempStr);
       SSCellStyle_setDataFormat(CellDates: DateFmt);


      /end-free

     P CreateCellStyles...
     P                 E

      * ------------------------------------------------------------ *
      * FormatColumns(): Establecer el ancho de las columnas y combi-*
      *                  nar las celdas (si corresponde)             *
      *                                                              *
      * NOTA: Este procedimiento deberá variar en función de la      *
      *       cantidad de columnas que nuestra hoja tenga.           *
      *                                                              *
      * El ancho de cada columna es en unidades que son aproximadamen*
      * te 1/256 de cada carácter.                                   *
      *                                                              *
      * ------------------------------------------------------------ *
     P FormatColumns   B
     D FormatColumns   pi
     D   sheet                             like(ssSheet)

      /free

       SSSheet_setColumnWidth( sheet: 00:  10 * 256 );
       SSSheet_setColumnWidth( sheet: 01:  55 * 256 );
       SSSheet_setColumnWidth( sheet: 02:  14 * 256 );
       SSSheet_setColumnWidth( sheet: 03:  55 * 256 );

       select;
         when ( peTipo = 'A' );
           SSSheet_setColumnWidth( sheet: 04:  55 * 256 );
           SSSheet_setColumnWidth( sheet: 05:  22 * 256 );
           SSSheet_setColumnWidth( sheet: 06:  12 * 256 );
           SSSheet_setColumnWidth( sheet: 07:  22 * 256 );
           SSSheet_setColumnWidth( sheet: 08:  12 * 256 );
           SSSheet_setColumnWidth( sheet: 09:  22 * 256 );
           SSSheet_setColumnWidth( sheet: 10:  12 * 256 );
           SSSheet_setColumnWidth( sheet: 11:  22 * 256 );
           SSSheet_setColumnWidth( sheet: 12:  15 * 256 );
           SSSheet_setColumnWidth( sheet: 13:  22 * 256 );
           SSSheet_setColumnWidth( sheet: 14:  18 * 256 );
           SSSheet_setColumnWidth( sheet: 15:  10 * 256 );
           SSSheet_setColumnWidth( sheet: 16:  22 * 256 );
           SSSheet_setColumnWidth( sheet: 17:  17 * 256 );
           SSSheet_setColumnWidth( sheet: 18:  17 * 256 );
           SSSheet_setColumnWidth( sheet: 19:  17 * 256 );
           SSSheet_setColumnWidth( sheet: 20:  17 * 256 );
           SSSheet_setColumnWidth( sheet: 21:  17 * 256 );
           SSSheet_setColumnWidth( sheet: 22:  17 * 256 );
           SSSheet_setColumnWidth( sheet: 23:  17 * 256 );
           SSSheet_setColumnWidth( sheet: 24:  17 * 256 );
           SSSheet_setColumnWidth( sheet: 25:  17 * 256 );
           SSSheet_setColumnWidth( sheet: 26:  50 * 256 );
         when ( peTipo = 'H' );
           SSSheet_setColumnWidth( sheet: 04:  15 * 256 );
           SSSheet_setColumnWidth( sheet: 05:  18 * 256 );
           SSSheet_setColumnWidth( sheet: 06:  18 * 256 );
         when ( peTipo = 'V' );
           SSSheet_setColumnWidth( sheet: 04:  15 * 256 );
           SSSheet_setColumnWidth( sheet: 05:  18 * 256 );
           SSSheet_setColumnWidth( sheet: 06:  18 * 256 );
       endsl;

      /end-free

     P FormatColumns   E

      * ------------------------------------------------------------ *
      * SetHeadings(): Cargar encabezados                            *
      *                                                              *
      *     sheet  (input)  La hoja en la cual setear los titulos    *
      *  rowcount  (input/output) contador de filas (actualizado)    *
      *                                                              *
      * ------------------------------------------------------------ *
     P SetHeadings     B
     D SetHeadings     pi
     D   sheet                             like(ssSheet)

     D row             s                   like(SSRow)

      /free

       row = SSSheet_createRow(sheet: rowcount);
       ss_text( row: 00 : 'Poliza'             : TitColumn);
       ss_text( row: 01 : 'Nombre de Asegurado': TitColumn);
       ss_text( row: 02 : 'Cod. Productor'     : TitColumn);
       ss_text( row: 03 : 'Nombre de Productor': TitColumn);

       select;
         when ( peTipo = 'A' );
           ss_text( row: 04 : 'Cod. Organizador'   : TitColumn);
           ss_text( row: 05 : 'Nombre Organizador' : TitColumn);
           ss_text( row: 06 : 'Cod. Cob.'          : TitColumn);
           ss_text( row: 07 : 'Descripcion Cob.'   : TitColumn);
           ss_text( row: 08 : 'Cod. Marca'         : TitColumn);
           ss_text( row: 09 : 'Descripcion Marca'  : TitColumn);
           ss_text( row: 10 : 'Cod. Modelo'        : TitColumn);
           ss_text( row: 11 : 'Descripcion Modelo' : TitColumn);
           ss_text( row: 12 : 'Cod. SubMod.'       : TitColumn);
           ss_text( row: 13 : 'Descripcion SubMod.': TitColumn);
           ss_text( row: 14 : 'Patente'            : TitColumn);
           ss_text( row: 15 : 'Motor'              : TitColumn);
           ss_text( row: 16 : 'Chasis'             : TitColumn);
           ss_text( row: 17 : 'Suma Asegurada'     : TitColumn);
           ss_text( row: 18 : 'Prima'              : TitColumn);
           ss_text( row: 19 : 'Premio'             : TitColumn);
           ss_text( row: 20 : 'Tarifa'             : TitColumn);
           ss_text( row: 21 : 'Tipo de Inspeccion' : TitColumn);
           ss_text( row: 22 : 'Nombre de Inspector': TitColumn);
           ss_text( row: 23 : 'Domicilio/Nro'      : TitColumn);
           ss_text( row: 24 : 'Hora Inspeccion'    : TitColumn);
           ss_text( row: 25 : 'Fecha Inspeccion'   : TitColumn);
           ss_text( row: 26 : 'Observacion'        : TitColumn);
         when ( peTipo = 'H' );
           ss_text( row: 04 : 'Inicio Vig.'        : TitColumn);
           ss_text( row: 05 : 'Prima'              : TitColumn);
           ss_text( row: 06 : 'Premio'             : TitColumn);
         when ( peTipo = 'V' );
           ss_text( row: 04 : 'Inicio Vig.'        : TitColumn);
           ss_text( row: 05 : 'Prima'              : TitColumn);
           ss_text( row: 06 : 'Premio'             : TitColumn);
       endsl;

      /end-free

     P SetHeadings     E

      * ------------------------------------------------------------ *
      * chkWeb() Determina si Poliza desde la Web                    *
      * ------------------------------------------------------------ *
     P chkWeb...
     P                 B
     D chkWeb...
     D                 pi              n
     D  peEmpr                        1    const
     D  peSucu                        2    const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const

       k1y000.w0empr = peEmpr;
       k1y000.w0sucu = peSucu;
       k1y000.w0arcd = peArcd;
       k1y000.w0spol = peSpol;

       chain %kds ( k1y000 : 4 ) ctw00009;

       return %found ( ctw00009 ) and w0spol <> *Zeros;

     P chkWeb...
     P                 E

