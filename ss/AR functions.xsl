<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes"
    xmlns:ar="tag:doaks.org,2015:ns/ar" xmlns:f="http://fxsl.sf.net/" exclude-result-prefixes="#all"
    version="2.0">
    
    <!-- COMMONLY USED ATHENA RUBY FUNCTIONS -->

    <xsl:function name="ar:hex-to-dec" as="xs:integer?">
        <xsl:param name="str" as="xs:string?"/>
        <xsl:variable name="len" select="string-length($str)"/>
        <xsl:value-of
            select="
                if (string-length($str) &lt; 1)
                then
                    0
                else
                    ar:hex-to-dec(substring($str, 1, $len - 1)) * 16 + string-length(substring-before('0123456789ABCDEF', substring($str, $len)))"
        />
    </xsl:function>

    <xsl:function name="ar:ligature-permutations" as="element()*">
        <xsl:param name="distributed-groups" as="element()*"/>
        <xsl:param name="undistributed-ligatureelements" as="element()*"/>
        <xsl:variable name="qty-uls-to-come"
            select="
                for $i in $undistributed-ligatureelements[position() gt 1]
                return
                    count($i/ar:unicode)"/>
        <xsl:variable name="product-uls-to-come" select="ar:mult($qty-uls-to-come)"/>
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
                    select="ar:ligature-permutations($new-dist-gr, subsequence($undistributed-ligatureelements, 2))"
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
                            ar:ligature-permutations($new-dist-gr, subsequence($undistributed-ligatureelements, 2))"
                />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="ar:mult" as="xs:integer?">
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
                <xsl:copy-of select="ar:mult($new-seq)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

</xsl:stylesheet>
