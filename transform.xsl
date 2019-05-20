<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:kit="https://hananils.de/xslt/kit">

<!--
 * hana+nils · Büro für Gestaltung
 * https://hananils.de · buero@hananils.de
-->

<!--
 * Kit: Transform
 *
 * This template is based on a technique by Allen Chang, http://chaoticpattern.com,
 * see http://getsymphony.com/learn/articles/view/html-ninja-technique
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

<!--
    Match elements
-->

<xsl:template match="//*" mode="kit:transform">
    <xsl:param name="offset" select="0" />
    <xsl:param name="class" />
    <xsl:param name="prefix" />
    <xsl:param name="suffix" />

    <xsl:variable name="name">
        <xsl:choose>

            <!-- Get offset headline name -->
            <xsl:when test="translate(name(), '123456', '') = 'h'">
                <xsl:apply-templates select="." mode="kit:transform-apply-offset">
                    <xsl:with-param name="offset" select="$offset" />
                </xsl:apply-templates>
            </xsl:when>

            <!-- Get element name -->
            <xsl:otherwise>
                <xsl:value-of select="name()" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:element name="{$name}">

        <!-- Set class -->
        <xsl:apply-templates select="$class" mode="kit:transform-set-class" />

        <!-- Set prefix -->
        <xsl:if test="position() = 1">
            <xsl:copy-of select="$prefix" />
        </xsl:if>

        <!-- Apply nested transforms -->
        <xsl:apply-templates select="* | @* | text()" mode="kit:transform">
            <xsl:with-param name="offset" select="$offset" />
        </xsl:apply-templates>

        <!-- Set suffix -->
        <xsl:if test="position() = last()">
            <xsl:copy-of select="$suffix" />
        </xsl:if>
    </xsl:element>
</xsl:template>

<!--
    Match attributes
-->

<xsl:template match="//@*" mode="kit:transform">
    <xsl:attribute name="{name(.)}">
        <xsl:value-of select="." />
    </xsl:attribute>
</xsl:template>

<!--
    Utilities
-->

<!-- Set class attribute -->
<xsl:template match="text()" mode="kit:transform-set-class">
    <xsl:attribute name="class">
        <xsl:value-of select="." />
    </xsl:attribute>
</xsl:template>

<!-- Get offset headline -->
<xsl:template match="*" mode="kit:transform-apply-offset">
    <xsl:param name="offset" select="0" />
    <xsl:variable name="depth" select="number(substring-after(name(), 'h'))" />

    <xsl:text>h</xsl:text>
    <xsl:choose>
        <xsl:when test="$offset = 0">
            <xsl:value-of select="$depth" />
        </xsl:when>
        <xsl:when test="$depth + $offset &lt;= 6">
            <xsl:value-of select="$depth + $offset" />
        </xsl:when>
        <xsl:otherwise>6</xsl:otherwise>
    </xsl:choose>
</xsl:template>


</xsl:stylesheet>
