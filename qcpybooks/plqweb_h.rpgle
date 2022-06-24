      * ------------------------------------------------------------ *
      /if defined(PLQWEB_H)
      /eof
      /endif
      /define PLQWEB_H

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy HDIILE/QCPYBOOKS,MAIL_H
      /copy HDIILE/QCPYBOOKS,svpvls_h
      /copy HDIILE/QCPYBOOKS,svpdaf_h
      /copy HDIILE/QCPYBOOKS,spvspo_h
      /copy HDIILE/QCPYBOOKS,dtaq_h

      * ------------------------------------------------------------ *
      * PLQWEB_nuevaPreliquidacion(): genera cuotas pendientes de    *
      *                               pago para el productor.        *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (output)  Número de Preliquidación              *
      *     peFhas   (output)  Fecha Hasta de Cuotas (aaaammdd)      *
      *     peDaut   (input)   Incluir debito automatico S o N?      *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_nuevaPreliquidacion...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0
     D   peFhas                       8  0
     D   peDaut                       1a   const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_marcarDeudaAnterior(): marca para pagar toda la Deuda *
      *                               Anterior de la preliquidación. *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_marcarDeudaAnterior...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarDeudaAnterior(): Desmarca para pagar toda la *
      *                                  Deuda Anterior de la Preli- *
      *                                  quidación.                  *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_desmarcarDeudaAnterior...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_marcarQuincenaAnterior(): marca para pagar toda la    *
      *                                  Quincena Anterior de la     *
      *                                  Preliquidación.             *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_marcarQuincenaAnterior...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarQuincenaAnterior(): Desmarca para pagar toda *
      *                                     la Quincena Anterior de  *
      *                                     la prequidación.         *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_desmarcarQuincenaAnterior...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_marcarQuincenaActual():   marca para pagar toda la    *
      *                                  Quincena Actual de la       *
      *                                  Preliquidación.             *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_marcarQuincenaActual...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarQuincenaActual():   Desmarca para pagar toda *
      *                                     la Quincena Actual de    *
      *                                     la prequidación.         *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_desmarcarQuincenaActual...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_marcarQuincenaSiguiente(): marca para pagar toda la   *
      *                                   Quincena Siguiente de la   *
      *                                   Preliquidación.            *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_marcarQuincenaSiguiente...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarQuincenaSiguiente(): Desmarca para pagar to- *
      *                                      da la Quincena Siguien- *
      *                                      te de la prequidación.  *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_desmarcarQuincenaSiguiente...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_marcarSaldo(): marca para pagar todo en Saldo de la   *
      *                       preliquidación.                        *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_marcarSaldo...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarSaldo(): Desmarca para pagar todo el Saldo   *
      *                          de la Preliquidación                *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_desmarcarSaldo...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_marcarDeudaAnteriorSuperPolizaEndoso(): marca para    *
      *                                                pagar la Deu- *
      *                                                da Anterior   *
      *                                                de una Póliza *
      *                                                /Endoso.      *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_marcarDeudaAnteriorSuperPolizaEndoso...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarDeudaAnteriorSuperPolizaEndoso(): desmarca   *
      *                                                   para pagar *
      *                                                   la Deuda   *
      *                                                   Anterior   *
      *                                                   de una Pó- *
      *                                                   liza/Endo- *
      *                                                   so.        *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_desmarcarDeudaAnteriorSuperPolizaEndoso...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_marcarQuincenaAnteriorSuperPolizaEndoso(): marca para *
      *                                                  pagar la    *
      *                                                  Quincena    *
      *                                                  Anterior de *
      *                                                  una Póliza/ *
      *                                                  Endoso.     *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_marcarQuincenaAnteriorSuperPolizaEndoso...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarQuincenaAnteriorSuperPolizaEndoso(): desmar- *
      *                                                      ca para *
      *                                                      pagar la*
      *                                                      Quincena*
      *                                                      Anterior*
      *                                                      de una  *
      *                                                      Póliza/ *
      *                                                      Endoso. *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_desmarcarQuincenaAnteriorSuperPolizaEndoso...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_marcarQuincenaActualSuperPolizaEndoso(): marca para   *
      *                                                 pagar la     *
      *                                                 Quincena Ac- *
      *                                                 tual de una  *
      *                                                 Póliza/Endo- *
      *                                                 so.          *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_marcarQuincenaActualSuperPolizaEndoso...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarQuincenaActualSuperPolizaEndoso(): desmarca  *
      *                                                    para pagar*
      *                                                    la Quince-*
      *                                                    na Actual *
      *                                                    de una Pó-*
      *                                                    liza/Endo-*
      *                                                    so.       *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_desmarcarQuincenaActualSuperPolizaEndoso...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_marcarQuincenaSiguienteSuperPolizaEndoso() marca para *
      *                                                   pagar la   *
      *                                                   Quincena   *
      *                                                   Siguiente  *
      *                                                   de una Pó- *
      *                                                   liza/Endo- *
      *                                                   so.        *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_marcarQuincenaSiguienteSuperPolizaEndoso...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarQuincenaSiguienteSuperPolizaEndoso(): des-   *
      *                                                       marca  *
      *                                                       para   *
      *                                                       pagar  *
      *                                                       la Quin*
      *                                                       cena   *
      *                                                       siguien*
      *                                                       te de  *
      *                                                       una Pó-*
      *                                                       liza/  *
      *                                                       Endoso.*
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_desmarcarQuincenaSiguienteSuperPolizaEndoso...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_marcarSaldosSuperPolizaEndoso(): marca para pagar el  *
      *                                         saldo de una Póliza/ *
      *                                         Endoso.              *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_marcarSaldosSuperPolizaEndoso...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarSaldosSuperPolizaEndoso(): desmarca para pa- *
      *                                            gar el Saldo de   *
      *                                            una Póliza/Endo-  *
      *                                            so.               *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_desmarcarSaldosSuperPolizaEndoso...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_tipoDePago(): indica el Tipo de Pago que va a hacer-  *
      *                      se para la Preliquidación.              *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peTipo   (input)   Tipo de Pago                          *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_tipoDePago...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peTipo                       2    const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * Acceso Preliquidaciones                                      *
      * ------------------------------------------------------------ *
     D keypliq_t       ds                  qualified template
     D  nrpl                          7  0
     D  arcd                          6  0
     D  spol                          9  0
     D  sspo                          3  0
     D  rama                          2  0
     D  arse                          2  0
     D  oper                          7  0
     D  suop                          3  0
     D  poli                          7  0
     D  nomb                         40a

      * ------------------------------------------------------------ *
      * Detalle Preliquidaciones                                     *
      * ------------------------------------------------------------ *
     D listpliq_t      ds                  qualified template
     D  arcd                          6  0
     D  spol                          9  0
     D  sspo                          3  0
     D  rama                          2  0
     D  arse                          2  0
     D  oper                          7  0
     D  suop                          3  0
     D  poli                          7  0
     D  nomb                         40a
     D  dant                         15  2
     D  qant                         15  2
     D  qact                         15  2
     D  qsig                         15  2
     D  qpos                         15  2
     D  sald                         15  2

      * ------------------------------------------------------------ *
      * PLQWEB_listarPreliquidacion(): recupera la Preliquidación.   *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peCant   (input)   Cantidad de Líneas                    *
      *     peRoll   (input)   Forma de Paginado                     *
      *     peOrde   (input)   Ordenamiento                          *
      *     pePosi   (input)   Posicionamiento                       *
      *     pePreg   (output)  Primer Registro Leído                 *
      *     peUreg   (output)  Último Registro Leído                 *
      *     peLdet   (output)  Lista de Detalle                      *
      *     peLdetC  (output)  Cantidad de registros                 *
      *     peMore   (output)  Hay/No hay más registros              *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_listarPreliquidacion...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   peOrde                      10a   const
     D   pePosi                            likeds(keypliq_t) const
     D   pePreg                            likeds(keypliq_t)
     D   peUreg                            likeds(keypliq_t)
     D   peLdet                            likeds(listpliq_t) dim(99)
     D   peLdetC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * Acceso Cuotas Marcadas                                       *
      * ------------------------------------------------------------ *
     D keycmar_t       ds                  qualified template
     D  nrpl                          7  0
     D  arcd                          6  0
     D  spol                          9  0
     D  sspo                          3  0
     D  rama                          2  0
     D  arse                          2  0
     D  oper                          7  0
     D  suop                          3  0
     D  poli                          7  0
     D  nrcu                          2  0
     D  nrsc                          2  0

      * ------------------------------------------------------------ *
      * Detalle Cuotas Marcadas                                      *
      * ------------------------------------------------------------ *
     D listcmar_t      ds                  qualified template
     D  arcd                          6  0
     D  spol                          9  0
     D  sspo                          3  0
     D  rama                          2  0
     D  arse                          2  0
     D  oper                          7  0
     D  suop                          3  0
     D  poli                          7  0
     D  nomb                         40a
     D  nrcu                          2  0
     D  nrsc                          2  0
     D  fvto                          8  0
     D  imcu                         15  2
     D  comi                         15  2

      * ------------------------------------------------------------ *
      * Detalle Cuotas Marcadas                                      *
      * ------------------------------------------------------------ *
     D listcma2_t      ds                  qualified template
     D  arcd                          6  0
     D  spol                          9  0
     D  sspo                          3  0
     D  rama                          2  0
     D  arse                          2  0
     D  oper                          7  0
     D  suop                          3  0
     D  poli                          7  0
     D  nomb                         40a
     D  nrcu                          2  0
     D  nrsc                          2  0
     D  fvto                          8  0
     D  imcu                         15  2
     D  comi                         15  2
     D  como                          2a
     D  nmoc                          5a
     D  nmol                         30a
     D  imc2                         15  2

      * ------------------------------------------------------------ *
      * PLQWEB_listarCuotasMarcadas(): recupera Cuotas seleccionadas *
      *                                para pagar.                   *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peCant   (input)   Cantidad de Líneas                    *
      *     peRoll   (input)   Forma de Paginado                     *
      *     pePosi   (input)   Posicionamiento                       *
      *     pePreg   (output)  Primer Registro Leído                 *
      *     peUreg   (output)  Último Registro Leído                 *
      *     peLdet   (output)  Lista de Detalle                      *
      *     peLdetC  (output)  Cantidad de registros                 *
      *     peMore   (output)  Hay/No hay más registros              *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_listarCuotasMarcadas...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keycmar_t) const
     D   pePreg                            likeds(keycmar_t)
     D   peUreg                            likeds(keycmar_t)
     D   peLdet                            likeds(listcmar_t) dim(99)
     D   peLdetC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_listarCuotas(): Recupera Cuotas de Preliquidación     *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peCant   (input)   Cantidad de Líneas                    *
      *     peRoll   (input)   Forma de Paginado                     *
      *     pePosi   (input)   Posicionamiento                       *
      *     pePreg   (output)  Primer Registro Leído                 *
      *     peUreg   (output)  Último Registro Leído                 *
      *     peLdet   (output)  Lista de Detalle                      *
      *     peLdetC  (output)  Cantidad de registros                 *
      *     peMore   (output)  Hay/No hay más registros              *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     D PLQWEB_listarCuotas...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keycmar_t) const
     D   pePreg                            likeds(keycmar_t)
     D   peUreg                            likeds(keycmar_t)
     D   peLdet                            likeds(listcmar_t) dim(99)
     D   peLdetC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_insertarMontoEfectivo(): ingresa el importe que va a  *
      *                                 pagarse en efectivo.         *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peEfvo   (input)   Importe en Efectivo                   *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_insertarMontoEfectivo...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peEfvo                      15  2 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_insertarCheque(): ingresa un cheque a la Preliquida-  *
      *                          ción.                               *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peIvbc   (input)   Código de Banco                       *
      *     peNche   (input)   Número de Cheque                      *
      *     peFche   (input)   Fecha del Cheque (aaaammdd)           *
      *     peEfvo   (input)   Importe                               *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_insertarCheque...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNche                      30    const
     D   peFche                       8  0 const
     D   peEfvo                      15  2 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_borrarCheque(): elimina un cheque de una Preliquida-  *
      *                          ción.                               *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peIvbc   (input)   Código de Banco                       *
      *     peNche   (input)   Número de Cheque                      *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_borrarCheque...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNche                      30    const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_insertarDepositoBancario(): ingresa los datos de un   *
      *                                    depósito bancario a la    *
      *                                    Preliquidación.           *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peIvbc   (input)   Código de Banco                       *
      *     peNros   (input)   Número Secuencial                     *
      *     peImpo   (input)   Importe                               *
      *     peFdep   (input)   Fecha de Deposito                     *
      *     peArch   (input)   Archivo                               *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_insertarDepositoBancario...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNros                      30a   const
     D   peImpo                      15  2 const
     D   peFdep                       8  0 const
     D   peArch                     512a   const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_borrarDepositoBancario(): elimina un depósito ingre-  *
      *                                  sado.                       *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peIvbc   (input)   Código de Banco                       *
      *     peNdep   (input)   Número de Depósito                    *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_borrarDepositoBancario...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNdep                      30a   const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_enviarPreliquidacion(): envía la Preliquidación a la  *
      *                                Compañía.                     *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_enviarPreliquidacion...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D PLQWEB_inz      pr

      * ------------------------------------------------------------ *
      * PLQWEB_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D PLQWEB_end      pr

      * ------------------------------------------------------------ *
      * PLQWEB_canfacpend: Cantidad de Facturas pendientes que tiene *
      *                    un productor.                             *
      *                                                              *
      *     peEmpr   (input)   Parametros Base                       *
      *     peSucu   (input)   Número de Preliquidación              *
      *     peNivt   (input)   Tipo de Intermediario                 *
      *     peNivc   (input)   Número de Intermediario               *
      *     peCant   (output)  Cantidad de Facturas Pendientes       *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_canfacpend...
     D                 pr             3  0
     D   peBase                            likeds(paramBase) const


      * ------------------------------------------------------------ *
      * PLQWEB_canfacperm: Cantidad de Facturas permitidas           *
      *                                                              *
      *     peEmpr   (input)   Parametros Base                       *
      *     peSucu   (input)   Número de Preliquidación              *
      *     peCanp   (input)   Cantidad de Facturas Pendientes       *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_canfacperm...
     D                 pr             3  0
     D   peBase                            likeds(paramBase) const

      * ------------------------------------------------------------ *
      * PLQWEB_listaValores(): Lista Valores ingresados.             *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peLval   (output)  Lista de Valores                      *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     D PLQWEB_listaValores...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peLval                            likeds(listaValores_t) dim(99)
     D   peLvalC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D listaValores_t  ds                  qualified template
     D  ivcv                          2  0
     D  ivdv                         50a
     D  imcu                         15  2
     D  imcua                        20a
     D  ivch                         30a
     D  fech                          8  0
     D  fecha                        10a
     D  ivbc                          3  0
     D  nomb                         40a

      * ------------------------------------------------------------ *
      * PLQWEB_guardar(): Guarda Preliquidacion.                     *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     D PLQWEB_guardar...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_marcarEnviadaPorMail(): Marcar como enviada por mail  *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     D PLQWEB_marcarEnviadaPorMail...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_cotiza(): Cotizar cuota                               *
      *                                                              *
      *     peMone   (input)   Moneda                                *
      *     peImcu   (input)   Importe                               *
      *     peTipo   (input)   Tipo de Cotizacion                    *
      *     peFech   (input)   Fecha de cotizacion                   *
      *                                                              *
      * Retorna: Cuota cotizada                                      *
      * ------------------------------------------------------------ *
     D PLQWEB_cotiza   pr            15  2
     D  peMone                        2a   const
     D  peImcu                       15  2 const
     D  peTipo                        1a   const
     D  peFech                        8  0 const options(*omit:*nopass)

      * ------------------------------------------------------------ *
      * PLQWEB_codigoDeColumna(): Retorna codigo de columna          *
      *                                                              *
      *     peFeda   (input)   Fecha Deuda Anterior                  *
      *     peFeqa   (input)   Fecha Quincena Anterior               *
      *     peFeqt   (input)   Fecha Quincena Actual                 *
      *     peFeqs   (input)   Fecha Quincena Siguiente              *
      *     peFeqp   (input)   Fecha Quincena Posterior              *
      *     peFvto   (input)   Fecha Vencimiento                     *
      *                                                              *
      * Retorna: Codigo de columna                                   *
      *          DA = Deuda Anterior                                 *
      *          QA = Quincena Anterior                              *
      *          QT = Quincena Actual                                *
      *          QS = Quincena Siguiente                             *
      *          QP = Quincena Posterior                             *
      * ------------------------------------------------------------ *
     D PLQWEB_codigoDeColumna...
     D                 pr             2a
     D  peFeda                        8  0 const
     D  peFeqa                        8  0 const
     D  peFeqt                        8  0 const
     D  peFeqs                        8  0 const
     D  peFeqp                        8  0 const
     D  peFvto                        8  0 const

      * ------------------------------------------------------------ *
      * PLQWEB_totalSuperpoliza(): Totaliza superpoliza              *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediario                *
      *     peNivc   (input)   Codigo de Intermediario               *
      *     peNrpl   (input)   Numero de Preliquidacion              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peCodi   (input)   Columna                               *
      *     peImcu   (input)   Importe                               *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     D PLQWEB_totalSuperpoliza...
     D                 pr
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNrpl                        7  0 const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const
     D  peCodi                        2a   const
     D  peImcu                       15  2 const

      * ------------------------------------------------------------ *
      * PLQWEB_totalPoliza(): Totaliza poliza                        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediario                *
      *     peNivc   (input)   Codigo de Intermediario               *
      *     peNrpl   (input)   Numero de Preliquidacion              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Secuencia de Articulo/Rama            *
      *     peOper   (input)   Operacion                             *
      *     peSuop   (input)   Suplemento                            *
      *     pePoli   (input)   Poliza                                *
      *     peCodi   (input)   Columna                               *
      *     peImcu   (input)   Importe                               *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     D PLQWEB_totalPoliza...
     D                 pr
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNrpl                        7  0 const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peOper                        7  0 const
     D  peSuop                        3  0 const
     D  pePoli                        7  0 const
     D  peCodi                        2a   const
     D  peImcu                       15  2 const

      * ------------------------------------------------------------ *
      * PLQWEB_comisionSuperpoliza(): Obtiene comisiones de Spol     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediario                *
      *     peNivc   (input)   Codigo de Intermediario               *
      *     peMone   (input)   Moneda                                *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: Importe de comision de produccion                   *
      * ------------------------------------------------------------ *
     D PLQWEB_comisionSuperpoliza...
     D                 pr            15  2
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peMone                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const

      * ------------------------------------------------------------ *
      * PLQWEB_comisionPoliza(): Obtiene comisiones de rama/sec      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediario                *
      *     peNivc   (input)   Codigo de Intermediario               *
      *     peMone   (input)   Moneda                                *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peSuop   (input)   Suplemento                            *
      *                                                              *
      * Retorna: Importe de comision de produccion                   *
      * ------------------------------------------------------------ *
     D PLQWEB_comisionPoliza...
     D                 pr            15  2
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peMone                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const
     D  peRama                        2  0 const
     D  peSuop                        3  0 const

      * ------------------------------------------------------------ *
      * PLQWEB_generaCabecera(): Generar PAHPQC                      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediario                *
      *     peNivc   (input)   Codigo de Intermediario               *
      *     peNrpl   (input)   Nro de Preliquidacion                 *
      *     peFdes   (input)   Fecha Desde                           *
      *     peFhas   (input)   Fecha Hasta                           *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     D PLQWEB_generaCabecera...
     D                 pr
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNrpl                        7  0 const
     D  peFdes                        8  0 const
     D  peFhas                        8  0 const

      * ------------------------------------------------------------ *
      * PLQWEB_marcarComoProcesada(): Marcar preli como procesada    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel                                 *
      *     peNivc   (input)   Codigo                                *
      *     peNrpl   (input)   Número de Preliquidación              *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     D PLQWEB_marcarComoProcesada...
     D                 pr
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNrpl                       7  0 const

      * ------------------------------------------------------------ *
      * PLQWEB_tieneCheques(): Retorna si tiene cheques cargados.    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel                                 *
      *     peNivc   (input)   Codigo                                *
      *     peNrpl   (input)   Número de Preliquidación              *
      *                                                              *
      * Retorna: *ON Si tiene cheques / *OFF no tiene cheques        *
      * ------------------------------------------------------------ *
     D PLQWEB_tieneCheques...
     D                 pr             1n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNrpl                       7  0 const

      * ------------------------------------------------------------ *
      * PLQWEB_tieneEfectivo(): Retorna si tiene cheques cargados.   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel                                 *
      *     peNivc   (input)   Codigo                                *
      *     peNrpl   (input)   Número de Preliquidación              *
      *                                                              *
      * Retorna: *ON Si tiene efectivo / *OFF no tiene efectivo      *
      * ------------------------------------------------------------ *
     D PLQWEB_tieneEfectivo...
     D                 pr             1n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNrpl                       7  0 const

      * ------------------------------------------------------------ *
      * PLQWEB_tieneBancoGalicia(): Retorna si tiene depositos del   *
      *                             Banco Galicia.                   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel                                 *
      *     peNivc   (input)   Codigo                                *
      *     peNrpl   (input)   Número de Preliquidación              *
      *                                                              *
      * Retorna: *ON Si tiene / *OFF no tiene                        *
      * ------------------------------------------------------------ *
     D PLQWEB_tieneBancoGalicia...
     D                 pr             1n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNrpl                       7  0 const

      * ------------------------------------------------------------ *
      * PLQWEB_marcarComoEliminada(): Marcar preli como eliminada    *
      *                                                              *
      *     peBase   (input)   Parametro Base                        *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     D PLQWEB_marcarComoEliminada...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_PLQWEB_tieneCobranzaIntegradaGalicia(): Retorna si    *
      *                             tiene valores de Cobranza Integra*
      *                             da de Banco Galicia.             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel                                 *
      *     peNivc   (input)   Codigo                                *
      *     peNrpl   (input)   Número de Preliquidación              *
      *                                                              *
      * Retorna: *ON Si tiene / *OFF no tiene                        *
      * ------------------------------------------------------------ *
     D PLQWEB_tieneCobranzaIntegradaGalicia...
     D                 pr             1n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNrpl                       7  0 const

      * ------------------------------------------------------------ *
      * PLQWEB_sndDataQueue(): Enviar preli a cola de datos para que *
      *                        se aplique automaticamente.           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel                                 *
      *     peNivc   (input)   Codigo                                *
      *     peNrpl   (input)   Número de Preliquidación              *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     D PLQWEB_sndDataQueue...
     D                 pr
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNrpl                       7  0 const

      * ------------------------------------------------------------ *
      * PLQWEB_insertarCobranzaIntegrada(): Inserta Cobranza Integra *
      *                                     da Banco Galicia.        *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peIvbc   (input)   Código de Banco                       *
      *     peNros   (input)   Número Secuencial                     *
      *     peImpo   (input)   Importe                               *
      *     peFdep   (input)   Fecha de Deposito                     *
      *     peArch   (input)   Archivo                               *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     D PLQWEB_insertarCobranzaIntegrada...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNros                      30a   const
     D   peImpo                      15  2 const
     D   peFdep                       8  0 const
     D   peArch                     512a   const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_eliminarCobranzaIntegrada(): Elimina Cobranza Integra *
      *                                     da Banco Galicia.        *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peIvbc   (input)   Código de Banco                       *
      *     peNdep   (input)   Número de Depósito                    *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     D PLQWEB_eliminarCobranzaIntegrada...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNdep                      30a   const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_insertarRedondeo(): Insertar redondeo.                *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peEfvo   (input)   Importe de redondeo                   *
      *     peArch   (input)   Archivo                               *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     D PLQWEB_insertarRedondeo...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peEfvo                      15  2 const
     D   peArch                     512a   const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_getTipoDeValor(): Obtiene tipo de valor.              *
      *                                                              *
      *     peIvcv   (input)   Tipo de valor                         *
      *                                                              *
      * Retorna: tipo de valor.                                      *
      * ------------------------------------------------------------ *
     D PLQWEB_getTipoDeValor...
     D                 pr             2a
     D   peIvcv                       2  0 const

      * ------------------------------------------------------------ *
      * PLQWEB_getTipoDePago():  Obtiene tipo de pago.               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel                                 *
      *     peNivc   (input)   Codigo                                *
      *     peNrpl   (input)   Número de Preliquidación              *
      *                                                              *
      * Retorna: tipo de pago.                                       *
      * ------------------------------------------------------------ *
     D PLQWEB_getTipoDePago...
     D                 pr             2a
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNrpl                       7  0 const

      * ------------------------------------------------------------ *
      * PLQWEB_tieneRedondeo(): Retorna si tiene Redondeo como       *
      *                         forma de Pago.                       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel                                 *
      *     peNivc   (input)   Codigo                                *
      *     peNrpl   (input)   Número de Preliquidación              *
      *                                                              *
      * Retorna: *ON Si tiene / *OFF no tiene                        *
      * ------------------------------------------------------------ *
     D PLQWEB_tieneRedondeo...
     D                 pr             1n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNrpl                       7  0 const

      * ------------------------------------------------------------ *
      * PLQWEB_marcarQuincenaPosterior() : Marcar para pagar toda la *
      *                                    deuda de la quincena pos_ *
      *                                    terior.                   *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     D PLQWEB_marcarQuincenaPosterior...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarQuincenaPosterior():Desmarca para pagar toda *
      *                                     la Quincena Posterior de *
      *                                     la prequidación.         *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     D PLQWEB_desmarcarQuincenaPosterior...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_marcarQuincenaPosteriorSuperPolizaEndoso() marca para *
      *                                                   pagar la   *
      *                                                   Quincena   *
      *                                                   Posterior  *
      *                                                   de una Pó- *
      *                                                   liza/Endo- *
      *                                                   so.        *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     D PLQWEB_marcarQuincenaPosteriorSuperPolizaEndoso...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarQuincenaPosteriorSuperPolizaEndoso(): des-   *
      *                                                       marca  *
      *                                                       para   *
      *                                                       pagar  *
      *                                                       la Quin*
      *                                                       cena   *
      *                                                       Posteri*
      *                                                       or de  *
      *                                                       una Pó-*
      *                                                       liza/  *
      *                                                       Endoso.*
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     D PLQWEB_desmarcarQuincenaPosteriorSuperPolizaEndoso...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_insertarECheque(): ingresa un cheque electronico      *
      *                           a la Preliquidación.               *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peIvbc   (input)   Código de Banco                       *
      *     peNech   (input)   Número de Cheque Electronico          *
      *     peFche   (input)   Fecha del Cheque Electronico(aaaammdd)*
      *     peEfvo   (input)   Importe                               *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_insertarECheque...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNech                      30    const
     D   peFche                       8  0 const
     D   peEfvo                      15  2 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_borrarECheque(): elimina un cheque electronico        *
      *                         de una Preliquidación.               *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peIvbc   (input)   Código de Banco                       *
      *     peNech   (input)   Número de Cheque Electronico          *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_borrarECheque...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNech                      30    const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

