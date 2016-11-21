<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes" xmlns:kalv="http://kalvesmaki.com/"
    xmlns:ar="tag:doaks.org,2015:ns/ar" xmlns:f="http://fxsl.sf.net/" exclude-result-prefixes="#all"
    version="2.0">
    <!--<xsl:import href="../../TAN/stylesheets/prepare/fxsl-xslt2/f/func-product.xsl"/>-->
    <xsl:output method="xhtml" indent="no"/>
    
    <xsl:include href="AR%20functions.xsl"/>

    <xsl:param name="output-for-DO-website" as="xs:boolean" select="true()"/>
    <xsl:variable name="unicode-db" select="document('../unicode/ucd.nounihan.grouped.xml')"/>
    <xsl:variable name="variants" select="/*/ar:variants" as="element()"/>
    <xsl:variable name="authorities" select="/*/ar:authorities" as="element()"/>

    <xsl:template match="/">
        <html>
            <head>
                <link rel="stylesheet" type="text/css" href="ss/default.css"/>
                <link rel="stylesheet" type="text/css" href="ss/ar-otf.css"/>
                <!--<meta http-equiv="Content-Type"/>
                <meta charset="UTF-8"/>-->
                <style type="text/css"/>
            </head>
            <body>
                <h1>Database of Athena Ruby glyphs</h1>
                <p>Generated <xsl:value-of select="current-date()"/></p>
                <h2 id="glyphs">Glyphs</h2>
                <xsl:apply-templates select="*/ar:glyph">
                    <xsl:sort select="xs:integer(replace(@xml:id, '\D+', ''))"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="*/ar:variants"></xsl:apply-templates>
                <xsl:apply-templates select="*/ar:authorities"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="ar:glyph">
        <xsl:variable name="gid" select="@xml:id"/>
        <xsl:variable name="these-variants"
            select="//ar:set/ar:variant-glyph[@which = $gid]"/>
        <xsl:apply-templates select="ar:legacyfonts"/>
        <xsl:text>&#xA;</xsl:text>
        <h3 id="{$gid}">
            <xsl:text>Glyph </xsl:text>
            <xsl:value-of select="replace(@xml:id, '\D', '')"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="ar:postname"/>
            <xsl:for-each select="$these-variants">
                <xsl:text>, variant no. </xsl:text>
                <xsl:value-of select="count(preceding-sibling::*)"/>
                <xsl:text> (set </xsl:text>
                <a href="{concat('#v',../@n)}">
                    <xsl:value-of select="../@n"/>
                </a>
                <xsl:text>) </xsl:text>
            </xsl:for-each>
        </h3>
        <xsl:apply-templates select="ar:unicode | ar:ligature"/>
        <xsl:apply-templates select="ar:pua"/>
        <xsl:apply-templates select="ar:symbolclass"/>
        <xsl:apply-templates select="ar:example">
            <xsl:sort select="min(ar:year-range/@from)"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="ar:description"/>
        <xsl:apply-templates select="ar:comment"/>
        <hr/>
    </xsl:template>
    <xsl:template match="ar:legacyfonts">
        <div class="legacy">
            <xsl:apply-templates select="*"/>
        </div>
    </xsl:template>
    <xsl:template match="ar:athena | ar:coinart | ar:coingreek | ar:grierson | ar:coininscr">
        <xsl:variable name="cps" select="tokenize(@cp, '\s+')" as="xs:string*"/>
        <div>
            <xsl:value-of select="name(.)"/>
            <xsl:text> (</xsl:text>
            <xsl:value-of
                select="
                    string-join(for $i in $cps
                    return
                        concat('U+', $i), ' ')"/>
            <xsl:text>): </xsl:text>
            <span class="{name(.)}">
                <xsl:copy-of
                    select="
                        for $i in $cps
                        return
                            codepoints-to-string(ar:hex-to-dec($i))"
                />
            </span>
        </div>
    </xsl:template>
    <xsl:template match="ar:unicode">
        <xsl:text>&#xA;</xsl:text>
        <div>
            <xsl:if test="$output-for-DO-website = false()">
                <xsl:attribute name="class" select="'major'"/>
            </xsl:if>
            <xsl:call-template name="sample">
                <xsl:with-param name="unicode" select="."/>
                <xsl:with-param name="glyph-id" select="../@xml:id"/>
            </xsl:call-template>
        </div>
    </xsl:template>
    <xsl:template match="ar:ligature">
        <xsl:variable name="this-lig" select="."/>
        <xsl:variable name="combinations"
            select="ar:ligature-permutations((), ar:ligatureelement)" as="element()*"/>
        <xsl:text>&#xA;</xsl:text>
        <div>
            <xsl:if test="$output-for-DO-website = false()">
                <xsl:attribute name="class" select="'major'"/>
            </xsl:if>
            <xsl:for-each select="$combinations">
                <xsl:variable name="this" select="."/>
                <xsl:variable name="these-unicodes" as="element()*">
                    <xsl:sequence
                        select="
                            for $i in (1 to count($this/*))
                            return
                                $this-lig/ar:ligatureelement[$i]/ar:unicode[number($this/*[$i])]"
                    />
                </xsl:variable>
                <xsl:call-template name="sample">
                    <xsl:with-param name="unicode" select="$these-unicodes"/>
                    <xsl:with-param name="glyph-id" select="$this-lig/../@xml:id"/>
                </xsl:call-template>

            </xsl:for-each>
        </div>
    </xsl:template>
    <xsl:template name="sample" as="item()*">
        <xsl:param name="unicode" as="element()*"/>
        <xsl:param name="glyph-id" as="xs:string"/>
        <xsl:variable name="variant-element"
            select="$variants/ar:set/ar:variant-glyph[@which = $glyph-id]"/>
        <xsl:variable name="cv-set" select="$variant-element/../@xml:id"/>
        <xsl:variable name="cv-no" select="count($variant-element/preceding-sibling::*)"/>
        <xsl:variable name="u-points"
            select="
                for $i in $unicode/@cp
                return
                    concat('U+', $i)"
            as="xs:string*"/>
        <xsl:variable name="sample-class"
            select="
                concat('ar-cv-n', string(($cv-no,
                0)[1]), if (count($unicode) gt 1) then
                    if ($output-for-DO-website = true()) then
                        '-lig'
                    else
                        ' lig'
                else
                    ())"
        />
        <xsl:text>&#xA;</xsl:text>
        <div>
            <xsl:copy-of select="$u-points"/>
            <xsl:text>: </xsl:text>
            <span class="sample"><span class="samplecontext">AB</span><span class="{$sample-class}"><xsl:copy-of select="
                            string-join(for $i in $unicode/@cp
                            return
                                codepoints-to-string(ar:hex-to-dec($i)), '')"/></span><span class="samplecontext">CD </span></span>
            <xsl:choose>
                <xsl:when test="$output-for-DO-website = true()">
                    <xsl:value-of select="string-join($unicode-db//*[@cp = $unicode/@cp]/@na, ', ')"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <span class="minor">
                        <xsl:value-of
                            select="string-join($unicode-db//*[@cp = $unicode/@cp]/@na, ', ')"/>
                    </span>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    
    <xsl:template match="ar:pua">
        <xsl:text>&#xA;</xsl:text>
        <div/>
        <div>
            <xsl:if test="$output-for-DO-website = false()">
                <xsl:attribute name="class" select="'major'"/>
            </xsl:if>
            <xsl:text>Private Use Area U+</xsl:text>
            <xsl:value-of select="@cp"/>
            <xsl:text>:&#160; </xsl:text>
            <span class="athenaruby">
                <xsl:value-of select="fn:codepoints-to-string(ar:hex-to-dec(@cp))"/>
            </span>
        </div>
    </xsl:template>

    <xsl:template match="ar:postname">
        <xsl:text>&#xA;</xsl:text>
        <a href="{concat('#',//ar:glyph[ar:postname=current()]/@xml:id)}">
            <xsl:value-of select="."/>
        </a>
    </xsl:template>
    <xsl:template match="ar:symbolclass">
        <xsl:text>&#xA;</xsl:text>
        <div>
            <xsl:text>Symbol: </xsl:text>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    
    <xsl:template match="ar:example">
        <xsl:text>&#xA;</xsl:text>
        <div>
            <xsl:apply-templates select="ar:year-range"/>
            <xsl:apply-templates select="ar:resp-auth"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="ar:ref"/>
        </div>
    </xsl:template>
    
    <xsl:template match="ar:year-range">
        <xsl:variable name="year-a" select="number(@from)"/>
        <xsl:variable name="year-b" select="number(@through)"/>
        <xsl:variable name="cent-a" select="number(replace(@from,'\d\d$','')) + (if ($year-a mod 100 = 0) then 0 else 1)"/>
        <xsl:variable name="cent-b" select="number(replace(@through,'\d\d$','')) + (if ($year-b mod 100 = 0) then 0 else 1)"/>
        <xsl:variable name="results">
            <xsl:choose>
                <xsl:when test="$year-a mod 100 = 1 and ($year-b - $year-a) mod 100 = 99">
                    <xsl:choose>
                        <xsl:when test="$cent-a = $cent-b">
                            <xsl:value-of select="$cent-a"/>
                            <xsl:text>th century: </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$cent-a"/>
                            <xsl:text>th–</xsl:text>
                            <xsl:value-of select="$cent-b"/>
                            <xsl:text>th century: </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$year-a"/>
                    <xsl:text>–</xsl:text>
                    <xsl:value-of select="$year-b"/>
                    <xsl:text>: </xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$output-for-DO-website = true()">
                <xsl:value-of select="$results"/>
            </xsl:when>
            <xsl:otherwise>
                <span class="date">
                    <xsl:value-of select="$results"/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="ar:resp-auth">
        <xsl:variable name="this-auth" select="$authorities/ar:auth[@xml:id = current()/@which]"/>
        <span class="auth">
            <a href="{concat('#',$this-auth/@xml:id)}"><xsl:value-of select="$this-auth/ar:name[@short]"/></a>
        </span>
    </xsl:template>
    
    <xsl:template match="ar:description|ar:comment">
        <xsl:text>&#xA;</xsl:text>
        <div>
            <xsl:if test="$output-for-DO-website = false()">
                <xsl:attribute name="class" select="'minor'"/>
            </xsl:if>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="ar:variants">
        <h2 id="variants">Variants</h2>
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="ar:set">
        <h3 id="{concat('v',@n)}"><xsl:text>Set </xsl:text>
            <xsl:value-of select="@n"/></h3>
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="ar:variant-glyph">
        <xsl:variable name="points-to" select="//ar:glyph[@xml:id = current()/@which]"/>
        <xsl:variable name="pos" select="count(preceding-sibling::ar:variant-glyph) + 1"/>
        <xsl:choose>
            <xsl:when test="$points-to/ar:ligature">
                <h4>
                    <xsl:apply-templates select="$points-to/ar:postname"/>
                </h4>
                <xsl:apply-templates select="$points-to//ar:ligature"/>
            </xsl:when>
            <xsl:otherwise>
                <h4>
                    <xsl:apply-templates select="$points-to/ar:postname"/>
                </h4>
                <div>
                    <xsl:call-template name="sample">
                        <xsl:with-param name="glyph-id" select="$points-to/@xml:id"/>
                        <xsl:with-param name="unicode" select="$points-to/ar:unicode"/>
                    </xsl:call-template>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="ar:authorities">
        <h2 id="authorities">Authorities</h2>
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="ar:auth">
        <div id="{@xml:id}">
            <xsl:copy-of select="ar:name[@short]/*"/>
            <xsl:text> = </xsl:text>
            <xsl:copy-of select="ar:name[not(@short)]/*"/>
            <xsl:apply-templates select="ar:IRI"/>
        </div>
    </xsl:template>
    <xsl:template match="ar:IRI">
        <xsl:if test="matches(.,'^http')">
            <xsl:text> </xsl:text>
            <a href="{.}">
                <xsl:text>more</xsl:text>
            </a>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
