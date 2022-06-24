     h Dftactgrp(*No)
     h option(*srcstmt: *nodebugio: *noshowcpy)
     h bnddir('HDIILE/HDIBDIR')
      **---------------------------------------------------------**
      *  Sistema       : CONSULTAS WEB
      *  Origen        : Software local
      *  Programa      : COW131
      *  Programacion  : Sergio Luis Puentes Valladares
      *  Fecha         : 2020/01/20
      *  Abr.Dev.      :
      *  Objetivo      : Consulta de Cotizaciones de Hogar
      *
      *
      *  Project Name  :
      *  Work ID       :

      **---------------------------------------------------------**
      *   Fecha    User    Modificacion
      **---------------------------------------------------------**
      * 24/03/2020 INF1SERG Elimino harcode rama 27 y tomo de parm.
      *
      * 09/08/2021 INF1RUBE Se agrega 2 enteros al campos Suma Asegurada
      *
      **---------------------------------------------------------**
      *  Objeto     D e s c r i p c i o n                         Tipo
      **---------------------------------------------------------**
      *  COW131FM   Consulta de Cotizaciones de Hogar             DSPF
      *  CTWER0     Cotización Web: Cabecera Riesgos Varios       PF
      *  CTWER2     Cotización Web: Coberturas Riesgos Varios     PF
      *  CTW000     Cotización Web: Cabecera de Cotizaciones      PF
      *  SET101     Capitulos de Tarifa                           PF
      *  SET102     Productos                                     PF
      *  SET104     Riesgos                                       PF
      *  SET107     Coberturas                                    PF
      *  SET162     Viviendas                                     PF
      *  GNTLOC     Localidad                                     PF
      *
      **---------------------------------------------------------**
      *  Ind        Uso
      *
      *
      *
      **---------------------------------------------------------**
     * Define Archivos
      **---------------------------------------------------------**
     fcow131fm  cf   e             Workstn
     f                                     Sfile(Cow131cs1:NrSfl)
     f                                     Sfile(Cow131cs2:RrSfl)
     f                                     InfDs(Iofb)
     fctwer0    if   e           k Disk
     fctwer2    if   e           k Disk
     fctw000    if   e           k Disk
     fset101    if   e           k Disk
     fset102    if   e           k Disk
     fset104    if   e           k Disk
     fset107    if   e           k Disk
     fset162    if   e           k Disk
     fgntloc    if   e           k Disk
      *---------------------------------------------------------------*
     * Define Estructura de Programa
      *---------------------------------------------------------------*
     d Parms          sds
     d  WsProg                 1     10
     d  WsStat                11     15  0
     d  ErrMsi                40     46
     d  ErrMsg                91    169
     d  JobNam               244    253
     d  WsPant               244    253
     d  Userid               254    263
     d  JobNbr               264    269
      *---------------------------------------------------------------*
     * Define Estructura de Pantalla
      *---------------------------------------------------------------*
     d Iofb            DS
     d  Wpfopn                 9      9
     d  Wpfeof                10     10
     d  WMsgid                46     52
     d  Wkypres              369    369
     d  WCurso               370    371B 0
     d  WSrn                 376    377B 0
     d  WSrnb                378    379B 0
      *
     d  F01            c                   Const(X'31')
     d  F02            c                   Const(X'32')
     d  F03            c                   Const(X'33')
     d  F04            c                   Const(X'34')
     d  F05            c                   Const(X'35')
     d  F06            c                   Const(X'36')
     d  F07            c                   Const(X'37')
     d  F08            c                   Const(X'38')
     d  F09            c                   Const(X'39')
     d  F10            c                   Const(X'3A')
     d  F11            c                   Const(X'3B')
     d  F12            c                   Const(X'3C')
     d  F13            c                   Const(X'B1')
     d  F14            c                   Const(X'B2')
     d  F15            c                   Const(X'B3')
     d  F16            c                   Const(X'B4')
     d  F17            c                   Const(X'B5')
     d  F18            c                   Const(X'B6')
     d  F19            c                   Const(X'B7')
     d  F20            c                   Const(X'B8')
     d  F21            c                   Const(X'B9')
     d  F22            c                   Const(X'BA')
     d  F23            c                   Const(X'BB')
     d  F24            c                   Const(X'BC')
     d  Enter          c                   Const(X'F1')
     d  Help           c                   Const(X'F3')
     d  PageUp         c                   Const(X'F4')
     d  PageDn         c                   Const(X'F5')
     d  Print          c                   Const(X'F6')

      *---------------------------------------------------------------*
     * Define Variables de Programa
      *---------------------------------------------------------------*
     d xVariables      ds                  Inz
     d  xInd                          5s 0
     d  xPos                          5s 0
     d  xLine                         5s 0
     d  xCiclo                        5s 0
     d  xRama1                        2s 0
     d  xPoco1                        4s 0
     d  xArse1                        2s 0

     d  xFormat                       2A
     d  xData                         1A
     d  xError                        1A

     d  xFecha                        8A
     d  xTime                         8A
     d  xFecha1                       8S 0
     d  xTime1                        8S 0
     d  xTime_S                      26A
     d  xTime0                        8A
     d  xFecha0                      10A
     d  xTime_Stamp    S               Z

      *---------------------------------------------------
     * Define Variables de Subfile
      *---------------------------------------------------
     d XSubfile        DS                  Inz
     d  NrSfl                         4S 0
     d  RrSfl                         4S 0
     d  SrSfl                         4S 0
     d  ZrSfl                         4S 0
     d  WsfNum1                       4S 0
     d  WsfNum2                       4S 0
     d  WsfNum3                       4S 0
     d  WsfNum4                       4S 0
     d  Wsftot1                       4S 0
     d  Wsftot2                       4S 0
     d  Wsftot3                       4S 0
     d  Wsftot4                       4S 0

      *---------------------------------------------------
     * Define Variables de Keys
      *---------------------------------------------------
     d xKey1           DS                  Inz
     d  xEMPR                         1a
     d  xSUCU                         2a
     d  xNIVT                         1s 0
     d  xNIVC                         5s 0
     d  xNCTW                         7s 0
     d  xRAMA                         2s 0
     d  xPOCO                         4s 0
     d  xARSE                         2s 0

      *---------------------------------------------------
     * Define parametros de programas invocados
      *---------------------------------------------------
     d xParms          DS                  Inz
     d  peEmpr1                       1a
     d  peSucu1                       2a
     d  peNivt1                       1a
     d  peNivc1                       5a
     d  peNctw1                       7a
     d  peRama1                       2a
     d  pePoco1                       4a
     d  peArse1                       2a
     d  peCobl1                       2a
     d  peErro1                      10i 0
     d  peMsgs1                      80a

     d  peEmpr2                       1a
     d  peSucu2                       2a
     d  peNivt2                       1a
     d  peNivc2                       5a
     d  peNctw2                       7a
     d  peRama2                       2a
     d  pePoco2                       4a
     d  peArse2                       2a
     d  peRiec2                       3a
     d  pexCob2                       3a
     d  peErro2                      10i 0
     d  peMsgs2                      80a

     d  peEmpr3                       1a
     d  peSucu3                       2a
     d  peNivt3                       1a
     d  peNivc3                       5a
     d  peNctw3                       7a
     d  peRama3                       2a
     d  pePoco3                       4a
     d  peArse3                       2a
     d  pexCob3                       3a
     d  peErro3                      10i 0
     d  peMsgs3                      80a

     d  peEmpr4                       1a
     d  peSucu4                       2a
     d  peNivt4                       1a
     d  peNivc4                       5a
     d  peNctw4                       7a
     d  peRama4                       2a
     d  peArse4                       2a
     d  pePoco4                       4a
     d  peRiec4                       3a
     d  pexCob4                       3a
     d  peErro4                      10i 0
     d  peMsgs4                      80a

      *---------------------------------------------------------------*
     * Define Constantes de Programa
      *---------------------------------------------------------------*
     d up              c                   'ABCDEFGHIJKLMNNOPQRSTUVWXY-
     d                                     ZAEIOUAEIOUNAEIOU'
     d lo              c                   'abcdefghijklmn¤opqrstuvwxy-
     d                                     z ?¡¢£???"¥µÖàé'

      *----------------------------------------------------------------*
     * Define copys
      *----------------------------------------------------------------*
      /copy './qcpybooks/svpint_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'

      *----------------------------------------------------------------*
     * Define klist de archivos
      *----------------------------------------------------------------*
     D k1twer0         ds                  likerec(C1wer0:*key)
     D k1twer2         ds                  likerec(C1wer2:*key)
     d k1tw000         ds                  likerec(C1w000:*key)
     D k1t101          ds                  likerec(S1t101:*key)
     D k1t102          ds                  likerec(S1t102:*key)
     D k1t104          ds                  likerec(S1t104:*key)
     D k1t107          ds                  likerec(S1t107:*key)
     D k1t162          ds                  likerec(S1t162:*key)
     D k1tloc          ds                  likerec(G1tloc:*key)

      *----------------------------------------------------------------*
     * Define programas invocados
      *----------------------------------------------------------------*
     d Main            pr                  ExtPgm('COW131    ')
     d  peEmpr                        1a   const
     d  peSucu                        2a   const
     d  peNivt                        1a   const
     d  peNivc                        5a   const
     d  peNctw                        7a   const
     d  peRama                        2a   const
      * peErro = 0 -> OK
      * peErro = -1 -> NO OK
     d  peErro                       10i 0
     d  peMsgs                       80a

     d Cobertura       pr                  ExtPgm('COW132    ')
     d  peEmpr2                       1a   const
     d  peSucu2                       2a   const
     d  peNivt2                       1a   const
     d  peNivc2                       5a   const
     d  peNctw2                       7a   const
     d  peRama2                       2a
     d  pePoco2                       4a
     d  peArse2                       2a
     d  peRiec2                       3a
     d  pexCob2                       3a
      * peErro = 0 -> OK
      * peErro = -1 -> NO OK
     d  peErro2                      10i 0
     d  peMsgs2                      80a

     d Descuentos      pr                  ExtPgm('COW133    ')
     d  peEmpr3                       1a   const
     d  peSucu3                       2a   const
     d  peNivt3                       1a   const
     d  peNivc3                       5a   const
     d  peNctw3                       7a   const
     d  peRama3                       2a
     d  pePoco3                       4a
     d  peArse3                       2a
     d  pexCob3                       3a
      * peErro = 0 -> OK
      * peErro = -1 -> NO OK
     d  peErro3                      10i 0
     d  peMsgs3                      80a


     d Objetos         pr                  ExtPgm('COW134    ')
     d  peEmpr4                       1a   const
     d  peSucu4                       2a   const
     d  peNivt4                       1a   const
     d  peNivc4                       5a   const
     d  peNctw4                       7a   const
     d  peRama4                       2a   const
     d  peArse4                       2a   const
     d  pePoco4                       4a   const
     d  peRiec4                       3a   const
     d  pexCob4                       3a   const
      * peErro = 0 -> OK
      * peErro = -1 -> NO OK
     d  peErro4                      10i 0
     d  peMsgs4                      80a

      *----------------------------------------------------------------*
     * Define parametros de programas invocados
      *----------------------------------------------------------------*
     d Main            pi
     d  peEmpr                        1a   const
     d  peSucu                        2a   const
     d  peNivt                        1a   const
     d  peNivc                        5a   const
     d  peNctw                        7a   const
     d  peRama                        2a   const
      * peErro = 0 -> OK
      * peErro = -1 -> NO OK
     d  peErro                       10i 0
     d  peMsgs                       80a

      *----------------------------------------------------------------*
     * Define renombre de campos
      *----------------------------------------------------------------*
     IS1t101
     I              T@Fech                      t@Fechx

      /Free
         //*--------------------------------------------------------*
         //*    C  u  e  r  p  o      P  r  i  n  c  i  p  a  l     *
         //*--------------------------------------------------------*
         // Inicializa variables
            Exsr RtvDtaSis;

         // Ciclo de Proceso - Paneles
            Dow xFormat <> *Blanks;
                Select;
                   When xFormat = '10';  // Panel Principal
                        Exsr HndDtaP10;
                   When xFormat = '20';  // Panel Componentes
                        Exsr HndDtaP20;
                EndSl;
            EndDo;

         // Fin de Programa
            *inlr = *On;

         //*--------------------------------------------------------*
         //* HndDtaP10 - Rutina Manejo Panel 10                     *
         //*--------------------------------------------------------*
          BegSr  HndDtaP10;

            // Inicializa variables de panel 10
            wMsg  = *Blanks;

            // Carga data de cabecera
            xxnivt = %Dec(peNivt:1:0);
            xxnivc = %Dec(peNivc:5:0);
            xxProd = SVPINT_GetNombre( peEmpr:
                                       peSucu:
                                       %Dec(peNivt:1:0):
                                       %Dec(peNivc:5:0));
            xxnctw = %Dec(peNctw:7:0);
            xxrama = %Dec(peRama:2:0);
            xxdram = SVPDES_rama( xxRama);
            // Carga data de cabecera
            Exsr RtvDtaCab;

            // Carga data de Subfile
            Exsr ChgDtaSfl1;

            // Ciclo Manejo Panel 10
            Dow xFormat = '10';

                // Despliega Subfile-Control
                Write  Cow131cca;
                Write  Cow131cp1;
                Exfmt  Cow131cc1;

                // F12 = Salir
                If  Wkypres  = F12;
                    xFormat  = *Blanks;
                EndIf;

                // Intro:Valida - Procesa
                If  Wkypres  = Enter;
                    Exsr ValDtaP10;
                    If   xError = *Blanks;
                         If  xData <> *Blanks;
                             xFormat  = '20';
                         EndIf;
                    EndIf;
                EndIf;

            EndDo;

          EndSr;

         //*--------------------------------------------------------*
         //* HndDtaP20 - Rutina Manejo Panel 20                     *
         //*--------------------------------------------------------*
          BegSr  HndDtaP20;

            // Inicializa variables de panel 20
            wMsg  = *Blanks;

            // Carga data de Subfile
            Exsr ChgDtaSfl2;

            // Ciclo Manejo Panel 20
            Dow xFormat = '20';

                // Despliega Subfile-Control
                Write  Cow131cca;
                Write  Cow131cp1;
                Exfmt  Cow131cc2;

                // F12 = volver
                If  Wkypres  = F12;
                    xxpoco   = 0;
                    xFormat  = '10';
                EndIf;

                // Intro:Valida - Procesa
                If  Wkypres  = Enter;
                    Exsr ValDtaP20;
                EndIf;

            EndDo;

          EndSr;

         //*--------------------------------------------------------*
         //* ValDtaP10 - Rutina Valida Datos Panel 10               *
         //*--------------------------------------------------------*
          BegSr  ValDtaP10;
              // Inicializa variables
              Clear xData;
              Clear wMsg;
              Clear xError;
              Clear xKey1;

              // Posicionamiento en Subfile
              If xxPoco <> *Zeros;
                 // Carga data de Subfile
                 If xxPoco <= Wsftot1;
                    Exsr ChgDtaSfl1;
                    LeaveSr;
                 EndIf;
              EndIf;

              // Valida datos
              For xCiclo = 1  to WsfNum1;
                  NrSfl = xCiclo;
                  Chain xCiclo  Cow131cs1;
                      If x1Opci <> *Zeros;
                         // Opciones
                         Select;
                           // Consulta
                           When x1Opci = 5;
                                xData = '1';
                                Clear  x1Opci;
                                Update Cow131cs1;
                                Leave;
                           // Error
                           Other;
                            wMsg   = 'Error..Opcion ingresada es incorrecta';
                             xError = '1';
                             Leave;
                         EndSl;
                       EndIf;
               EndFor;
          EndSr;


         //*--------------------------------------------------------*
         //* ValDtaP20 - Rutina Valida Datos Panel 20               *
         //*--------------------------------------------------------*
          BegSr  ValDtaP20;
              // Inicializa variables
              Clear xData;
              Clear wMsg;
              Clear xError;
              Clear xKey1;

              // Valida datos
              For xCiclo = 1  to WsfNum2;
                  RrSfl = xCiclo;
                  Chain xCiclo  Cow131cs2;
                    If x1Opci <> *Zeros;
                      Select;
                        // Descuentos
                        When x1Opci = 1;
                           peNivt3 = %Editc(x1Nivt:'X');
                           peNivt3 = %Editc(x1Nivt:'X');
                           peNivc3 = %Editc(x1Nivc:'X');
                           peNctw3 = %Editc(x1Nctw:'X');
                           peRama3 = %Editc(x1Rama:'X');
                           pePoco3 = %Editc(x1Poco:'X');
                           peArse3 = %Editc(x1Arse:'X');
                           pexCob3 = %Editc(x1xCob:'X');
                           Descuentos(x1Empr :
                                      x1Sucu :
                                      peNivt :
                                      peNivc :
                                      peNctw :
                                      peRama3:
                                      pePoco3:
                                      peArse3:
                                      pexCob3:
                                      peErro3:
                                      peMsgs3);
                            Clear  x1Opci;
                            update Cow131cs2;
                            Leave;
                           // Objetos
                           When x1Opci = 2;
                                peNivt4 = %Editc(x1Nivt:'X');
                                peNivc4 = %Editc(x1Nivc:'X');
                                peNctw4 = %Editc(x1Nctw:'X');
                                peRama4 = %Editc(x1Rama:'X');
                                peArse4 = %Editc(x1Arse:'X');
                                pePoco4 = %Editc(x1Poco:'X');
                                peRiec4 = x1Riec;
                                pexCob4 = %Editc(x1Xcob:'X');
                                Objetos(x1Empr :
                                        x1Sucu :
                                        peNivt :
                                        peNivc :
                                        peNctw :
                                        peRama4:
                                        peArse4:
                                        pePoco4:
                                        peRiec4:
                                        pexCob4:
                                        peErro4:
                                        peMsgs4);
                            Clear  x1Opci;
                            update Cow131cs2;
                            Leave;
                        Other;
                          wMsg   = 'Error..Opcion ingresada es incorrecta';
                          xError = '1';
                          Leave;
                      EndSl;
                    EndIf;
               EndFor;
          EndSr;

         //*--------------------------------------------------------*
         //* ChgDtaSfl1 - Rutina Carga Datos Subfile 1              *
         //*--------------------------------------------------------*
          BegSr  ChgDtaSfl1;

              // Limpia Subfile
              *in30 = '0';
              *in31 = '1';
              Write Cow131cc1;
              *in30 = '1';
              *in31 = '0';
              *in32 = '1';

              // Inicializa variables de Subfile
              NrSfl       = *Zeros;

              // Posicionamiento
              // asigna campos clave
              Clear k1twer0;
              k1twer0.r0empr = peEmpr;
              k1twer0.r0sucu = peSucu;
              k1twer0.r0nivt = %Dec(peNivt:1:0);
              k1twer0.r0nivc = %Dec(peNivc:5:0);
              k1twer0.r0nctw = %Dec(peNctw:7:0);
              If xxPoco = *Zeros;
                 // Posicionamiento
                 Setll %kds(k1twer0:5) CTwer0;
                 // Lectura de CTwer0
                 Reade %kds(k1twer0:5) CTwer0;
              Else;
                 k1twer0.r0rama = xRama1;
                 k1twer0.r0poco = xxPoco;
                 // Posicionamiento
                 Setll %kds(k1twer0:7) CTwer0;
                 // Lectura de CTwer0
                 Reade %kds(k1twer0:6) CTwer0;
              Endif;

              // Carga Subfile - Principal
              Dow Not %Eof(CTwer0);
                  Clear Cow131cs1;
                     // Carga datos
                     x1Nivt  = r0Nivt;
                     x1Nivc  = r0Nivc;
                     x1Poco  = r0Poco;
                     x1Rdes  = r0Rdes;

                     // Carga campos keys
                     x1Empr  = r0Empr;
                     x1Sucu  = r0Sucu;
                     x1Rama  = r0Rama;
                     x1Arse  = r0Arse;

                     // Guarda Rama
                     xRama1  = r0Rama;

                  NrSfl += 1;
                  Write Cow131cs1;
                  // Lectura de CTwer0
                  If xxPoco = *Zeros;
                     Reade %kds(k1twer0:5) CTwer0;
                  Else;
                     Reade %kds(k1twer0:6) CTwer0;
                  Endif;
              EndDo;

              //  Verifica, si cargo subfile
              If NrSfl = 0;
                 NrSfl += 1;
                 Write Cow131cs1;
              EndIf;

              //  Posiciona Record Subfile number, inicio
              xxPoco  = 0;
              WsfNum1 = NrSfl;
              //  Guarda total de registros Subfile
              If Wsftot1 = *Zeros;
                 Wsftot1 = NrSfl;
              EndIf;
              NrSfl   = 1;

          EndSr;

         //*--------------------------------------------------------*
         //* ChgDtaSfl2 - Rutina Carga Datos Subfile 2              *
         //*--------------------------------------------------------*
          BegSr  ChgDtaSfl2;

              // Limpia Subfile
              *in33 = '0';
              *in34 = '1';
              Write Cow131cc2;
              *in33 = '1';
              *in34 = '0';
              *in35 = '1';

              // Inicializa variables de Subfile
              RrSfl       = *Zeros;

              // Carga datos en control
              Exsr ChgDtaTab1;

              // Posicionamiento
              // asigna campos clave
              Clear k1twer2;
              k1twer2.r2empr = peEmpr;
              k1twer2.r2sucu = peSucu;
              k1twer2.r2nivt = %Dec(peNivt:1:0);
              k1twer2.r2nivc = %Dec(peNivc:5:0);
              k1twer2.r2nctw = %Dec(peNctw:7:0);
              k1twer2.r2rama = %dec(peRama:2:0);
              // Posicionamiento
              Setll %kds(k1twer2:6) CTwer2;
              // Lectura de CTwer2
              Reade %kds(k1twer2:6) CTwer2;

              // Carga Subfile - Principal
              Dow Not %Eof(CTwer2);
                    Clear Cow131cs2;
                     // Carga datos
                     x1Empr  = r2Empr;
                     x1Sucu  = r2Sucu;
                     x1Nivt  = r2Nivt;
                     x1Nivc  = r2Nivc;
                     x1Nctw  = r2Nctw;
                     x1Rama  = r2Rama;
                     x1Arse  = r2Arse;
                     x1Poco  = r2Poco;
                     x1Riec  = r2Riec;
                     x1Xcob  = r2Xcob;
                       // Lectura de archivo set102
                       Clear k1t102;
                       k1t107.t@rama = xRama1;
                       k1t107.t@cobc = r2xcob;
                       Chain %kds(k1t107) Set107;
                         x1Dxco = t@cobd;
                     x1Saco  = r2Saco;
                     x1Ptco  = r2Ptco;
                     x1Xpri  = r2Xpri;

                    RrSfl += 1;
                    Write Cow131cs2;
                  // Lectura de CTwer2
                  Reade %kds(k1twer2:6) CTwer2;
              EndDo;

              //  Verifica, si cargo subfile
              If RrSfl = 0;
                 *in40  = *on;
                 RrSfl += 1;
                 Write Cow131cs2;
              EndIf;

              //  Posiciona Record Subfile number, inicio
              WsfNum2 = RrSfl;
              RrSfl   = 1;
              //  Guarda total de registros Subfile
              If Wsftot2 = *Zeros;
                 Wsftot2 = RrSfl;
              EndIf;

          EndSr;

         //*--------------------------------------------------------*
         //* RtvDtaCab  - Rutina Recupera datos de Tabla CTw000     *
         //*--------------------------------------------------------*
          BegSr  RtvDtaCab;

              // Inicializa registro
              Clear C1W000;

              // Posicionamiento
              Clear k1tw000;
              k1tw000.w0empr = peEmpr;
              k1tw000.w0sucu = peSucu;
              k1tw000.w0nivt = %Dec(peNivt:1:0);
              k1tw000.w0nivc = %Dec(peNivc:5:0);
              k1tw000.w0nctw = %Dec(peNctw:7:0);
              // Lectura de archivo CTw000
              Chain %kds(k1tw000) CTw000;
                  xxArcd = W0Arcd;
                  xxArno = W0Arno;

          EndSr;

         //*--------------------------------------------------------*
         //* RtvDtaTab1 - Rutina Recupera datos de Tabla CTwer0     *
         //*--------------------------------------------------------*
          BegSr  ChgDtaTab1;

              // Inicializa registro
              Clear C1WER0;

              // Posicionamiento
              Clear k1twer0;
              k1twer0.r0empr = xEmpr;
              k1twer0.r0sucu = xSucu;
              k1twer0.r0nivt = xnivt;
              k1twer0.r0nivc = xnivc;
              k1twer0.r0nctw = xnctw;
              k1twer0.r0rama = xrama;
              k1twer0.r0poco = xpoco;
              k1twer0.r0arse = xarse;
              // Lectura de archivo CTwer0
              Chain %kds(k1twer0) CTwer0;

              // Carga datos en form - Pantalla
              xxPoco = r0Poco;
              xxXpro = r0Xpro;
                // Lectura de archivo set102
                Clear k1t102;
                k1t102.t@rama = xRama1;
                k1t102.t@xpro = r0xpro;
                  Chain %kds(k1t102) Set102;
                  xxdxpr= t@prds;
              xxRpro = r0Rpro;
              xxRdep = r0Rdep;
              xxRloc = r0Rloc;
              xxBlck = r0Blck;
              If r0Blck = *Blanks;
                 xxBlck = '0000000000';
              EndIf;
              xxRdes = r0Rdes;
              xxNrdm = r0Nrdm;
              xxCopo = r0Copo;
              xxCops = r0Cops;
                // Lectura de archivo gntloc
                Clear k1tloc;
                k1tloc.locopo = r0copo;
                k1tloc.locops = r0cops;
                  Chain %kds(k1tloc:1) Gntloc;
                  xxDcop = %Subst(loloca:1:24);
              xxSuas = r0Suas;
              xxSamo = r0Samo;
              xxCviv = r0Cviv;
                // Lectura de archivo set162
                Clear k1t162;
                k1t162.t@cviv = r0Cviv;
                  Chain %kds(k1t162:1) Set162;
                  xxDcvi = %Subst(t@Dviv:1:24);
              xxClfr = r0Clfr;
              xxCagr = r0Cagr;
              xxCtar = r0Ctar;
                // Lectura de archivo set101
                Clear k1t101;
                Clear t@ctds;
                k1t101.t@rama = xRama1;
                k1t101.t@ctar = r0ctar;
                k1t101.t@cta1 = '1 ';
                k1t101.t@cta2 = *Blanks;
                  Chain %kds(k1t101) Set101;
                  xxdcta= t@ctds;
              xxCta1 = r0Cta1;
                // Lectura de archivo set101
                Clear k1t101;
                Clear t@ctds;
                k1t101.t@rama = xRama1;
                k1t101.t@ctar = r0ctar;
                k1t101.t@cta1 = r0cta1;
                k1t101.t@cta2 = *Blanks;
                  Chain %kds(k1t101) Set101;
                  xxdct1= t@ctds;
              xxCta2 = r0Cta2;
                // Lectura de archivo set101
                Clear k1t101;
                Clear t@ctds;
                If xxCta2 <> *Blanks;
                   k1t101.t@rama = xRama1;
                   k1t101.t@ctar = r0ctar;
                   k1t101.t@cta1 = r0cta1;
                   k1t101.t@cta2 = r0cta2;
                     Chain %kds(k1t101) Set101;
                     xxdct2= t@ctds;
                EndIf;

          EndSr;

         //*--------------------------------------------------------*
         //* RtvPrmPrc - Rutina Recupera Parametros de Proceso      *
         //*--------------------------------------------------------*
          BegSr  RtvPrmPrc;

             // Recupera fecha de proceso
             xTime_Stamp = %Timestamp();
             xTime_S     = %Char(xTime_Stamp);
             xFecha      = %Subst(xTime_S:01:04)
                         + %Subst(xTime_S:06:02)
                         + %Subst(xTime_S:09:02);
             xFecha0     = %Subst(xTime_S:09:02) + '/'
                         + %Subst(xTime_S:06:02) + '/'
                         + %Subst(xTime_S:01:04);
             xTime       = %Subst(xTime_S:12:02)
                         + %Subst(xTime_S:15:02)
                         + %Subst(xTime_S:18:02)
                         + %Subst(xTime_S:21:02);
             xTime0      = %Subst(xTime_S:12:02)
                         + %Subst(xTime_S:15:02)
                         + %Subst(xTime_S:18:02)
                         + %Subst(xTime_S:21:02);
             xFecha1     = %Int(xFecha);
             xTime1      = %Int(xTime);

          EndSr;
         //*--------------------------------------------------------*
         //* RtvDtaSis - Rutina Inicial, Recupera datos de Sistema  *
         //*--------------------------------------------------------*
          BegSr  RtvDtaSis;

             //  Recupera Parametros de Proceso
             Exsr RtvPrmPrc;

             // Inicializa variables de programas
             xFormat = '10';

          EndSr;

      /End-Free
