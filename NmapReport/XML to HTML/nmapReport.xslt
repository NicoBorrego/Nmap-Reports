<?xml version="1.0" encoding="UTF-8"?>
<!-- Plantilla XSLT mejorada con lista desplegable -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- global variables      -->
  <!-- ............................................................ -->
  <xsl:variable name="nmap_xsl_version">0.9c</xsl:variable>
  <!-- ............................................................ -->
  <xsl:variable name="start"><xsl:value-of select="/nmaprun/@startstr" /></xsl:variable>
  <xsl:variable name="end"><xsl:value-of select="/nmaprun/runstats/finished/@timestr" /> </xsl:variable>
  <xsl:variable name="totaltime"><xsl:value-of select="/nmaprun/runstats/finished/@time -/nmaprun/@start" /></xsl:variable>
  <xsl:key name="portstatus" match="@state" use="."/>
  <xsl:variable name="inicio">
    <xsl:call-template name="Formateofecha">
      <xsl:with-param name="fecha" select="$start"/>
    </xsl:call-template>
  </xsl:variable>
    <xsl:variable name="final">
    <xsl:call-template name="Formateofecha">
      <xsl:with-param name="fecha" select="$end"/>
    </xsl:call-template>
  </xsl:variable>
  <!-- Plantilla para el resumen -->
  <xsl:template match="/nmaprun">
    <html>
      <head>
        <title>Informe de Nmap</title>
        <style>
          body {
            font-family: Arial, sans-serif;
            background-color: 242424;
            color: white;
          }
          h1, h2{
            text-align: center;
          }
          h2{
            color: white;
          }
          
          h3{
            text-align: left;
            color: white;
          }
          table {
            border-collapse: collapse;
            width: 100%;
            margin-bottom: 20px;
          }
          th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
          }
          th {
            background-color: #6e6b6b;
          }
          hr{
            color: white;
          }
          #hrPeque{
            width: 40%;
          }
          #hrGrande{
            width: 80%;
          }
          #hostUp{
            background-color: black;
            width: 100%;
          }
          .down {
            color: #d9534f;
            font-weight: bold;
            cursor: pointer;
          }
          .hidden {
            display: none;
          }
          #downList{
            background-color: black;
          }
          #cabecera{
            background-color: #dedede;
            color: black;
            width: 100%;
            box-sizing: border-box;
            top: 0;
            left: 0;
            right: 0;
            display: flex;
          }
          #cabecera h1{
            padding-left: 32%;
          }
          #cabecera img{
            text-align: left;
            height: 13vh;
          }
          #divResumen{
            width: 100%;
            color: white;
            padding-top: 10vh;
            text-align: center;
          }
          #tabla {
            width: 100%;
            border-collapse: collapse;
            background-color: #333; /* Fondo oscuro */
            color: white;
            text-align: center;
          }
          /* Estilo para celdas de resumen */
          #tabla tfoot td {
            text-align: center;
            background-color: #555;
            color: white;
          }
          td table{
            border-collapse: collapse;
            text-align: center;
          }
        </style>
        <script>
          function toggleDropdown(id) {
            var dropdown = document.getElementById(id);
            dropdown.classList.toggle('hidden');
          }
        </script>
      </head>
      <body>
        <div id="cabecera">
          <img src="./Logo.png" alt="Logo"/>
          <h1>Escaneo Nmap</h1>
        </div>
        <div id="divResumen">
          <table id="tabla" style="text-align: center;">
            <thead >
              <tr><th colspan="3" >Resumen</th></tr>
              <tr>
                <th>General</th>
                <th>Tiempo</th>
                <th>Resultado</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>
                  <table>
                    <thead>
                      <tr>
                        <th>Versión</th>
                        <th>Comando</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td><xsl:value-of select="@version" /></td>
                        <td><xsl:value-of select="@args" style="color: white;"/></td>
                      </tr>
                    </tbody>
                  </table>
                </td>
                <td>
                  <table>
                    <thead>
                      <tr>
                        <th>Inicio</th>
                        <th>Final</th>
                        <th>Tiempo</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td><xsl:value-of select="$inicio" /></td>
                        <td><xsl:value-of select="$final" /></td>
                        <td><xsl:value-of select="/nmaprun/runstats/finished/@elapsed" /> seconds</td>
                      </tr>
                    </tbody>
                  </table>
                </td>
                <td>
                  <table>
                    <thead>
                      <tr>
                        <th>Salida</th>
                        <th>Total</th>
                        <th>Activos</th>
                        <th>Inactivos</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td><xsl:value-of select="/nmaprun/runstats/finished/@exit" /></td>
                        <td><xsl:value-of select="/nmaprun/runstats/hosts/@total" /> hosts</td>
                        <td><xsl:value-of select="/nmaprun/runstats/hosts/@up" /> hosts</td>
                        <td><xsl:value-of select="/nmaprun/runstats/hosts/@down" /> hosts</td>
                      </tr>
                    </tbody>
                  </table>
                </td>
              </tr>
            </tbody>
            <tfoot>
              <tr><td colspan="3"><xsl:value-of select="/nmaprun/runstats/finished/@summary" /></td></tr>
            </tfoot>
          </table>
        </div>
        <h2>Hosts Up</h2>
        <xsl:apply-templates select="//host[status/@state='up']">
          <xsl:sort select="number(substring-before(address[@addrtype='ipv4']/@addr, '.'))"/>
        </xsl:apply-templates>
        <hr id="hrGrande"/>
        <h2>Hosts Down</h2>
        <span class="down" onclick="toggleDropdown('downList')">Mostrar Hosts Down</span>
        <ul id="downList" class="down hidden">
          <xsl:apply-templates select="//host[status/@state='down']"/>
        </ul>
      </body>
    </html>
  </xsl:template>

  <!-- Plantilla para la información de cada host -->
  <xsl:template match="host">
    <hr id="hrPeque"/>
    <h2>Información de <xsl:value-of select="address[@addrtype='ipv4']/@addr"/></h2>
    <div id="hostUp">
      <h3>General</h3>
      <table>
        <tr>
          <th>IP</th>
          <th>MAC</th>
          <th>Sistema Operativo</th>
        </tr>
        <tr>
          <td><xsl:value-of select="address[@addrtype='ipv4']/@addr"/></td>
          <td><xsl:value-of select="address[@addrtype='mac']/@addr"/></td>
          <td>
            <xsl:choose>
              <xsl:when test="'os/osmatch/@name'!= '' "><xsl:value-of select="os/osmatch/@name"/></xsl:when>
              <xsl:otherwise><p style="color: red;">Desconocido</p></xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </table>

      <!-- Plantilla para la información de los puertos -->
      <h3>Puertos</h3>
      <table>
        <tr>
          <th colspan="2">Puerto</th>
          <th>Estado</th>
          <th>Servicio</th>
          <th>Razón</th>
          <th>Producto</th>
          <th>Versión</th>
          <th>Info</th>
        </tr>
        <xsl:apply-templates select="ports/port"/>
      </table>
    </div>
  </xsl:template>

<!-- Plantilla para la información de cada puerto -->
<xsl:template match="port">
  <xsl:variable name="unknownColor" select="'red'" />

  <xsl:choose>
    <xsl:when test="state/@state = 'open'">
      <tr class="open">
        <td><xsl:value-of select="@portid" /></td>
        <td><xsl:value-of select="@protocol" /></td>
        <td>
          <xsl:choose>
            <xsl:when test="string-length(state/@state) > 0">
              <xsl:value-of select="state/@state" />
            </xsl:when>
            <xsl:otherwise>
              <span style="color: {$unknownColor};">Desconocido</span>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td><xsl:value-of select="service/@name" /><xsl:text>&#xA0;</xsl:text></td>
        <td>
          <xsl:choose>
            <xsl:when test="string-length(state/@reason) > 0">
              <xsl:value-of select="state/@reason"/>
            </xsl:when>
            <xsl:otherwise>
              <span style="color: {$unknownColor};">Desconocido</span>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="state/@reason_ip">
            <xsl:text> from </xsl:text>
            <xsl:value-of select="state/@reason_ip"/>
          </xsl:if>
        </td>
        <td>
          <xsl:choose>
            <xsl:when test="string-length(service/@product) > 0">
              <xsl:value-of select="service/@product" />
            </xsl:when>
            <xsl:otherwise>
              <span style="color: {$unknownColor};">Desconocido</span>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td>
          <xsl:choose>
            <xsl:when test="string-length(service/@version) > 0">
              <xsl:value-of select="service/@version" />
            </xsl:when>
            <xsl:otherwise>
              <span style="color: {$unknownColor};">Desconocido</span>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td>
          <xsl:choose>
            <xsl:when test="string-length(service/@extrainfo) > 0">
              <xsl:value-of select="service/@extrainfo" />
            </xsl:when>
            <xsl:otherwise>
              <span style="color: {$unknownColor};">Desconocido</span>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>

      <xsl:for-each select="script">
        <tr class="script">
          <td></td>
          <td><xsl:value-of select="@id"/> <xsl:text>&#xA0;</xsl:text></td>
          <td colspan="6">
            <pre><xsl:value-of select="@output"/> <xsl:text>&#xA0;</xsl:text></pre>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:when>

    <!-- Otras condiciones como 'filtered' y 'closed' -->

    <xsl:otherwise>
      <!-- Código para el caso predeterminado -->
    </xsl:otherwise>

  </xsl:choose>
</xsl:template>

<!-- Plantilla para hosts down individuales -->
  <xsl:template name="Formateofecha">
    <xsl:param name="fecha"/>
    <xsl:variable name="diaSem" select="substring($fecha, 1, 3)"/>
    <xsl:variable name="mes" select="substring($fecha, 5, 3)"/>
    <xsl:variable name="dia" select="substring($fecha, 9, 2)"/>
    <xsl:variable name="anio" select="substring($fecha, 21, 4)"/>
    <xsl:variable name="tiempo" select="substring($fecha, 12, 8)"/>

    <xsl:variable name="diaSemana">
      <xsl:choose>
        <xsl:when test="$diaSem='Mon'">Lunes</xsl:when>
        <xsl:when test="$diaSem='Tue'">Martes</xsl:when>
        <xsl:when test="$diaSem='Wed'">Miércoles</xsl:when>
        <xsl:when test="$diaSem='Thu'">Jueves</xsl:when>
        <xsl:when test="$diaSem='Fri'">Viernes</xsl:when>
        <xsl:when test="$diaSem='Sat'">Sábado</xsl:when>
        <xsl:when test="$diaSem='Sun'">Domingo</xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="mesFinal">
      <xsl:choose>
        <xsl:when test="$mes='Jan'">Enero</xsl:when>
        <xsl:when test="$mes='Feb'">Febrero</xsl:when>
        <xsl:when test="$mes='Mar'">Marzo</xsl:when>
        <xsl:when test="$mes='Apr'">Abril</xsl:when>
        <xsl:when test="$mes='May'">Mayo</xsl:when>
        <xsl:when test="$mes='Jun'">Junio</xsl:when>
        <xsl:when test="$mes='Jul'">Julio</xsl:when>
        <xsl:when test="$mes='Aug'">Agosto</xsl:when>
        <xsl:when test="$mes='Sep'">Septiembre</xsl:when>
        <xsl:when test="$mes='Oct'">Octubre</xsl:when>
        <xsl:when test="$mes='Nov'">Noviembre</xsl:when>
        <xsl:when test="$mes='Dec'">Diciembre</xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="concat($diaSemana, ', ', $dia, ' de ', $mesFinal, ' de ', $anio, ', a las ', $tiempo)"/>
    <xsl:text>&#xA;</xsl:text> <!-- Agrega un salto de línea después de cada timestamp -->
  </xsl:template>

</xsl:stylesheet>


