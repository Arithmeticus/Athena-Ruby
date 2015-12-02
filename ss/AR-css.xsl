<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes" xmlns:kalv="http://kalvesmaki.com/"
    xmlns:ar="tag:doaks.org,2015:ns/ar" xmlns:f="http://fxsl.sf.net/" exclude-result-prefixes="#all"
    version="2.0">

    <xsl:output method="text" indent="no"/>
    <xsl:variable name="quot" select="'&quot;'"/>
    <xsl:variable name="settings"
        select="
            '-moz-',
            '-webkit-',
            '-ms-',
            '-o-',
            ''"
        as="xs:string+"/>

    <xsl:template match="/">
        <xsl:text>/* Athena Ruby character variants
   If you wish to use Athena Ruby character variants, use the appropriate class value.
   For example, &lt;span class="ar-cv-n01 lig">text&lt;/span> will request that all enclosed 
   text be rendered in character variant number 1 and ligatures are turned on. If none exists, the default will be used.*/
@font-feature-values athenaruby {
  @character-variant {&#xA;</xsl:text>
        <xsl:for-each select="/ar:athenaruby/ar:variants/ar:set">
            <xsl:variable name="this-set" select="@n"/>
            <xsl:for-each select="ar:variant-glyph">
                <xsl:variable name="this-pos" select="count(preceding-sibling::*)"/>
                <xsl:value-of
                    select="concat('cv', $this-set, '-', $this-pos, ': ', $this-set, ' ', $this-pos, '; ')"
                />
            </xsl:for-each>
            <xsl:text>&#xA;</xsl:text>
        </xsl:for-each>
        <xsl:text>  }&#xA;}&#xA;</xsl:text>

        <!-- Syntax that works, but not recommended by W3C -->
        <xsl:for-each-group
            select="/ar:athenaruby/ar:variants/ar:set/ar:variant-glyph"
            group-by="count(preceding-sibling::*)">
            <xsl:variable name="pos" select="current-grouping-key()"/>
            
            <xsl:variable name="params" as="xs:string*">
                <xsl:for-each select="current-group()">
                    <xsl:variable name="this-set" select="../@n"/>
                    <xsl:value-of select="concat($quot, 'cv', $this-set, $quot,' ',$pos)"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:text>.ar-cv-n</xsl:text>
            <xsl:value-of select="$pos"/>
            <xsl:text>{&#xA;-moz-font-feature-settings: "calt=1", </xsl:text>
            <xsl:value-of
                select="
                string-join(for $i in $params
                return
                replace($i, concat($quot, ' (\d+)'), concat('=$1', $quot)), ', ')"/>
            <xsl:text>;&#xA;</xsl:text>
            <xsl:for-each select="$settings">
                <xsl:value-of select="."/>
                <xsl:text>font-feature-settings: "calt" 1, </xsl:text>
                <xsl:value-of select="string-join($params, ', ')"/>
                <!--<xsl:text> </xsl:text>
                <xsl:value-of select="$pos"/>-->
                <xsl:text>;&#xA;</xsl:text>
            </xsl:for-each>
            <xsl:text>}&#xA;</xsl:text>
            
        </xsl:for-each-group>
        <!--<xsl:for-each-group select="/ar:athenaruby/ar:variants/ar:set/ar:variant-glyph"
            group-by="count(preceding-sibling::*)">
            <xsl:variable name="pos" select="current-grouping-key()"/>
            <xsl:variable name="params" as="xs:string*">
                <xsl:for-each select="current-group()">
                    <xsl:variable name="this-set" select="../@n"/>
                    <xsl:value-of select="concat('&quot;cv', $this-set, '&quot; ', $pos)"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:text>.ar-cv-n</xsl:text>
            <xsl:value-of select="$pos"/>
            <xsl:text>-lig</xsl:text>
            <xsl:text>{&#xA;-moz-font-feature-settings: "calt=1", "liga=on", "dlig=on", </xsl:text>
            <xsl:value-of
                select="
                string-join(for $i in $params
                return
                replace($i, concat($quot, '=(\d+)'), concat(' $1', $quot)), ', ')"/>
            <xsl:text>;&#xA;</xsl:text>
            <xsl:for-each select="$settings">
                <xsl:value-of select="."/>
                <xsl:text>font-feature-settings: "calt" 1, "liga" on, "dlig" on, </xsl:text>
                <xsl:value-of select="string-join($params, ', ')"/>
                <xsl:text>;&#xA;</xsl:text>
            </xsl:for-each>
            <xsl:text>}&#xA;</xsl:text>
        </xsl:for-each-group>-->


        <!-- recommended CSS3 Fonts Module syntax
            http://www.w3.org/TR/css3-fonts/ -->
        <xsl:for-each-group select="/ar:athenaruby/ar:variants/ar:set/ar:variant-glyph"
            group-by="count(preceding-sibling::*)">
            <xsl:variable name="pos" select="current-grouping-key()"/>
            <xsl:text>.ar-cv-n</xsl:text>
            <xsl:value-of select="$pos"/>
            <xsl:text>{&#xA;font-variant-alternates: character-variant(</xsl:text>
            <xsl:value-of
                select="
                    string-join(for $i in current-group()
                    return
                        concat('cv', $i/../@n, '-', $pos), ', ')"/>
            <xsl:text>)&#xA;}&#xA;</xsl:text>
        </xsl:for-each-group>
        <xsl:text>.lig{
    -moz-font-feature-settings:"liga=on", "dlig=on";
    -moz-font-feature-settings:"liga" on, "dlig" on;
    -webkit-font-feature-settings:"liga" on, "dlig" on;
    -ms-font-feature-settings:"liga" on, "dlig" on;
    -o-font-feature-settings:"liga" on, "dlig" on;
    font-feature-settings:"liga" on, "dlig" on;
}
.calt{
    -moz-font-feature-settings:"calt=1";
    -moz-font-feature-settings:"calt" 1;
    -webkit-font-feature-settings:"calt" 1;
    -ms-font-feature-settings:"calt" 1;
    -o-font-feature-settings:"calt" 1;
    font-feature-settings:"calt" 1;
}
</xsl:text>


    </xsl:template>
</xsl:stylesheet>
