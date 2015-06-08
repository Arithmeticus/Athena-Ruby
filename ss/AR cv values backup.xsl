<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions">
    <xsl:output media-type="text" indent="yes"/>
    <xsl:template match="/">
        <xsl:apply-templates select="athenaruby"/>
    </xsl:template>

    <xsl:template match="athenaruby">
        <xsl:apply-templates select="glyph">
            <xsl:sort select="variant[1]/text()"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="glyph">
        <xsl:text>.</xsl:text>
        <xsl:value-of select="fn:concat('cv-var',variant[1]/text(),'-on {')"/>
        <xsl:for-each select="variant">
            <xsl:sort select="@cv"/>
            <xsl:text>&#x000A;-moz-font-feature-settings: 'cv</xsl:text>
            <xsl:value-of select="@cv"/>
            <xsl:text>=</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>';&#x000A;-moz-font-feature-settings: 'cv</xsl:text>
            <xsl:value-of select="@cv"/>
            <xsl:text>' </xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>;&#x000A;-webkit-font-feature-settings: 'cv</xsl:text>
            <xsl:value-of select="@cv"/>
            <xsl:text>' </xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>;&#x000A;-ms-font-feature-settings: 'cv</xsl:text>
            <xsl:value-of select="@cv"/>
            <xsl:text>' </xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>;&#x000A;-o-font-feature-settings: 'cv</xsl:text>
            <xsl:value-of select="@cv"/>
            <xsl:text>' </xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>;&#x000A;font-feature-settings: 'cv</xsl:text>
            <xsl:value-of select="@cv"/>
            <xsl:text>' </xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>;&#x000A;</xsl:text>
        </xsl:for-each>
        <xsl:text>}&#x000A;</xsl:text>
    </xsl:template>

    <xsl:template match="variant"> </xsl:template>

</xsl:stylesheet>
