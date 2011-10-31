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
	                     `firstname` (English) or `vorname` (German)
	                     `surname` (English) or `nachname` (German)
	                     `suffix` (e. g. "PHD")
	                     
	- title              Show title, defaults to `false()`
	- nn                 Value returned if none of the above values is provide, defaults to "N.N."
	
	# Change log
	
	## Version 1.1
	
	- Added option to link names in lists
	- Added option to have static names in lists
	- Renamed English `name` to `firstname` in single name template
	
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
			<xsl:value-of select="$person/firstname | $person/vorname" />
			
			<!-- Surname -->
			<xsl:if test="$person/firstname != '' or $person/vorname != ''">
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
	- link               Link to a person's profile, use `{@handle}` as name placeholder
	- handle             Name of node used to replace `{@handle}` placeholder (relative to the node of a single person)
	- title              Show title, defaults to `false()`
	- static             Static names to be added at the end of the list
	- nn                 Value returned if none of the above values is provide, defaults to "N.N."
	- connector          Characters used to join names, defaults to `, `
	- last               Connector used to add the last name, defaults to ` and `
-->
<xsl:template name="names">
	<xsl:param name="persons" />
	<xsl:param name="link" />
	<xsl:param name="handle" />
	<xsl:param name="nn" select="'N.&#8201;N.'" />
	<xsl:param name="title" select="false()" />
	<xsl:param name="static" />
	<xsl:param name="connector" select="', '" />
	<xsl:param name="last" select="' and '" />
	
	<xsl:for-each select="$persons">
		
		<!-- Connect names -->
		<xsl:choose>
			<xsl:when test="position() != 1 and (position() != last() or $static != '') ">
				<xsl:value-of select="$connector" />
			</xsl:when>
			<xsl:when test="position() != 1 and position() = last() and $static = ''">
				<xsl:value-of select="$last" />
			</xsl:when>
		</xsl:choose>	

		<!-- Get name -->
		<xsl:choose>
		
			<!-- Linked -->
			<xsl:when test="$link != ''">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="substring-before($link, '{@handle}')"/>
						<xsl:value-of select="current()/*[name() = $handle]/@handle"/>
						<xsl:value-of select="substring-after($link, '{@handle}')"/>
					</xsl:attribute>
					<xsl:call-template name="name">
						<xsl:with-param name="person" select="current()" />
						<xsl:with-param name="nn" select="$nn" />
						<xsl:with-param name="title" select="$title" />
					</xsl:call-template>
				</a>
			</xsl:when>
			
			<!-- Plain -->
			<xsl:otherwise>
				<xsl:call-template name="name">
					<xsl:with-param name="person" select="current()" />
					<xsl:with-param name="nn" select="$nn" />
					<xsl:with-param name="title" select="$title" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
	
	<!-- Static names -->
	<xsl:if test="$static != ''">
		<xsl:value-of select="$connector" />
		<xsl:value-of select="$static" />
	</xsl:if>
</xsl:template>


</xsl:stylesheet>