<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:kit="https://hananils.de/xslt/kit"
    exclude-result-prefixes="kit">

<!--
 * hana+nils · Büro für Gestaltung
 * https://hananils.de · buero@hananils.de
-->

<xsl:include href="languages.xsl" />

<!--
 * Kit: Time
 *
 * This template formats times.
 *
 * # Example usage
 *
 * <xsl:apply-templates select="time" select="kit:dates-time" />
 *
 * # Parameters
 *
 * - zero
 *   Whether to include a leading zero or not, defaults to false
 * - ampm
 *   Whether to use am/pm times or not, defaults to false,
 *   only applies to English times
-->

<xsl:template match="*" mode="kit:dates-time">
    <xsl:param name="zero" select="false()" />
    <xsl:param name="ampm" select="false()" />

    <xsl:variable name="number-format">
        <xsl:choose>
            <xsl:when test="$zero = true()">00</xsl:when>
            <xsl:otherwise>#0</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="hours" select="format-number(substring-before(':', @time), $number-format)" />
    <xsl:variable name="minutes" select="substring-after(':', @time)" />

    <xsl:choose>
        <xsl:when test="$kit:language-code = 'de'">
            <xsl:apply-templates select="." mode="kit:time-formatter-german">
                <xsl:with-param name="hours" select="$hours" />
                <xsl:with-param name="minutes" select="$minutes" />
            </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates select="." mode="kit:time-formatter-english">
                <xsl:with-param name="hours" select="$hours" />
                <xsl:with-param name="minutes" select="$minutes" />
                <xsl:with-param name="twentyfour" select="$ampm" />
            </xsl:apply-templates>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
    German
-->

<xsl:template select="*" mode="kit:time-formatter-german">
    <xsl:param name="hours" />
    <xsl:param name="minutes" />

    <xsl:value-of select="concat($hours, ':', $minutes, ' Uhr')" />
</xsl:template>

<!--
    English
-->

<xsl:template select="*" mode="kit:time-formatter-english">
    <xsl:param name="ampm" select="false()" />
    <xsl:param name="hours" />
    <xsl:param name="minutes" />

    <xsl:choose>
        <xsl:when test="$ampm = true() and $hours &lt; 12">
            <xsl:value-of select="concat($hours, ':', $minutes, 'am')" />
        </xsl:when>
        <xsl:when test="$ampm = true() and $hours &gt; 12">
            <xsl:value-of select="concat($hours - 12, ':', $minutes, 'pm')" />
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="concat($hours, ':', $minutes)" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


</xsl:stylesheet>
