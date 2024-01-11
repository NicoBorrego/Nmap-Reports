<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- Establecer el delimitador de CSV -->
    <xsl:output method="html" indent="yes" encoding="UTF-8" omit-xml-declaration="yes"/>
    
    <xsl:variable name="direccionesDown">
        <xsl:for-each select="//host[status/@state='down']/address[@addrtype='ipv4']/@addr">
            <xsl:value-of select="concat(., ';')" />
        </xsl:for-each>
    </xsl:variable>
    <xsl:template match="/nmaprun">
        <xsl:text>IP;Estado;Sistema Operativo;Mac;Puertos&#xA;</xsl:text>
        <xsl:apply-templates select="host[status/@state='up']"/>
        
        <xsl:text>Direcciones IP de Hosts Down de </xsl:text>
        <xsl:value-of select="$direccionesDown" />
    </xsl:template>

    <xsl:template match="host[status/@state='up']">
        <xsl:variable name="puertosHostUp">
            <xsl:for-each select="./ports/port">
                <xsl:value-of select="concat(@portid, ';')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="concat(
            address[@addrtype='ipv4']/@addr, ',',
            status/@state, ',',
            os/osmatch/@name, ',',
            address[@addrtype='mac']/@addr, ',',
            $puertosHostUp, '&#xA;')"
        />
    </xsl:template>
</xsl:stylesheet>

