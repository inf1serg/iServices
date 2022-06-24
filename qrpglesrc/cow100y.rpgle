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
      **********************************************************************
     Fpawpd0    if   e           k disk
     Fpahed0    if   e           k disk
     Fpahec1    if   e           k disk
     Fsehni2    if   e           k disk
     Fgnhdaf    if   e           k disk
     Fctw00009  if   e           k disk

      /copy './qcpybooks/hssf_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'

     DCOW100Y          pr                  EXTPGM('COW100Y')
     D  tipo                          1    const

     DCOW100Y          pi
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

     D rama            s              1

     D k1y000          ds                  likerec(c1w000:*key)
     D k1yec1          ds                  likerec(p1hec1:*key)
     D k1yni2          ds                  likerec(s1hni2:*key)
     D k1yed0          ds                  likerec(p1hed0:*key)

       ADDCPATH ( );

       ss_begin_object_group(100);
       book = new_XSSFWorkbook();
       CreateCellStyles();
       Sheet = SS_newSheet(book: 'Hoja1');
       FormatColumns( sheet );
       SetHeadings( sheet );

       setll *start pawpd0;
       read pawpd0;

       dow not %eof ( pawpd0 );

         rama = SVPWS_getGrupoRama ( z0rama );

         if ( rama = peTipo );

           if chkWeb ( z0empr : z0sucu : z0arcd : z0spo1 );

             k1yec1.c1empr = z0empr;
             k1yec1.c1sucu = z0sucu;
             k1yec1.c1arcd = z0arcd;
             k1yec1.c1spol = z0spo1;
             k1yec1.c1sspo = z0sspo;
             chain %kds ( k1yec1 ) pahec1;

             k1yni2.n2empr = z0empr;
             k1yni2.n2sucu = z0sucu;
             k1yni2.n2nivt = c1nivt;
             k1yni2.n2nivc = c1nivc;
             chain %kds ( k1yni2 ) sehni2;

             chain n2nrdf gnhdaf;

             select;
               when ( rama = 'H' );

                 k1yed0.d0empr = z0empr;
                 k1yed0.d0sucu = z0sucu;
                 k1yed0.d0arcd = z0arcd;
                 k1yed0.d0spol = z0spo1;
                 k1yed0.d0sspo = z0sspo;
                 k1yed0.d0rama = z0rama;
                 k1yed0.d0arse = z0arse;
                 k1yed0.d0oper = z0oper;
                 k1yed0.d0suop = z0suop;

                 chain %kds ( k1yed0 ) pahed0;

                 exsr SuspHogar;

             endsl;

           endif;

         endif;

         read pawpd0;

       enddo;

       if ( rowcount > *Zeros );
         select;
           when ( peTipo = 'H' );
             SS_save(book: '/tmp/suspHogar.xls' );
             SNDMAIL ( 'EMISION WEB' : 'HOGAR SUSP' );
         endsl;
       endif;

       ss_end_object_group();

       *inlr = *on;

       begsr suspHogar;

         rowcount += 1;
         row = SSSheet_createRow(sheet: rowcount);

         ss_num ( row: 00: w0nctw : CellNumer);
         ss_num ( row: 01: c1asen : CellNumer);
         ss_num ( row: 02: c1nivc : CellNumer);
         ss_text( row: 03: %trim ( dfnomb ) : CellTexto);

         monitor;
           ss_date( row: 04: %date ( d0fioa * 10000
                                   + d0fiom * 100
                                   + d0fiod ) : CellDates);
         on-error;
           ss_text( row: 04: *Blanks      : CellTexto);
         endmon;

         monitor;
           ss_date( row: 05: %date ( w0fpro ) : CellDates);
         on-error;
           ss_text( row: 05: *Blanks           : CellTexto);
         endmon;

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
       SSSheet_setColumnWidth( sheet: 01:  56 * 256 );
       SSSheet_setColumnWidth( sheet: 02:  15 * 256 );
       SSSheet_setColumnWidth( sheet: 03:  45 * 256 );

       select;
         when ( peTipo = 'H' );
           SSSheet_setColumnWidth( sheet: 04:  15 * 256 );
           SSSheet_setColumnWidth( sheet: 05:  15 * 256 );
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
       ss_text( row: 00 : 'Cotizacion'         : TitColumn);
       ss_text( row: 01 : 'Nombre de Asegurado': TitColumn);
       ss_text( row: 02 : 'Cod. Productor'     : TitColumn);
       ss_text( row: 03 : 'Nombre de Productor': TitColumn);

       select;
         when ( peTipo = 'H' );
           ss_text( row: 04 : 'Inicio Vigencia'    : TitColumn);
           ss_text( row: 05 : 'Ingreso Cia.'       : TitColumn);
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

