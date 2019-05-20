<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:kit="https://hananils.de/xslt/kit">

<!--
 * hana+nils · Büro für Gestaltung
 * https://hananils.de · buero@hananils.de
-->

<xsl:include href="languages.xsl" />

<!--
 * Kit: Dates
 *
 * This template formats dates to one of the following formats:
 *
 * - long
 *   The full date with day, long month and long year
 * - short
 *   The full date with day, shortened month and long year
 * - numeric
 *   The full date in localized tabular format
 *
 * # Example usage
 *
 * <xsl:apply-templates select="date" mode="kit:dates" />
 *
 * # Parameters
 *
 * - format
 *   The output format, either long, short or numeric, defaults to numeric
 * - zero
 *   Wheather to include a leading zero or not, defaults to false
 *
 * # Requirements
 *
 * The template requires the `datetime` and date type nodes from Kirby XSLT,
 * https://github.com/hananils/kirby-xslt
-->

<xsl:template match="*" mode="kit:dates">
    <xsl:param name="format" select="numeric" />
    <xsl:param name="zero" select="false()" />

    <xsl:variable name="month" select="/data/datetime/language[@id = $kit:language-code]/months/month[@id = current()/@month]" />
    <xsl:variable name="number-format">
        <xsl:choose>
            <xsl:when test="$zero = true()">00</xsl:when>
            <xsl:otherwise>#0</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:choose>
        <xsl:when test="$kit:language-code = 'de'">
            <xsl:apply-templates select="." mode="kit:dates-formatter-german">
                <xsl:with-param name="format" select="$format" />
                <xsl:with-param name="month" select="$month" />
                <xsl:with-param name="number-format" select="$number-format" />
            </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates select="." mode="kit:dates-formatter-english">
                <xsl:with-param name="format" select="$format" />
                <xsl:with-param name="month" select="$month" />
                <xsl:with-param name="number-format" select="$number-format" />
            </xsl:apply-templates>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
    German
-->
<xsl:template match="*" mode="kit:dates-formatter-german">
    <xsl:param name="format" select="numeric" />
    <xsl:param name="month" />
    <xsl:param name="number-format" />

    <xsl:choose>
        <xsl:when test="$format = 'long' and $month != ''">
            <xsl:value-of select="concat(format-number(@day, $number-format), '. ', $month, ' ', @year)" />
        </xsl:when>
        <xsl:when test="$format = 'short' and $month != ''">
            <xsl:value-of select="concat(format-number(@day, $number-format), '. ', $month/@abbr, '. ', @year)" />
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="concat(format-number(@day, $number-format), '.', format-number(@month, $number-format), '.', @year)" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
    English
-->
<xsl:template match="*" mode="kit:dates-formatter-english">
    <xsl:param name="format" select="numeric" />
    <xsl:param name="month" />
    <xsl:param name="number-format" />

    <xsl:choose>
        <xsl:when test="$format = 'long' and $month != ''">
            <xsl:value-of select="concat($month, ' ', format-number(@day, $number-format), ', ', @year)" />
        </xsl:when>
        <xsl:when test="$format = 'short' and $month != ''">
            <xsl:value-of select="concat($month/@abbr, '. ', format-number(@day, $number-format), ', ', @year)" />
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="concat(format-number(@day, $number-format), '/', format-number(@month, $number-format), '/', @year)" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


</xsl:stylesheet>
