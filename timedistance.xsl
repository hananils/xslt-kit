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

	- start:            Start date as string, formatted as YYYY-MM-DD
	- end:              End date as string, formatted as YYYY-MM-DD

	# Optional Parameters:
	
	- start-time        Start time as string, formatted as hh:mm
	- end-time          End time as string, formatted as hh:mm
	- full-time         Display hours and minutes, boolean, defaults to false()
	- format:           Number format, defaults to '#0'
	- lang:             The language used, defaults to English
	- highlight:        Highlight the numbers, boolean, defaults to false()
	- connector:        Used to connect values, defaults to ", "
	- last:             Used to connect the last two values, defaults to "and "
	
	# Change Log
	
	## Version 1.2
	
	- Added time calculation (hours and minutes)
	
	## Version 1.1
	
	- Added number format
	- Added highlighting markup
	- Added configurable connector
	
	## Version 1.0
	
	- Initial release
-->

<xsl:template name="timedistance">
	<xsl:param name="start" />
	<xsl:param name="end" />
	<xsl:param name="start-time" select="'-01:00'" />
	<xsl:param name="end-time" select="'-01:00'" />
	<xsl:param name="full-time" select="false()" />
	<xsl:param name="format" select="'#0'" />
	<xsl:param name="lang" select="'en'" />
	<xsl:param name="highlight" select="false()" />
	<xsl:param name="connector" select="', '" />
	<xsl:param name="last" />
	
	<!-- Default connector -->
	<xsl:variable name="and">
		<xsl:choose>
			<xsl:when test="$last != ''">
				<xsl:value-of select="$last" />
			</xsl:when>
			<xsl:when test="$lang = 'de'"> und </xsl:when>
			<xsl:otherwise> and </xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

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
				<xsl:variable name="hours">
					<xsl:choose>
						<xsl:when test="$lang = 'de'">Stunden</xsl:when>
						<xsl:otherwise>hours</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="hour">
					<xsl:choose>
						<xsl:when test="$lang = 'de'">Stunde</xsl:when>
						<xsl:otherwise>hour</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="minutes">
					<xsl:choose>
						<xsl:when test="$lang = 'de'">Minuten</xsl:when>
						<xsl:otherwise>minutes</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="minute">
					<xsl:choose>
						<xsl:when test="$lang = 'de'">Minute</xsl:when>
						<xsl:otherwise>minute</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
			
				<!-- Split dates -->
				<xsl:variable name="start-year" select="number(substring($start, 1, 4))" />
				<xsl:variable name="start-month" select="number(substring($start, 6, 2))" />
				<xsl:variable name="start-day" select="number(substring($start, 9, 2))" />
				<xsl:variable name="start-hour" select="number(substring-before($start-time, ':'))" />
				<xsl:variable name="start-minute" select="number(substring-after($start-time, ':'))" />
				<xsl:variable name="end-year" select="number(substring($end, 1, 4))" />
				<xsl:variable name="end-month" select="number(substring($end, 6, 2))" />
				<xsl:variable name="end-day" select="number(substring($end, 9, 2))" />
				<xsl:variable name="end-hour" select="number(substring-before($end-time, ':'))" />
				<xsl:variable name="end-minute" select="number(substring-after($end-time, ':'))" />
				
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
				<xsl:variable name="day-difference">
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
				<xsl:variable name="day-correction">
					<xsl:choose>
						<xsl:when test="$start-hour &gt; $end-hour and $start-hour != -1">1</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="day-distance" select="$day-difference - $day-correction" />
				
				<!-- Get hour distance -->
				<xsl:variable name="hour-difference">
					<xsl:choose>
						<xsl:when test="$start-hour &lt; $end-hour">
							<xsl:value-of select="$end-hour - $start-hour" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="24 - $start-hour + $end-hour" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="hour-correction">
					<xsl:choose>
						<xsl:when test="$start-minute &gt; $end-minute">1</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="hour-distance" select="$hour-difference - $hour-correction" />
				
				<!-- Get minute distance -->
				<xsl:variable name="minute-distance">
					<xsl:choose>
						<xsl:when test="$start-minute &lt; $end-minute">
							<xsl:value-of select="$end-minute - $start-minute" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="60 - $start-minute + $end-minute" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<!-- Build result -->
				<xsl:variable name="result">
					
					<!-- Years -->
					<xsl:if test="$year-distance &gt; 0">
						<span class="years">
							<xsl:value-of select="format-number($year-distance, $format)" />
						</span>
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
					
					<!-- Months -->
					<xsl:if test="$month-distance &gt; 0">
			
						<!-- Separator -->
						<xsl:if test="$year-distance != 0">
							<xsl:choose>
								<xsl:when test="$day-distance = 0">
									<xsl:value-of select="$and" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$connector" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					
						<!-- Months -->
						<span class="months">
							<xsl:value-of select="format-number($month-distance, $format)" />
						</span>
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
					
					<!-- Days -->
					<xsl:if test="$day-distance != 0">
					
						<!-- Separator -->
						<xsl:if test="$year-distance != 0 or $month-distance != 0">
							<xsl:value-of select="$and" />
						</xsl:if>
						<xsl:if test="$year-distance != 0 or $month-distance != 0">
							<xsl:choose>
								<xsl:when test="$start-hour != -1">
									<xsl:value-of select="$and" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$connector" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
			
						<!-- Days -->
						<span class="days">
							<xsl:value-of select="format-number($day-distance, $format)" />
						</span>
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
									
					<!-- Hours -->
					<xsl:if test="$start-hour != -1">
					
						<!-- Separator -->
						<xsl:if test="$year-distance != 0 or $month-distance != 0 or $day-distance != 0">
							<xsl:choose>
								<xsl:when test="$full-time = false()">
									<xsl:value-of select="$and" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$connector" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
			
						<!-- Hours -->
						<span class="hours">
							<xsl:value-of select="format-number($hour-distance, $format)" />
						</span>
						<xsl:text> </xsl:text>
						<xsl:choose>
							<xsl:when test="$hour-distance = 1">
								<xsl:value-of select="$hour"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$hours"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
									
					<!-- Minutes -->
					<xsl:if test="$start-hour != -1 and $full-time = true()">
					
						<!-- Separator -->
						<xsl:value-of select="$and" />
			
						<!-- Minutes -->
						<span class="minutes">
							<xsl:value-of select="format-number($minute-distance, $format)" />
						</span>
						<xsl:text> </xsl:text>
						<xsl:choose>
							<xsl:when test="$minute-distance = 1">
								<xsl:value-of select="$minute"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$minutes"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:variable>
				
				<!-- Return result -->
				<xsl:choose>
					<xsl:when test="$highlight = false()">
						<xsl:value-of select="$result" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$result" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>