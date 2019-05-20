<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:kit="https://hananils.de/xslt/kit">

<!--
 * hana+nils · Büro für Gestaltung
 * https://hananils.de · buero@hananils.de
-->

<!--
 * Kit: Name
 *
 * This template formats a name from a node containing `firstname`, `lastname`,
 * `prefix`, `title` or `suffix` nodes.
 *
 * # Example usage
 *
 * <xsl:apply-templates select="person" mode="kit:name" />
 *
 * # Parameters
 *
 * - nn
 *   String used if the matched node doesn't contain any personal information,
 *   defaults to "N.&#8201;N."
 * - title
 *   Whether the title should be included or not, defaults to false
-->

<xsl:template match="*" mode="kit:name">
	<xsl:param name="nn" select="'N.&#8201;N.'" />
	<xsl:param name="title" select="false()" />

	<!-- Get name -->
	<xsl:choose>

		<!-- Nomen nominandum -->
		<xsl:when test="not(prefix) and not(firstname) and not(lastname) and not(suffix)">
			<xsl:value-of select="$nn" />
		</xsl:when>

		<!-- Format name -->
		<xsl:otherwise>

			<!-- Title -->
			<xsl:if test="$title = true() and title/text()">
				<xsl:value-of select="title"/>
			</xsl:if>

			<!-- Prefix -->
			<xsl:if test="$title = true() and title/text() and prefix/text()">
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:value-of select="prefix" />

			<!-- First name -->
			<xsl:if test="prefix/text()">
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:value-of select="firstname" />

			<!-- Surname -->
			<xsl:if test="firstname/text()">
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:value-of select="lastname" />

			<!-- Suffix -->
			<xsl:choose>
				<xsl:when test="suffix != '' and not(starts-with(suffix, '('))">
					<xsl:text>,&#0160;</xsl:text>
				</xsl:when>
				<xsl:when test="suffix != '' and starts-with(suffix, '(')">
					<xsl:text>&#0160;</xsl:text>
				</xsl:when>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="suffix = 'M.A.' or suffix = 'M. A.'">M.&#8201;A.</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="suffix" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>
