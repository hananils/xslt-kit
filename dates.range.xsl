<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:kit="https://hananils.de/xslt/kit"
    exclude-result-prefixes="kit">

<!--
 * hana+nils · Büro für Gestaltung
 * https://hananils.de · buero@hananils.de
-->

<xsl:import href="dates.xsl" />
<xsl:import href="dates.time.xsl" />

<!--
 * Kit: Date Ranges
 *
 * This template creates readable date and time ranges.
 *
 * # Example usage
 *
 * <xsl:apply-templates select="dates" mode="kit:dates-range" />
 *
 * # Parameters
 *
 * - show-date
 *   Whether to display the date or not, defaults to true
 * - show-time
 *   Whether to display the time or not, defaults to true
 * - separator-datetime
 *   A string used to separate date and time values, defaults to comma and space
 * - separator-times
 *   A string used to separate times, defaults to a n-dash
-->

<xsl:template match="*" mode="kit:dates-range">
    <xsl:param name="show-date" select="true()" />
    <xsl:param name="show-time" select="true()" />
    <xsl:param name="separator-datetime" select="', '" />
    <xsl:param name="separator-times" select="'–'" />

    <!-- Timerange -->
    <xsl:choose>

        <!-- Same day -->
        <xsl:when test="start = end or not(end)">
            <xsl:if test="$show-date = true()">
                <xsl:apply-templates match="start" mode="kit:dates">
                    <xsl:with-param name="format" select="'long'" />
                </xsl:apply-templates>
            </xsl:if>

            <xsl:if test="$show-date = true() and $show-time = true()">
                <xsl:value-of select="$separator-datetime" />
            </xsl:if>

            <xsl:if test="$show-time = true()">
                <xsl:apply-templates select="start" mode="kit:dates-time" />

                <xsl:if test="start/@time and end/time">
                    <xsl:value-of select="$separator-times" />
                </xsl:if>

                <xsl:apply-templates select="end" mode="kit:dates-time" />
            </xsl:if>
        </xsl:when>

        <!-- Different day -->
        <xsl:otherwise>
            <xsl:if test="$show-date = true()">
                <xsl:apply-templates match="start" mode="kit:dates">
                    <xsl:with-param name="format" select="'long'" />
                </xsl:apply-templates>
            </xsl:if>

            <xsl:if test="$show-date = true() and $show-time = true()">
                <xsl:value-of select="$separator-datetime" />
            </xsl:if>

            <xsl:if test="$show-time = true()">
                <xsl:apply-templates select="start" mode="kit:dates-time" />
            </xsl:if>

            <xsl:value-of select="concat(' ', $separator-times, ' ')" />

            <xsl:if test="$show-date = true()">
                <xsl:apply-templates match="end" mode="kit:dates">
                    <xsl:with-param name="format" select="'long'" />
                </xsl:apply-templates>
            </xsl:if>

            <xsl:if test="$show-date = true() and $show-time = true()">
                <xsl:value-of select="$separator-datetime" />
            </xsl:if>

            <xsl:if test="$show-time = true()">
                <xsl:apply-templates select="end" mode="kit:dates-time" />
            </xsl:if>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


</xsl:stylesheet>
