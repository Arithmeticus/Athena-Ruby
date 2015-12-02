<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes" xmlns:kalv="http://kalvesmaki.com/"
    xmlns:ar="tag:doaks.org,2015:ns/ar" xmlns:f="http://fxsl.sf.net/" exclude-result-prefixes="#all"
    version="2.0">
    <!--<xsl:import href="../../TAN/stylesheets/prepare/fxsl-xslt2/f/func-product.xsl"/>-->
    <xsl:output method="xhtml" indent="no"/>

    <xsl:template match="/">
        <html>
            <head>
                <link rel="stylesheet" type="text/css" href="ss/default.css"/>
                <link rel="stylesheet" type="text/css" href="ss/ar-otf-test.css"/>
                <meta charset="UTF-8"/>
                <style type="text/css"/>
            </head>
            <body>
                <h1>Variant Athena Ruby glyphs</h1>
                <p>Generated <xsl:value-of select="current-date()"/></p>
                <p>Intended for testing in browsers. First line represent Unicode-compliant variant
                    and the second, the PUA counterpart. The first and second lines should appear
                    identical. Differences indicate a problem in CSS @font-feature-settings.</p>
                <hr/>
                <xsl:for-each select="ar:athenaruby/ar:variants/ar:set">
                    <xsl:variable name="cv-set" select="@n"/>
                    <div class="athenaruby sample calt">
                        <xsl:for-each select="ar:variant-glyph">
                            <xsl:variable name="this-which" select="@which"/>
                            <xsl:variable name="this-glyph"
                                select="//ar:glyph[@xml:id = $this-which]"/>
                            <xsl:variable name="this-pos" select="count(preceding-sibling::*)"/>
                            <xsl:variable name="this-class"
                                select="
                                    concat('ar-cv-n', string(($this-pos,
                                    0)[1]), if ($this-glyph/ar:ligature) then
                                        ' lig'
                                    else
                                        ())"/>
                            <span class="{$this-class}">
                                <xsl:value-of
                                    select="
                                        string-join(for $i in ($this-glyph/ar:unicode[1]/@cp,
                                        $this-glyph/ar:ligature/ar:ligatureelement/ar:unicode[1]/@cp)
                                        return
                                            fn:codepoints-to-string(kalv:hex-to-dec($i)), '')"
                                />
                            </span>
                        </xsl:for-each>
                    </div>
                    <div class="athenaruby sample calt">
                        <xsl:for-each select="ar:variant-glyph">
                            <xsl:variable name="this-which" select="@which"/>
                            <xsl:variable name="this-glyph"
                                select="//ar:glyph[@xml:id = $this-which]"/>
                            <xsl:value-of
                                select="
                                    fn:codepoints-to-string(kalv:hex-to-dec(($this-glyph/ar:pua/@cp,
                                    $this-glyph//ar:unicode[1]/@cp)[1]))"
                            />
                        </xsl:for-each>
                    </div>
                    <hr/>
                </xsl:for-each>
            </body>
        </html>
    </xsl:template>

    <!-- FUNCTIONS -->

    <xsl:function name="kalv:hex-to-dec" as="xs:integer?">
        <xsl:param name="str" as="xs:string?"/>
        <xsl:variable name="len" select="string-length($str)"/>
        <xsl:value-of
            select="
                if (string-length($str) &lt; 1)
                then
                    0
                else
                    kalv:hex-to-dec(substring($str, 1, $len - 1)) * 16 + string-length(substring-before('0123456789ABCDEF', substring($str, $len)))"
        />
    </xsl:function>

</xsl:stylesheet>
