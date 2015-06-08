<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions">
    <xsl:output media-type="text" indent="yes"/>
    <xsl:template match="/">
        <xsl:apply-templates select="athenaruby/glyph"/>
    </xsl:template>
    
    <xsl:template match="glyph">
        <xsl:value-of select="fn:concat(index,': ')"></xsl:value-of>
        <xsl:value-of select="description/text()"></xsl:value-of>
        <xsl:text>&#x000A;</xsl:text>
    </xsl:template>

</xsl:stylesheet>
