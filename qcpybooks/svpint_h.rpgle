      /if defined(SVPINT_H)
      /eof
      /endif
      /define SVPINT_H

      /copy './qcpybooks/svpdaf_h.rpgle'
      /copy './qcpybooks/mail_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'

      * Datos del Intermediario
     d DsSehni2_t      ds                  qualified template
     d   n2empr                       1
     d   n2sucu                       2
     d   n2nivt                       1p 0
     d   n2nivc                       5p 0
     d   n2inta                       1p 0
     d   n2inna                       5p 0
     d   n2matr                       6p 0
     d   n2nrdf                       7p 0
     d   n2coma                       2
     d   n2nrma                       7p 0
     d   n2esma                       1p 0
     d   n2bloq                       1
     d   n3nivt                       1p 0
     d   n3nivc                       5p 0
     d   n2fiaa                       4p 0
     d   n2fiam                       2p 0
     d   n2fiad                       2p 0
     d   n2feaa                       4p 0
     d   n2feam                       2p 0
     d   n2fead                       2p 0
     d   n2mar1                       1
     d   n2mar2                       1
     d   n2mar3                       1
     d   n2mar4                       1
     d   n2mar5                       1
     d   n2cn02                       2p 0
     d   n2user                      10
     d   n2time                       6p 0
     d   n2date                       6p 0
     d   n2fmaa                       4p 0
     d   n2fmam                       2p 0
     d   n2fmad                       2p 0
     d   n2com1                       2
     d   n2nrm1                       7p 0
     d   n2esm1                       1p 0
     d   n2nrcm                      11p 0
     d   n2cpgm                      10
     d   n2mar6                       1
     d   n2mar7                       1

     D RecSet6118_t    ds                  qualified
     D  t@empr                        1a
     D  t@sucu                        2a
     D  t@nivt                        1  0
     D  t@nivc                        5  0
     D  t@rama                        2  0
     D  t@xopr                        5  2
     D  t@xcco                        5  2
     D  t@xfno                        5  2
     D  t@xfnn                        5  2
     D  t@bas1                        1a
     D  t@bas2                        1a
     D  t@bas3                        1a
     D  t@bas4                        1a
     D  t@pdn1                        5  2
     D  t@pdn2                        5  2
     D  t@pdn3                        5  2
     D  t@pdn4                        5  2
     D  t@pdn5                        5  2
     D  t@pdn6                        5  2
     D  t@pdn7                        5  2
     D  t@pdn8                        5  2
     D  t@pdn9                        5  2
     D  t@pdc1                        5  2
     D  t@pdc2                        5  2
     D  t@pdc3                        5  2
     D  t@pdc4                        5  2
     D  t@pdc5                        5  2
     D  t@pdc6                        5  2
     D  t@pdc7                        5  2
     D  t@pdc8                        5  2
     D  t@pdc9                        5  2
     D  t@pdf1                        5  2
     D  t@pdf2                        5  2
     D  t@pdf3                        5  2
     D  t@pdf4                        5  2
     D  t@pdf5                        5  2
     D  t@pdf6                        5  2
     D  t@pdf7                        5  2
     D  t@pdf8                        5  2
     D  t@pdf9                        5  2
     D  t@pdg1                        5  2
     D  t@pdg2                        5  2
     D  t@pdg3                        5  2
     D  t@pdg4                        5  2
     D  t@pdg5                        5  2
     D  t@pdg6                        5  2
     D  t@pdg7                        5  2
     D  t@pdg8                        5  2
     D  t@pdg9                        5  2
     D  t@fac1                        1a
     D  t@fac2                        1a
     D  t@fac3                        1a
     D  t@fac4                        1a
     D  t@fac5                        1a
     D  t@fac6                        1a
     D  t@fac7                        1a
     D  t@fac8                        1a
     D  t@fac9                        1a
     D  t@bpip                        5  2
     D  t@xrea                        5  2
     D  t@xref                        5  2
     D  t@dere                       15  2
     D  t@marp                        1a
     D  t@nrpp                        3  0
     D  t@mar1                        1a
     D  t@mar2                        1a
     D  t@mar3                        1a
     D  t@mar4                        1a
     D  t@mar5                        1a
     D  t@user                       10a
     D  t@date                        6  0
     D  t@time                        6  0

      * Datos del Intermediario
     D dsSet290_t      ds                  qualified template
     D  t@empr                        1a
     D  t@sucu                        2a
     D  t@nivt                        1s 0
     D  t@nivc                        5s 0
     D  t@rama                        2s 0
     D  t@fech                        8s 0
     D  t@secu                        5s 0
     D  t@porc                        5s 2
     D  t@defe                        5s 2
     D  t@mar1                        1a
     D  t@mar2                        1a
     D  t@mar3                        1a
     D  t@mar4                        1a
     D  t@mar5                        1a
     D  t@mar6                        1a
     D  t@mar7                        1a
     D  t@mar8                        1a
     D  t@mar9                        1a
     D  t@mar0                        1a
     D  t@user                       10a
     D  t@date                        8s 0
     D  t@time                        6s 0

      * ------------------------------------------------------------ *
      * SVPINT_GetNombre: Recupera Nombre de Intermediario.          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *                                                              *
      * Retorna: Nombre / *blanks                                    *
      * ------------------------------------------------------------ *

     D SVPINT_GetNombre...
     D                 pr            40
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
      * ------------------------------------------------------------ *
      * SVPINT_GetCadena: Recupera Cadena de Intermediario.          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peNrdf   (input)   Nro de Cliente                        *
      *                                                              *
      * Retorna: *On= Encontro / *off = Error                        *
      * ------------------------------------------------------------ *

     D SVPINT_GetCadena...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peCade                       5  0 dim(9)
     D   peNrdf                       7  0 dim(9) options(*nopass)

      * ------------------------------------------------------------ *
      * SVPINT_GetCuit: Recupera CUIT de un Intermediario.           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *                                                              *
      * Retorna: CUIT / *blanks                                      *
      * ------------------------------------------------------------ *

     D SVPINT_GetCuit...
     D                 pr            11
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const

      * ------------------------------------------------------------ *
      * SVPINT_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPINT_inz      pr

      * ------------------------------------------------------------ *
      * SVPINT_end():  Finaliza módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPINT_end      pr

      * ------------------------------------------------------------ *
      * SVPINT_getIntermediario: Obtiene la informacion del          *
      *                          Intermediario.-                     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peDsInte (output)  Estructura Intermediario              *
      *                                                              *
      * Retorna: 0 = Si coincide la Clave / -1 = Si no coincide      *
      * ------------------------------------------------------------ *
     D SVPINT_getIntermediario...
     D                 pr             1  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peDsInte                          likeds( DsSehni2_t )

      * ------------------------------------------------------------ *
      * SVPINT_getNroDaf: Obtiene el numero de persona del           *
      *                   Intermediario.-                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *                                                              *
      * Retorna: Numero de persona / -1 ... Si encuentra en archivo  *
      * ------------------------------------------------------------ *
     D SVPINT_getNroDaf...
     D                 pr             7  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
      * ------------------------------------------------------------ *
      * SVPINT_getTelefonos: Obtiene los números telefónico del      *
      *                      Intermediario.-                         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peCont   (output)  Estructura Telefonos/Pagina Web       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPINT_getTelefonos...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peCont                            likeDs(dsCont_t)

      * ------------------------------------------------------------ *
      * SVPINT_getTelefonosWeb: Obtiene los números telefónico del   *
      *                         Intermediario que se puedan mostrar  *
      *                         en la Web.-                          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peDsTl   (output)  Estructura Telefonos en la Web        *
      *     peDsTlC  (output)  Cantidad                              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPINT_getTelefonosWeb...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peDsTl                            likeds ( DsTelPublic_t )
     D                                     dim(10)
     D   peDsTlC                     10i 0

      * ------------------------------------------------------------ *
      * SVPINT_setMostrarDatosContacto: Graba mostrar datos del      *
      *                                 contacto del intermediario.- *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peTipo   (input)   Tipo de Contacto                      *
      *     peMar1   (input)   Mostrar Si o No                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPINT_setMostrarDatosContacto...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peTipo                       1    const
     D   peMar1                       1    const
      * ------------------------------------------------------------ *
      * SVPINT_setMostrarTelefonos: Graba si se puede mostrar        *
      *                             teléfono de intermediario.-      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peMar1   (input)   Mostrar Si o No                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPINT_setMostrarTelefonos...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peMar1                       1    const
      * ------------------------------------------------------------ *
      * SVPINT_setMostrarMails: Graba si se puede mostrar mails      *
      *                         de intermediario.-                   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peMar1   (input)   Mostrar Si o No                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPINT_setMostrarMails...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peMar1                       1    const
      * ------------------------------------------------------------ *
      * SVPINT_isMostrarTelefonos: Retorna si se puede mostrar       *
      *                            teléfono de intermediario.-       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peFech   (input)   Fecha (opcional)                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPINT_isMostrarTelefonos...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peFech                       8  0 options(*nopass:*omit) const
      * ------------------------------------------------------------ *
      * SVPINT_isMostrarMails: Retorna si se puede mostrar Mails     *
      *                        de intermediario.-                    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peFech   (input)   Fecha (opcional)                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPINT_isMostrarMails...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peFech                       8  0 options(*nopass:*omit) const

      * ------------------------------------------------------------ *
      * SVPINT_getmaILWeb: Obtiene los correos Electronicos Web      *
      *                    de un Intermediario.-                     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peMail   (output)  DS con los mails                      *
      *     peMailC  (output)  Cantidad                              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPINT_getMailWeb...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peMail                            likeds(Mailaddr_t) dim(100)
     D   peMailC                     10i 0

      * ------------------------------------------------------------ *
      * SVPINT_getDescuentoWeb(): Retorna registro de SET290         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peRama   (input)   Rama                                  *
      *     peFech   (input)   Fecha                                 *
      *     peDeRe   (output)  DS con Descuento/Recargo              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPINT_getDescuentoWeb...
     D                 pr              n
     D   peEmpr                       1    Const
     D   peSucu                       2    Const
     D   peNivt                       1  0 Const
     D   peNivc                       5  0 Const
     D   peRama                       2  0 Const
     D   peFech                       8  0 Options( *Omit ) Const
     D   peDeRe                            Likeds(dsSet290_t)

      * ------------------------------------------------------------ *
      * SVPINT_chkDescuentoWeb(): Retorna si existe en SET290        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peRama   (input)   Rama                                  *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPINT_chkDescuentoWeb...
     D                 pr              n
     D   peEmpr                       1    Const
     D   peSucu                       2    Const
     D   peNivt                       1  0 Const
     D   peNivc                       5  0 Const
     D   peRama                       2  0 Const
     D   peFech                       8  0 Options( *Nopass : *Omit ) Const

      * ------------------------------------------------------------ *
      * SVPINT_isCabeceraEspecial: Retorna Cabecera Especial         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peCcbp   (output)  Código de Componente                  *
      *     pePcbp   (output)  Porcentaje Bonificación               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPINT_isCabeceraEspecial...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peCcbp                       3  0 Options( *Nopass : *Omit )
     D   pePcbp                       5  2 Options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SVPINT_getMatricula: Recupera Matricula de Intermediario.    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *                                                              *
      * Retorna: Matricula / 0 = no tiene cargada                    *
      * ------------------------------------------------------------ *

     D SVPINT_getMatricula...
     D                 pr             6  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const

      * ------------------------------------------------------------ *
      * SVPINT_getMayorAuxiliar : Recupera Código y Número Mayor     *
      *                           Auxiliar                           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peComa   (output)  Cod. de Mayor Auxiliar                *
      *     peNrma   (output)  Nro. de Mayor Auxiliar                *
      *                                                              *
      * Retorna: Matricula / 0 = no tiene cargada                    *
      * ------------------------------------------------------------ *

     D SVPINT_getMayorAuxiliar...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peComa                       2
     D   peNrma                       7  0

      * ------------------------------------------------------------ *
      * SVPINT_bloquearVoucher: Determina si bloquea o no voucher.   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peFech   (input)   Fecha (opcional)                      *
      *                                                              *
      * Retorna: *On bloquea / *off no bloquea                       *
      * ------------------------------------------------------------ *
     D SVPINT_bloquearVoucher...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peFech                       8  0 const Options( *Nopass : *Omit )

