<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="*" mode="comma-separated">
    <xsl:if test="position() != 1">, </xsl:if>
    <xsl:value-of select="." />
</xsl:template>

</xsl:stylesheet>
