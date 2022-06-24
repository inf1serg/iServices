     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRLR2:  QUOM Versión 2                                      *
      *          Libro rubricado de operaciones en XML               *
      * ------------------------------------------------------------ *
      * Sergio Fernandez               *03-May-2021                  *
      * ************************************************************ *
     Fpahlrc    if   e           k disk
     Fsehni201  if   e           k disk
     Fpahec1    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/GETSYSV_H.rpgle'

     D uri             s            512a
     D url             s           3000a   varying
     D Data            s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D fema            s              4a
     D femm            s              2a
     D quin            s              1a

     D @care           s             10i 0
     D @tiso           s              1a
     D @@Stat          s              1a
     D peResp          s             10i 0
     D peQuin          s              1  0

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)
     D  JobName                      10a   overlay(PsDs:244)
     D  JobUser                      10a   overlay(PsDs:254)
     D  JobNbr                        6  0 overlay(PsDs:264)

     D k1hni2          ds                  likerec(s1hni201 : *key)
     D k1hlrc          ds                  likerec(p1hlrc   : *key)
     D k1hec1          ds                  likerec(p1hec1   : *key)

     D proNi2          ds                  likerec(s1hni201 : *input)
     D orgNi2          ds                  likerec(s1hni201 : *input)

     D rc              s              1n

      /free

       *inlr = *on;

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
       fema = REST_getNextPart(url);
       femm = REST_getNextPart(url);
       quin = REST_getNextPart(url);

       k1hni2.n2empr = empr;
       k1hni2.n2sucu = sucu;
       k1hni2.n2nivt = %dec(nivt:1:0);
       k1hni2.n2nivc = %dec(nivc:5:0);
       chain %kds(k1hni2) sehni201 proNi2;
       if not %found;
          return;
       endif;

       if rtvSysName() <> 'POWER7';
          proNi2.n2matr = 1;
       endif;

       if proNi2.dftiso = 98;
          @tiso = '1';
        else;
          @tiso = '2';
       endif;

       k1hlrc.d0empr = empr;
       k1hlrc.d0sucu = sucu;
       k1hlrc.d0nivt = %dec(nivt:1:0);
       k1hlrc.d0nivc = %dec(nivc:5:0);
       k1hlrc.d0fema = %dec(fema:4:0);
       k1hlrc.d0femm = %dec(femm:2:0);
       k1hlrc.d0quin = pequin;
       if pequin > 0;
          setll %kds(k1hlrc:7) pahlrc;
          reade %kds(k1hlrc:7) pahlrc;
       else;
          setll %kds(k1hlrc:6) pahlrc;
          reade %kds(k1hlrc:6) pahlrc;
       endif;
       dow not %eof;
           @care += 1;
        if pequin > 0;
           reade %kds(k1hlrc:7) pahlrc;
        else;
           reade %kds(k1hlrc:6) pahlrc;
        endif;
       enddo;

       REST_writeHeader();

       data = '<?xml version="1.0" encoding="utf-8"?>'
            + '<SSN>'
            + '<Cabecera>'
            + '<Productor TipoPersona="'
            + @tiso
            + '" Matricula="'
            + %trim(%char(proNi2.n2matr))
            + '" />'
            + ' <CantidadRegistros>'
            + %trim(%char(@care))
            + '</CantidadRegistros>'
            + '</Cabecera>'
            + '<Detalle>';
       REST_write(Data);

       // --------------------------------------------------
       // Procesa el detalle de cuotas
       // --------------------------------------------------
       if pequin > 0;
          setll %kds(k1hlrc:7) pahlrc;
          reade %kds(k1hlrc:7) pahlrc;
       else;
          setll %kds(k1hlrc:6) pahlrc;
          reade %kds(k1hlrc:6) pahlrc;
       endif;
       dow not %eof;

           k1hec1.c1empr = d0empr;
           k1hec1.c1sucu = d0sucu;
           k1hec1.c1arcd = d0arcd;
           k1hec1.c1spol = d0spol;
           k1hec1.c1sspo = d0sspo;
           chain %kds(k1hec1) pahec1;
           if %found;
              k1hni2.n2nivt = 3;
              k1hni2.n2nivc = c1niv3;
              chain %kds(k1hni2) sehni201 orgNi2;
              if not %found;
                 orgNi2 = proNi2;
              endif;
           endif;

           if rtvSysName() <> 'POWER7';
              orgNi2.n2matr = 1;
           endif;

           data = '<Registro>';
           REST_write(Data);

           data = '<TipoRegistro>';
           if d0prem >= 0;
              data = %trim(Data) + '1';
            else;
              data = %trim(Data) + '3';
           endif;
           data = %trim(Data) + '</TipoRegistro>';
           REST_write(Data);

           data = '<FechaRegistro>'
                + %editc(d0fasa:'X')
                + '-'
                + %editc(d0fasm:'X')
                + '-'
                + %editc(d0fasd:'X')
                + '</FechaRegistro>';
           REST_write(Data);

           data = '<Concepto>P: '
                + %trim(%char(d0poli))
                + ' C: '
                + %trim(%char(d0nrcu))
                + ' S: '
                + %trim(%char(d0nrsc))
                + '</Concepto>';
           REST_write(Data);

           data = '<Polizas><Poliza>'
                + %trim(%char(d0poli))
                + '</Poliza></Polizas>';
           REST_write(Data);

           data = '<CiaID>0335</CiaID>';
           REST_write(Data);

           data = '<Organizador TipoPersona="';
           REST_write(Data);

           data = @tiso
                + '" Matricula="'
                + %trim(%char(orgNi2.n2matr))
                + '" />';
           REST_write(Data);

           data = '<Importe>'
                + %trim(%editw(d0prem: '             ,  '))
                + '</Importe>';
           REST_write(Data);

           data = '<ImporteTipo>';
           select;
            when d0mone = '00' or d0mone = '01';
                 data = %trim(Data) + '1';
            when d0mone = '51';
                 data = %trim(Data) + '2';
            when d0mone = '17';
                 data = %trim(Data) + '3';
           endsl;
           data = %trim(Data) + '</ImporteTipo>';
           REST_write(Data);

           data = '</Registro>';
           REST_write(Data);

        if pequin > 0;
           reade %kds(k1hlrc:7) pahlrc;
        else;
           reade %kds(k1hlrc:6) pahlrc;
        endif;
       enddo;

       data = '</Detalle></SSN>';
       REST_write(Data);

       return;

      /end-free

      /define GETSYSV_LOAD_PROCEDURE
      /copy './qcpybooks/GETSYSV_H.rpgle'
