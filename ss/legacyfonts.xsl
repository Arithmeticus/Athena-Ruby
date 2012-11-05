<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="athenaruby">
        <html>
            <head>
                <style type="text/css">
                    @font-face
                     {
                        font-family : AthenaRuby;
                        src : url('AthenaRuby_b017.ttf');
                    }
                    @font-face
                     {
                        font-family : Athena;
                        src : url('Athena.TTF');
                    }
                    @font-face
                     {
                        font-family : CoinArt;
                        src : url('COINART_.TTF');
                    }
                    @font-face
                     {
                        font-family : CoinGreek;
                        src : url('COG_____.TTF');
                    }
                    @font-face
                     {
                        font-family : CoinInscr;
                        src : url('COI_____.TTF');
                    }
                    @font-face
                     {
                        font-family : Grierson;
                        src : url('GR______.TTF');
                    }</style>
            </head>
            <body>
                <h1>Athena Ruby: legacy fonts</h1>
                <xsl:apply-templates select="glyph">
                    <xsl:sort select="legacyfonts/athena/@cp" data-type="text"/>
                    <!--xsl:sort select="unicode" data-type="number"/-->
                </xsl:apply-templates>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="glyph">
        <xsl:if test="legacyfonts/athena">
            <span style="font-family:'Athena Ruby';font-size:200%;width:80px;float:left;color:gray;">
                <xsl:value-of select="unicode"/>
            </span>
        </xsl:if>
        <p>
            <xsl:apply-templates select="legacyfonts"> </xsl:apply-templates>
        </p>
    </xsl:template>
    <xsl:template match="legacyfonts">
        <xsl:apply-templates select="athena"> </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="athena">
        <span style="font-family:Athena;font-size:200%">
            <xsl:value-of select="."/>
        </span>&#8195;<xsl:value-of select="@cp"/>&#8195; <xsl:value-of select="."/>&#8195;
    </xsl:template>
</xsl:stylesheet>
