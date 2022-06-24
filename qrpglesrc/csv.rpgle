     H nomain
     H bnddir('QC2LE')
      * ********************************************************** *
      * CSV: Programa de Servivio para parsear cualquier documento *
      *      separado por comas (u otro delimitador).              *
      *                                                            *
      * ---------------------------------------------------------- *
      * Sergio Fernandez              *16-Sep-2011                 *
      * ********************************************************** *

      /copy HDIILE/QCPYBOOKS,BUFIO_H
      /copy HDIILE/QCPYBOOKS,CSV_H

      * --------------------------------------------------------- *
      * Constantes
      * --------------------------------------------------------- *

      * Longitud para varying
     D VARPREF         C                   2
     D LINEFEED        C                   X'25'
     D CARRTN          C                   X'0D'

      * Template de archivo
     D CSVFILE_t       ds                  qualified
     D    fp                           *           inz(*NULL)
     D    buf                     65502A   varying inz('')
     D    bufpos                     10I 0         inz(0)
     D    flddel                      1A           inz(',')
     D    strdel1                     1A           inz('"')
     D    strdel2                     1A           inz('''')

      * --------------------------------------------------------- *
      * Enviar *ESCAPE
      * --------------------------------------------------------- *
     D ReportError     PR
     D   peMsg                      256a   varying const
     D                                     options(*varsize:*nopass:*omit)


      * --------------------------------------------------------- *
      * CSV_open(): Abrir archivo
      *
      *    peFilename = (input) Path del IFS al archivo
      *     peStrDel1 = (input/omit) Delimitador de Strings
      *                  si *OMIT, uso comillas dobles
      *     peStrDel2 = (input/omit) Delimitador de Strings
      *                  si *OMIT, uso comilla simple
      *      peFldDel = (input/omit) Delimitador de campos
      *                  si *OMIT, uso coma
      *
      * retorna un CSV_HANDLE usado para "seguir" al archivo abierto
      *        como hace open() de C. Si hay error, manda un *ESCAPE
      * --------------------------------------------------------- *
     P CSV_open        B                   export
     D CSV_open        PI                  like(CSV_HANDLE)
     D   peFilename                5000A   varying const options(*varsize)
     D   peStrDel1                    1A   const options(*omit:*nopass)
     D   peStrDel2                    1A   const options(*omit:*nopass)
     D   peFldDel                     1A   const options(*omit:*nopass)

     D myCSV           ds                  likeds(CSVFILE_t)
     D                                     inz(*LIKEDS)
     D CSV             ds                  likeds(CSVFILE_t)
     D                                     based(p_CSV)

      /free
         if (%parms>=2 and %addr(peStrDel1)<>*NULL);
            myCSV.StrDel1 = peStrDel1;
         endif;
         if (%parms>=3 and %addr(peStrDel2)<>*NULL);
            myCSV.StrDel2 = peStrDel2;
         endif;
         if (%parms>=4 and %addr(peFldDel)<>*NULL);
            myCSV.FldDel = peFldDel;
         endif;

         myCSV.fp = fopen(%trim(peFilename): 'r');
         if (myCSV.fp = *NULL);
            ReportError();
         endif;

         myCSV.buf = '';

         monitor;
            p_CSV = %alloc(%size(CSV));
         on-error;
            ReportError('Imposible reservar memoria para el archivo!.');
         endmon;

         CSV = myCSV;
         csv_rewindrec(p_CSV);
         return p_CSV;
      /end-free
     P                 E


      * --------------------------------------------------------- *
      * CSV_loadrec(): Carga un registro completo en memoria
      *
      *     peHandle = (i/o) Este es el handle que retorna CSV_open()
      *
      * Reotna  *ON si ok, *OFF por falla o EOF
      * --------------------------------------------------------- *
     P CSV_loadrec     B                   export
     D CSV_loadrec     PI             1N
     D   peHandle                          like(CSV_HANDLE) value

     D CSV             DS                  likeds(CSVFILE_t)
     D                                     based(peHandle)

     D p_buf           s               *
     D len             s             10I 0

      /free

         %len(CSV.buf) = %size(CSV.buf) - VARPREF;

         p_buf = fgets( %addr(CSV.buf) + VARPREF
                      : %size(CSV.buf) - VARPREF
                      : CSV.fp );

         if (p_buf = *NULL);
            return *OFF;
         endif;

         len = %len(%str(p_buf));
         %len(CSV.buf) = len;

         if (%subst(CSV.buf : len : 1) = LINEFEED );
            len = len - 1;
            %len(CSV.buf) = len;
         endif;

         if (%subst(CSV.buf : len : 1) = CARRTN );
            len = len - 1;
            %len(CSV.buf) = len;
         endif;

         csv_rewindrec(peHandle);

         return *ON;
      /end-free
     P                 E


      * --------------------------------------------------------- *
      * CSV_rewindfile():  Retorna el cursor al comienzo de archivo
      *                    (para leerlo nuevamente desde inicio)
      *
      *   peHandle = (i/o) el handle que devuelve CSV_open()
      *
      * Retorna *ON si ok, *OFF si falla.
      * --------------------------------------------------------- *
     P CSV_rewindfile  B                   EXPORT
     D CSV_rewindfile  PI             1N
     D   peHandle                          like(CSV_HANDLE) value

     D CSV             DS                  likeds(CSVFILE_t)
     D                                     based(peHandle)
      /free
         if fseek( CSV.fp: 0: 0 ) = -1;
            ReportError();
            return *OFF;
         else;
            csv_rewindrec(peHandle);
            return *ON;
         endif;
      /end-free
     P                 E


      * --------------------------------------------------------- *
      * CSV_getfld(): Recupera siguiente campo del registro
      *
      *  peHandle = (i/o)  handle devuelto por CSV_open()
      * peFldData = (output) Datos leídos
      * peVarSize = (input) Tamaño, en bytes, de peFldData
      *                     (OJO! incluye los dos bytes de la
      *                     longitud -es varying-)
      *
      * Retorna *ON si leyó datos, *OFF si no
      * --------------------------------------------------------- *
     P CSV_getfld      B                   export
     D CSV_getfld      PI             1N
     D   peHandle                          like(CSV_HANDLE) value
     D   peFldData                65502A   varying options(*varsize)
     D   peVarSize                   10I 0 value

     D UNQUOTED        C                   0
     D QUOTED          C                   1
     D ENDQUOTE        C                   2

     D CSV             DS                  likeds(CSVFILE_t)
     D                                     based(peHandle)

     D state           s             10i 0 inz(UNQUOTED)
     D max             s             10I 0
     D len             s             10I 0
     D start           s             10I 0
     D pos             s             10I 0
     D char            s              1A   based(p_char)
     D qchar           s              1A

      /free

         max = peVarSize - VARPREF;
         len = %len(CSV.buf) - 1;
         start = CSV.bufpos;
         %len(peFldData) = 0;

         if (start > len);
             return *OFF;
         endif;

         for pos = start to len;

             p_char = %addr(CSV.buf) + VARPREF + pos;

             select;
             when state = UNQUOTED;

                select;
                when char = CSV.flddel;
                   leave;
                when char = CSV.strdel1
                  or char = CSV.strDel2;
                   state = QUOTED;
                   qchar = char;
                when %len(peFldData) < max;
                   peFldData += char;
                endsl;

             when state = QUOTED;

                 select;
                 when char = qchar;
                    state = ENDQUOTE;
                 when %len(peFldData) < max;
                    peFldData += char;
                 endsl;

             when state = ENDQUOTE;

                select;
                when char = qchar;
                    state = QUOTED;
                    if (%len(peFldData) < max);
                       peFldData += char;
                    endif;
                when char = CSV.flddel;
                    leave;
                when char = CSV.strdel1
                  or char = CSV.strDel2;
                    state = QUOTED;
                    qchar = char;
                when %len(peFldData) < max;
                    state = UNQUOTED;
                    peFldData += char;
                endsl;

             endsl;

         endfor;

         CSV.bufpos = pos + 1;
         return *ON;
      /end-free
     P                 E


      * --------------------------------------------------------- *
      * CSV_rewindrec():  Retorna cursor al comienzo
      *                  (para releer los campos de todo el registro)
      *
      *   peHandle = (i/o) el handle que retorna CSV_open
      *
      * Retorna *ON si ok, *OFF si no
      * --------------------------------------------------------- *
     P CSV_rewindrec   B                   EXPORT
     D CSV_rewindrec   PI             1N
     D   peHandle                          like(CSV_HANDLE) value

     D CSV             DS                  likeds(CSVFILE_t)
     D                                     based(peHandle)
      /free
         CSV.bufpos = 0;
         return *ON;
      /end-free
     P                 E


      * --------------------------------------------------------- *
      * CSV_close(): Cierra archivo
      *
      *  peHandle = (i/o) handle que retorna CSV_open()
      *                   se setea a *NULL cuando el archivo es
      *                   cerrado correctamente.
      *
      * Retorna un *ESCAPE si termina bien, si no retorna nada
      * --------------------------------------------------------- *
     P CSV_close       B                   export
     D CSV_close       PI
     D   peHandle                          like(CSV_HANDLE)
     D CSV             DS                  likeds(CSVFILE_t)
     D                                     based(p_CSV)

      /free

         p_CSV = peHandle;
         if (fclose(CSV.fp) <> 0);
            ReportError();
         endif;
         dealloc p_CSV;
         peHandle = *null;

      /end-free
     P                 E


      * --------------------------------------------------------- *
      * ReportError():  Envia *ESCAPE
      *
      *    peMsg = (input/optional) si llega, este mensaje se
      *                 envía como CPF9897 al llamador.
      *                 Si no viene, envía un CPExxxx, donde xxxx
      *                 es el valor de la global errno de C.
      *
      * No hay retorno. Llamar a este proc() voltea el service program.
      * --------------------------------------------------------- *
     P ReportError     B
     D ReportError     PI
     D   peMsg                      256a   varying const
     D                                     options(*varsize:*nopass:*omit)

     D my_errno_func   PR              *   ExtProc('__errno')
     D my_errno        s             10I 0 based(p_my_errno)

     D QMHSNDPM        PR                  ExtPgm('QMHSNDPM')
     D   MessageID                    7A   Const
     D   QualMsgF                    20A   Const
     D   MsgData                  32767A   Const options(*varsize)
     D   MsgDtaLen                   10I 0 Const
     D   MsgType                     10A   Const
     D   CallStkEnt                  10A   Const
     D   CallStkCnt                  10I 0 Const
     D   MessageKey                   4A
     D   ErrorCode                32767A   options(*varsize)

     D ErrorCode       DS                  qualified
     D  BytesProv                    10I 0 inz(0)
     D  BytesAvail                   10I 0 inz(0)

     D MsgKey          S              4A
     D MsgID           s              7A
     D MsgDta          s            256a   varying

      /free

         if  %parms>=1 and %addr(peMsg)<>*null;
            MsgId = 'CPF9897';
            MsgDta = peMsg;
         else;
            p_my_errno = my_errno_func();
            MsgID = 'CPE' + %editc( %dec(my_errno:4:0) : 'X' );
            %len(MsgDta) = 0;
         endif;

         QMHSNDPM( MsgID
                 : 'QCPFMSG   *LIBL'
                 : MsgDta
                 : %len(MsgDta)
                 : '*ESCAPE'
                 : '*PGMBDY'
                 : 1
                 : MsgKey
                 : ErrorCode         );

      /end-free
     P                 E
