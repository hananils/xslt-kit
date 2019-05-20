<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    extension-element-prefixes="exsl">

<!--
 * hana+nils · Büro für Gestaltung
 * https://hananils.de · buero@hananils.de
-->

<!--
 * Kit: Year Ranges
 *
 * This template creates a
 *
 * # Example usage
 *
 * <xsl:apply-templates select="p/*" mode="kit:transform" />
 *
 * # Parameters
 *
 * - offset
 *   A number to adjust the headline depth, defaults to 0
 * - prefix
 *   A string or node added as first child to the matched elements
 * - suffix
 *   A string or node added as last child to the matched elements
-->

<xsl:variable name="lang-since">
    <xsl:choose>
        <xsl:when test="/data/kirby/languages/language[@current = 'true']/@code = 'de'">seit</xsl:when>
        <xsl:otherwise>since</xsl:otherwise>
    </xsl:choose>
</xsl:variable>

<xsl:template match="*" mode="kit:dates-years">
    <!-- create a custom node set with all years sorted ascending -->
    <xsl:variable name="sorted">
        <xsl:for-each select="item">
            <xsl:sort select="." order="ascending" />
            <xsl:copy-of select="." />
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="years" select="exsl:node-set($sorted)" />

    <xsl:choose>
        <!-- consecutive years until current year -->
        <xsl:when test="$years/item[last()] - $years/item[1] + 1 = count($years/item) and $years/item[last()] = /data/datetime/today/@year">
            <xsl:value-of select="$lang-since" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="$years/item[1]" />
        </xsl:when>
        <!-- other years and year ranges -->
        <xsl:otherwise>
            <xsl:apply-templates select="$years/item" mode="kit:dates-years-item">
                <xsl:sort select="." order="ascending" />
            </xsl:apply-templates>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="item" mode="kit:dates-years-item">
    <xsl:choose>
        <!-- years within a range -->
        <xsl:when test="following-sibling::item[1] = text() + 1 and preceding-sibling::item[1] = text() - 1"></xsl:when>
        <!-- first year in range -->
        <xsl:when test="following-sibling::item[1] = text() + 1">
            <xsl:value-of select="." />
            <xsl:text>–</xsl:text>
        </xsl:when>
        <!-- last year in range or single years -->
        <xsl:when test="position() != last()">
            <xsl:value-of select="." />
            <xsl:text>, </xsl:text>
        </xsl:when>
        <!-- very last year -->
        <xsl:otherwise>
            <xsl:value-of select="." />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


</xsl:stylesheet>
