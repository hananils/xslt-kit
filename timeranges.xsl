<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
	TIME RANGE
	
	- Author: Nils Hörrmann <http://nilshoerrmann.de>
	- Version: 1.0
	- Release date: 31st October 2011
	
	# Example usage
	
	To do!

	# Required Parameters:

	To do!

	# Optional Parameters:
	
	To do!
	
	# Requirements
	
	kit/datetime.xsl
	
	# Change Log
	
	## Version 1.1
	
	- Added non-breaking space for German times
	
	## Version 1.0
	
	- Initial release
-->

<xsl:template name="timerange">
	<xsl:param name="start" />
	<xsl:param name="end" />
	<xsl:param name="show-time" select="true()" />
	<xsl:param name="lang" select="'de'" />
	<xsl:param name="dateformat-long" />
	<xsl:param name="dateformat-short" />
	<xsl:param name="date-separator" />
	<xsl:param name="time-separator" />
	<xsl:param name="datetime-separator" />
	<xsl:param name="timeformat" />
	
	<!-- Format times -->
	<xsl:choose>
	
		<!-- Process given times -->
		<xsl:when test="$dateformat-long != '' and $dateformat-short != '' and ($show-time = false() or $timeformat !='')">
			<xsl:call-template name="time-formatter">
				<xsl:with-param name="start" select="$start" />
				<xsl:with-param name="end" select="$end" />
				<xsl:with-param name="show-time" select="$show-time" />
				<xsl:with-param name="lang" select="$lang" />
				<xsl:with-param name="dateformat-long" select="$dateformat-long" />
				<xsl:with-param name="dateformat-short" select="$dateformat-short" />
				<xsl:with-param name="date-separator" select="$date-separator" />
				<xsl:with-param name="time-separator" select="$time-separator" />
				<xsl:with-param name="datetime-separator" select="$datetime-separator" />
				<xsl:with-param name="timeformat" select="$timeformat" />
			</xsl:call-template>
		</xsl:when>

		<!-- Set default formats based on language -->
		<xsl:otherwise>
			<xsl:choose>
				<xsl:when test="$lang = 'en'">
					<xsl:call-template name="time-formatter">
						<xsl:with-param name="start" select="$start" />
						<xsl:with-param name="end" select="$end" />
						<xsl:with-param name="show-time" select="$show-time" />
						<xsl:with-param name="lang" select="$lang" />
						<xsl:with-param name="dateformat-long" select="'D_M Y'" />
						<xsl:with-param name="dateformat-short" select="'D_M'" />
						<xsl:with-param name="date-separator" select="' – '" />
						<xsl:with-param name="datetime-separator" select="', '" />
						<xsl:with-param name="time-separator" select="' – '" />
						<xsl:with-param name="timeformat" select="'t'" />
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$lang = 'de'">
					<xsl:call-template name="time-formatter">
						<xsl:with-param name="start" select="$start" />
						<xsl:with-param name="end" select="$end" />
						<xsl:with-param name="show-time" select="$show-time" />
						<xsl:with-param name="lang" select="$lang" />
						<xsl:with-param name="dateformat-long" select="'x._M Y'" />
						<xsl:with-param name="dateformat-short" select="'x._M'" />
						<xsl:with-param name="date-separator" select="' – '" />
						<xsl:with-param name="datetime-separator" select="', '" />
						<xsl:with-param name="time-separator" select="' – '" />
						<xsl:with-param name="timeformat" select="'h_\U\h\r'" />
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>	
	
<xsl:template name="time-formatter">
	<xsl:param name="start" />
	<xsl:param name="end" />
	<xsl:param name="show-time" />
	<xsl:param name="lang" />
	<xsl:param name="dateformat-long" />
	<xsl:param name="dateformat-short" />
	<xsl:param name="date-separator" />
	<xsl:param name="time-separator" />
	<xsl:param name="datetime-separator" />
	<xsl:param name="timeformat" />

	<!-- Timerange -->
	<xsl:choose>

		<!-- Same day -->
		<xsl:when test="$start = $end or not($end)">
	
			<!-- Start date -->
			<xsl:call-template name="format-date">
				<xsl:with-param name="date" select="$start" />
				<xsl:with-param name="format" select="$dateformat-long" />
				<xsl:with-param name="lang" select="$lang" />
			</xsl:call-template>
			
			<!-- Time -->
			<xsl:if test="$start/@time != '00:00' and $show-time = true()">
				<xsl:value-of select="$datetime-separator" />
				<xsl:call-template name="format-date">
					<xsl:with-param name="date" select="$start" />
					<xsl:with-param name="format" select="$timeformat" />
					<xsl:with-param name="lang" select="$lang" />
				</xsl:call-template>
				<xsl:if test="$end">
					<xsl:value-of select="$time-separator" />
					<xsl:call-template name="format-date">
						<xsl:with-param name="date" select="$end" />
						<xsl:with-param name="format" select="$timeformat" />
						<xsl:with-param name="lang" select="$lang" />
					</xsl:call-template>
				</xsl:if>
			</xsl:if>	
		</xsl:when>
		
		<!-- Different day -->
		<xsl:otherwise>
	
			<!-- Start date -->
			<xsl:call-template name="format-date">
				<xsl:with-param name="date" select="$start" />
				<xsl:with-param name="format" select="$dateformat-long" />
				<xsl:with-param name="lang" select="$lang" />
			</xsl:call-template>
			
			<!-- Start time -->
			<xsl:if test="$start/@time != '00:00' and $show-time = true()">
				<xsl:value-of select="$datetime-separator" />
				<xsl:call-template name="format-date">
					<xsl:with-param name="date" select="$start" />
					<xsl:with-param name="format" select="$timeformat" />
					<xsl:with-param name="lang" select="$lang" />
				</xsl:call-template>
			</xsl:if>	
			
			<!-- End date -->
			<xsl:if test="$end">	
				<xsl:value-of select="$date-separator" />
				<xsl:call-template name="format-date">
					<xsl:with-param name="date" select="$end" />
					<xsl:with-param name="format" select="$dateformat-long" />
					<xsl:with-param name="lang" select="$lang" />
				</xsl:call-template>
			</xsl:if>
			
			<!-- End time -->
			<xsl:if test="$end/@time != '00:00' and $show-time = true()">
				<xsl:value-of select="$datetime-separator" />
				<xsl:call-template name="format-date">
					<xsl:with-param name="date" select="$end" />
					<xsl:with-param name="format" select="$timeformat" />
					<xsl:with-param name="lang" select="$lang" />
				</xsl:call-template>
			</xsl:if>	
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--
	TIME RANGES
-->
<xsl:template name="timeranges">
	<xsl:param name="ranges" />
	<xsl:param name="connector" select="', '" />
	<xsl:param name="last" select="' and '" />

	<xsl:param name="show-time" select="true()" />
	<xsl:param name="lang" select="'de'" />
	<xsl:param name="dateformat-long" />
	<xsl:param name="dateformat-short" />
	<xsl:param name="date-separator" />
	<xsl:param name="time-separator" />
	<xsl:param name="datetime-separator" />
	<xsl:param name="timeformat" />

	<xsl:for-each select="$ranges">
		
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
		<xsl:call-template name="timerange">
			<xsl:with-param name="start" select="current()/start" />
			<xsl:with-param name="end" select="current()/end" />
			<xsl:with-param name="show-time" select="$show-time" />
			<xsl:with-param name="lang" select="$lang" />
			<xsl:with-param name="dateformat-long" select="$dateformat-long" />
			<xsl:with-param name="dateformat-short" select="$dateformat-short" />
			<xsl:with-param name="date-separator" select="$date-separator" />
			<xsl:with-param name="time-separator" select="$time-separator" />
			<xsl:with-param name="datetime-separator" select="$datetime-separator" />
			<xsl:with-param name="timeformat" select="$timeformat" />
		</xsl:call-template>
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
	