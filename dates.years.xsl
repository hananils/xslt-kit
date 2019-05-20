<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:kit="https://hananils.de/xslt/kit"
    xmlns:exsl="http://exslt.org/common"
    extension-element-prefixes="exsl">

<!--
 * hana+nils · Büro für Gestaltung
 * https://hananils.de · buero@hananils.de
-->

<xsl:include href="languages.xsl" />

<!--
 * Kit: Year Ranges
 *
 * This template creates date ranges from a node set of years. If the years are
 * a continuous range until today, the template will return "since {$year}".
 *
 * # Example usage
 *
 * <xsl:apply-templates select="dates" mode="kit:dates-years" />
-->

<xsl:template match="*" mode="kit:dates-years">

    <!-- Create a custom node set with all years sorted ascending -->
    <xsl:variable name="sorted">
        <xsl:for-each select="item">
            <xsl:sort select="." order="ascending" />
            <xsl:copy-of select="." />
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="years" select="exsl:node-set($sorted)" />

    <xsl:choose>

        <!-- Consecutive years until current year -->
        <xsl:when test="$years/item[last()] - $years/item[1] + 1 = count($years/item) and $years/item[last()] = /data/datetime/today/@year">
            <xsl:value-of select="$kit:translate/since" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="$years/item[1]" />
        </xsl:when>

        <!-- Other years and year ranges -->
        <xsl:otherwise>
            <xsl:apply-templates select="$years/item" mode="kit:dates-years-item">
                <xsl:sort select="." order="ascending" />
            </xsl:apply-templates>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="item" mode="kit:dates-years-item">
    <xsl:choose>

        <!-- Years within a range -->
        <xsl:when test="following-sibling::item[1] = text() + 1 and preceding-sibling::item[1] = text() - 1"></xsl:when>

        <!-- First year in range -->
        <xsl:when test="following-sibling::item[1] = text() + 1">
            <xsl:value-of select="." />
            <xsl:text>–</xsl:text>
        </xsl:when>

        <!-- Last year in range or single years -->
        <xsl:when test="position() != last()">
            <xsl:value-of select="." />
            <xsl:text>, </xsl:text>
        </xsl:when>

        <!-- Very last year -->
        <xsl:otherwise>
            <xsl:value-of select="." />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


</xsl:stylesheet>
