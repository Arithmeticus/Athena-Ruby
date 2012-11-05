<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" version="2.0">
    <xsl:template match="/">
        <html>
            <head>
                <style type="text/css">
                <link rel="stylesheet" type="text/css" href="default.css" charset="utf-8"/>
                </style>
            </head>
            <body>
                <h1>Athena Ruby</h1>
                <xsl:apply-templates select="athenaruby/glyph">
                    <xsl:sort select="unicode" data-type="text"/>
                </xsl:apply-templates>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="glyph">
        <xsl:apply-templates select="unicode"/>
    </xsl:template>

    <xsl:template match="index">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="unicode">
        <xsl:variable name="test1" select="current()/@cp"/>
        #x<xsl:value-of select="current()/@cp"></xsl:value-of>;
        <!--span style="color:blue;font-size:300%;font-family:AthenaRuby;">
            <span style="color:gray">◌</span>
            <xsl:value-of select="."/>
        </span-->
    </xsl:template>

</xsl:stylesheet>
