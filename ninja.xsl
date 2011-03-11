<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
	XSLT NINJA TRANSFORMATIONS
	A utility based on http://symphony-cms.com/learn/articles/view/html-ninja-technique/
	extended by Nils Hörrmann <http://nilshoerrmann.de>
-->

<xsl:template match="//*" mode="ninja">

	<!-- Adjust headline hierarchy by this number -->
	<xsl:param name="level" select="0" />
	
	<!-- Create element -->
	<xsl:element name="{name()}">
	
		<!-- Apply templates for inline elements, attributes and text nodes -->
		<xsl:apply-templates select="* | @* | text()" mode="ninja">
			<xsl:with-param name="level" select="$level" />
		</xsl:apply-templates>
		
	</xsl:element>
	
</xsl:template>

<!--
	ATTRIBUTES
	Reapply attributes 
-->
<xsl:template match="//@*" mode="ninja">

	<!-- Create Attribute -->
	<xsl:attribute name="{name(.)}">
		<xsl:value-of select="." />
	</xsl:attribute>
	
</xsl:template>

<!--
	HEADLINES
	Adjust hierarchy 
-->
<xsl:template match="h1 | h2 | h3 | h4" mode="ninja" priority="1">

	<!-- Get level -->
	<xsl:param name="level" select="0" />
	
	<!-- Change hierarchy -->
	<xsl:element name="h{substring-after(name(), 'h') + $level}">
		<xsl:apply-templates select="* | @* | text()" />
	</xsl:element>
	
</xsl:template>


</xsl:stylesheet>