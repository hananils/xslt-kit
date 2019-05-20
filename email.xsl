<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
 * hana+nils · Büro für Gestaltung
 * https://hananils.de · buero@hananils.de
-->

<!--
 * Kit: Email
 *
 * Creates a HTML link from a node containing a plain text address.
 *
 * # Example usage
 *
 * <xsl:apply-templates select="email" mode="kit:email" />
-->

<xsl:template match="*" mode="kit:email">
    <a href="mailto:{.}">
        <xsl:value-of select="." />
    </a>
</xsl:template>


</xsl:stylesheet>
