<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
	TIME DISTANCE
	
	- Author: Nils Hörrmann <http://nilshoerrmann.de>
	- Version: 1.0
	- Release date: 7th June 2012
	
	# Example usage
	
		<xsl:call-template name="timedistance">
			<xsl:with-param name="start" select="'2011-07-17'" />
			<xsl:with-param name="end" select="'2011-08-04'" />
		</xsl:call-template>	

	# Required Parameters:

	- start:            The start date as string, formatted as YYYY-MM-DD
   	- end:              The end date as string, formatted as YYYY-MM-DD

	# Optional Parameters:
	
	- lang:             The language used, defaults to English
	
	# Change Log
	
	## Version 1.0
	
	- Initial release
-->

<xsl:template name="timedistance">
	<xsl:param name="start" />
	<xsl:param name="end" />
	<xsl:param name="lang" select="'en'"/>

	<!-- Get relative time distance -->
	<xsl:if test="$start != '' and $end != ''">
		<xsl:choose>
		
			<!-- Switch dates when end date is prior start date -->
			<xsl:when test="translate($start, '-', '') &gt; translate($end, '-', '')">
				<xsl:call-template name="timedistance">
					<xsl:with-param name="start" select="$end" />
					<xsl:with-param name="end" select="$start" />
					<xsl:with-param name="lang" select="$lang" />
				</xsl:call-template>	
			</xsl:when>
			
			<!-- Process dates -->
			<xsl:otherwise>
		
				<!-- Language strings -->
				<xsl:variable name="years">
					<xsl:choose>
						<xsl:when test="$lang = 'de'">Jahre</xsl:when>
						<xsl:otherwise>years</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="year">
					<xsl:choose>
						<xsl:when test="$lang = 'de'">Jahr</xsl:when>
						<xsl:otherwise>year</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="months">
					<xsl:choose>
						<xsl:when test="$lang = 'de'">Monate</xsl:when>
						<xsl:otherwise>months</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="month">
					<xsl:choose>
						<xsl:when test="$lang = 'de'">Monat</xsl:when>
						<xsl:otherwise>month</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="days">
					<xsl:choose>
						<xsl:when test="$lang = 'de'">Tage</xsl:when>
						<xsl:otherwise>days</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="day">
					<xsl:choose>
						<xsl:when test="$lang = 'de'">Tag</xsl:when>
						<xsl:otherwise>day</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="and">
					<xsl:choose>
						<xsl:when test="$lang = 'de'">und</xsl:when>
						<xsl:otherwise>and</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
			
				<!-- Split dates -->
				<xsl:variable name="start-year" select="number(substring($start, 1, 4))" />
				<xsl:variable name="start-month" select="number(substring($start, 6, 2))" />
				<xsl:variable name="start-day" select="number(substring($start, 9, 2))" />
				<xsl:variable name="end-year" select="number(substring($end, 1, 4))" />
				<xsl:variable name="end-month" select="number(substring($end, 6, 2))" />
				<xsl:variable name="end-day" select="number(substring($end, 9, 2))" />
				
				<!-- Get year distance -->
				<xsl:variable name="year-difference" select="$end-year - $start-year" />
				<xsl:variable name="year-correction">
					<xsl:choose>
						<xsl:when test="($year-difference &gt; 0 and $start-month &gt; $end-month) or ($year-difference &gt; 0 and $start-month &gt; $end-month and $start-day &gt; $end-day)">1</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>		
				</xsl:variable>
				<xsl:variable name="year-distance" select="$year-difference - $year-correction" />
				
				<!-- Get month distance -->
				<xsl:variable name="month-difference">
					<xsl:choose>
						<xsl:when test="$start-month &gt; $end-month">
							<xsl:value-of select="12 - $start-month + $end-month" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$end-month - $start-month" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="month-correction">
					<xsl:choose>
						<xsl:when test="$month-difference &gt; 0 and $start-day &gt; $end-day">1</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>		
				</xsl:variable>
				<xsl:variable name="month-distance" select="$month-difference - $month-correction" />
				
				<!-- Get day distance -->
				<xsl:variable name="day-distance">
					<xsl:choose>
						<xsl:when test="$start-day &gt; $end-day">
							<xsl:choose>
							
								<!-- 30 days a month -->
								<xsl:when test="$start-month = 4 or $start-month = 6 or $start-month = 9 or $start-month = 11">
									<xsl:value-of select="30 - $start-day + $end-day"/>
								</xsl:when>
								
								<!-- February -->
								<xsl:when test="$start-month = 2">
									<xsl:choose>
										<xsl:when test="($start-year div 4 = 0 and $start-year div 100 != 0) or $start-year div 400 = 0">
											<xsl:value-of select="29 - $start-day + $end-day"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="28 - $start-day + $end-day"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								
								<!-- 31 days a month -->
								<xsl:otherwise>
									<xsl:value-of select="31 - $start-day + $end-day"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$end-day - $start-day" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<!-- Build string: years -->
				<xsl:if test="$year-distance &gt; 0">
					<xsl:value-of select="$year-distance" />
					<xsl:text> </xsl:text>
					<xsl:choose>
						<xsl:when test="$year-distance = 1">
							<xsl:value-of select="$year"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$years"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				
				<!-- Build string: months -->
				<xsl:if test="$month-distance &gt; 0">
		
					<!-- Separator -->
					<xsl:if test="$year-distance != 0">
						<xsl:choose>
							<xsl:when test="$day-distance = 0">
								<xsl:text> </xsl:text>
								<xsl:value-of select="$and" />
								<xsl:text> </xsl:text>
							</xsl:when>
							<xsl:otherwise>, </xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				
					<!-- Months -->
					<xsl:value-of select="$month-distance" />
					<xsl:text> </xsl:text>
					<xsl:choose>
						<xsl:when test="$month-distance = 1">
							<xsl:value-of select="$month"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$months"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				
				<!-- Build string: days -->
				<xsl:if test="$day-distance != 0">
				
					<!-- Separator -->
					<xsl:if test="$year-distance != 0 or $month-distance != 0">
						<xsl:text> </xsl:text>
						<xsl:value-of select="$and" />
						<xsl:text> </xsl:text>
					</xsl:if>
		
					<!-- Days -->
					<xsl:value-of select="$day-distance" />
					<xsl:text> </xsl:text>
					<xsl:choose>
						<xsl:when test="$day-distance = 1">
							<xsl:value-of select="$day"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$days"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>