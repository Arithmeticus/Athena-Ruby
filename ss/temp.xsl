<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="tag:doaks.org,2015:ns/ar"
    xmlns:ar="tag:doaks.org,2015:ns/ar"
    exclude-result-prefixes="xs ar" version="2.0">
    <xsl:output indent="yes"/>
    <xsl:template match="/">
        <xsl:variable name="ar-codepoints" as="xs:string+">
            <xsl:for-each-group select="//@cp" group-by=".">
                <xsl:sort/>
                <xsl:value-of select="current-grouping-key()"/>
            </xsl:for-each-group>
        </xsl:variable>
        <xsl:copy-of select="string-join($ar-codepoints,',')"></xsl:copy-of>
        <!--<xsl:sequence select="doc('http://viaf.org/viaf/18112405')"></xsl:sequence>-->
        <!--<variants>
            <xsl:for-each-group select="//ar:glyph" group-by="ar:variant/@cv">
                <xsl:sort select="current-grouping-key()"/>
                <!-\-<variant n="{current-grouping-key()}"
                    glyphs="{for $i in current-group() return
                    $i/@xml:id}"/>-\->
                <set>
                    <xsl:variable name="cgk" select="current-grouping-key()"/>
                    <xsl:attribute name="n" select="$cgk"/>
                    <xsl:for-each select="current-group()">
                        <xsl:sort select="xs:integer(ar:variant[@cv = $cgk])"/>
                        <variant-glyph which="{@xml:id}"/>
                    </xsl:for-each>
                </set>
            </xsl:for-each-group>
        </variants>-->
        <!--<authorities>
            <xsl:for-each select="//ar:auth">
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
                    <name short="true"><xsl:value-of select="@xml:id"/></name>
                    <xsl:copy-of select="*"/>
                </xsl:copy>
            </xsl:for-each>
        </authorities>-->
    </xsl:template>
    
    <!--<xsl:template match="ar:index"/>
    <xsl:template match="node()">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:if test="self::ar:glyph">
                <xsl:attribute name="xml:id" select="concat('i',ar:index)"/>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>-->
</xsl:stylesheet>
