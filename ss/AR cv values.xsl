<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions">
    <xsl:output media-type="text" indent="yes"/>
    <xsl:template match="/">
        <xsl:apply-templates select="athenaruby"/>
    </xsl:template>

    <xsl:template match="athenaruby">
        <xsl:for-each select="glyph/variant">
            <xsl:sort select="." data-type="number"/>
            <xsl:value-of select="@cv"></xsl:value-of>
            <xsl:text> </xsl:text>
            <xsl:value-of select="."></xsl:value-of>
            <xsl:text>&#x000A;</xsl:text>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
