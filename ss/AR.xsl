<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:f="http://kalvesmaki.com/" version="2.0">
    <xsl:template match="/">
        <html>
            <head>
                <link rel="stylesheet" type="text/css" href="ss/default.css"/>
                <style type="text/css">
                    .majorinfo{
                        color:blue;
                        font-size:120%;
                    }
                    .otlig-on{
                        -moz-font-feature-settings:"liga=1, dlig=1"; /* for Firefox 14 and prior */
                        -moz-font-feature-settings:"liga" on, "dlig" on; /* for Firefox 15 */
                        -ms-font-feature-settings:"liga" on, "dlig" on;
                        -webkit-font-feature-settings:"liga" on, "dlig" on;
                        -o-font-feature-settings:"liga" on, "dlig" on;
                        font-feature-settings:"liga" on, "dlig" on;
                    }</style>
            </head>
            <body>
                <h1>Athena Ruby</h1>
                <p>Generated <xsl:value-of select="current-date()"/></p>
                <xsl:apply-templates select="athenaruby/glyph">
                    <xsl:sort select="index" data-type="number"/>
                </xsl:apply-templates>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="glyph">
        <div style="float:right">
            <xsl:apply-templates select="legacyfonts"/>
        </div>
        <xsl:element name="a">
            <xsl:attribute name="name">
                <xsl:value-of select="postname"/>
            </xsl:attribute>
        </xsl:element>
        <h3>Athena Ruby glyph no. <xsl:apply-templates select="index"/>: <xsl:apply-templates
                select="prodname"/></h3>
        <p class="majorinfo">
            <xsl:apply-templates select="unicode"/>
            <xsl:apply-templates select="ligature"/>
        </p>
        <p class="majorinfo">
            <xsl:apply-templates select="pua"/>
        </p>
        <p>
            <xsl:apply-templates select="postname"/>
            <xsl:apply-templates select="symbolclass"/>
        </p>
        <p>
            <xsl:apply-templates select="description"/>
            <xsl:apply-templates select="comment"/>
            <xsl:apply-templates select="ttnote"/>
        </p>
        <p> Published example(s): <xsl:apply-templates select="example"/>
        </p>
        <hr/>
    </xsl:template>

    <xsl:template match="index">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="prodname">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="unicode">
        <xsl:variable name="cppicked" select="fn:codepoints-to-string(f:hex-to-dec(@cp))"/>
        <xsl:variable name="arcvcat" select="../variant/@cv"/>
        <xsl:variable name="arcvitem" select="../variant/text()"/> U+<xsl:value-of select="@cp"/>:
            <span style="font-size:300%;font-family:athenarubyweb;color:gray">AB<xsl:choose>
                <xsl:when test="fn:exists(../pua)">
                    <xsl:element name="span"><xsl:attribute name="style">color:blue;
                            -moz-font-feature-settings: 'cv<xsl:value-of select="$arcvcat"
                                />=<xsl:value-of select="$arcvitem"/>'; -moz-font-feature-settings:
                                'cv<xsl:value-of select="$arcvcat"/>' <xsl:value-of
                                select="$arcvitem"/>; -webkit-font-feature-settings:
                                'cv<xsl:value-of select="$arcvcat"/>' <xsl:value-of
                                select="$arcvitem"/>; -ms-font-feature-settings: 'cv<xsl:value-of
                                select="$arcvcat"/>' <xsl:value-of select="$arcvitem"/>;
                            -o-font-feature-settings: 'cv<xsl:value-of select="$arcvcat"/>'
                                <xsl:value-of select="$arcvitem"/>; font-feature-settings:
                                'cv<xsl:value-of select="$arcvcat"/>' <xsl:value-of
                                select="$arcvitem"/>; </xsl:attribute><xsl:value-of
                            select="$cppicked"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise><span style="color:blue"><xsl:value-of select="$cppicked"
                    /></span></xsl:otherwise>
            </xsl:choose>CD </span>
        <xsl:value-of select="document('../unicode/ucd.nounihan.grouped.xml')//*[@cp=$cppicked]/@na"/>
        <xsl:choose>
            <xsl:when test="fn:exists(../pua)">, variant <xsl:value-of select="../variant"/> (cv
                    <xsl:value-of select="../variant/@cv"/>)</xsl:when>
        </xsl:choose>
        <br/>
    </xsl:template>
    <xsl:template match="ligature">
        <xsl:variable name="isvariant" select="fn:exists(../variant)"/>
        <xsl:variable name="arcvcat" select="../variant/@cv"/>
        <xsl:variable name="arcvitem" select="../variant/text()"/>
        <xsl:for-each select="ligatureelement">
            <xsl:for-each select="unicode">
                <xsl:value-of select="fn:concat('U+',@cp,' ')"/>
            </xsl:for-each>
            <br/>
        </xsl:for-each>
        <span style="font-size:300%;font-family:athenarubyweb;color:gray">AB<xsl:for-each
                select="ligatureelement">
                <xsl:choose><xsl:when test="$isvariant"><xsl:element name="span">
                            <xsl:attribute name="class">otlig-on</xsl:attribute>
                            <xsl:attribute name="style">color:blue; -moz-font-feature-settings:
                                    'cv<xsl:value-of select="$arcvcat"/>=<xsl:value-of
                                    select="$arcvitem"/>'; -moz-font-feature-settings:
                                    'cv<xsl:value-of select="$arcvcat"/>' <xsl:value-of
                                    select="$arcvitem"/>; -webkit-font-feature-settings:
                                    'cv<xsl:value-of select="$arcvcat"/>' <xsl:value-of
                                    select="$arcvitem"/>; -ms-font-feature-settings:
                                    'cv<xsl:value-of select="$arcvcat"/>' <xsl:value-of
                                    select="$arcvitem"/>; -o-font-feature-settings: 'cv<xsl:value-of
                                    select="$arcvcat"/>' <xsl:value-of select="$arcvitem"/>;
                                font-feature-settings: 'cv<xsl:value-of select="$arcvcat"/>'
                                    <xsl:value-of select="$arcvitem"/>;
                                </xsl:attribute><xsl:value-of
                                select="fn:codepoints-to-string(f:hex-to-dec(unicode[1]/@cp))"
                            /></xsl:element></xsl:when>
                    <xsl:otherwise><span class="otlig-on" style="color:blue;"><xsl:value-of
                                select="fn:codepoints-to-string(f:hex-to-dec(unicode[1]/@cp))"
                            /></span></xsl:otherwise></xsl:choose>
            </xsl:for-each>CD </span>
    </xsl:template>

    <xsl:template match="pua">Private Use Area U+<xsl:value-of select="./@cp"/>:&#160;
            <span style="font-family:athenarubyweb"><xsl:value-of
                select="fn:codepoints-to-string(f:hex-to-dec(../pua/@cp))"/></span></xsl:template>

    <xsl:template match="postname">Postname: <xsl:value-of select="."/></xsl:template>
    <xsl:template match="symbolclass"><br/>Symbol: <xsl:value-of select="."/></xsl:template>

    <xsl:template match="legacyfonts">
        <xsl:apply-templates select="athena"/>
        <xsl:apply-templates select="coinart"/>
        <xsl:apply-templates select="coingreek"/>
        <xsl:apply-templates select="coininscr"/>
        <xsl:apply-templates select="grierson"/>
    </xsl:template>

    <xsl:template match="athena"> Athena (<xsl:for-each select="fn:tokenize(@cp,';')"
                >U+<xsl:value-of select="."/><xsl:text>&#x0020;</xsl:text></xsl:for-each>): <span
            style="font-family:Athena;font-size:200%">
            <xsl:for-each select="fn:tokenize(@cp,';')"><xsl:value-of
                    select="fn:codepoints-to-string(f:hex-to-dec(.))"/></xsl:for-each>
        </span>
    </xsl:template>
    <xsl:template match="coinart"> CoinArt: (U+<xsl:value-of select="@cp"/>): <span
            style="font-family:CoinArt;font-size:200%"><xsl:value-of
                select="fn:codepoints-to-string(f:hex-to-dec(@cp))"/></span>
    </xsl:template>
    <xsl:template match="coingreek"> CoinGreek: (U+<xsl:value-of select="@cp"/>): <span
            style="font-family:CoinGreek;font-size:200%"><xsl:value-of
                select="fn:codepoints-to-string(f:hex-to-dec(@cp))"/></span>
    </xsl:template>
    <xsl:template match="coininscr"> CoinInscr: (U+<xsl:value-of select="@cp"/>): <span
            style="font-family:CoinInscr;font-size:200%"><xsl:value-of
                select="fn:codepoints-to-string(f:hex-to-dec(@cp))"/></span>
    </xsl:template>
    <xsl:template match="grierson"> Grierson: (U+<xsl:value-of select="@cp"/>): <span
            style="font-family:Grierson;font-size:200%"><xsl:value-of
                select="fn:codepoints-to-string(f:hex-to-dec(@cp))"/></span>
    </xsl:template>

    <xsl:template match="description">
        <xsl:value-of select="."/>
        <xsl:for-each select="./postname">(x-ref: <xsl:element name="a"><xsl:attribute name="href"
                        ><xsl:value-of select="fn:concat('#',.)"/>
                </xsl:attribute>
                <xsl:value-of select="."/></xsl:element>) </xsl:for-each>
    </xsl:template>

    <xsl:template match="example">
        <xsl:value-of select="pub"/>&#160;<xsl:value-of select="ref"/>&#160;(<xsl:value-of
            select="date/node()"/>); </xsl:template>

    <xsl:template match="comment"> JK: <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="ttnote"> Tiro Type: <xsl:value-of select="."/>
    </xsl:template>

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
