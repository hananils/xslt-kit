<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
	XSLT NINJA TRANSFORMATIONS
	
	- Author: Nils Hörrmann <http://nilshoerrmann.de> based on a technique by Allen Chang <http://chaoticpattern.com>
	- See: <http://symphony-cms.com/learn/articles/view/html-ninja-technique/>
	- Version: 1.1
	- Release date: 20th September 2011

	# Example usage
	
	# Options
	
	- level             a number to adjust the headline hierarchy, defaults to 0
	
	# Change log
	
	## Version 1.1
	
	- Added missing `ninja` mode for headlines
	
	## Version 1.0
	
	- Initial release
-->

<xsl:template match="//*" mode="ninja">
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
	Attributes 
-->
<xsl:template match="//@*" mode="ninja">
	<xsl:attribute name="{name(.)}">
		<xsl:value-of select="." />
	</xsl:attribute>
</xsl:template>

<!--
	Headlines 
-->
<xsl:template match="h1 | h2 | h3 | h4" mode="ninja" priority="1">
	<xsl:param name="level" select="0" />
	
	<!-- Change hierarchy -->
	<xsl:element name="h{substring-after(name(), 'h') + $level}">
		<xsl:apply-templates select="* | @* | text()" mode="ninja" />
	</xsl:element>
</xsl:template>


</xsl:stylesheet>