<?xml version="1.0" encoding="UTF-8"?>
<!-- Developed to get merely a list of glyphs -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:f="http://kalvesmaki.com/" version="2.0">
    <xsl:template match="/">
        <html>
            <head>
                <style type="text/css">
                <link rel="stylesheet" type="text/css" href="default.css" charset="utf-8"/>
                </style>
            </head>
            <body>
                <h1>Athena Ruby</h1>
                <p class="athenaruby">
                    <xsl:for-each select="/*/glyph[index &gt; 2]">
                        <xsl:choose>
                            <xsl:when test="exists(pua)"><span class="ar-p">#x<xsl:value-of
                                        select="pua/@cp"/>;</span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="ar-u">#x<xsl:value-of select="unicode[1]/@cp"/>;</span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </p>
            </body>
        </html>
    </xsl:template>

    <!--<xsl:template match="glyph">
        <xsl:apply-templates select="unicode"/>
    </xsl:template>

    <xsl:template match="index">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="unicode">
        <xsl:variable name="test1" select="current()/@cp"/>
        #x<xsl:value-of select="current()/@cp"></xsl:value-of>;
    </xsl:template>-->

    <xsl:function name="f:hex-to-dec" as="xs:integer">
        <xsl:param name="str"/>
        <xsl:variable name="len" select="string-length($str)"/>
        <xsl:value-of
            select="if (string-length($str) &lt; 1)
            then 0
            else f:hex-to-dec(substring($str,1,$len - 1))*16+string-length(substring-before('0123456789ABCDEF',substring($str,$len)))"
        />
    </xsl:function>

</xsl:stylesheet>
