<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
	NAMES

	- Author: Nils Hörrmann <http://nilshoerrmann.de>
	- Version: 1.0
	- Release date: 20th September 2011
	
	# Example usage
	
		<xsl:call-template name="name">
			<xsl:with-param name="person" select="/data/people/entry[1]" />
		</xsl:call-template>
	
	# Options
	
	- person             A node containing information about a person.
	                     The utitily expects the following nodes relative to $person:
	
	                     `title` (English) or `anrede` (German) – depending on the title setting
	                     `prefix` (e. g. "Prof.")
	                     `name` (English) or `vorname` (German)
	                     `surname` (English) or `nachname` (German)
	                     `suffix` (e. g. "PHD")
	                     
	- title              show title, defaults to `false()`
	- nn                 Value returned if none of the above values is provide, defaults to "N.N."
	
	# Change log
	
	## Version 1.0

	- Initial release
-->

<xsl:template name="name">
	<xsl:param name="person" />
	<xsl:param name="nn" select="'N.&#8201;N.'" />
	<xsl:param name="title" select="false()" />
	
	<!-- Get name -->
	<xsl:choose>
	
		<!-- Nomen nominandum -->
		<xsl:when test="not($person/prefix) and not($person/name) and not($person/surname) and not($person/vorname) and not($person/nachname) and not($person/suffix)">
			<xsl:value-of select="$nn" />
		</xsl:when>
		
		<!-- Format name -->
		<xsl:otherwise>
		
			<!-- Title -->
			<xsl:if test="$title = true() and ($person/title or $person/anrede)">
				<xsl:value-of select="$person/title | $person/anrede"/>
			</xsl:if>

			<!-- Prefix -->
			<xsl:if test="$title = true() and ($person/title or $person/anrede) and $person/prefix">
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:value-of select="$person/prefix" />
			
			<!-- First name -->
			<xsl:if test="$person/prefix != ''">
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:value-of select="$person/name | $person/vorname" />
			
			<!-- Surname -->
			<xsl:if test="$person/name != '' or $person/vorname = ''">
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:value-of select="$person/surname | $person/nachname" />
			
			<!-- Suffix -->
			<xsl:choose>
				<xsl:when test="$person/suffix != '' and not(starts-with($person/suffix, '('))">
					<xsl:text>, </xsl:text>
				</xsl:when>
				<xsl:when test="$person/suffix != '' and starts-with($person/suffix, '(')">
					<xsl:text> </xsl:text>
				</xsl:when>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="$person/suffix = 'M.A.' or $person/suffix = 'M. A.'">M.&#8201;A.</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$person/suffix" />
				</xsl:otherwise>
			</xsl:choose>		
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--
	LIST OF NAMES
	
	# Options
	
	- persons            Multiple person nodes, see "name" template                  
	- title              show title, defaults to `false()`
	- nn                 Value returned if none of the above values is provide, defaults to "N.N."
	- connector          characters used to join names, defaults to `, `
	- last               connector used to add the last name, defaults to ` and `
-->
<xsl:template name="names">
	<xsl:param name="persons" />
	<xsl:param name="nn" select="'N.&#8201;N.'" />
	<xsl:param name="title" select="false()" />
	<xsl:param name="connector" select="', '" />
	<xsl:param name="last" select="' and '" />
	
	<xsl:for-each select="$persons">
		
		<!-- Connect names -->
		<xsl:choose>
			<xsl:when test="position() != 1 and position() != last()">
				<xsl:value-of select="$connector" />
			</xsl:when>
			<xsl:when test="position() != 1 and position() = last()">
				<xsl:value-of select="$last" />
			</xsl:when>
		</xsl:choose>	
		
		<!-- Format name -->
		<xsl:call-template name="name">
			<xsl:with-param name="person" select="current()" />
			<xsl:with-param name="nn" select="$nn" />
			<xsl:with-param name="title" select="$title" />
		</xsl:call-template>
	</xsl:for-each>
</xsl:template>


</xsl:stylesheet>