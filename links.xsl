<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:kit="https://hananils.de/xslt/kit">

<!--
 * hana+nils · Büro für Gestaltung
 * https://hananils.de · buero@hananils.de
-->

<!--
 * Kit: Links
 *
 * Layouts external links where the text contains nothing but the link itself.
 * Removes protocol and www prefix for better readability.
 *
 * # Example usage
 *
 * <xsl:apply-templates select="a" mode="kit:links" />
 *
 * # Parameters
 *
 * - protocol
 *   Default protocol used if a link doesn't feature a protocol, defaults to https
 * - target
 *   The link target, e. g. `_blank`, not set by default
-->

<xsl:template match="* | @* | text()" mode="kit:links">
    <xsl:param name="protocol" select="'https://'" />
    <xsl:param name="target" />

    <xsl:variable name="without-http">
        <xsl:choose>
            <xsl:when test="starts-with(., 'http')">
                <xsl:value-of select="substring-after(., '://')" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="." />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="without-www">
        <xsl:choose>
            <xsl:when test="starts-with($without-http, 'www')">
                <xsl:value-of select="substring-after($without-http, 'www.')" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$without-http" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <a>
        <xsl:attribute name="href">
            <xsl:choose>
                <xsl:when test="not(starts-with(., 'http'))">
                    <xsl:value-of select="concat($protocol, .)" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="." />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:if test="$target != ''">
            <xsl:attribute name="target">
                <xsl:value-of select="$target" />
            </xsl:attribute>
        </xsl:if>

        <xsl:value-of select="$without-www" />
    </a>
</xsl:template>

<!--
    Automatic transform for external links
-->

<xsl:template match="a[contains(@href, text())]" mode="kit:transform" priority="1">
    <xsl:choose>
        <xsl:when test="starts-with(@href, 'mailto:') or starts-with(@href, 'tel:')">
            <xsl:copy-of select="." />
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates select="." mode="kit:links" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
    Automatic transform for internal links, path may or may not start with a slash.
-->

<xsl:template match="a[not(starts-with(@href, 'http'))]" mode="kit:transform">
    <xsl:choose>
        <xsl:when test="starts-with(@href, 'mailto:') or starts-with(@href, 'tel:')">
            <xsl:copy-of select="." />
        </xsl:when>
        <xsl:otherwise>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="$index" />
                    <xsl:if test="not(starts-with(@href, '/'))">/</xsl:if>
                    <xsl:value-of select="@href" />
                </xsl:attribute>

                <xsl:apply-templates select="text() | *" mode="kit:transform" />
            </a>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


</xsl:stylesheet>
