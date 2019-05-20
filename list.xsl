<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:kit="https://hananils.de/xslt/kit">

<!--
 * hana+nils · Büro für Gestaltung
 * https://hananils.de · buero@hananils.de
-->

<!--
 * Kit: List
 *
 * This template combines nodes with a separator, e. g. creating a comma-separated
 * list from a node set. It's possible to apply a template to the list item using
 * the `kit:list-item` mode.
 *
 * # Example usage
 *
 * <xsl:apply-templates select="item" mode="kit:list" />
 *
 * # Parameters
 *
 * - separator
 *   The separator used to append items, defaults to a comma and space
 * - separator-last
 *   The separator used to append the last item, defaults to a comma and space
-->

<xsl:template match="*" mode="kit:list">
    <xsl:param name="separator" select="', '" />
    <xsl:param name="separator-last" select="', '" />

    <xsl:choose>
        <xsl:when test="position() != 1 and position() != last()">
            <xsl:value-of select="$separator" />
        </xsl:when>
        <xsl:when test="position() != 1 and position() = last()">
            <xsl:value-of select="$separator-last" />
        </xsl:when>
    </xsl:choose>

    <xsl:apply-templates select="." mode="kit:list-item" />
</xsl:template>


</xsl:stylesheet>
