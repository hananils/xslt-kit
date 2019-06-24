<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:kit="https://hananils.de/xslt/kit"
    xmlns:exsl="http://exslt.org/common"
    extension-element-prefixes="exsl"
    exclude-result-prefixes="kit">

<!--
 * hana+nils · Büro für Gestaltung
 * https://hananils.de · buero@hananils.de
-->

<xsl:variable name="kit:language-code" select="/data/kirby/languages/language[@current = 'true']/@code" />
<xsl:variable name="kit:language-strings">
    <languages>
        <language code="de">
            <since>seit</since>
        </language>
        <language code="en">
            <since>since</since>
        </language>
    </languages>
</xsl:variable>
<xsl:variable name="kit:translate" select="exsl:node-set($kit:language-strings)/languages/language[@code = $kit:language-code]" />


</xsl:stylesheet>
