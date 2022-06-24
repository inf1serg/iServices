      /if defined(SPVVEH_H)
      /eof
      /endif
      /define SPVVEH_H

      /copy './qcpybooks/svpart_h.rpgle'
      /copy './qcpybooks/svpdau_h.rpgle'
      /copy './qcpybooks/svpbue_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'
      /copy './qcpybooks/spvfec_h.rpgle'
      /copy './qcpybooks/svpdaf_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/czwutl_h.rpgle'
      /copy './qcpybooks/svppol_h.rpgle'
      /copy './qcpybooks/svplrc_h.rpgle'

      * Marca Invalida...
     D SPVVEH_VMCNF    c                   const(0001)
      * Modelo Invalido...
     D SPVVEH_VMONF    c                   const(0002)
      * SubModelo Invalido...
     D SPVVEH_VCSNF    c                   const(0003)
      * Vehiculo no Encontrado...
     D SPVVEH_VVONF    c                   const(0004)
      * Carroceria Invalida...
     D SPVVEH_VCRNF    c                   const(0005)
      * Codigo de Uso Invalido...
     D SPVVEH_VUVNF    c                   const(0006)
      * Codigo de Origen Invalido...
     D SPVVEH_VNINF    c                   const(0007)
      * Capitulo Variante invalido...
     D SPVVEH_VCPNF    c                   const(0008)
      * Codigo Tipo Vehiculo Invalido...
     D SPVVEH_VCTNF    c                   const(0009)
      * Codigo de Cobertura Invalido...
     D SPVVEH_VBLNF    c                   const(0010)
      * Valor de Usado Invalido...
     D SPVVEH_VVUNF    c                   const(0011)
      * Formato de Patente Invalida...
     D SPVVEH_VATNF    c                   const(0012)
      * Tipo de Patente Invalida...
     D SPVVEH_VANNF    c                   const(0013)
      * Patente Duplicada...
     D SPVVEH_VANDU    c                   const(0014)
      * Nro de Motor Invalido...
     D SPVVEH_VTONF    c                   const(0015)
      * Nro de Chasis Invalido...
     D SPVVEH_VASNF    c                   const(0016)
      * Marca de Averia Invalida...
     D SPVVEH_VERNF    c                   const(0017)
      * Codigo de Acreedor Prendario Invalido...
     D SPVVEH_VCPAP    c                   const(0018)
      * Forma de Pago Acreedor Prendario Invalida...
     D SPVVEH_VRCNF    c                   const(0019)
      * Marca de GNC Invalida...
     D SPVVEH_VGNNF    c                   const(0020)
      * Error de Cobertura Origen...
     D SPVVEH_VCONF    c                   const(0021)
      * Error de Rebaja por Buen Resultado...
     D SPVVEH_VBRNF    c                   const(0022)
      * Error de Codigo Tabla RC Sin Tarifa...
     D SPVVEH_VRCST    c                   const(0023)
      * Error de Codigo Tabla RC Con Tarifa...
     D SPVVEH_VRCCT    c                   const(0024)
      * Error de Codigo Tabla AIR Sin Tarifa...
     D SPVVEH_VAIRS    c                   const(0025)
      * Error de Codigo Tabla AIR Con Tarifa...
     D SPVVEH_VAIRC    c                   const(0026)
      * Se Debe Ingresar una Franquicia...
     D SPVVEH_VFRNI    c                   const(0027)
      * No Se Debe Ingresar una Franquicia...
     D SPVVEH_VFRSI    c                   const(0028)
      * Importe de Franquicia Mayor a Valor Asegurado...
     D SPVVEH_VFRMA    c                   const(0029)
      * Franquicia Debe ser A/B/M...
     D SPVVEH_VFRMU    c                   const(0030)
      * Franquicia Debe ser 1 a 9...
     D SPVVEH_VFR19    c                   const(0031)
      * Tarjeta de Mercosur Invalida...
     D SPVVEH_VTMIN    c                   const(0032)
      * Año de Vehiculo Invalido...
     D SPVVEH_VAVNF    c                   const(0033)
      * Año de Vehiculo Fuera de Rango...
     D SPVVEH_VAVFR    c                   const(0034)
      * Capitulo/Uso No lleva RUTA...
     D SPVVEH_VRUNC    c                   const(0035)
      * Capitulo/Uso lleva RUTA...
     D SPVVEH_VRUSC    c                   const(0036)
      * RUTA Asignado a Otro Vehiculo...
     D SPVVEH_VRUOV    c                   const(0037)
      * RUTA Vehiculo-Asegurado No...
     D SPVVEH_VRUAN    c                   const(0038)
      * Zona Invalida...
     D SPVVEH_VZONF    c                   const(0039)
      * Articulo: Extencion Rama Autos Invalida...
     D SPVVEH_VAENF    c                   const(0040)
      * Cobertura CPlus Invalida...
     D SPVVEH_VCPIN    c                   const(0041)
      * Cobertura B1 Invalida...
     D SPVVEH_VCBIN    c                   const(0042)
      * Cobertura Invalida...
     D SPVVEH_VCOIN    c                   const(0043)
      * Cobertura A Invalida...
     D SPVVEH_VCAIN    c                   const(0044)
      * Cobertura CRI Invalida...
     D SPVVEH_VCCIN    c                   const(0045)
      * Estado Componente Invalido para Operacion...
     D SPVVEH_VECIO    c                   const(0046)
      * Error en Tipos de Operaciones...
     D SPVVEH_VOONF    c                   const(0047)
      * Nros. AIR y RC Invalidos...
     D SPVVEH_RCAIR    c                   const(0048)
      * Codigo de Tarifa Invalido...
     D SPVVEH_COTNF    c                   const(0049)
      * No es 0KM...
     D SPVVEH_VENT0    c                   const(0050)
      * Codigo de Relacion Invalido...
     D SPVVEH_VECRN    c                   const(0051)
      * Marca Tarifa Diferencia Invalida...
     D SPVVEH_MTDIN    c                   const(0052)
      * Suma Asegurada supera máximo....
     D SPVVEH_SUMAX    c                   const(0053)
      * Suma Asegurada menor al mínimo....
     D SPVVEH_SUMIN    c                   const(0054)
      * Cobertura no es Responsabilidad Civil...
     D SPVVEH_COBNA    c                   const(0055)
      * Suma Asegurada debe ser 0 para RC...
     D SPVVEH_SUMCA    c                   const(0056)
      * VHCA/VHV1/VHV2 no corresponde para la rama...
     D SPVVEH_RCVIN    c                   const(0057)
      * Cobertura no Permitida para Articulo/Rama...
     D SPVVEH_CNPAR    c                   const(0058)
      * No se Encontraron Pautas...
     D SPVVEH_SINPA    c                   const(0059)
      * Vehiculo no encontrado en INFOAUTOS...
     D SPVVEH_NEINF    c                   const(0060)
      * Tiene Cobertura "D"...
     D SPVVEH_PLANP    c                   const(0061)
      * Tipo de Franquicia Manual...
     D SPVVEH_FRAMA    c                   const(0062)
      * Vehiculo no apto para 0km...
     D SPVVEH_NO0KM    c                   const(0063)
      * Vehiculo no apto para año solicitado...
     D SPVVEH_NOAÑO    c                   const(0064)
      * Vehiculo no es seguro de registro...
     D SPVVEH_VCPNS    c                   const(0065)
      * Cuestionario no existe...
     D SPVVEH_VTAAJ    c                   const(0065)
      * Item de Scoring no existe en cuestionario...
     D SPVVEH_VCOSG    c                   const(0066)
      * Resultado del Item es incorrecto...
     D SPVVEH_VVEFA    c                   const(0067)
      * Respuesta invalida para este tipo de Item...
     D SPVVEH_VVFR1    c                   const(0068)
      * Item de Scoring no admite que se cargue cantidad...
     D SPVVEH_VCANT    c                   const(0069)
      * Item de Scoring duplicado...
     D SPVVEH_VDCOS    c                   const(0070)
      * Item de Scoring Excluyente con otro ya cargado...
     D SPVVEH_VDCOX    c                   const(0071)
      * Faltan items de ingreso obligatorio...
     D SPVVEH_VOBLI    c                   const(0072)
      * Error en la secuencia de carga de items...
     D SPVVEH_VSECU    c                   const(0073)
      * Error tipo de ajuste diferente a la anterior
     D SPVVEH_ETIAJ    c                   const(0074)
      * Error forma de aplicar ajuste diferente a la anterior
     D SPVVEH_ETIAC    c                   const(0075)
      * Error resultado es diferente al anterior
     D SPVVEH_EVEFA    c                   const(0076)
      * Error Coef/Porc. RC es diferente al anterior
     D SPVVEH_ECORC    c                   const(0077)
      * Error Coef/Porc. Casco es diferente al anterior
     D SPVVEH_ECOCA    c                   const(0078)
      * Error Cantidad es diferente al anterior
     D SPVVEH_ECANT    c                   const(0079)
      * Error la pregunta de la tabla pahet3 no se encuentra en la de parm
     D SPVVEH_EFCOS    c                   const(0080)
      * La cantidad de preguntas de la tabla pahet3 no es la misma del parm
     D SPVVEH_ECOMP    c                   const(0081)
      * El Artículo requiere responder cuestionario de Scoring
     D SPVVEH_ARCSC    c                   const(0082)
      * El Artículo no requiere responder cuestionario de Scoring
     D SPVVEH_ARCNS    c                   const(0083)
      * Incongruencia entre zona y localidad
     D SPVVEH_LOCZO    c                   const(0084)
      * Factores multiplicativos AUTOS no existe
     D SPVVEH_FAMNE    c                   const(0085)

      * --------------------------------------------------- *
      * Estrucutura de datos con el último error
      * --------------------------------------------------- *
     D SPVVEH_ERDS_T   ds                  qualified
     D                                     based(template)
     D   Errno                        4s 0
     D   Msg                         80a

      * --------------------------------------------------- *
      * Estrucutura DS set204
      * --------------------------------------------------- *
     D @@@204          ds                  qualified
     D                                     based(template)
     D t@vhmc                         3
     D t@vhmo                         3
     D t@vhcs                         3
     D t@vhmd                        15
     D t@vhdm                        15
     D t@vhds                        10
     D t@vhca                         2  0
     D t@vhv1                         1  0
     D t@vhv2                         1  0
     D t@vhct                         2  0
     D t@vhcr                         3
     D t@vhni                         1
     D t@vhma                         3
     D t@vhml                         3
     D t@vhms                         3
     D t@cmar                         3  0
     D t@cmod                         3  0
     D t@vhcb                         2
     D t@vhff                         1
     D t@vhpe                         6  0
     D t@mar1                         1
     D t@mar2                         1
     D t@mar3                         1
     D t@mar4                         1
     D t@mar5                         1
     D t@cgru                         2  0

      * --------------------------------------------------- *
      * Estrucutura DS PAHET0
      * DEPRECATED: Usar dsPahet02_t
      * --------------------------------------------------- *
     D dsPahet0_t      ds                  qualified template
     D  t0empr                        1a
     D  t0sucu                        2a
     D  t0arcd                        6  0
     D  t0spol                        9  0
     D  t0sspo                        3  0
     D  t0rama                        2  0
     D  t0arse                        2  0
     D  t0oper                        7  0
     D  t0suop                        3  0
     D  t0poco                        4  0
     D  t0cert                        9  0
     D  t0poli                        7  0
     D  t0acrc                        7  0
     D  t0esco                        1a
     D  t0rpro                        2  0
     D  t0rdep                        2  0
     D  t0rloc                        2  0
     D  t0vhmc                        3a
     D  t0vhmo                        3a
     D  t0vhcs                        3a
     D  t0vhcr                        3a
     D  t0vhaÑ                        4  0
     D  t0vhni                        1a
     D  t0patl                        1a
     D  t0patn                        7  0
     D  t0panl                        3a
     D  t0pann                        3  0
     D  t0moto                       25a
     D  t0chas                       25a
     D  t0vhca                        2  0
     D  t0vhv1                        1  0
     D  t0vhv2                        1  0
     D  t0vhct                        2  0
     D  t0vhuv                        2  0
     D  t0cobl                        2a
     D  t0vhvu                       15  2
     D  t0vh0k                       15  2
     D  t0rcle                       15  2
     D  t0rcco                       15  2
     D  t0rcac                       15  2
     D  t0lrce                       15  2
     D  t0saap                       15  2
     D  t0claj                        3  0
     D  t0rebr                        1  0
     D  t0cfas                        1a
     D  t0tarc                        2  0
     D  t0tair                        2  0
     D  t0scta                        1  0
     D  t0prrc                       15  2
     D  t0prac                       15  2
     D  t0prin                       15  2
     D  t0prro                       15  2
     D  t0pacc                       15  2
     D  t0praa                       15  2
     D  t0prsf                       15  2
     D  t0prce                       15  2
     D  t0prap                       15  2
     D  t0mar1                        1a
     D  t0mar2                        1a
     D  t0mar3                        1a
     D  t0mar4                        1a
     D  t0mar5                        1a
     D  t0strg                        1a
     D  t0user                       10a
     D  t0time                        6  0
     D  t0date                        6  0
     D  t0ca01                        3a
     D  t0ca02                        3a
     D  t0ca03                        3a
     D  t0ca04                        3a
     D  t0ca05                        3a
     D  t0ca06                        3a
     D  t0ca07                        3a
     D  t0ca08                        3a
     D  t0ca09                        3a
     D  t0ca10                        3a
     D  t0ca11                        3a
     D  t0ca12                        3a
     D  t0ca13                        3a
     D  t0ca14                        3a
     D  t0ca15                        3a
     D  t0ca16                        3a
     D  t0ca17                        3a
     D  t0ca18                        3a
     D  t0ca19                        3a
     D  t0ca20                        3a
     D  t0ca21                        3a
     D  t0ca22                        3a
     D  t0ca23                        3a
     D  t0ca24                        3a
     D  t0ca25                        3a
     D  t0ca26                        3a
     D  t0ca27                        3a
     D  t0ca28                        3a
     D  t0ca29                        3a
     D  t0ca30                        3a
     D  t0an01                        1a
     D  t0an02                        1a
     D  t0an03                        1a
     D  t0an04                        1a
     D  t0an05                        1a
     D  t0an06                        1a
     D  t0an07                        1a
     D  t0an08                        1a
     D  t0an09                        1a
     D  t0an10                        1a
     D  t0an11                        1a
     D  t0an12                        1a
     D  t0an13                        1a
     D  t0an14                        1a
     D  t0an15                        1a
     D  t0an16                        1a
     D  t0an17                        1a
     D  t0an18                        1a
     D  t0an19                        1a
     D  t0an20                        1a
     D  t0an21                        1a
     D  t0an22                        1a
     D  t0an23                        1a
     D  t0an24                        1a
     D  t0an25                        1a
     D  t0an26                        1a
     D  t0an27                        1a
     D  t0an28                        1a
     D  t0an29                        1a
     D  t0an30                        1a
     D  t0gbco                        3a
     D  t0corc                        7  4
     D  t0coca                        7  4
     D  t0taaj                        2  0
     D  t0ctre                        5  0
     D  t0ruta                       16  0
     D  t0mtdf                        1a
     D  t0ifra                       15  2
     D  t0vhde                       40a
     D  t0mar6                        1a
     D  t0mar7                        1a
     D  t0mar8                        1a
     D  t0mar9                        1a
     D  t0mar0                        1a
     D  t0rgnc                        9  2

      * --------------------------------------------------- *
      * Estrucutura DS PAHET0
      * --------------------------------------------------- *
     D dsPahet02_t     ds                  qualified template
     D  t0empr                        1a
     D  t0sucu                        2a
     D  t0arcd                        6  0
     D  t0spol                        9  0
     D  t0sspo                        3  0
     D  t0rama                        2  0
     D  t0arse                        2  0
     D  t0oper                        7  0
     D  t0suop                        3  0
     D  t0poco                        4  0
     D  t0cert                        9  0
     D  t0poli                        7  0
     D  t0acrc                        7  0
     D  t0esco                        1a
     D  t0rpro                        2  0
     D  t0rdep                        2  0
     D  t0rloc                        2  0
     D  t0vhmc                        3a
     D  t0vhmo                        3a
     D  t0vhcs                        3a
     D  t0vhcr                        3a
     D  t0vhaÑ                        4  0
     D  t0vhni                        1a
     D  t0patl                        1a
     D  t0patn                        7  0
     D  t0panl                        3a
     D  t0pann                        3  0
     D  t0moto                       25a
     D  t0chas                       25a
     D  t0vhca                        2  0
     D  t0vhv1                        1  0
     D  t0vhv2                        1  0
     D  t0vhct                        2  0
     D  t0vhuv                        2  0
     D  t0cobl                        2a
     D  t0vhvu                       15  2
     D  t0vh0k                       15  2
     D  t0rcle                       15  2
     D  t0rcco                       15  2
     D  t0rcac                       15  2
     D  t0lrce                       15  2
     D  t0saap                       15  2
     D  t0claj                        3  0
     D  t0rebr                        1  0
     D  t0cfas                        1a
     D  t0tarc                        2  0
     D  t0tair                        2  0
     D  t0scta                        1  0
     D  t0prrc                       15  2
     D  t0prac                       15  2
     D  t0prin                       15  2
     D  t0prro                       15  2
     D  t0pacc                       15  2
     D  t0praa                       15  2
     D  t0prsf                       15  2
     D  t0prce                       15  2
     D  t0prap                       15  2
     D  t0mar1                        1a
     D  t0mar2                        1a
     D  t0mar3                        1a
     D  t0mar4                        1a
     D  t0mar5                        1a
     D  t0strg                        1a
     D  t0user                       10a
     D  t0time                        6  0
     D  t0date                        6  0
     D  t0ca01                        3a
     D  t0ca02                        3a
     D  t0ca03                        3a
     D  t0ca04                        3a
     D  t0ca05                        3a
     D  t0ca06                        3a
     D  t0ca07                        3a
     D  t0ca08                        3a
     D  t0ca09                        3a
     D  t0ca10                        3a
     D  t0ca11                        3a
     D  t0ca12                        3a
     D  t0ca13                        3a
     D  t0ca14                        3a
     D  t0ca15                        3a
     D  t0ca16                        3a
     D  t0ca17                        3a
     D  t0ca18                        3a
     D  t0ca19                        3a
     D  t0ca20                        3a
     D  t0ca21                        3a
     D  t0ca22                        3a
     D  t0ca23                        3a
     D  t0ca24                        3a
     D  t0ca25                        3a
     D  t0ca26                        3a
     D  t0ca27                        3a
     D  t0ca28                        3a
     D  t0ca29                        3a
     D  t0ca30                        3a
     D  t0an01                        1a
     D  t0an02                        1a
     D  t0an03                        1a
     D  t0an04                        1a
     D  t0an05                        1a
     D  t0an06                        1a
     D  t0an07                        1a
     D  t0an08                        1a
     D  t0an09                        1a
     D  t0an10                        1a
     D  t0an11                        1a
     D  t0an12                        1a
     D  t0an13                        1a
     D  t0an14                        1a
     D  t0an15                        1a
     D  t0an16                        1a
     D  t0an17                        1a
     D  t0an18                        1a
     D  t0an19                        1a
     D  t0an20                        1a
     D  t0an21                        1a
     D  t0an22                        1a
     D  t0an23                        1a
     D  t0an24                        1a
     D  t0an25                        1a
     D  t0an26                        1a
     D  t0an27                        1a
     D  t0an28                        1a
     D  t0an29                        1a
     D  t0an30                        1a
     D  t0gbco                        3a
     D  t0corc                        7  4
     D  t0coca                        7  4
     D  t0taaj                        2  0
     D  t0ctre                        5  0
     D  t0ruta                       16  0
     D  t0mtdf                        1a
     D  t0ifra                       15  2
     D  t0vhde                       40a
     D  t0mar6                        1a
     D  t0mar7                        1a
     D  t0mar8                        1a
     D  t0mar9                        1a
     D  t0mar0                        1a
     D  t0rgnc                        9  2
     D  t0copo                        5  0
     D  t0cops                        1  0

      * --------------------------------------------------- *
      * Estrucutura DS PAHET9
      * --------------------------------------------------- *
     D dsPahet9_t      ds                  qualified template
     D  t9empr                        1a
     D  t9sucu                        2a
     D  t9arcd                        6  0
     D  t9spol                        9  0
     D  t9sspo                        3  0
     D  t9rama                        2  0
     D  t9arse                        2  0
     D  t9oper                        7  0
     D  t9poco                        4  0
     D  t9cert                        9  0
     D  t9poli                        7  0
     D  t9vhmc                        3a
     D  t9vhmo                        3a
     D  t9vhcs                        3a
     D  t9vhcr                        3a
     D  t9vhaÑ                        4  0
     D  t9vhni                        1a
     D  t9patl                        1a
     D  t9patn                        7  0
     D  t9panl                        3a
     D  t9pann                        3  0
     D  t9moto                       25a
     D  t9chas                       25a
     D  t9vhca                        2  0
     D  t9vhv1                        1  0
     D  t9vhv2                        1  0
     D  t9vhct                        2  0
     D  t9vhuv                        2  0
     D  t9suin                        3  0
     D  t9ainn                        4  0
     D  t9minn                        2  0
     D  t9dinn                        2  0
     D  t9suen                        3  0
     D  t9aegn                        4  0
     D  t9megn                        2  0
     D  t9degn                        2  0
     D  t9mar1                        1a
     D  t9mar2                        1a
     D  t9mar3                        1a
     D  t9mar4                        1a
     D  t9mar5                        1a
     D  t9strg                        1a
     D  t9user                       10a
     D  t9time                        6  0
     D  t9date                        6  0
     D  t9acrc                        7  0
     D  t9nmer                       40a
     D  t9ruta                       16  0
     D  t9mtdf                        1a
     D  t9tmat                        3a
     D  t9nmat                       25a
     D  t9ifra                       15  2
     D  t9vhde                       40a
     D  t9mar6                        1a
     D  t9mar7                        1a
     D  t9mar8                        1a
     D  t9mar9                        1a
     D  t9mar0                        1a
     D  t9rgnc                        9  2

      * --------------------------------------------------- *
      * Estrucutura DS registro de patente duplicada
      * --------------------------------------------------- *
     D patdup          ds                  qualified
     D                                     based(template)
     D duarcd                         6  0
     D duspol                         9  0
     D durama                         2  0
     D dupoco                         4  0
     D dupoli                         7  0
     D duhast                         8  0

      * --------------------------------------------------- *
      * Estrucutura DS registro de Pautas
      * --------------------------------------------------- *
     D pautas          ds                  qualified
     D                                     based(template)
     D paanti                         2  0
     D painsp                         2  0
     D parast                        15  2

      * --------------------------------------------------- *
      * Estrucutura DS set206 - Valores del cero kilómetro
      * --------------------------------------------------- *
     D DsSet206_t      ds                  qualified
     D                                     based(template)
     D t@vhmc                         3
     D t@vhmo                         3
     D t@vhcs                         3
     D t@vhcr                         3
     D t@como                         2
     D t@vh0k                        15p 0

      * --------------------------------------------------- *
      * Estrucutura DS PAHET406
      * --------------------------------------------------- *
     D dsPahet406_t    ds                  qualified template
     D  t4empr                        1a
     D  t4sucu                        2a
     D  t4arcd                        6  0
     D  t4spol                        9  0
     D  t4sspo                        3  0
     D  t4rama                        2  0
     D  t4arse                        2  0
     D  t4oper                        7  0
     D  t4suop                        3  0
     D  t4poco                        4  0
     D  t4ccbp                        3  0
     D  t4cert                        9  0
     D  t4poli                        7  0
     D  t4prin                       15  2
     D  t4pcbp                        5  2
     D  t4pori                        5  2
     D  t4mcbp                        1a
     D  t4user                       10a
     D  t4time                        6  0
     D  t4date                        6  0
     D  stccbe                        3a
     D  stdcbp                       25a

      * --------------------------------------------------- *
      * Estrucutura DS set224
      * --------------------------------------------------- *
     D dsSet224_t      ds                  qualified template
     D  t@ftga                        4p 0
     D  t@ftgm                        2p 0
     D  t@ftgd                        2p 0
     D  t@ftao                        1p 0
     D  t@csaa                        1p 0
     D  t@fcrf                        1p 0
     D  t@reb1                        7p 0
     D  t@reb2                        7p 0
     D  t@reb3                        7p 0
     D  t@reb4                        7p 0
     D  t@arce                        1a
     D  t@tapm                        1a
     D  t@como                        2a

      * --------------------------------------------------- *
      * Estrucutura DS set228
      * --------------------------------------------------- *
     D dsSet228_t      ds                  qualified template
     D  t@cobl                        2
     D  t@tair                        2p 0
     D  t@mone                        2
     D  t@vhca                        2p 0
     D  t@vhv2                        1p 0
     D  t@cap1                       15p 2
     D  t@cap2                       15p 2
     D  t@cap3                       15p 2
     D  t@mar1                        1
     D  t@mar2                        1
     D  t@mar3                        1
     D  t@mar4                        1
     D  t@mar5                        1
     D  t@user                       10
     D  t@date                        8p 0
     D  t@time                        6p 0

      * --------------------------------------------------- *
      * Estrucutura DS PAHET4
      * --------------------------------------------------- *
     D dsPahet4_t      ds                  qualified template
     D  t4empr                        1a
     D  t4sucu                        2a
     D  t4arcd                        6  0
     D  t4spol                        9  0
     D  t4sspo                        3  0
     D  t4rama                        2  0
     D  t4arse                        2  0
     D  t4oper                        7  0
     D  t4suop                        3  0
     D  t4poco                        4  0
     D  t4ccbp                        3  0
     D  t4cert                        9  0
     D  t4poli                        7  0
     D  t4prin                       15  2
     D  t4pcbp                        5  2
     D  t4pori                        5  2
     D  t4mcbp                        1a
     D  t4user                       10a
     D  t4time                        6  0
     D  t4date                        6  0

      * --------------------------------------------------- *
      * Estrucutura DS PAHET1
      * --------------------------------------------------- *
     D dsPahet1_t      ds                  qualified template
     D  t1empr                        1a
     D  t1sucu                        2a
     D  t1arcd                        6  0
     D  t1spol                        9  0
     D  t1sspo                        3  0
     D  t1rama                        2  0
     D  t1arse                        2  0
     D  t1oper                        7  0
     D  t1suop                        3  0
     D  t1poco                        4  0
     D  t1secu                        2  0
     D  t1cert                        9  0
     D  t1poli                        7  0
     D  t1accd                       20
     D  t1accv                       15  2
     D  t1mar1                        1
     D  t1mar2                        1
     D  t1mar3                        1
     D  t1mar4                        1
     D  t1mar5                        1
     D  t1strg                        1
     D  t1user                       10
     D  t1time                        6  0
     D  t1date                        6  0

      * --------------------------------------------------- *
      * Estrucutura DS PAHET5
      * --------------------------------------------------- *
     D dsPahet5_t      ds                  qualified template
     D  t5empr                        1a
     D  t5sucu                        2a
     D  t5arcd                        6  0
     D  t5spol                        9  0
     D  t5sspo                        3  0
     D  t5rama                        2  0
     D  t5arse                        2  0
     D  t5oper                        7  0
     D  t5poco                        4  0
     D  t5suop                        3  0
     D  t5cert                        9  0
     D  t5poli                        7  0
     D  t5cdaÑ                        4  0
     D  t5daÑl                      200
     D  t5edaÑ                        1
     D  t5mar1                        1
     D  t5mar2                        1
     D  t5mar3                        1
     D  t5mar4                        1
     D  t5mar5                        1
     D  t5mar6                        1
     D  t5mar7                        1
     D  t5mar8                        1
     D  t5mar9                        1
     D  t5mar0                        1
     D  t5user                       10
     D  t5date                        8  0
     D  t5time                        6  0

      * --------------------------------------------------- *
      * Estrucutura DS PAHET6
      * --------------------------------------------------- *
     D dsPahet6_t      ds                  qualified template
     D  t6empr                        1a
     D  t6sucu                        2a
     D  t6arcd                        6  0
     D  t6spol                        9  0
     D  t6sspo                        3  0
     D  t6rama                        2  0
     D  t6arse                        2  0
     D  t6oper                        7  0
     D  t6poco                        4  0
     D  t6suop                        3  0
     D  t6cert                        9  0
     D  t6poli                        7  0
     D  t6ncon                        4  0
     D  t6nomb                       19
     D  t6apel                       19
     D  t6nreg                       11
     D  t6fvto                        8  0
     D  t6expp                       15
     D  t6stat                        1
     D  t6mar1                        1
     D  t6mar2                        1
     D  t6mar3                        1
     D  t6mar4                        1
     D  t6mar5                        1
     D  t6mar6                        1
     D  t6mar7                        1
     D  t6mar8                        1
     D  t6mar9                        1
     D  t6mar0                        1
     D  t6user                       10
     D  t6date                        8  0
     D  t6time                        6  0


      * --------------------------------------------------- *
      * Estrucutura DS PAHET002
      * --------------------------------------------------- *
     D dsPahet002_t    ds                  qualified template
     D  t0empr                        1a
     D  t0sucu                        2a
     D  t0arcd                        6  0
     D  t0spol                        9  0
     D  t0sspo                        3  0
     D  t0rama                        2  0
     D  t0arse                        2  0
     D  t0oper                        7  0
     D  t0suop                        3  0
     D  t0poco                        4  0
     D  t0cert                        9  0
     D  t0poli                        7  0
     D  t0acrc                        7  0
     D  t0esco                        1a
     D  t0rpro                        2  0
     D  t0rdep                        2  0
     D  t0rloc                        2  0
     D  t0vhmc                        3a
     D  t0vhmo                        3a
     D  t0vhcs                        3a
     D  t0vhcr                        3a
     D  t0vhaÑ                        4  0
     D  t0vhni                        1a
     D  t0patl                        1a
     D  t0patn                        7  0
     D  t0panl                        3a
     D  t0pann                        3  0
     D  t0moto                       25a
     D  t0chas                       25a
     D  t0vhca                        2  0
     D  t0vhv1                        1  0
     D  t0vhv2                        1  0
     D  t0vhct                        2  0
     D  t0vhuv                        2  0
     D  t0cobl                        2a
     D  t0vhvu                       15  2
     D  t0vh0k                       15  2
     D  t0rcle                       15  2
     D  t0rcco                       15  2
     D  t0rcac                       15  2
     D  t0lrce                       15  2
     D  t0saap                       15  2
     D  t0claj                        3  0
     D  t0rebr                        1  0
     D  t0cfas                        1a
     D  t0tarc                        2  0
     D  t0tair                        2  0
     D  t0scta                        1  0
     D  t0prrc                       15  2
     D  t0prac                       15  2
     D  t0prin                       15  2
     D  t0prro                       15  2
     D  t0pacc                       15  2
     D  t0praa                       15  2
     D  t0prsf                       15  2
     D  t0prce                       15  2
     D  t0prap                       15  2
     D  t0mar1                        1a
     D  t0mar2                        1a
     D  t0mar3                        1a
     D  t0mar4                        1a
     D  t0mar5                        1a
     D  t0strg                        1a
     D  t0user                       10a
     D  t0time                        6  0
     D  t0date                        6  0
     D  t0ca01                        3a
     D  t0ca02                        3a
     D  t0ca03                        3a
     D  t0ca04                        3a
     D  t0ca05                        3a
     D  t0ca06                        3a
     D  t0ca07                        3a
     D  t0ca08                        3a
     D  t0ca09                        3a
     D  t0ca10                        3a
     D  t0ca11                        3a
     D  t0ca12                        3a
     D  t0ca13                        3a
     D  t0ca14                        3a
     D  t0ca15                        3a
     D  t0ca16                        3a
     D  t0ca17                        3a
     D  t0ca18                        3a
     D  t0ca19                        3a
     D  t0ca20                        3a
     D  t0ca21                        3a
     D  t0ca22                        3a
     D  t0ca23                        3a
     D  t0ca24                        3a
     D  t0ca25                        3a
     D  t0ca26                        3a
     D  t0ca27                        3a
     D  t0ca28                        3a
     D  t0ca29                        3a
     D  t0ca30                        3a
     D  t0an01                        1a
     D  t0an02                        1a
     D  t0an03                        1a
     D  t0an04                        1a
     D  t0an05                        1a
     D  t0an06                        1a
     D  t0an07                        1a
     D  t0an08                        1a
     D  t0an09                        1a
     D  t0an10                        1a
     D  t0an11                        1a
     D  t0an12                        1a
     D  t0an13                        1a
     D  t0an14                        1a
     D  t0an15                        1a
     D  t0an16                        1a
     D  t0an17                        1a
     D  t0an18                        1a
     D  t0an19                        1a
     D  t0an20                        1a
     D  t0an21                        1a
     D  t0an22                        1a
     D  t0an23                        1a
     D  t0an24                        1a
     D  t0an25                        1a
     D  t0an26                        1a
     D  t0an27                        1a
     D  t0an28                        1a
     D  t0an29                        1a
     D  t0an30                        1a
     D  t0gbco                        3a
     D  t0corc                        7  4
     D  t0coca                        7  4
     D  t0taaj                        2  0
     D  t0ctre                        5  0
     D  t0ruta                       16  0
     D  t0mtdf                        1a
     D  t0tmat                        3a
     D  t0nmat                       25a
     D  t0ifra                       15  2
     D  t0vhde                       40a
     D  t0mar6                        1a
     D  t0mar7                        1a
     D  t0mar8                        1a
     D  t0mar9                        1a
     D  t0mar0                        1a
     D  t0rgnc                        9  2

      * --------------------------------------------------- *
      * Estrucutura DS PAHET7
      * --------------------------------------------------- *
     D dsPahet7_t      ds                  qualified template
     D  t7empr                        1a
     D  t7sucu                        2a
     D  t7arcd                        6  0
     D  t7spol                        9  0
     D  t7sspo                        3  0
     D  t7rama                        2  0
     D  t7arse                        2  0
     D  t7oper                        7  0
     D  t7suop                        3  0
     D  t7poco                        4  0
     D  t7ccoe                        3  0
     D  t7cert                        9  0
     D  t7poli                        7  0
     D  t7coef                        7  4
     D  t7mar2                        1a
     D  t7user                       10a
     D  t7time                        6  0
     D  t7date                        8  0

      * ------------------------------------------------------------ *
      * SPVVEH_CheckMarca(): Chequea Marca de Vehiculo               *
      *                                                              *
      *     peVhmc   (input)   Marca                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckMarca...
     D                 pr             1n
     D   peVhmc                       3    const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckMod(): Chequea Modelo de Vehiculo                *
      *                                                              *
      *     peVhmo   (input)   Modelo                                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckMod...
     D                 pr             1n
     D   peVhmo                       3    const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckSubMod(): Chequea SubModelo de Vehiculo          *
      *                                                              *
      *     peVhcs   (input)   SubModelo                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckSubMod...
     D                 pr             1n
     D   peVhcs                       3    const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckVeh(): Chequea Existencia de Vehiculo            *
      *                                                              *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *     peVhcs   (Output)  Registro de Vehiculo                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckVeh...
     D                 pr             1n
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peVehr                            likeds(@@@204)options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_GetDescripcion(): Retorna la Descripcion del Vehiculo *
      *                                                              *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *     peVhmd   (output)  Descripcion Marca                     *
      *     peVhdm   (output)  Descripcion Modelo                    *
      *     peVhds   (output)  Descripcion SubModelo                 *
      *                                                              *
      * Retorna: Descripcion del Vehiculo o Blanks por Error         *
      *          peVhmd, peVhdm, y peVhds si se Pasan Como Parametro *
      * ------------------------------------------------------------ *

     D SPVVEH_GetDescripcion...
     D                 pr            40
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peVhmd                      15    options(*nopass:*omit)
     D   peVhdm                      15    options(*nopass:*omit)
     D   peVhds                      10    options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_CheckAÑoIn(): Chequea Año Ingresado del Vehiculo      *
      *                                                              *
      *     peVhaÑ   (input)   Año                                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckAÑoIn...
     D                 pr             1n
     D   peVhaÑ                       4  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckRangoAÑos(): Cheque Existencia en Tabla 625 y    *
      *                          Retorna Rango de Años si Solicita   *
      *                                                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peFdes   (Output)  Fecha Desde                           *
      *     peFhas   (Output)  Fecha Hasta                           *
      *                                                              *
      * Retorna: *On - Año Desde y Hasta - / *Off                    *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckRangoAÑos...
     D                 pr             1n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peFdes                       4  0 options(*nopass:*omit)
     D   peFhas                       4  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_CheckAÑo(): Chequea Año del Vehiculo                  *
      *                                                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peVhaÑ   (input)   Fecha de Vehiculo                     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckAÑo...
     D                 pr             1n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peVhaÑ                       4  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCarroceria(): Chequea Carroceria de Vehiculo     *
      *                                                              *
      *     peVhcr   (input)   Carroceria                            *
      *     peVhcd   (output)  Descripcion Carroceria                *
      *                                                              *
      * Retorna: *On / *Off y Descripcion de Carroceria si Recibe el *
      *          Parametro peVhcd                                    *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckCarroceria...
     D                 pr             1n
     D   peVhcr                       3    const
     D   peVhcd                      15    options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCodUso(): Chequea Codigo de Uso de Vehiculo      *
      *                                                              *
      *     peVhuv   (input)   Codigo de Uso                         *
      *     peVhdu   (output)  Descripcion Codigo de Uso             *
      *                                                              *
      * Retorna: *On / *Off y Descripcion de Codigo de Uso si Recibe *
      *          Parametro peVhdu                                    *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckCodUso...
     D                 pr             1n
     D   peVhuv                       2  0 const
     D   peVhdu                      15    options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_CheckOrigen(): Chequea Origen del Vehiculo            *
      *                                                              *
      *     peVhni   (input)   Origen del Vehiculo                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckOrigen...
     D                 pr             1n
     D   peVhni                       1    const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCapVar(): Chequea Capitulo/Variante              *
      *                                                              *
      *     peVhca   (input)   Capitulo del Vehiculo                 *
      *     peVhv1   (input)   Capitulo Variante RC                  *
      *     peVhv2   (input)   Capitulo Variante AIR                 *
      *     peCvde   (output)  Descripcion de Capitulo               *
      *                                                              *
      * Retorna: *On / *Off y Descripcion de Capitulo si Recibe      *
      *          Parametro peCvde                                    *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckCapVar...
     D                 pr             1n
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const
     D   peVhv2                       1  0 const
     D   peCvde                      20    options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_CheckTipoVeh(): Chequea Tipo de vehiculo              *
      *                                                              *
      *     peVhct   (input)   Tipo del Vehiculo                     *
      *     peVhdt   (output)  Descripcion Tipo del Vehiculo         *
      *                                                              *
      * Retorna: *On / *Off y Descripcion de Tipo de Vehiculo si     *
      *          Recibe Parametro peVhdt                             *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckTipoVeh...
     D                 pr             1n
     D   peVhct                       2  0 const
     D   peVhdt                      15    options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_CheckValorUsado(): Chequea Valor del Vehiculo Usado   *
      *                                                              *
      *     peCobl   (input)   Cobertura del Vehiculo                *
      *     peVhvu   (input)   Valor del Vehiculo Usado              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckValorUsado...
     D                 pr             1n
     D   peCobl                       2    const
     D   peVhvu                      15  2 const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckTipoPatente(): Chequea Tipo de patente           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peTmat   (input)   Tipo de Patente                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckTipoPatente...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peTmat                       3    const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckFmtPatente(): Chequea Formato de Patente         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNmat   (input)   Nro. de Patente                       *
      *     peTmat   (input)   Tipo de Patente                       *
      *     peVald   (Output)  Validar Duplicada                     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckFmtPatente...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNmat                      25    const
     D   peTmat                       3    const
     D   peVald                       1    options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_CheckPatenteDupli(): Chequea Patente Duplicada        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Nro. Superpoliza                      *
      *     peNmat   (input)   Nro. de Patente                       *
      *     pePoco   (input)   Componente                            *
      *     peFech   (input)   Fecha                                 *
      *     pePadu   (Output)  Registro con Patente Duplicada        *
      *                                                              *
      * Retorna: *On Si la Patente es Duplicada                      *
      *          *Off Si la Patente No es Duplicada                  *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckPatenteDupli...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peNmat                      25    const
     D   pePoco                       4  0 const
     D   peFech                       8  0 options(*nopass:*omit)
     D   pePadu                            likeds(patdup)options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_CheckPatente(): Chequea Patente de Vehiculo           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Nro. Superpoliza                      *
      *     peNmat   (input)   Nro. de Patente                       *
      *     peTmat   (input)   Tipo de Patente                       *
      *     pePoco   (input)   Componente                            *
      *     peFech   (input)                                         *
      *     pePadu   (input)   Registro con Patente Duplicada        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckPatente...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peNmat                      25    const
     D   peTmat                       3    const
     D   pePoco                       4  0 const
     D   peFech                       8  0 options(*nopass:*omit)
     D   pePadu                            likeds(patdup)options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_GetOrigen(): Retorna Origen del Vehiculo              *
      *                                                              *
      *     peCobl   (input)   Cobertura del Vehiculo                *
      *                                                              *
      * Retorna: Origen de Vehiculo o Blanks por Error               *
      * ------------------------------------------------------------ *

     D SPVVEH_GetOrigen...
     D                 pr             1
     D   peCobl                       2    const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCobOrigen(): Chequea Cobertura Origen Vehiculo   *
      *                                                              *
      *     peVhni   (input)   Origen del Vehiculo                   *
      *     peCobl   (input)   Cobertura del Vehiculo                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckCobOrigen...
     D                 pr             1n
     D   peVhni                       1    const
     D   peCobl                       2    const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCobertura(): Chequea Cobertura Valida            *
      *                                                              *
      *     peCobl   (input)   Tipo del Vehiculo                     *
      *     peNomb   (Output)  Descripcion de Cobertura              *
      *                                                              *
      * Retorna: *On / *Off y Descripcion de la Cobertura si Recibe  *
      *          Parametro peNomb                                    *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckCobertura...
     D                 pr             1n
     D   peCobl                       2    const
     D   peNomb                      40    options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_CheckMotor(): Chequea Motor de Vehiculo               *
      *                                                              *
      *     peMoto   (input)   Nro. de Motor                         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckMotor...
     D                 pr             1n
     D   peMoto                      25    const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckChasis(): Chequea Chasis de Vehiculo             *
      *                                                              *
      *     peChas   (input)   Nro. de Chasis                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckChasis...
     D                 pr             1n
     D   peChas                      25    const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckAveria(): Chequea Marca de Averia                *
      *                                                              *
      *     peAver   (input)   Marca de Averia                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckAveria...
     D                 pr             1n
     D   peAver                       1    const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckAcPrendario(): Chequea Codigo de Acreedor        *
      *                                                              *
      *     peAcrc   (input)   Codigo de Acreedor Prendario          *
      *     peNomb   (Output)  Nombre de Acreedor Prendario          *
      *                                                              *
      * Retorna: *On / *Off y Nombre de Acreedor Prendario si Recibe *
      *          Parametro peNomb                                    *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckAcPrendario...
     D                 pr             1n
     D   peAcrc                       7  0 const
     D   peNomb                      40    options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_CheckPagoAcPrendario(): Chequea Pago de Acreedor      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peAcrc   (input)   Codigo de Acreedor Prendario          *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peCfpg   (input)   Codigo de Forma de Pago               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckPagoAcPrendario...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peAcrc                       7  0 const
     D   peArcd                       6  0 const
     D   peCfpg                       1  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckGNC(): Chequea Marca de GNC                      *
      *                                                              *
      *     peMgnc   (input)   Marca de GNC                          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckGNC...
     D                 pr             1n
     D   peMgnc                       1    const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckRebaja(): Chequea Buen Resultado de Rebaja       *
      *                                                              *
      *     peRebr   (input)   Marca de Rebaja por Buen Resultado    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckRebaja...
     D                 pr             1n
     D   peRebr                       1  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCodRcNoTar(): Chequea Codigo Tabla RC No Tarifa  *
      *                                                              *
      *     peTarc   (input)   Nro. Tabla RC                         *
      *     peComo   (input)   Codigo de Moneda                      *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhv1   (input)   Capitulo Variante RC                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckCodRcNoTar...
     D                 pr             1n
     D   peTarc                       2  0 const
     D   peComo                       2    const
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCodRcSiTar(): Chequea Codigo Tabla RC Si Tarifa  *
      *                                                              *
      *     peNcoc   (input)   Codigo Cia. CoAseguradora             *
      *     peTarc   (input)   Nro. Tabla RC                         *
      *     peComo   (input)   Codigo de Moneda                      *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhv1   (input)   Capitulo Variante RC                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckCodRcSiTar...
     D                 pr             1n
     D   peNcoc                       5  0 const
     D   peTarc                       2  0 const
     D   peComo                       2    const
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCodRc(): Chequea Codigo de Tabla RC              *
      *                                                              *
      *     peNcoc   (input)   Codigo Cia. CoAsegurada               *
      *     peTarc   (input)   Nro. Tabla RC                         *
      *     peComo   (input)   Codigo de Moneda                      *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhv1   (input)   Capitulo Variante RC                  *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckCodRc...
     D                 pr             1n
     D   peNcoc                       5  0 const
     D   peTarc                       2  0 const
     D   peComo                       2    const
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCodAirNoTar(): Chequea Codigo de Tabla AIR       *
      *                            Sin Tarifa                        *
      *                                                              *
      *     peTair   (input)   Nro. Tabla AIR                        *
      *     peScta   (input)   Sub Tabla AIR                         *
      *     peComo   (input)   Codigo de Moneda                      *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhv2   (input)   Capitulo Variante AIR                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckCodAirNoTar...
     D                 pr             1n
     D   peTair                       2  0 const
     D   peScta                       1  0 const
     D   peComo                       2    const
     D   peVhca                       2  0 const
     D   peVhv2                       1  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCodAirSiTar(): Chequea Codigo de Tabla AIR       *
      *                            Con Tarifa                        *
      *                                                              *
      *     peNcoc   (input)   Codigo Cia. Coasegurada               *
      *     peTair   (input)   Nro. Tabla AIR                        *
      *     peScta   (input)   Sub Tabla AIR                         *
      *     peComo   (input)   Codigo de Moneda                      *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhv2   (input)   Capitulo Variante AIR                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckCodAirSiTar...
     D                 pr             1n
     D   peNcoc                       5  0 const
     D   peTair                       2  0 const
     D   peScta                       1  0 const
     D   peComo                       2    const
     D   peVhca                       2  0 const
     D   peVhv2                       1  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCodAir(): Chequea Codigo de Tabla AIR            *
      *                                                              *
      *     peNcoc   (input)   Codigo Cia. Coasegurada               *
      *     peTair   (input)   Nro. Tabla AIR                        *
      *     peScta   (input)   Sub Tabla AIR                         *
      *     peComo   (input)   Codigo de Moneda                      *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhv2   (input)   Capitulo Variante AIR                 *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckCodAir...
     D                 pr             1n
     D   peNcoc                       5  0 const
     D   peTair                       2  0 const
     D   peScta                       1  0 const
     D   peComo                       2    const
     D   peVhca                       2  0 const
     D   peVhv2                       1  0 const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckPorMilajeSa(): Obtiene PorMilaje de Suma Aseg.   *
      *                                                              *
      *     peTair   (input)   Nro. Tabla AIR                        *
      *     peScta   (input)   Sub Tabla AIR                         *
      *     peComo   (input)   Codigo de Moneda                      *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhv2   (input)   Capitulo Variante AIR                 *
      *     peIfr8   (output)  Importe Franquicia D2                 *
      *     peIfr9   (output)  Importe Franquicia D3                 *
      *                                                              *
      * Retorna: *On - Importes de Franquicias D2 y D3 - / *Off      *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckPorMilajeSa...
     D                 pr             1n
     D   peTair                       2  0 const
     D   peScta                       1  0 const
     D   peComo                       2    const
     D   peVhca                       2  0 const
     D   peVhv2                       1  0 const
     D   peIfr8                      15  2 options(*nopass:*omit)
     D   peIfr9                      15  2 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_GetImpFranquicia(): Retorna Importe de Franquicia     *
      *                                                              *
      *     peTair   (input)   Nro Tabla AIR                         *
      *     peScta   (input)   Nro SubTabla AIR                      *
      *     peComo   (input)   Codigo de Moneda                      *
      *     peVhca   (input)   Capitulo del Vehiculo                 *
      *     peVhv2   (input)   Capitulo Variante AIR                 *
      *     peCobl   (input)   Codigo de Cobertura                   *
      *                                                              *
      * Retorna: Importe de Franquicia o cero por no encontrar en las*
      *          tablas 221 y 2221 o no ser cobertura D%             *
      * ------------------------------------------------------------ *

     D SPVVEH_GetImpFranquicia...
     D                 pr            15p 2
     D   peTair                       2  0 const
     D   peScta                       1  0 const
     D   peComo                       2    const
     D   peVhca                       2  0 const
     D   peVhv2                       1  0 const
     D   peCobl                       2    const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckFranquicia(): Chequea Franquicia                 *
      *                                                              *
      *     peVhvu   (input)   Valor Vehiculo Usado                  *
      *     peCobl   (input)   Codigo de Cobertura                   *
      *     peIfra   (input)   Importe de Franquicia                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckFranquicia...
     D                 pr             1n
     D   peVhvu                      15  2 const
     D   peCobl                       2    const
     D   peIfra                      15p 2 const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCodFranquiciaSeg(): Chequea Franquicia en Seguros*
      *                                                              *
      *     peCobl   (input)   Cobertura del Vehiculo                *
      *     peCfas   (input)   Codigo de Franquicia                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckCodFranquiciaSeg...
     D                 pr             1n
     D   peCobl                       2    const
     D   peCfas                       1    const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckTarjMercosur(): Chequea Tarjeta Mercosur         *
      *                                                              *
      *     peNmer   (input)   Tarjeta Mercosur                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckTarjMercosur...
     D                 pr             1n
     D   peNmer                      40    const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckRuta(): Chequea R.U.T.A.                         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento Superpoliza                *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Nro. Operacion                        *
      *     peSuop   (input)   Suplemento Operacion                  *
      *     peRuta   (input)   Nro. Ruta                             *
      *     peAsen   (input)   Nro. Asegurado                        *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhuv   (input)   Codigo de Uso                         *
      *     pePoco   (input)   Componente                            *
      *     peFdes   (input)   Vigencia Desde                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckRuta...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   peRuta                      16  0 const
     D   peAsen                       7  0 const
     D   peVhca                       2  0 const
     D   peVhuv                       2  0 const
     D   pePoco                       4  0 const
     D   peFdes                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_CheckZona(): Chequea Zona                             *
      *                                                              *
      *     peScta   (input)   Zona                                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckZona...
     D                 pr             1n
     D   peScta                       1  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckEstado(): Chequea Estado de Componente Contra    *
      *                       Estado de Operacion                    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Estado de Componente                  *
      *     pePoli   (input)   Tipo de Operacion                     *
      *     pePoco   (input)   Subtipo de Operacion                  *
      *     peTiou   (input)   Tipo de Operacion                     *
      *     peStou   (input)   Subtipo de Operacion                  *
      *     peStos   (input)   Subtipo de Operacion de Sistema       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckEstado...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePoco                       4  0 const
     D   peTiou                       1  0 const
     D   peStou                       3  0 const
     D   peStos                       2  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCobCRI(): Chequea Cumplimiento de Cobertura CRI  *
      *                                                              *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhv1   (input)   Capitulo Variante RC                  *
      *     peVhni   (input)   Origen de Vehiculo                    *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckCobCRI...
     D                 pr             1n
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const
     D   peVhni                       1    const
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCobA(): Chequea Cumplimiento de Cobertura A      *
      *                                                              *
      *     peClaj   (input)   % Ajuste Automatico                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckCobA...
     D                 pr             1n
     D   peClaj                       3  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCobOtras(): Chequea Cumplimiento Otras Coberturas*
      *                                                              *
      *     peClaj   (input)   % Ajuste Automatico                   *
      *     peClao   (input)   % Ajuste Automatico                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckCobOtras...
     D                 pr             1n
     D   peClaj                       3  0 const
     D   peClao                       3  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCobB1(): Chequea Cumplimiento Cobertura B1       *
      *                                                              *
      *     peScta   (input)   Zona                                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckCobB1...
     D                 pr             1n
     D   peScta                       1  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCobCPlus(): Chequea Cumplimiento Cobertura CPlus *
      * "DEPRECATED" Se debe utilizar SPVVEH_CheckCobCPlus2()        *
      *                                                              *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peScta   (input)   Zona                                  *
      *     peVhuv   (input)   Valor Vehiculo Usado                  *
      *     peCtre   (input)   Codigo Relacion                       *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckCobCPlus...
     D                 pr             1n
     D   peVhca                       2  0 const
     D   peScta                       1  0 const
     D   peVhuv                      15  2 const
     D   peCtre                       5  0 const
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckRcAir(): Chequea Tabla Rc y Tabla Air            *
      * "DEPRECATED" Se debe utilizar SPVVEH_CheckRcAir2             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peCtre   (input)   Codigo de Relacion                    *
      *     peScta   (input)   Sub Tabla AIR                         *
      *     peComo   (input)   Codigo de Moneda                      *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhv1   (input)   Capitulo Variante AIR                 *
      *     peVhv2   (input)   Capitulo Variante AIR                 *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *     peTarc   (Output)  Nro. Tabla RC                         *
      *     peTair   (Output)  Nro. Tabla AIR                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckRcAir...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peCtre                       5  0 const
     D   peScta                       1  0 const
     D   peComo                       2    const
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const
     D   peVhv2                       1  0 const
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peTarc                       2  0
     D   peTair                       2  0

      * ------------------------------------------------------------ *
      * SPVVEH_CheckTar(): Chequea Codigo de Tarifa                  *
      *                                                              *
      *     peCtre   (input)   Codigo de Relacion                    *
      *     peScta   (input)   Sub Tabla AIR                         *
      *     peTarc   (Output)  Nro. Tabla RC                         *
      *     peTair   (Output)  Nro. Tabla AIR                        *
      *     peComo   (input)   Codigo de Moneda                      *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhv1   (input)   Capitulo Variante AIR                 *
      *     peVhv2   (input)   Capitulo Variante AIR                 *
      *     peMarc   (input)   Marca                                 *
      *     peFema   (input)   Año                                   *
      *     peFemm   (input)   Mes                                   *
      *     peFemd   (input)   Dia                                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckTar...
     D                 pr             1n
     D   peCtre                       5  0 const
     D   peScta                       1  0 const
     D   peTarc                       2  0 const
     D   peTair                       2  0 const
     D   peComo                       2    const
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const
     D   peVhv2                       1  0 const
     D   peMarc                       1    const
     D   peFema                       4  0 const
     D   peFemm                       2  0 const
     D   peFemd                       2  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_GetCobEquivalente(): Retorna Cobertura Equivalente    *
      *                                                              *
      *     peCobl   (input)   Cobertura del Vehiculo                *
      *                                                              *
      * Retorna: Cobertura Equivalente o Blanks por Error            *
      * ------------------------------------------------------------ *

     D SPVVEH_GetCobEquivalente...
     D                 pr             1
     D   peCobl                       2    const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckVeh0Km(): Chequea Vehiculo 0 Km                  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peVhaÑ   (input)   Año                                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckVeh0Km...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peVhaÑ                       4  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckPlan0Km(): Chequea Plan 0 Km                     *
      *                                                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   SuplementoSuperPoliza                 *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     peOper   (input)   Operacion                             *
      *     peSuop   (input)   Sup. Operacion                        *
      *     pePoco   (input)   Componente                            *
      *     peMarc   (input)   Marca                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckPlan0Km...
     D                 pr             1n
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   pePoco                       4  0 const
     D   peMarc                       1    const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckAcPrendarioCuit(): Chequea Cuit de Acreedor      *
      *                                                              *
      *     peCuit   (input)   Cuit de Acreedor Prendario            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckAcPrendarioCuit...
     D                 pr             1n
     D   peCuit                      11    const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCodRelacion(): Chequea Relacion en Set2222       *
      *                                                              *
      *     peCtre   (input)   Codigo de Relacion                    *
      *     peFema   (input)   Año de Relacion                       *
      *     peFemm   (input)   Mes de Relacion                       *
      *     peFemd   (input)   Dia de Relacion                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckCodRelacion...
     D                 pr             1n
     D   peCtre                       5  0 const
     D   peFema                       4  0 options(*nopass:*omit)
     D   peFemm                       2  0 options(*nopass:*omit)
     D   peFemd                       2  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SPVVEH_inz      pr

      * ------------------------------------------------------------ *
      * SPVVEH_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SPVVEH_End      pr

      * ------------------------------------------------------------ *
      * SPVVEH_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     D SPVVEH_Error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCobCPlus2(): Chequea Cumplimiento Cobertura CPlus*
      *                                                              *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peScta   (input)   Zona                                  *
      *     peVhuv   (input)   Valor Vehiculo Usado                  *
      *     peCtre   (input)   Codigo Relacion                       *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckCobCPlus2...
     D                 pr             1n
     D   peVhca                       2  0 const
     D   peScta                       1  0 const
     D   peVhuv                       2  0 const
     D   peCtre                       5  0 const
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckTarDif(): Chequea Tarifia Diferencia Set208      *
      *                                                              *
      *     peMtdf   (input)   Marca                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckTarDif...
     D                 pr             1n
     D   peMtdf                       1    const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckRcAir2(): Chequea Tabla Rc y Tabla Air           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peCtre   (input)   Codigo de Relacion                    *
      *     peScta   (input)   Sub Tabla AIR                         *
      *     peComo   (input)   Codigo de Moneda                      *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhv1   (input)   Capitulo Variante AIR                 *
      *     peVhv2   (input)   Capitulo Variante AIR                 *
      *     peTarc   (Output)  Nro. Tabla RC                         *
      *     peTair   (Output)  Nro. Tabla AIR                        *
      *     peTadi   (Input)   Marca de Tarifa Diferencial           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckRcAir2...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peCtre                       5  0 const
     D   peScta                       1  0 const
     D   peComo                       2    const
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const
     D   peVhv2                       1  0 const
     D   peTarc                       2  0
     D   peTair                       2  0
     D   peTadi                       1    options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_getSumaMinima(): Recupera suma asegurada mínima       *
      *                                                              *
      *     peFemi   (input)   Fecha a la cual controlar             *
      *                                                              *
      * Retorna: Importe de Suma Mínima (puede ser cero)             *
      * ------------------------------------------------------------ *
     D SPVVEH_getSumaMinima...
     D                 pr            15  2
     D   peFemi                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_getSumaMaxima(): Recupera suma asegurada máxima       *
      *                                                              *
      *     peFemi   (input)   Fecha a la cual controlar             *
      *                                                              *
      * Retorna: Importe de Suma Máxima (puede ser cero)             *
      * ------------------------------------------------------------ *
     D SPVVEH_getSumaMaxima...
     D                 pr            15  2
     D   peFemi                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_chkSumaMinima(): Controla Suma aseg > a suma mínima   *
      *                                                              *
      *     peVhvu   (input)   Suma asegurada                        *
      *     peFemi   (input)   Fecha a la cual controlar             *
      *                                                              *
      * Retorna: *ON OK, *OFF no OK                                  *
      * ------------------------------------------------------------ *
     D SPVVEH_chkSumaMinima...
     D                 pr             1N
     D   peVhvu                      15  2
     D   peFemi                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_chkSumaMaxima(): Controla Suma aseg > a suma mínima   *
      *                                                              *
      *     peVhvu   (input)   Suma asegurada                        *
      *     peFemi   (input)   Fecha a la cual controlar             *
      *                                                              *
      * Retorna: *ON OK, *OFF no OK                                  *
      * ------------------------------------------------------------ *
     D SPVVEH_chkSumaMaxima...
     D                 pr             1N
     D   peVhvu                      15  2
     D   peFemi                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_chkCoberturaA(): Controla Suma aseg vs Cobertura A    *
      *                                                              *
      *     peCobl   (input)   Cobertura                             *
      *     peVhvu   (input)   Suma asegurada                        *
      *                                                              *
      * Retorna: *ON OK, *OFF no OK                                  *
      * ------------------------------------------------------------ *
     D SPVVEH_chkCoberturaA...
     D                 pr             1N
     D   peCobl                       2a   const
     D   peVhvu                      15  2 const

      * ------------------------------------------------------------ *
      * SPVVEH_chkRamaCapitulo(): Verifica relación Rama vs VHCA/VHV1*
      *                           VHV2.                              *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peVhca   (input)   Capítulo                              *
      *     peVhv1   (input)   Variante RC                           *
      *     peVhv2   (input)   Variante AIR                          *
      *                                                              *
      * Retorna: *ON existe la relación, *OFF no                     *
      * ------------------------------------------------------------ *
     D SPVVEH_chkRamaCapitulo...
     D                 pr             1N
     D   peRama                       2  0 const
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const
     D   peVhv2                       1  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_chkRamaCobertura(): Chequea cobertura valida para     *
      *                            Arcd/Rama                         *
      *                                                              *
      *     peArcd   (input)   Articulo                              *
      *     peRama   (input)   Rama                                  *
      *     peCobl   (input)   Cobertura                             *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_chkRamaCobertura...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCobl                       2    const
     D   peFech                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_chkArticuloCobertura(): Chequea cobertura valida para *
      *                                Articulo                      *
      *                                                              *
      *     peArcd   (input)   Articulo                              *
      *     peCobl   (input)   Cobertura                             *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_chkArticuloCobertura...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peCobl                       2    const
     D   peFech                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_CheckArcd1006(): Chequea si corresponde a Arcd 1006   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento Superpoliza                *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Nro. Operacion                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckArcd1006...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckArcd1006Gral():Chequea si corresponde a Arcd 1006*
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Superpoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Nro. Operacion                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_CheckArcd1006Gral...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_chkPautasCobl(): Retorna Pautas por Cobertura         *
      *                                                              *
      *     peCobl   (input)   Cobertura                             *
      *     peTiou   (input)   Tipo Operacion                        *
      *     peStou   (input)   SubTipo Operacion                     *
      *     peStos   (input)   Tipo Operacion Sistema                *
      *     peFech   (input)   Fecha                                 *
      *     pePaut   (output)  Variante AIR                          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_chkPautasCobl...
     D                 pr              n
     D   peCobl                       2    const
     D   peTiou                       2  0 const
     D   peStou                       2  0 const
     D   peStos                       1  0 const
     D   pePaut                            likeds(pautas)options(*nopass:*omit)
     D   peFech                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * DEPRECATED   Se debe utilizar SPVVEH_getCodInfoauto1()       *
      * SPVVEH_getCodInfoautos(): Retorna Codigo de INFOAUTOS        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Nro. Operacion                        *
      *     pePoco   (input)   Componente                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_getCodInfoautos...
     D                 pr             6  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_getCodInfoauto1(): Retorna Codigo de INFOAUTOS        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Nro. Operacion                        *
      *     pePoco   (input)   Componente                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_getCodInfoauto1...
     D                 pr             7  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_getValGnc(): Retorna Valor de GNC                     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Valor de GNC / -1 caso de error                     *
      * ------------------------------------------------------------ *

     D SPVVEH_getValGnc...
     D                 pr             9  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peFech                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_getValGncComp(): Retorna Valor de GNC Componente      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Nro. Operacion                        *
      *     pePoco   (input)   Componente                            *
      *                                                              *
      * Retorna: Valor de GNC / -1 caso de error                     *
      * ------------------------------------------------------------ *

     D SPVVEH_getValGncComp...
     D                 pr             9  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_chkGnc(): Retorna si Componente con GNC               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Nro. Operacion                        *
      *     pePoco   (input)   Componente                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_chkGnc...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_getValGncUlt(): Retorna Valor de GNC Componente       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Superpoliza                           *
      *     pePoco   (input)   Componente                            *
      *                                                              *
      * Retorna: Valor de GNC / -1 caso de error                     *
      * ------------------------------------------------------------ *

     D SPVVEH_getValGncUlt...
     D                 pr             9  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_getMinMaxSuma(): Retorna % de Suma Asegurada          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peMone   (input)   Moneda                                *
      *     peSumh   (input)   Suma Asegurada                        *
      *     peMini   (output)  % Minimo                              *
      *     peMaxi   (output)  % Maximo                              *
      *                                                              *
      * Retorna: Valor de GNC / -1 caso de error                     *
      * ------------------------------------------------------------ *

     D SPVVEH_getMinMaxSuma...
     D                 pr              n
     D   peMone                       2    const
     D   peSumh                      15  2 const
     D   peMini                       5  2
     D   peMaxi                       5  2

      * ------------------------------------------------------------ *
      * SPVVEH_getRastreador(): Retorna Código de Rastreador         *
      *                                                              *
      *     peCobl   (input)   Cobertura                             *
      *     peTiou   (input)   Tipo de operación                     *
      *     peStou   (input)   Subtipo de operación Usiario          *
      *     peStos   (output)  Subtipo de operación Sistema          *
      *     peScta   (output)  Subtabla AIR                          *
      *                                                              *
      * Retorna: Código de Rastreador / -1 caso de error             *
      * ------------------------------------------------------------ *

     D SPVVEH_getRastreador...
     D                 pr             3  0
     D   peCobl                       2    const
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peStos                       2  0 const
     D   peScta                       1  0 const
      * ----------------------------------------------------------------- *
      * SPVVEH_getClasificacion(): Devuelve Capítulo, variante AIR,       *
      *                            Variante RC y tarifa diferencial       *
      *        Input :                                                    *
      *                                                                   *
      *                peVhmc  -  Marca del Vehículo                      *
      *                peVhmo  -  Modelo del Vehículo                     *
      *                peVhcs  -  SubModelo del Vehículo                  *
      *                                                                   *
      *        Output :                                                   *
      *                                                                   *
      *                peVhca  -  Capítulo                                *
      *                peVhv1  -  Variante R.C.                           *
      *                peVhv2  -  Variante Air                            *
      *                peMtdf  -  Tarifa Diferencial                      *
      *                                                                   *
      * ----------------------------------------------------------------- *
     D SPVVEH_getClasificacion...
     D                 pr              n
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peVhca                       2  0
     D   peVhv1                       1  0
     D   peVhv2                       1  0
     D   peMtdf                       1
      * ----------------------------------------------------------------- *
      * SPVVEH_getCarroceria(): Devuelve el codigo de carroceria          *
      *                                                                   *
      *        Input :                                                    *
      *                                                                   *
      *                peVhmc  -  Marca del Vehículo                      *
      *                peVhmo  -  Modelo del Vehículo                     *
      *                peVhcs  -  SubModelo del Vehículo                  *
      *                                                                   *
      * ----------------------------------------------------------------- *
     D SPVVEH_getCarroceria...
     D                 pr             3
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
      * ----------------------------------------------------------------- *
      * SPVVEH_getTipoVehiculo():Devuelve el tipo de Vehiculo             *
      *                                                                   *
      *        Input :                                                    *
      *                                                                   *
      *                peVhmc  -  Marca del Vehículo                      *
      *                peVhmo  -  Modelo del Vehículo                     *
      *                peVhcs  -  SubModelo del Vehículo                  *
      *                                                                   *
      * ----------------------------------------------------------------- *
     D SPVVEH_getTipoVehiculo...
     D                 pr             2  0
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
      * ------------------------------------------------------------ *
      * SPVVEH_coberturaD: Busca Coberturas D.                       *
      *                                                              *
      *        peEmpr (input)  Empresa                               *
      *        peSucu (input)  Sucursal                              *
      *        peArcd (input)  Articulo                              *
      *        peSpol (input)  SuperPoliza                           *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SPVVEH_coberturaD...
     D                 pr              n
     D   peEmpr                       1      const
     D   peSucu                       2      const
     D   peArcd                       6  0   const
     D   peSpol                       9  0   const

      * ------------------------------------------------------------ *
      * SPVVEH_CheckPatenteDupliSpol(): Chequea Patente Duplicada    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Nro. Superpoliza                      *
      *     peFech   (input)   Fecha                                 *
      *     pePadu   (Output)  Registro con Patente Duplicada        *
      *                                                              *
      * Retorna: *On Si la Patente es Duplicada                      *
      *          *Off Si la Patente No es Duplicada                  *
      * ------------------------------------------------------------ *
     D SPVVEH_CheckPatenteDupliSpol...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peFech                       8  0 options(*Omit:*Nopass)
     D   pePadu                            likeds(patdup)options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_franquiciaManual: Valida si tiene franquicia Manual   *
      *                                                              *
      *        peEmpr (input)  Empresa                               *
      *        peSucu (input)  Sucursal                              *
      *        peArcd (input)  Articulo                              *
      *        peSpol (input)  SuperPoliza                           *
      *        pePoco (input)  Componente                            *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SPVVEH_franquiciaManual...
     D                 pr              n
     D   peEmpr                       1      const
     D   peSucu                       2      const
     D   peArcd                       6  0   const
     D   peSpol                       9  0   const
     D   pePoco                       4  0   const

      * ------------------------------------------------------------ *
      * SPVVEH_franquiciaManualSpol: Valida si SuperPoliza           *
      *                                     tiene franquicia Manual  *
      *        peEmpr (input)  Empresa                               *
      *        peSucu (input)  Sucursal                              *
      *        peArcd (input)  Articulo                              *
      *        peSpol (input)  SuperPoliza                           *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SPVVEH_franquiciaManualSpol...
     D                 pr              n
     D   peEmpr                       1      const
     D   peSucu                       2      const
     D   peArcd                       6  0   const
     D   peSpol                       9  0   const

      * ------------------------------------------------------------ *
      * SPVVEH_tablasRcAir: Valida si tiene AIR                      *
      *                                                              *
      *        peEmpr (input)  Empresa                               *
      *        peSucu (input)  Sucursal                              *
      *        peArcd (input)  Articulo                              *
      *        peSpol (input)  SuperPoliza                           *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SPVVEH_tablasRcAir...
     D                 pr              n
     D   peEmpr                       1      const
     D   peSucu                       2      const
     D   peArcd                       6  0   const
     D   peSpol                       9  0   const

      * ------------------------------------------------------------ *
      * SPVVEH_getSumaMovAut() Suma Maxima Mov Automaticos           *
      *                                                              *
      *        peArcd (input)  Articulo                              *
      *        peTiou (input)  Tipo Operacion                        *
      *        peStou (input)  SubTipo Operacion                     *
      *                                                              *
      * Retorna: Monto                                               *
      * ------------------------------------------------------------ *
     D SPVVEH_getSumaMovAut...
     D                 pr            15  2
     D   peArcd                       6  0   const
     D   peTiou                       1  0   const
     D   peStou                       2  0   const

      * ------------------------------------------------------------ *
      * SPVVEH_getPahet0(): Retorna Registro de PAHET0               *
      *                                                              *
      * DEPRECATED: Usar SPVVEH_getPahet02().                        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Nro. Superpoliza                      *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componetne                            *
      *     peSspo   (input)   Suplemento                            *
      *     peDsT0   (Output)  Registro con PAHET0                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SPVVEH_getPahet0...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peSspo                       3  0 options(*Omit:*Nopass)
     D   peDsT0                            likeds(dsPahet0_t)
     D                                     options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_getPahet9(): Retorna Registro de PAHET9               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Nro. Superpoliza                      *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componetne                            *
      *     peDsT9   (Output)  Registro con PAHET9                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SPVVEH_getPahet9...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peDsT9                            likeds(dsPahet9_t)
     D                                     options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_getSumaAccesorios() Suma de Accesorios                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Nro. Superpoliza                      *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componetne                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SPVVEH_getSumaAccesorios...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_getAÑoVehiculo(): Retorna Año del Vehiculo            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Nro. Superpoliza                      *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componetne                            *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SPVVEH_getAÑoVehiculo...
     D                 pr             4  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peSspo                       3  0 options(*Omit:*Nopass)

      * ------------------------------------------------------------ *
      * SPVVEH_getCobertura(): Retorna Cobertura de Componente       *
      *                                                              *
      *        peEmpr (input)  Empresa                               *
      *        peSucu (input)  Sucursal                              *
      *        peArcd (input)  Articulo                              *
      *        peSpol (input)  SuperPoliza                           *
      *        pePoco (input)  Componente                            *
      *                                                              *
      * Retorna: Cobertura                                           *
      * ------------------------------------------------------------ *
     D SPVVEH_getCobertura...
     D                 pr             2
     D   peEmpr                       1      const
     D   peSucu                       2      const
     D   peArcd                       6  0   const
     D   peSpol                       9  0   const
     D   pePoco                       4  0   const

      * ------------------------------------------------------------ *
      * SPVVEH_getCodDeRastreador(): Retorna Código de Rastreador    *
      *                              para Anterior.-                 *
      *        peEmpr (input)  Empresa                               *
      *        peSucu (input)  Sucursal                              *
      *        peRama (input)  Rama                                  *
      *        peArse (input)  Cant. de Polizas por rama             *
      *        pePoco (input)  Componente                            *
      *        peArcd (input)  Cod. de Articulo                      *
      *        peSpo1 (Input)  SuperPoliza                           *
      *                                                              *
      * Retorna: Cod. Rastreador / *Zeros                            *
      * ------------------------------------------------------------ *
     D SPVVEH_getCodDeRastreador...
     D                 pr             3  0
     D   peEmpr                       1      const
     D   peSucu                       2      const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const
     D   peArcd                       6  0   const
     D   peSpol                       9  0   const

      * ------------------------------------------------------------ *
      * SPVVEH_chkVehiculo0KM: Valida si vehiculo es 0KM             *
      *                                                              *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *                                                              *
      * Retorna: *off = No es valido como 0km / *off = 0KM valido    *
      * ------------------------------------------------------------ *
     D SPVVEH_chkVehiculo0km...
     D                 pr              n
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const

      * ------------------------------------------------------------ *
      * SPVVEH_getValor0km(): Retorna Valor de 0km                   *
      *                                                              *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *                                                              *
      * Retorna: 0 = No tiene valor / > 0 Valor                      *
      * ------------------------------------------------------------ *
     D SPVVEH_getValor0km...
     D                 pr            15  2
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const

      * ------------------------------------------------------------ *
      * SPVVEH_chkAÑoVehiculo: Valida si vehiculo corresponde al año *
      *                        ingresado                             *
      *                                                              *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *     peVhan   (input)   Año del Vehiculo                      *
      *                                                              *
      * Retorna: *off = No es valido para el año / *off = Valido     *
      * ------------------------------------------------------------ *
     D SPVVEH_chkAÑoVehiculo...
     D                 pr              n
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peVhan                       4  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_confirmarInspeccion():Retorna si confirma inspeccion  *
      *                                                              *
      *     peCobl   (input)   Codigo de Cobertura                   *
      *     peVhaÑ   (input)   AÑo Vehiculo                          *
      *     peTiou   (input)   Tipo de Operacion                     *
      *     peStou   (input)   Subtipo de Operacion                  *
      *     peStos   (input)   Subtipo de Operacion de Sistema       *
      *     peScta   (input)   Zona                                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVVEH_confirmarInspeccion...
     D                 pr              n
     D   peCobl                       2    Const
     D   peVhaÑ                       4    Const
     D   peTiou                       1  0 Const
     D   peStou                       3  0 Const
     D   peStos                       2  0 Const
     D   peScta                       1  0 Const

      * ---------------------------------------------------------------- *
      * SPVVEH_vehiculo0km() :Valida si es un 0KM o no                   *
      *                                                                  *
      *        Input :                                                   *
      *                peVhan  -  Año del Vehículo                       *
      *                                                                  *
      * Retorna: S/N                                                     *
      * ---------------------------------------------------------------- *
     D SPVVEH_vehiculo0km...
     D                 pr             1
     D   peVhan                       4    const

      * ---------------------------------------------------------------- *
      * SPVVEH_getInspector(): retorna Inspectores de Zona               *
      *                                                                  *
      *        Input :                                                   *
      *                peCopo  -  Codigo Postal                          *
      *                peCops  -  SubCodigo Postal                       *
      *        Output:                                                   *
      *                peNomb  -  Lista de Nombres                       *
      *                                                                  *
      * Retorna: Cantidad Lista de Nombres                               *
      * ---------------------------------------------------------------- *
     D SPVVEH_getInspector...
     D                 pr            10i 0
     D   peCopo                       5  0 Const
     D   peCops                       1  0 Const
     D   peNomb                      40    Dim( 99 )

      * ---------------------------------------------------------------- *
      * SPVVEH_getInspectorWeb(): Retorna Inspectores de Zona Web        *
      *                                                                  *
      *        Input :                                                   *
      *                peCopo  -  Codigo Postal                          *
      *                peCops  -  SubCodigo Postal                       *
      *        Output:                                                   *
      *                peNomb  -  Lista de Nombres                       *
      *                                                                  *
      * Retorna: Cantidad Lista de Nombres                               *
      * ---------------------------------------------------------------- *
     D SPVVEH_getInspectorWeb...
     D                 pr            10i 0
     D   peCopo                       5  0 Const
     D   peCops                       1  0 Const
     D   peNomb                      40    Dim( 99 )

      * ---------------------------------------------------------------- *
      * SPVVEH_getLimiteMaximoRuedasCristales: Retorna Límite Máximo de  *
      *                                        Ruedas y Cristales        *
      *                                                                  *
      *        Input :                                                   *
      *                peCtre  -  Código de Tarifa                       *
      *                peCobl  -  Cobertura                              *
      *        Output:                                                   *
      *                peMaxr  -  Límite Máximo de Ruedas                *
      *                peMaxc  -  Límite Máximo de Cristales             *
      *                                                                  *
      * Retorna: *On / *Off                                              *
      * ---------------------------------------------------------------- *
     D SPVVEH_getLimiteMaximoRuedasCristales...
     D                 pr              n
     D   peCtre                       5  0 Const
     D   peCobl                       2    Const
     D   peMaxr                      15  2
     D   peMaxc                      15  2

      * ---------------------------------------------------------------- *
      * SPVVEH_getLimiteMaximoRuedas: Retorna Límite Máximo de Ruedas    *
      *                                                                  *
      *        Input :                                                   *
      *                peCtre  -  Código de Tarifa                       *
      *                peCobl  -  Cobertura                              *
      *        Output:                                                   *
      *                peMaxr  -  Límite Máximo de Ruedas                *
      *                                                                  *
      * Retorna: *On / *Off                                              *
      * ---------------------------------------------------------------- *
     D SPVVEH_getLimiteMaximoRuedas...
     D                 pr
     D   peCtre                       5  0 Const
     D   peCobl                       2    Const
     D   peMaxr                      15  2

      * ---------------------------------------------------------------- *
      * SPVVEH_getLimiteMaximoCristales: Retorna Límite Máximo de Cris-  *
      *                                  tales                           +
      *                                                                  *
      *        Input :                                                   *
      *                peCtre  -  Código de Tarifa                       *
      *                peCobl  -  Cobertura                              *
      *        Output:                                                   *
      *                peMaxc  -  Límite Máximo de Cristales             *
      *                                                                  *
      * Retorna: *On / *Off                                              *
      * ---------------------------------------------------------------- *
     D SPVVEH_getLimiteMaximoCristales...
     D                 pr
     D   peCtre                       5  0 Const
     D   peCobl                       2    Const
     D   peMaxc                      15  2

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_getCodEquixCodDesRec: Retorna Código Compo. Bonif.    *
     ?*                              Prima equivalente               *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     pePoli   ( input  ) Póliza                               *
     ?*     pePoco   ( input  ) Componente                           *
     ?*     peSuop   ( input  ) Cant.de Polizas                      *
     ?*     peCcbp   ( input  ) Cód. Componente Bonif.               *
     ?*     peCcbe   ( output ) Cód. Compo. Bonif. Equiv.            *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     D SPVVEH_getCodEquixCodDesRec...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const
     D   peCcbp                       3  0 const
     D   peCcbe                       3    options( *nopass : *omit )

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_getCodDesRecxCodEqui: Retorna Código Compo. Bonif.    *
     ?*                              Prima                           *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     pePoli   ( input  ) Póliza                               *
     ?*     pePoco   ( input  ) Componente                           *
     ?*     peSuop   ( input  ) Cant.de Polizas                      *
     ?*     peCcbe   ( input  ) Cód. Compo. Bonif. Equiv.            *
     ?*     peCcbp   ( output ) Cód. Componente Bonif.               *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     D SPVVEH_getCodDesRecxCodEqui...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const
     D   peCcbe                       3    const
     D   peCcbp                       3  0 options( *nopass : *omit )

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_getListaDescuentoRecargo: Retorna Lista de descuento/ *
     ?*                                  recargo                     *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     pePoli   ( input  ) Póliza                               *
     ?*     pePoco   ( input  ) Componente                (opcional) *
     ?*     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     ?*     peDs406  ( output ) Cód. Componente Bonif.               *
     ?*     peDs406  ( output ) Cód. Compo. Bonif. Equiv.            *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     D SPVVEH_getListaDescuentoRecargo...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peDs406                           likeds( dsPahet406_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDs406C                    10i 0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SPVVEH_getRastreadorXSpol(): Retorna Rastreador por Super-   *
      *                              poliza                          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *                                                              *
      * Retorna: Código de Rastreador / 0 Si no existe               *
      * ------------------------------------------------------------ *

     D SPVVEH_getRastreadorXSpol...
     D                 pr             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
      * ------------------------------------------------------------ *
      * SPVVEH_chkSeguroRegistro: Valida si es seguro de Registro    *
      *                                                              *
      *     peVhmc   (input)   Marca                                 *
      *                                                              *
      * Retorna: *on  = Si es Seguro                                 *
      * Retorna: *off = No es Seguro Registro                        *
      * ------------------------------------------------------------ *
     D SPVVEH_chkSeguroRegistro...
     D                 pr              n
     D   peVhca                       2  0 const

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_getPahet3: Retorna datos Prod.Art. Rama Automotores.  *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) Superpoliza                          *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cant. Polizas por Rama               *
     ?*     pePoco   ( input  ) Componente                           *
     ?*     peSspo   ( input  ) Suplemento de la superpoliza         *
     ?*     peSuop   ( input  ) Suplemento de la operacion           *
     ?*     peOper   ( input  ) Operacion                            *
     ?*     peTaaj   ( input  ) Cod. Tabla ajuste                    *
     ?*     peCosg   ( input  ) Item de Scoring                      *
     ?*     peDst3   ( output ) Estr. Prod.Art. Rama Automotores.    *
     ?*     peDst3C  ( output ) cant. Prod.Art. Rama Automotores.    *
     ?*     peForm   ( input  ) Formatear Valores                    *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     D SPVVEH_getPahet3...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peSuop                       4  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peTaaj                       2  0 options( *nopass : *omit ) const
     D   peCosg                       4    options( *nopass : *omit ) const
     D   peDst3                            likeds ( dspahet3_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDst3C                     10i 0 options( *nopass : *omit )
     D   peForm                       1    options( *nopass : *omit )

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_chkPahet3: Retorna datos Prod.Art. Rama Automotores.  *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) Superpoliza                          *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cant. Polizas por Rama               *
     ?*     pePoco   ( input  ) Componente                           *
     ?*     peSspo   ( input  ) Suplemento de la superpoliza         *
     ?*     peSuop   ( input  ) Suplemento de la operacion           *
     ?*     peOper   ( input  ) Operacion                            *
     ?*     peTaaj   ( input  ) Cod. Tabla ajuste                    *
     ?*     peCosg   ( input  ) Item de Scoring                      *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     D SPVVEH_chkPahet3...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peSuop                       4  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peTaaj                       2  0 options( *nopass : *omit ) const
     D   peCosg                       4    options( *nopass : *omit ) const

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_getUltimoSuplemento(): Retorna último suplemento.     *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Artículo                             *
     ?*     peSpol   ( input  ) Superpoliza                          *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cant. Pólizas por Rama               *
     ?*     pePoco   ( input  ) Componente                           *
     ?*     peSspo   ( output ) Suplemento de la superpoliza         *
     ?*     peSuop   ( output ) Suplemento de la operación           *
     ?*     peOper   ( output ) operacion       ( opcional )         *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     D SPVVEH_getUltimoSuplemento...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peSspo                       3  0
     D   peSuop                       3  0
     D   peOper                       7  0 options(*nopass:*omit)

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_validaPreguntas(): Valida Detalle del Scoring         *
     ?*                                                              *
     ?*     peArcd   ( input  ) Codigo de Articulo                   *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cant. Polizas por Rama               *
     ?*     peTaaj   ( input  ) Código de Cuestionario               *
     ?*     peDsIte  ( input  ) Estr. Items de un componente         *
     ?*     peDsIteC ( input  ) Cant. Items de un componente         *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     D SPVVEH_validaPreguntas...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peTaaj                       2  0 const
     D   peDsIte                           likeds (items_t) dim(200)
     D   peDsIteC                    10i 0

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_aplicaScoring(): Aplica Scoring en las primas anuales *
     ?*                                                              *
     ?*     pePrrc   ( input  ) Prima de RC                          *
     ?*     pePrac   ( input  ) Prima de Accidente                   *
     ?*     pePrin   ( input  ) Prima de Incendio                    *
     ?*     pePrro   ( input  ) Prima de Robo                        *
     ?*     pePacc   ( input  ) Prima de Accesorios                  *
     ?*     pePraa   ( input  ) Prima de Ajuste                      *
     ?*     pePrsf   ( input  ) Prima Sin Franquicia                 *
     ?*     pePrce   ( input  ) Prima RC Exterior                    *
     ?*     pePrap   ( input  ) Prima de AP                          *
     ?*     peActu   ( input  ) Actualiza?                           *
     ?*     peTaaj   ( input  ) Código de Cuestionario               *
     ?*     peDsIte  ( in/out ) Estr. Items de un componente         *
     ?*     peDsIteC ( in/out ) Cant. Items de un componente         *
     ?*     poRrcp   ( output ) Prima de RC                          *
     ?*     poRacp   ( output ) Prima de Accidente                   *
     ?*     poRinp   ( output ) Prima de Incendio                    *
     ?*     poRrop   ( output ) Prima de Robo                        *
     ?*     poAccp   ( output ) Prima de Accesorios                  *
     ?*     poRaap   ( output ) Prima de Ajuste                      *
     ?*     poRsfp   ( output ) Prima Sin Franquicia                 *
     ?*     poRcep   ( output ) Prima RC Exterior                    *
     ?*     poRapp   ( output ) Prima de AP                          *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     D SPVVEH_aplicaScoring...
     D                 pr              n
     D   pePrrc                      15  2 const
     D   pePrac                      15  2 const
     D   pePrin                      15  2 const
     D   pePrro                      15  2 const
     D   pePacc                      15  2 const
     D   pePraa                      15  2 const
     D   pePrsf                      15  2 const
     D   pePrce                      15  2 const
     D   pePrap                      15  2 const
     D   peActu                       1    const
     D   peTaaj                       2  0 const
     D   peDsIte                           likeds (items_t) dim(200)
     D   peDsIteC                    10i 0
     D   poPrrc                      15  2
     D   poPrac                      15  2
     D   poPrin                      15  2
     D   poPrro                      15  2
     D   poPacc                      15  2
     D   poPraa                      15  2
     D   poPrsf                      15  2
     D   poPrce                      15  2
     D   poPrap                      15  2

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_validaScoringEmisión(): Valida Detalle del Scoring    *
     ?*                                para la Emisión               *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucursal                             *
     ?*     peArcd   ( input  ) Codigo de Articulo                   *
     ?*     peSpol   ( input  ) Superpoliza                          *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cant. Polizas por Rama               *
     ?*     pePoco   ( input  ) Componente                           *
     ?*     peSspo   ( input  ) Suplemento Superpoliza               *
     ?*     peSuop   ( input  ) Suplemento Operacion                 *
     ?*     peOper   ( input  ) Nro. Operacion                       *
     ?*     peTaaj   ( input  ) Código de Cuestionario               *
     ?*     peDsIte  ( input  ) Estr. Items de un componente         *
     ?*     peDsIteC ( input  ) Cant. Items de un componente         *
     ?*     peTiou   ( input  ) Tipo de Operación                    *
     ?*     peStou   ( input  ) SubTipo de Operación de Usuario      *
     ?*     peStos   ( input  ) SubTipo de Operación de Sistema      *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     D SPVVEH_validaScoringEmision...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peSspo                       3  0 const
     D   peSuop                       3  0 const
     D   peOper                       7  0 const
     D   peTaaj                       2  0 const
     D   peDsIte                           likeds (items_t) dim(200) const
     D   peDsIteC                    10i 0 const
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peStos                       2  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_chkScoringEnEmision(): Retorna si existe una Emision  *
      *                               guardada o vigente de Scoring. *
      *                                                              *
      *        Input :                                               *
      *                peEmpr  -  Empresa                            *
      *                peSucu  -  Sucursal                           *
      *                peTaaj  -  Código de Cuestionario             *
      *                peCosg  -  Código de Pregunta      (Opcional) *
      *                                                              *
      * Retorna: *on = Si encontro / *off = No Encontro              *
      * -------------------------------------------------------------*
     D SPVVEH_chkScoringEnEmision...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peTaaj                       2  0 const
     D   peCosg                       4    options( *nopass : *omit ) const

      * ------------------------------------------------------------ *
      * SPVVEH_getValorUsado: Retorna Valor de Usado                 *
      *                                                              *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *                                                              *
      * Retorna: 0 = No tiene valor / > 0 Valor                      *
      * ------------------------------------------------------------ *
     D SPVVEH_getValorUsado...
     D                 pr            15  2
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const

      * ------------------------------------------------------------ *
      * SPVVEH_getConvSumaAsegurada : Conversor de suma asegurada    *
      *                                                              *
      *     peMon1   (input)   Moneda de entrada                     *
      *     peMon2   (input)   Moneda de salida                      *
      *     peVh0k   (input)   Valor 0km                             *
      *     peVhvu   (input)   Valor Usado                           *
      *                                                              *
      * Retorna: *on = Conversion Ok / *off = Error                  *
      * ------------------------------------------------------------ *
     D SPVVEH_getConvSumaAsegurada...
     D                 pr              n
     D   peMon1                       2    const
     D   peMon2                       2    const
     D   peVh0k                      15  2 const
     D   peVhvu                      15  2 const

      * ------------------------------------------------------------ *
      * SPVVEH_calcSumaAsegurada : Calcula suma asegurada de un      *
      *                            vehiculo.                         *
      *                                                              *
      *     peVhmc   (input)   Marca de vehiculo                     *
      *     peVhmo   (input)   Modelo de vehiculo                    *
      *     peVhcs   (input)   SubModelo de Vehiculo                 *
      *     peArcd   (input)   Articulo                              *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     peMone   (input)   Moneda                                *
      *     peCobl   (input)   Cobertura                             *
      *     peTair   (input)   Numero de tabla air                   *
      *     peVhca   (input)   Capitulo del vehiculo                 *
      *     peVhv2   (input)   Capitulo variante air                 *
      *     peVhvu   (input)   Suma Asegurada                        *
      *                                                              *
      * Retorna: Suma Asegurada / *zeros                             *
      * ------------------------------------------------------------ *
     D SPVVEH_calcSumaAsegurada...
     D                 pr            15  2
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peMone                       2    const
     D   peCobl                       2    const
     D   peTair                       2  0 const
     D   peVhca                       2  0 const
     D   peVhv2                       1  0 const
     D   peVhvu                      15  2 const

      * ------------------------------------------------------------ *
      * SPVVEH_getRangoCapitales : Obtener rando de capitales        *
      *                                                              *
      *     peCobl   (input)   Codigo de cobertura                   *
      *     peTair   (input)   Numero de tabla air                   *
      *     peMone   (input)   Codigo de moneda de emision           *
      *     peVhca   (input)   Capitulo del vehiculo                 *
      *     peVhv2   (input)   Capitulo variante air                 *
      *     peCap1   (input)   Capital desde                         *
      *     peCap2   (input)   Capital hasta                         *
      *     peDsRc   (output)  Estructura de tabla   ( opcional )    *
      *     peDsRcC  (output)  Cantidad de registros ( opcional )    *
      *                                                              *
      * Retorna: *on = encontro / *off = No encontro                 *
      * ------------------------------------------------------------ *
     D SPVVEH_getRangoCapitales...
     D                 pr              n
     D   peCobl                       2    const options(*nopass:*omit)
     D   peTair                       2  0 const options(*nopass:*omit)
     D   peMone                       2    const options(*nopass:*omit)
     D   peVhca                       2  0 const options(*nopass:*omit)
     D   peVhv2                       1  0 const options(*nopass:*omit)
     D   peCap1                      15  2 const options(*nopass:*omit)
     D   peCap2                      15  2 const options(*nopass:*omit)
     D   peDsRc                            likeds( DsSet228_t ) dim( 9999 )
     D                                     options(*nopass:*omit)
     D   peDsRcC                     10i 0 options(*nopass:*omit)

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_getPahet1: Retorna datos Prod.Art. Rama Automotores.  *
     ?*                   Accesorios                                 *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Artículo                             *
     ?*     peSpol   ( input  ) Superpoliza                          *
     ?*     peSspo   ( input  ) Suplemento de la superpoliza         *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cant. Pólizas por Rama               *
     ?*     peOper   ( input  ) Operación                            *
     ?*     pePoco   ( input  ) Componente                           *
     ?*     peSuop   ( input  ) Suplemento de la operación           *
     ?*     peSecu   ( input  ) Secuencia Accesorios                 *
     ?*     peDst1   ( output ) Estr. Prod.Art. Rama Automotores.    *
     ?*     peDst1C  ( output ) cant. Prod.Art. Rama Automotores.    *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     D SPVVEH_getPahet1...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       4  0 options( *nopass : *omit ) const
     D   peSecu                       2  0 options( *nopass : *omit ) const
     D   peDst1                            likeds ( dspahet1_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDst1C                     10i 0 options( *nopass : *omit )

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_setPahet1: Graba datos Prod.Art. Rama Automotores.    *
     ?*                   Accesorios                                 *
     ?*                                                              *
     ?*     peDst1   ( imput  ) Estr. Prod.Art. Rama Automotores.    *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     D SPVVEH_setPahet1...
     D                 pr              n

     D  peDst1                             likeds ( dspahet1_t )
     D                                     options( *nopass : *omit ) const

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_setPahet3: Graba datos Prod.Art. Rama Automotores     *
     ?*                   Scoring.                                   *
     ?*                                                              *
     ?*     peDst3   ( imput  ) Estr. Prod.Art. Rama Automotores.    *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     D SPVVEH_setPahet3...
     D                 pr              n

     D  peDst3                             likeds ( dspahet3_t )
     D                                     options( *nopass : *omit ) const

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_setPahet4: Graba Composición Descuentos/Recargos de   *
     ?*                   Item Autos.                                *
     ?*                                                              *
     ?*     peDst4   ( imput  ) Estr. Prod.Art. Descuento/Recargo    *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     D SPVVEH_setPahet4...
     D                 pr              n

     D  peDst4                             likeds ( dspahet4_t )
     D                                     options( *nopass : *omit ) const

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_getPahet5: Retorna datos Carta de Daños/restricciones *
     ?*                   de Cobertura.                              *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Artículo                             *
     ?*     peSpol   ( input  ) Superpoliza                          *
     ?*     peSspo   ( input  ) Suplemento de la superpoliza         *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cant. Pólizas por Rama               *
     ?*     peOper   ( input  ) Operación                            *
     ?*     pePoco   ( input  ) Componente                           *
     ?*     peSuop   ( input  ) Suplemento de la operación           *
     ?*     peCdaÑ   ( input  ) Código de Daño                       *
     ?*     peDst5   ( output ) Estr. Prod.Art. Rama Automotores.    *
     ?*     peDst5C  ( output ) cant. Prod.Art. Rama Automotores.    *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     D SPVVEH_getPahet5...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       4  0 options( *nopass : *omit ) const
     D   peCdaÑ                       4  0 options( *nopass : *omit ) const
     D   peDst5                            likeds ( dspahet5_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDst5C                     10i 0 options( *nopass : *omit )

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_setPahet5: Graba Carta de Daños/Restricciones de      *
     ?*                   Cobertura.                                 *
     ?*                                                              *
     ?*     peDst5   ( imput  ) Estr. Carta de Daños/Restricciones.  *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     D SPVVEH_setPahet5...
     D                 pr              n

     D  peDst5                             likeds ( dspahet5_t )
     D                                     options( *nopass : *omit ) const

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_getPahet6: Retorna datos Carta de Daños/Restricciones *
     ?*                   Cobertura.
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Artículo                             *
     ?*     peSpol   ( input  ) Superpoliza                          *
     ?*     peSspo   ( input  ) Suplemento de la superpoliza         *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cant. Pólizas por Rama               *
     ?*     peOper   ( input  ) Operación                            *
     ?*     pePoco   ( input  ) Componente                           *
     ?*     peSuop   ( input  ) Suplemento de la operación           *
     ?*     peNcon   ( input  ) Número de Conductor                  *
     ?*     peDst6   ( output ) Estr. Prod.Art. Rama Automotores.    *
     ?*     peDst6C  ( output ) cant. Prod.Art. Rama Automotores.    *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     D SPVVEH_getPahet6...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       4  0 options( *nopass : *omit ) const
     D   peNcon                       4  0 options( *nopass : *omit ) const
     D   peDst6                            likeds ( dspahet6_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDst6C                     10i 0 options( *nopass : *omit )

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_setPahet6: Graba Carta de Daños/Restricciones de      *
     ?*                   Cobertura.                                 *
     ?*                                                              *
     ?*     peDst6   ( imput  ) Estr. Carta de Daños/Restricciones.  *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     D SPVVEH_setPahet6...
     D                 pr              n

     D  peDst6                             likeds ( dspahet6_t )
     D                                     options( *nopass : *omit ) const

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_setPahet9: Graba datos Prod.Art. Rama Automotores.    *
     ?*                                                              *
     ?*     peDst9   ( imput  ) Estr. Prod.Art. Rama Automotores.    *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     D SPVVEH_setPahet9...
     D                 pr              n

     D  peDst9                             likeds ( dspahet9_t )
     D                                     options( *nopass : *omit ) const

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_setPahet0: Graba datos Prod.Art. Rama Automotores.    *
     ?*                                                              *
     ?* DEPRECATED: Usar SPVVEH_setPahet02().                        *
     ?*                                                              *
     ?*     peDst0   ( imput  ) Estr. Prod.Art. Rama Automotores.    *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     D SPVVEH_setPahet0...
     D                 pr              n

     D  peDst0                             likeds ( dspahet0_t )
     D                                     options( *nopass : *omit ) const

      * ------------------------------------------------------------ *
      * SPVVEH_getAÑoVehUsado(): Retorna Año del Vehiculo            *
      *                                                              *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *                                                              *
      * Retorna: 0 = No tiene valor / > 0 Valor                      *
      * ------------------------------------------------------------ *
     D SPVVEH_getAÑoVehUsado...
     D                 pr             4  0
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_chk0km2aÑos(): Chequea si cumple con los filtros de   *
     ?*                       0kms 2 años                            *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Artículo                             *
     ?*     peSpol   ( input  ) Superpoliza                          *
     ?*     peSspo   ( input  ) Suplemento de la superpoliza         *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cant. Pólizas por Rama               *
     ?*     peOper   ( input  ) Operación                            *
     ?*     pePoco   ( input  ) Componente                           *
     ?*     peTipo   ( input  ) Refacturación/Renovación             *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     D SPVVEH_chk0km2aÑos...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peTipo                       1    const

      * ------------------------------------------------------------ *
      * SPVVEH_chkModuloDescRec: Valida si módulo de descuentos y    *
      *                          recargos                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     pePoco   (input)   Componente             ( opcional )   *
      *                                                              *
      * Retorna: *on = Esta Activo / *off = No esta activo           *
      * ------------------------------------------------------------ *
     D SPVVEH_chkModuloDescRec...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   pePoco                       4  0 const options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_calcDescRecSpol : Calcula descuento y recargo de      *
      *                          una póliza                          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     pePoco   (input)   Componente                            *
      *     peVhvu   (input)   Suma Asegurada                        *
      *     peClin   (input)   Cliente Integral       ( opcional )   *
      *     peBure   (input)   Buen Resultado         ( opcional )   *
      *     peTiou   (input)   Tipo Operacion         ( opcional )   *
      *     peStou   (input)   Subtipo Usuario        ( opcional )   *
      *     peStos   (input)   Subtipo Sistema        ( opcional )   *
      *     pePcli   (input)   Porcentaje CI          ( opcional )   *
      *     pePbur   (input)   Porcentaje BURE        ( opcional )   *
      *     @@Dset4  (output)  Estructura Des/Rec     ( opcional )   *
      *     @@Dset4C (output)  cantidad Des/Rec       ( opcional )   *
      *                                                              *
      * Retorna: *on = calculo ok / *off = No calculó                *
      * ------------------------------------------------------------ *
     D SPVVEH_calcDescRecSpol...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   pePoco                       4  0 const
     D   peVhvu                      15  2 const
     D   peClin                        n   const options(*nopass:*omit)
     D   peBure                       1  0 const options(*nopass:*omit)
     D   peTiou                       1  0 const options(*nopass:*omit)
     D   peStou                       2  0 const options(*nopass:*omit)
     D   peStos                       2  0 const options(*nopass:*omit)
     D   pePcli                       5  2 const options(*nopass:*omit)
     D   pePbur                       5  2 const options(*nopass:*omit)
     D   peCobl                       2    const options(*nopass:*omit)
     D   peCob2                       2    const options(*nopass:*omit)
     D   peDset4                           likeds(dsPahet406_t) dim( 999 )
     D                                     options(*nopass:*omit)
     D   peDset4C                    10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_grabDsEt4(): Graba DsEt4 para el archivo PAHET4.      *
      *                                                              *
      *     peCcbp   ( input  ) Cód. Componente Bonificación         *
      *     pePcbp   ( input  ) Porcentaje de Bonificación           *
      *     peMcbp   ( input  ) Valor cambiado por USER 'S/N'        *
      *     peEDs4   ( input  ) Estructura de entrada pahet4         *
      *     peSDs4   ( output ) Estructura de salida pahet4          *
      *     peSDs4C  ( output ) Cantidad de registro                 *
      *                                                              *
      * ------------------------------------------------------------ *
     D SPVVEH_grabDsEt4...
     D                 pr
     D   peCcbp                       3  0 const
     D   pePcbp                       5  2 const
     D   peMcbp                       1    const
     D   peEDs4                            likeds(dsPahet406_t) const
     D   peSDs4                            likeds(dsPahet406_t) dim( 999 )
     D   peSDs4C                     10i 0

      * ------------------------------------------------------------ *
      * SPVVEH_chkPahet4 : Valida Descuento en Vehiculo de una       *
      *                    Superpoliza                               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Componente                            *
      *     peOper   (input)   Operacion                             *
      *     peSuop   (input)   Suplemento de Operacion               *
      *     peCcbp   (input)   Codigo de Descuento                   *
      *                                                              *
      * Retorna: *on = Existe / *off 0 No existe                     *
      * ------------------------------------------------------------ *
     D SPVVEH_chkPahet4...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       4  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   peCcbp                       3  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_chkVehiculo0kmSpol: Valida si vehiculo tiene descuento*
      *                            de 0km                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Componente                            *
      *     peOper   (input)   Operacion                             *
      *     peSuop   (input)   Suplemento de Operacion               *
      *     pePoco   (input)   Codigo de componente                  *
      *     peTiou   (input)   Tipo de Operacion       ( opcional )  *
      *     peStou   (input)   Subtipo de Operacion    ( opcional )  *
      *     peStos   (input)   Subtipo de Op. Sistema  ( opcional )  *
      *                                                              *
      * Retorna: *on = Existe / *off = No existe                     *
      * ------------------------------------------------------------ *
     D SPVVEH_chkVehiculo0kmSpol...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       4  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   pePoco                       4  0 const
     D   peTiou                       1  0 const options(*nopass:*omit)
     D   peStou                       2  0 const options(*nopass:*omit)
     D   peStos                       2  0 const options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_chkDescuentoReno(): Chequea descuento para la renova- *
      *                            ción.                             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Artículo                              *
      *     peRama   (input)   Rama                                  *
      *     peCcbp   (input)   Código de descuento                   *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SPVVEH_chkDescuentoReno...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbp                       3  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_chkCoberturaDesc(): Chequea cobertura del descuento   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peCcbp   (input)   Código de descuento                   *
      *     pePbur   (input)   Porcentaje de Descuento BURE          *
      *     peCobl   (input)   Cobertura                             *
      *     peCob2   (input)   Cobertura por Omisión                 *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SPVVEH_chkCoberturaDesc...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peCcbp                       3  0 const
     D   pePbur                       5  2 const
     D   peCobl                       2    const
     D   peCob2                       2    const

      * ------------------------------------------------------------ *
      * SPVVEH_calcPrimaAnual : Calcula prima de un vehiculo         *
      *                                                              *
      *     peCobl   (input)   Cobertura                             *
      *     peVhvu   (input)   Valor usado                           *
      *     peVh0k   (input)   Valor cero kilometro                  *
      *     peVacc   (input)   Valor Accesorios                      *
      *     peClaj   (input)   Clausula de ajuste                    *
      *     peRebr   (input)   Buen Resultado                        *
      *     peCfas   (input)   Código de Franquicia                  *
      *     peTarc   (input)   Tabla RC                              *
      *     peTair   (input)   Tabla AIR                             *
      *     peScta   (input)   Zona                                  *
      *     peVhca   (input)   Capitulo del vehiculo                 *
      *     peVhv1   (input)   Capitulo variante r.c.                *
      *     peVhv2   (input)   Capitulo variante air                 *
      *     peVhaÑ   (input)   Año del Vechiculo                     *
      *     peVhni   (input)   Origen del Vehiculo                   *
      *     peVhct   (input)   Tipo de vehiculo                      *
      *     peVhuv   (input)   Codigo de uso de vehiculo             *
      *     peMone   (input)   Codigo de Moneda                      *
      *     peNcoc   (input)   Codigo de Coaseguradora               *
      *     peMar1   (input)   Buscar en tabla general RC            *
      *     peMar2   (input)   Buscar en tabla general AIR           *
      *     peDesc   (input)   Total de Descuentos                   *
      *     pe0km    (input)   Marca de 0Km                          *
      *     peFvid   (input)   Fecha de Vigencia                     *
      *     peCtre   (output)  Codigo de Tarifa                      *
      *     peMtdf   (output)  Marca tarifa diferencial              *
      *     poPrrc   (output)  Importe de Prima RC                   *
      *     poPrac   (output)  Importe de Prima por Accidente        *
      *     poPrin   (output)  Importe de Prima por Incendio         *
      *     poPrro   (output)  Importe de Prima Robo                 *
      *     poPacc   (output)  Importe de Prima Accesorio            *
      *     poPraa   (output)  Importe de Prima Ajuste Automatico    *
      *     poPrsf   (output)  Importe de Prima sin Franquicia       *
      *     poPrce   (output)  Importe de Prima Exterior             *
      *     poPrap   (output)  Importe de Prima por Accidente Pers.  *
      *     poRcle   (output)  Limite RC de Lesiones                 *
      *     poRcco   (output)  Limite RC Cosas                       *
      *     poRcac   (output)  Limite RC Acontecimientos             *
      *     poLrce   (output)  Limite RC de Exterior                 *
      *     poSaap   (output)  Suma.Aseg.Acci.Personales             *
      *     poSdes   (output)  Suma.Aseg.Descuentos                  *
      *                                                              *
      * Retorna: *on = Calculó / *off = No Calculó                   *
      * ------------------------------------------------------------ *
     D SPVVEH_calcPrimaAnual...
     D                 pr              n
     D   peCobl                       2    const
     D   peVhvu                      15  2 const
     D   peVh0k                      15  2 const
     D   peVacc                      15  0 const
     D   peClaj                       3  0 const
     D   peRebr                       1  0 const
     D   peCfas                       1    const
     D   peTarc                       2  0 const
     D   peTair                       2  0 const
     D   peScta                       1  0 const
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const
     D   peVhv2                       1  0 const
     D   peVhaÑ                       4  0 const
     D   peVhni                       1    const
     D   peVhct                       2  0 const
     D   peVhuv                       2  0 const
     D   peMone                       2    const
     D   peNcoc                       5  0 const
     D   peMar1                       1    const
     D   peMar2                       1    const
     D   peDesc                       5  2 const
     D   pe0km                         n   const
     D   peFvid                       8  0 const
     D   peCtre                       5  0 const
     D   peMtdf                       1    const
     D   poPrrc                      15  2
     D   poPrac                      15  2
     D   poPrin                      15  2
     D   poPrro                      15  2
     D   poPacc                      15  2
     D   poPraa                      15  2
     D   poPrsf                      15  2
     D   poPrce                      15  2
     D   poPrap                      15  2
     D   poRcle                      15  2
     D   poRcco                      15  2
     D   poRcac                      15  2
     D   poLrce                      15  2
     D   poSaap                      15  2
     D   poSdes                       5  2

      * ------------------------------------------------------------ *
      * SPVVEH_calcPrimaPeriodo: Calcula prima de un vehiculo        *
      *                          para un peridodo determinado        *
      *                                                              *
      *     peFini   ( input )   Fecha Inicio de Vigencia            *
      *     peFfin   ( input )   Fecha Fin de Vigencia               *
      *     peFhaf   ( input )   Fecha Hasta Facturado               *
      *     pePrrc   ( input )   Importe de Prima RC                 *
      *     pePrac   ( input )   Importe de Prima por Accidente      *
      *     pePrin   ( input )   Importe de Prima por Incendio       *
      *     pePrro   ( input )   Importe de Prima Robo               *
      *     pePacc   ( input )   Importe de Prima Accesorio          *
      *     pePraa   ( input )   Importe de Prima Ajuste Automatico  *
      *     pePrsf   ( input )   Importe de Prima sin Franquicia     *
      *     pePrce   ( input )   Importe de Prima Exterior           *
      *     pePrap   ( input )   Importe de Prima por Accidente Pers.*
      *     peTiou   ( input )   Tipo de Operacion                   *
      *     peStou   ( input )   Subtipo Usuario                     *
      *     peStos   ( input )   Subtipo Sistema                     *
      *                                                              *
      ****************************************************************
     D SPVVEH_calcPrimaPeriodo...
     D                 pr              n
     D   peFini                       8  0 const
     D   peFfin                       8  0 const
     D   peFhaf                       8  0 const
     D   pePrrc                      15  2
     D   pePrac                      15  2
     D   pePrin                      15  2
     D   pePrro                      15  2
     D   pePacc                      15  2
     D   pePraa                      15  2
     D   pePrsf                      15  2
     D   pePrce                      15  2
     D   pePrap                      15  2
     D   peDup2                       2  0 options(*nopass:*omit)
     D   peTiou                       1  0 options(*nopass:*omit)
     D   peStou                       2  0 options(*nopass:*omit)
     D   peStos                       2  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_calcPremio(): Calcular Premio                         *
      *                                                              *
      *    peArcd  -  Codigo de Articulo                             *
      *    peRpro  -  Provincia Inder                                *
      *    peNrpp  -  Plan de Pago                                   *
      *    peCfpg  -  Forma de Pago                                  *
      *                                                              *
      * Retorna: Premio                                              *
      * -------------------------------------------------------------*
     D SPVVEH_calcPremio...
     D                 pr            15  2
     D   peArcd                       6  0 const
     D   peRpro                       2  0 const
     D   pePrim                      15  2 const
     D   peNrpp                       3  0 const
     D   peCfpg                       1  0 const
     D   peTiso                       1  0 const
     D   peAsen                       7  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_getPahet4 : Retorna Descuentos de un Vehiculo de una  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Componente                            *
      *     peOper   (input)   Operacion                             *
      *     peSuop   (input)   Suplemento de Operacion               *
      *     pePoco   (input)   Nro de Componente                     *
      *     peCcbp   (input)   Codigo de Descuento                   *
      *     peDsT4   (Output)  Registro con PAHET4                   *
      *     peDsT4C  (Output)  Cantidad de Registros                 *
      *                                                              *
      * Retorna: *on = Existe / *off = No existe                     *
      * ------------------------------------------------------------ *
     D SPVVEH_getPahet4...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const options( *omit : *nopass )
     D   peRama                       2  0 const options( *omit : *nopass )
     D   peArse                       4  0 const options( *omit : *nopass )
     D   peOper                       7  0 const options( *omit : *nopass )
     D   peSuop                       3  0 const options( *omit : *nopass )
     D   pePoco                       4  0 const options( *omit : *nopass )
     D   peCcbp                       3  0 const options( *omit : *nopass )
     D   peDsT4                            likeds(dsPahet4_t) dim(999)
     D                                     options( *omit : *nopass )
     D   peDsT4C                     10i 0 options( *omit : *nopass )

      * ------------------------------------------------------------ *
      * SPVVEH_getUltimoSuop : Obtener ultimo nro de suplemento de   *
      *                        operacion de un componentee           *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArcd   ( input  ) Aticulo                              *
      *     peSpol   ( input  ) SuperPoliza                          *
      *     pePoco   ( input  ) Componente                           *
      *                                                              *
      * Retorna: -1:No encontro / >= 0:Encontro                      *
      * ------------------------------------------------------------ *
     D SPVVEH_getUltimoSuop...
     D                 pr             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_getListaPahet9(): Retorna Lista de PAHET9             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Nro. Superpoliza                      *
      *     peRama   (input)   Rama                ( opcional )      *
      *     peArse   (input)   Arse                ( opcional )      *
      *     pePoco   (input)   Componetne          ( opcional )      *
      *     peDsT9   (Output)  Estructura PAHET9   ( opcional )      *
      *     peDsT9C  (Output)  Cantidad   PAHET9   ( opcional )      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SPVVEH_getListaPahet9...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const options(*nopass:*omit)
     D   peArse                       2  0 const options(*nopass:*omit)
     D   peOper                       7  0 const options(*nopass:*omit)
     D   pePoco                       4  0 const options(*nopass:*omit)
     D   peDsT9                            likeds(dsPahet9_t) dim( 999 )
     D                                     options(*nopass:*omit)
     D   peDst9C                     10i 0 options(*nopass:*omit)

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_aplicaRevScoring(): Aplica Reverso de Scoring en las  *
     ?*                            primas                            *
     ?*                                                              *
     ?*     pePrrc   ( input  ) Prima de RC                          *
     ?*     pePrac   ( input  ) Prima de Accidente                   *
     ?*     pePrin   ( input  ) Prima de Incendio                    *
     ?*     pePrro   ( input  ) Prima de Robo                        *
     ?*     pePacc   ( input  ) Prima de Accesorios                  *
     ?*     pePraa   ( input  ) Prima de Ajuste                      *
     ?*     pePrsf   ( input  ) Prima Sin Franquicia                 *
     ?*     pePrce   ( input  ) Prima RC Exterior                    *
     ?*     pePrap   ( input  ) Prima de AP                          *
     ?*     peTaaj   ( input  ) Código de Cuestionario               *
     ?*     peDsIte  ( input  ) Estr. Items de un componente         *
     ?*     peDsIteC ( input  ) Cant. Items de un componente         *
     ?*     poRrcp   ( output ) Prima de RC                          *
     ?*     poRacp   ( output ) Prima de Accidente                   *
     ?*     poRinp   ( output ) Prima de Incendio                    *
     ?*     poRrop   ( output ) Prima de Robo                        *
     ?*     poAccp   ( output ) Prima de Accesorios                  *
     ?*     poRaap   ( output ) Prima de Ajuste                      *
     ?*     poRsfp   ( output ) Prima Sin Franquicia                 *
     ?*     poRcep   ( output ) Prima RC Exterior                    *
     ?*     poRapp   ( output ) Prima de AP                          *
     ?*                                                              *
     ?* ------------------------------------------------------------ *
     D SPVVEH_aplicaRevScoring...
     D                 pr
     D   pePrrc                      15  2 const
     D   pePrac                      15  2 const
     D   pePrin                      15  2 const
     D   pePrro                      15  2 const
     D   pePacc                      15  2 const
     D   pePraa                      15  2 const
     D   pePrsf                      15  2 const
     D   pePrce                      15  2 const
     D   pePrap                      15  2 const
     D   peTaaj                       2  0 const
     D   peDsIte                           likeds (items_t) dim(200) const
     D   peDsIteC                    10i 0 const
     D   poPrrc                      15  2
     D   poPrac                      15  2
     D   poPrin                      15  2
     D   poPrro                      15  2
     D   poPacc                      15  2
     D   poPraa                      15  2
     D   poPrsf                      15  2
     D   poPrce                      15  2
     D   poPrap                      15  2

      * ------------------------------------------------------------ *
      * SPVVEH_getPrimasAcumu(): Retonar primas acumuladas           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Nro. Superpoliza                      *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componetne                            *
      *     pePrrc   (input)   Prima de RC                           *
      *     pePrac   (input)   Prima de Accidente                    *
      *     pePrin   (input)   Prima de Incendio                     *
      *     pePrro   (input)   Prima de Robo                         *
      *     pePacc   (input)   Prima de Accesorios                   *
      *     pePraa   (input)   Prima de Ajuste                       *
      *     pePrsf   (input)   Prima Sin Franquicia                  *
      *     pePrce   (input)   Prima RC Exterior                     *
      *     pePrap   (input)   Prima de AP                           *
      *     pePrim   (input)   Prima Total                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SPVVEH_getPrimasAcumu...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   pePrrc                      15  2
     D   pePrac                      15  2
     D   pePrin                      15  2
     D   pePrro                      15  2
     D   pePacc                      15  2
     D   pePraa                      15  2
     D   pePrsf                      15  2
     D   pePrce                      15  2
     D   pePrap                      15  2
     D   pePrim                      15  2

      * ---------------------------------------------------------------- *
      * SPVVEH_getLimitesRC(): obtener limites de cobertura RC           *
      *                                                                  *
      *     peTarc ( intput ) Tabla de RC                                *
      *     peMone ( intput ) Moneda                                     *
      *     peRcle ( output ) Rc Lesiones                                *
      *     peRcco ( output ) RC Cosas                                   *
      *     peRcac ( output ) RC Acontecimiento                          *
      *     peLrce ( output ) RC Exterior                                *
      *     peCtre ( intput ) Codigo de tarifa                           *
      *     peVhca ( intput ) Capitulo                                   *
      *     peVhv1 ( intput ) Variante RC                                *
      *     peMtdf ( intput ) Marca de Tarifa Diferencial                *
      *     peScta ( intput ) Zona                                       *
      *                                                                  *
      * Retona : *on = obtuvo / *off = no obtuvo                         *
      * ---------------------------------------------------------------- *
     D SPVVEH_getLimitesRC...
     D                 pr              n
     D   peTarc                       2  0  const
     D   peMone                       2     const
     D   peRcle                      15  2
     D   peRcco                      15  2
     D   peRcac                      15  2
     D   peLrce                      15  2
     D   peCtre                       5  0  const
     D   peVhca                       2  0  const
     D   peVhv1                       1  0  const
     D   peMtdf                       1a    const
     D   peScta                       1  0  const

      * ---------------------------------------------------------------- *
      * SPVVEH_chkVigencia : Obtener limites de cobertura RC             *
      *                                                                  *
     *     Si no se envían fechas se toma la del día ( par310x3 )       *
      *                                                                  *
      *     peEmpr ( intput ) Empresa                                    *
      *     peSucu ( intput ) Sucursal                                   *
      *     peArcd ( intput ) Artículo                                   *
      *     peSpol ( intput ) Superpoliza                                *
      *     peRama ( intput ) Rama                                       *
      *     peArse ( intput ) Secuencia Articulo/rama                    *
      *     peOper ( intput ) Nro de operaion                            *
      *     pePoco ( intput ) Nro de componente                          *
      *     peVig2 ( intput ) Valida SPVVIG2? 1=Si / 0=No                *
      *     peSspo ( output ) Suplemento                                 *
      *     peSuop ( output ) Suplemento Operación                       *
      *     peFvig ( intput ) Fecha de Vigencia         (opcional)       *
      *     peFemi ( intput ) Fecha de emision          (opcional)       *
      *                                                                  *
      * Retorna: *on = Vigente / *off = No vigente                       *
      * ---------------------------------------------------------------- *
     D SPVVEH_chkVigencia...
     D                 pr              n
     D  peEmpr                        1    const
     D  peSucu                        2    const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peOper                        7  0 const
     D  pePoco                        4  0 const
     D  peVig2                         n   const
     D  peSspo                        3  0 options(*nopass:*omit)
     D  peSuop                        3  0 options(*nopass:*omit)
     D  peFvig                        8  0 options(*nopass:*omit)
     D  peFemi                        8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVVEH_getDescDecreciente(): Obtener descuento decreciente   *
      *                                                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peRama   (input)   Codigo de Rama                        *
      *     peTiou   (input)   Tipo de Operacion                     *
      *     peStou   (input)   Subtipo de Operacion                  *
      *     peFemi   (input)   Fecha de Emision                      *
      *     peNref   (input)   Numero de Refacturacion (0=Endoso 0)  *
      *     pePcbp   (output)  Porcentaje a usar                     *
      *                                                              *
      * Retorna: *On si debe aplicarse y *Off si no debe aplicarse   *
      * ------------------------------------------------------------ *
     D SPVVEH_getDescDecreciente...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peFemi                       8  0 const
     D   peNref                       2  0 const
     D   pePcbp                       5  2

      * ------------------------------------------------------------ *
      * SPVVEH_chkLocalidadZona(): Valida Localidad vs Zona          *
      *                                                              *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   Sufijo de Codigo Postal               *
      *     peScta   (input)   Zona                                  *
      *                                                              *
      * Retorna: *On si OK y *OFF si falla.                          *
      * ------------------------------------------------------------ *
     D SPVVEH_chkLocalidadZona...
     D                 pr              n
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peScta                       1  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_getPahet02(): Retorna Registro de PAHET0              *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Nro. Superpoliza                      *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componetne                            *
      *     peSspo   (input)   Suplemento                            *
      *     peDsT0   (Output)  Registro con PAHET0                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SPVVEH_getPahet02...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peSspo                       3  0 options(*Omit:*Nopass)
     D   peDsT0                            likeds(dsPahet02_t)
     D                                     options(*nopass:*omit)

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_setPahet0: Graba datos Prod.Art. Rama Automotores.    *
     ?*                                                              *
     ?*     peDst0   ( imput  ) Estr. Prod.Art. Rama Automotores.    *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     D SPVVEH_setPahet02...
     D                 pr              n
     D  peDst0                             likeds ( dspahet02_t )
     D                                     options( *nopass : *omit ) const

      * ------------------------------------------------------------ *
      * SPVVEH_getUltimoEstadoComponente():                          *
      *                                                              *
      *     peEmpr   (input)   Cod. Empresa                          *
      *     peSucu   (input)   Cod. Sucursal                         *
      *     peArcd   (input)   Cod. Articulo                         *
      *     peSpol   (input)   Nro. Superpoliza                      *
      *     peRama   (input)   Cod. Rama                             *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Nro. Operacion                        *
      *     pePoco   (input)   Nro. Componente                       *
      *     peDsT0   (Output)  Registro con PAHET0                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SPVVEH_getUltimoEstadoComponente...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peDsT0                            likeds(dsPahet002_t)

      * ----------------------------------------------------------------- *
      * SPVVEH_getPahet7(): Retorna datos de Pahet7                       *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peArcd   ( input  ) Artículo                              *
      *         peSpol   ( input  ) Superpoliza                           *
      *         peSspo   ( input  ) Suplemento de Superpoliza             *
      *         peRama   ( input  ) Rama                                  *
      *         peArse   ( input  ) Cant.Pólizas por rama/art ( opcional )*
      *         peOper   ( input  ) Número de Operación       ( opcional )*
      *         peSuop   ( input  ) Suplemento de la Operación( opcional )*
      *         pePoco   ( input  ) Número de Componente      ( opcional )*
      *         peCcoe   ( input  ) Código de Componente Bonif( opcional )*
      *         peLet7   ( output ) Estructura PAHET7         ( opcional )*
      *         peLet7C  ( output ) Cantidad   PAHET7         ( opcional )*
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SPVVEH_getPahet7...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *Nopass : *Omit ) const
     D   peRama                       2  0 options( *Nopass : *Omit ) const
     D   peArse                       2  0 options( *Nopass : *Omit ) const
     D   peOper                       7  0 options( *Nopass : *Omit ) const
     D   peSuop                       3  0 options( *Nopass : *Omit ) const
     D   pePoco                       4  0 options( *Nopass : *Omit ) const
     D   peCcoe                       3  0 options( *Nopass : *Omit ) const
     D   peLet7                            likeds(dsPahet7_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLet7C                     10i 0 options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SPVVEH_chkPahet7(): Valida si existe Factores Multiplicativos*
      *                     AUTOS.                                   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento de Superpoliza             *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant.Pólizas por rama/art             *
      *     peOper   (input)   Número de Operación                   *
      *     peSuop   (input)   Suplemento de la Operación            *
      *     pePoco   (input)   Número de Componente                  *
      *     peCcoe   (input)   Código de Componente Bonif            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SPVVEH_chkPahet7...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   pePoco                       4  0 const
     D   peCcoe                       3  0 const

      * ----------------------------------------------------------------- *
      * SPVVEH_setPahet7(): Graba datos en el archivo pahet7              *
      *                                                                   *
      *          peDsT7   ( input  ) Estrutura de pahet7                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SPVVEH_setPahet7...
     D                 pr              n
     D   peDsT7                            likeds( dsPahet7_t ) const

      * ----------------------------------------------------------------- *
      * SPVVEH_updPahet7(): Actualiza datos en el archivo pahet7          *
      *                                                                   *
      *          peDsT7   ( input  ) Estrutura de pahet7                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SPVVEH_updPahet7...
     D                 pr              n
     D   peDsT7                            likeds( dsPahet7_t ) const

      * ----------------------------------------------------------------- *
      * SPVVEH_dltPahet7(): Elimina datos en el archivo pahet7            *
      *                                                                   *
      *          peDsT7   ( input  ) Estrutura de pahet7                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SPVVEH_dltPahet7...
     D                 pr              n
     D   peDsT7                            likeds( dsPahet7_t ) const

      * ------------------------------------------------------------ *
      * SPVVEH_chkAditivoMarcaModelo(): Retorna si un auto et7       *
      *                                                              *
      *       peEmpr  (input)  Empresa                               *
      *       peSucu  (input)  Sucursal                              *
      *       peArcd  (input)  Artículo                              *
      *       peSpol  (input)  Superpóliza                           *
      *       peSspo  (input)  Suplemento (EL QUE SE ESTA EMITIENDO) *
      *       peRama  (input)  Rama                                  *
      *       peArse  (input)  Secuencia Artículo/Rama               *
      *       peOper  (input)  Operacion                             *
      *       peSuop  (input)  Suplemento (EL QUE SE ESTA EMITIENDO) *
      *       pePoco  (input)  Componente                            *
      *                                                              *
      * retorna El porcentaje convertido a coeficiente o un 1 si no  *
      *         tenia marca/modelo.                                  *
      * ------------------------------------------------------------ *
     D SPVVEH_chkAditivoMarcaModelo...
     D                 pr             7  4
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peOper                        7  0 const
     D  peSuop                        3  0 const
     D  pePoco                        4  0 const

      * ------------------------------------------------------------ *
      * SPVVEH_getUltimoCoeficienteMarcaModelo(): Retorna último     *
      *                       factor marca/modelo aplicado.          *
      *                                                              *
      *       peEmpr  (input)  Empresa                               *
      *       peSucu  (input)  Sucursal                              *
      *       peArcd  (input)  Artículo                              *
      *       peSpol  (input)  Superpóliza                           *
      *       peSspo  (input)  Suplemento (EL QUE SE ESTA EMITIENDO) *
      *       peRama  (input)  Rama                                  *
      *       peArse  (input)  Secuencia Artículo/Rama               *
      *       peOper  (input)  Operacion                             *
      *       peSuop  (input)  Suplemento (EL QUE SE ESTA EMITIENDO) *
      *       pePoco  (input)  Componente                            *
      *                                                              *
      * retorna El coeficiente aplicado o 1 si no tenia.             *
      * ------------------------------------------------------------ *
     D SPVVEH_getUltimoCoeficienteMarcaModelo...
     D                 pr             7  4
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peOper                        7  0 const
     D  peSuop                        3  0 const
     D  pePoco                        4  0 const

