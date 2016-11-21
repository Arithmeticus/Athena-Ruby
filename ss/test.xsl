<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="tag:doaks.org,2015:ns/ar"
    xmlns:ar="tag:doaks.org,2015:ns/ar" exclude-result-prefixes="xs ar" version="2.0">
    <xsl:output indent="yes"/>
    <xsl:include href="AR%20functions.xsl"/>

    <xsl:template match="/">
        <xsl:apply-templates mode="convert"/>
    </xsl:template>
    <xsl:template mode="convert" match="comment() | processing-instruction()">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template mode="convert" match="*">
        <xsl:variable name="has-cp" select="exists(@cp)"/>
        <xsl:variable name="dec-cp" select="for $i in tokenize(@cp,' ') return ar:hex-to-dec($i)"/>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:if test="$has-cp = true()">
                <xsl:attribute name="cp-dec" select="$dec-cp"/>
            </xsl:if>
            <xsl:apply-templates mode="#current"/>
        </xsl:copy>
    </xsl:template>
    

</xsl:stylesheet>
