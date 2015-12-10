<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes" xmlns:kalv="http://kalvesmaki.com/"
    xmlns:ar="tag:doaks.org,2015:ns/ar" xmlns:f="http://fxsl.sf.net/" exclude-result-prefixes="#all"
    version="2.0">
    <!--<xsl:import href="../../TAN/stylesheets/prepare/fxsl-xslt2/f/func-product.xsl"/>-->
    <xsl:output method="xhtml" indent="no"/>

    <xsl:variable name="unicode-db" select="document('../unicode/ucd.nounihan.grouped.xml')"/>
    <xsl:variable name="variants" select="/*/ar:variants" as="element()"/>
    <xsl:variable name="authorities" select="/*/ar:authorities" as="element()"/>

    <xsl:template match="/">
        <html>
            <head>
                <link rel="stylesheet" type="text/css" href="ss/default.css"/>
                <link rel="stylesheet" type="text/css" href="ss/ar-otf.css"/>
                <meta charset="UTF-8"/>
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
                            codepoints-to-string(kalv:hex-to-dec($i))"
                />
            </span>
        </div>
    </xsl:template>
    <xsl:template match="ar:unicode">
        <div class="major">
            <xsl:call-template name="sample">
                <xsl:with-param name="unicode" select="."/>
                <xsl:with-param name="glyph-id" select="../@xml:id"/>
            </xsl:call-template>
        </div>
    </xsl:template>
    <xsl:template match="ar:ligature">
        <xsl:variable name="this-lig" select="."/>
        <xsl:variable name="combinations"
            select="kalv:ligature-permutations((), ar:ligatureelement)" as="element()*"/>
        <div class="major">
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
    <xsl:template name="sample" as="item()">
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
                    ' lig'
                else
                    ())"
        />
        <div>
            <xsl:copy-of select="$u-points"/>
            <xsl:text>: </xsl:text>
            <span class="sample">
                <span class="samplecontext">
                    <xsl:text>AB</xsl:text><span class="{$sample-class}"><xsl:copy-of
                            select="
                                string-join(for $i in $unicode/@cp
                                return
                                    codepoints-to-string(kalv:hex-to-dec($i)), '')"
                        /></span>
                    <xsl:text>CD </xsl:text>
                </span>
            </span>
            <span class="minor">
                <xsl:value-of select="string-join($unicode-db//*[@cp = $unicode/@cp]/@na,', ')"/>
            </span>
        </div>
    </xsl:template>
    
    <xsl:template match="ar:pua">
        <div class="major">
            <xsl:text>Private Use Area U+</xsl:text>
            <xsl:value-of select="@cp"/>
            <xsl:text>:&#160; </xsl:text>
            <span class="athenaruby">
                <xsl:value-of select="fn:codepoints-to-string(kalv:hex-to-dec(@cp))"/>
            </span>
        </div>
    </xsl:template>

    <xsl:template match="ar:postname">
        <a href="{concat('#',//ar:glyph[ar:postname=current()]/@xml:id)}">
            <xsl:value-of select="."/>
        </a>
    </xsl:template>
    <xsl:template match="ar:symbolclass">
        <div>
            <xsl:text>Symbol: </xsl:text>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    
    <xsl:template match="ar:example">
        <div>
            <xsl:apply-templates select="ar:year-range"/>
            <xsl:apply-templates select="ar:resp-auth"/>
            <xsl:text> </xsl:text>
            <xsl:copy-of select="ar:ref"/>
        </div>
    </xsl:template>
    
    <xsl:template match="ar:year-range">
        <xsl:variable name="year-a" select="number(@from)"/>
        <xsl:variable name="year-b" select="number(@through)"/>
        <xsl:variable name="cent-a" select="number(replace(@from,'\d\d$','')) + (if ($year-a mod 100 = 0) then 0 else 1)"/>
        <xsl:variable name="cent-b" select="number(replace(@through,'\d\d$','')) + (if ($year-b mod 100 = 0) then 0 else 1)"/>
        <span class="date">
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
        </span>
    </xsl:template>
    
    <xsl:template match="ar:resp-auth">
        <xsl:variable name="this-auth" select="$authorities/ar:auth[@xml:id = current()/@which]"/>
        <span class="auth">
            <a href="{concat('#',$this-auth/@xml:id)}"><xsl:copy-of select="$this-auth/ar:name[@short]"/></a>
        </span>
    </xsl:template>
    
    <xsl:template match="ar:description|ar:comment">
        <div class="minor">
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
            <xsl:copy-of select="ar:name[@short]"/>
            <xsl:text> = </xsl:text>
            <xsl:copy-of select="ar:name[not(@short)]"/>
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

    <xsl:function name="kalv:ligature-permutations" as="element()*">
        <xsl:param name="distributed-groups" as="element()*"/>
        <xsl:param name="undistributed-ligatureelements" as="element()*"/>
        <xsl:variable name="qty-uls-to-come"
            select="
                for $i in $undistributed-ligatureelements[position() gt 1]
                return
                    count($i/ar:unicode)"/>
        <xsl:variable name="product-uls-to-come" select="kalv:mult($qty-uls-to-come)"/>
        <xsl:choose>
            <xsl:when test="not(exists($distributed-groups))">
                <xsl:variable name="new-dist-gr" as="element()*">
                    <xsl:for-each select="$undistributed-ligatureelements[1]/ar:unicode">
                        <xsl:variable name="this-pos" select="position()"/>
                        <xsl:for-each select="1 to $product-uls-to-come">
                            <ar:group>
                                <ar:n>
                                    <xsl:copy-of select="$this-pos"/>
                                </ar:n>
                            </ar:group>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:copy-of
                    select="kalv:ligature-permutations($new-dist-gr, subsequence($undistributed-ligatureelements, 2))"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="new-dist-gr" as="element()*">
                    <xsl:for-each-group select="$distributed-groups" group-by=".">
                        <xsl:for-each-group select="current-group()"
                            group-by="position() mod count($undistributed-ligatureelements[1]/ar:unicode)">
                            <xsl:variable name="key2" select="current-grouping-key()"/>
                            <xsl:for-each select="current-group()">
                                <xsl:copy>
                                    <xsl:copy-of select="*"/>
                                    <ar:n>
                                        <xsl:copy-of select="$key2 + 1"/>
                                    </ar:n>
                                </xsl:copy>
                            </xsl:for-each>
                        </xsl:for-each-group>
                    </xsl:for-each-group>
                </xsl:variable>
                <xsl:copy-of
                    select="
                        if (count($undistributed-ligatureelements) lt 2) then
                            $new-dist-gr
                        else
                            kalv:ligature-permutations($new-dist-gr, subsequence($undistributed-ligatureelements, 2))"
                />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="kalv:mult" as="xs:integer?">
        <!--<xsl:param name="product-so-far" as="xs:integer?"/>-->
        <xsl:param name="items-to-multiply" as="xs:integer*"/>
        <xsl:choose>
            <xsl:when test="count($items-to-multiply) lt 2">
                <xsl:copy-of select="$items-to-multiply"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="new-prod" select="$items-to-multiply[1] * $items-to-multiply[2]"/>
                <xsl:variable name="new-seq"
                    select="
                        $new-prod,
                        subsequence($items-to-multiply, 3)"
                    as="xs:integer*"/>
                <xsl:copy-of select="kalv:mult($new-seq)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

</xsl:stylesheet>
