<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
        <xsl:apply-templates select="//glyph[fn:contains(prodname,'_')]">
            <xsl:sort select="index" data-type="number"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="glyph">
        <xsl:variable name="liganame" select="prodname"/>
        <xsl:variable name="ligarray" select="fn:tokenize($liganame,'_')"/>
        <xsl:variable name="ligpart1" select="fn:subsequence($ligarray,1,1)"/>
        <xsl:variable name="ligpart2" select="fn:subsequence($ligarray,2,1)"/>
        <xsl:variable name="ligpart3" select="fn:subsequence($ligarray,3,1)"/>
        <xsl:element name="index">
            <xsl:value-of select="index"/>
        </xsl:element>
        <xsl:element name="ligature">
            <xsl:element name="ligatureelement">
                <xsl:attribute name="sequence">1</xsl:attribute>
                <xsl:for-each select="//glyph[prodname=$ligpart1]/unicode/@cp"><xsl:element name="unicode">
                    <xsl:attribute name="cp">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                    <xsl:value-of select="fn:concat('&amp;#x',.,';')"></xsl:value-of>
                </xsl:element></xsl:for-each>
            </xsl:element>
            <xsl:element name="ligatureelement">
                <xsl:attribute name="sequence">2</xsl:attribute>
                <xsl:for-each select="//glyph[prodname=$ligpart2]/unicode/@cp"><xsl:element name="unicode">
                    <xsl:attribute name="cp">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                    <xsl:value-of select="fn:concat('&amp;#x',.,';')"></xsl:value-of>
                </xsl:element></xsl:for-each>
            </xsl:element>
            <xsl:element name="ligatureelement">
                <xsl:attribute name="sequence">3</xsl:attribute>
                <xsl:for-each select="//glyph[prodname=$ligpart3]/unicode/@cp"><xsl:element name="unicode">
                    <xsl:attribute name="cp">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                    <xsl:value-of select="fn:concat('&amp;#x',.,';')"></xsl:value-of>
                </xsl:element></xsl:for-each>
            </xsl:element>
        </xsl:element>

        <!--AR glyph <xsl:value-of select="index"/> / <xsl:value-of select="$liganame"/>
        / <xsl:value-of select="//glyph[prodname=$ligpart1]/unicode"/> / <xsl:value-of
            select="//glyph[prodname=$ligpart2]/unicode"/> / <xsl:value-of
            select="//glyph[prodname=$ligpart3]/unicode"/>
        <xsl:value-of select="//glyph[prodname=$ligpart1]/unicode/@cp"/> - <xsl:value-of
            select="//glyph[prodname=$ligpart2]/unicode/@cp"/> - <xsl:value-of
            select="//glyph[prodname=$ligpart3]/unicode/@cp"/> - <xsl:for-each
            select="descendant::unicode"> <xsl:value-of select="."/> </xsl:for-each>-->
    </xsl:template>
</xsl:stylesheet>
