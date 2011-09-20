<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
	RESIZE IMAGES
	
	- Author: Nils Hörrmann <http://nilshoerrmann.de>
	- Version: 1.1
	- Release date: 8th March 2011
	
	# Example usage
	
		<xsl:call-template name="image" mode="jit">
			<xsl:with-param name="image" select="image" />
			<xsl:with-param name="mode" select="2" />
			<xsl:with-param name="width" select="50" />
			<xsl:with-param name="height" select="50" />
			<xsl:with-param name="link" select="true()" />
		</xsl:call-template>
							
	# Options
	
	- image:             A Symphony image node containing image path, 
	                     filename and meta information
	- mode:              Resize mode, either nummeric or string
	                     - direct display: 0 or empty
	                     - resize: 1 or 'resize'
	                     - crop to fill: 2 or 'crop'
	                     - resize canvas: 3 or 'resize-crop'
	- width:             Target width, nummeric
	- height:            Target height, nummeric
	- position:          Canvas position, nummeric
	- background-color:  Optional for mode 3, hex
	- link:              Link back to original image, either true() or false()	
	- alt:               Optional alternative text, string
	- title:             Optional title, string
	- class:             Optional class name, string
	
	# Notes
	
	This template will add the original dimensions as data attribute, e. g.
	
		data-width="615" data-height="250"
	
	This can be used as object for futher JavaScript processing when 
	generating an image gallery.
	
	If either width or height of the resized image are missing, these values are automatically calculated based on the original dimensions.
	
	# Limitations
	
	This template currently does not support external images.
	
	# Change log
	
	## Version 2.0
	
	- Store orinigal width and height in data attributes
	- Add custom alt attributes
	
	## Version 1.1
	
	- Initial release
-->
<xsl:template name="image" mode="jit">
	<xsl:param name="image" />
	<xsl:param name="mode" select="'resize'" />
	<xsl:param name="width" select="0" />
	<xsl:param name="height" select="0" />
	<xsl:param name="position" select="5" />
	<xsl:param name="background-color" />
	<xsl:param name="link" select="false()" />
	<xsl:param name="alt" />
	<xsl:param name="title" />
	<xsl:param name="class" />
	
	<!-- Get Image -->
	<xsl:variable name="resized-image">
		<xsl:choose>
		
			<!-- Resize -->
			<xsl:when test="$mode = 'resize' or $mode = 1">
				<xsl:call-template name="resize" mode="jit">
					<xsl:with-param name="image" select="$image" />
					<xsl:with-param name="mode" select="1" />
					<xsl:with-param name="width" select="$width" />
					<xsl:with-param name="height" select="$height" />
					<xsl:with-param name="alt" select="$alt" />
					<xsl:with-param name="title" select="$title" />
					<xsl:with-param name="class" select="$class" />
				</xsl:call-template>
			</xsl:when>
			
			<!-- Crop to fill -->
			<xsl:when test="$mode = 'crop' or $mode = 2">
				<xsl:call-template name="resize" mode="jit">
					<xsl:with-param name="image" select="$image" />
					<xsl:with-param name="mode" select="2" />
					<xsl:with-param name="width" select="$width" />
					<xsl:with-param name="height" select="$height" />
					<xsl:with-param name="position" select="$position" />
					<xsl:with-param name="alt" select="$alt" />
					<xsl:with-param name="title" select="$title" />
					<xsl:with-param name="class" select="$class" />
				</xsl:call-template>
			
			</xsl:when>
			
			<!-- Resize canvas -->
			<xsl:when test="$mode = 'resize-crop' or $mode = 3">
				<xsl:call-template name="resize" mode="jit">
					<xsl:with-param name="image" select="$image" />
					<xsl:with-param name="mode" select="3" />
					<xsl:with-param name="width" select="$width" />
					<xsl:with-param name="height" select="$height" />
					<xsl:with-param name="position" select="$position" />
					<xsl:with-param name="background-color" select="$background-color" />
					<xsl:with-param name="alt" select="$alt" />
					<xsl:with-param name="title" select="$title" />
					<xsl:with-param name="class" select="$class" />
				</xsl:call-template>
			</xsl:when>
			
			<!-- Direct display -->
			<xsl:otherwise>
				<xsl:call-template name="resize" mode="jit">
					<xsl:with-param name="image" select="$image" />
					<xsl:with-param name="mode" select="0" />
					<xsl:with-param name="alt" select="$alt" />
					<xsl:with-param name="title" select="$title" />
					<xsl:with-param name="class" select="$class" />
				</xsl:call-template>
			</xsl:otherwise>	
		</xsl:choose>
	</xsl:variable>
	
	<!-- Link image -->
	<xsl:choose>
		<xsl:when test="$link != false()">
			<a href="{$workspace}{$image/@path}/{$image/filename}">
				<xsl:copy-of select="$resized-image" />
			</a>
		</xsl:when>
		<xsl:otherwise>
			<xsl:copy-of select="$resized-image" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--
	Generate resized image
-->
<xsl:template name="resize" mode="jit">
	<xsl:param name="image" />
	<xsl:param name="mode" />
	<xsl:param name="width" />
	<xsl:param name="height" />
	<xsl:param name="position" />
	<xsl:param name="background-color" />
	<xsl:param name="alt" />
	<xsl:param name="title" />
	<xsl:param name="class" />
	
	<!-- Get Width -->
	<xsl:variable name="jit-width">
		<xsl:choose>
			
			<!-- Keep width -->
			<xsl:when test="$width != 0">
				<xsl:value-of select="$width" />
			</xsl:when>
			
			<!-- Calculate with -->
			<xsl:otherwise>
				<xsl:call-template name="calculate-dimension" mode="jit">
					<xsl:with-param name="a" select="$image/meta/@width" />
					<xsl:with-param name="b" select="$image/meta/@height" />
					<xsl:with-param name="c" select="$height" />
				</xsl:call-template>
			</xsl:otherwise>
			
		</xsl:choose>
	</xsl:variable>
	
	<!-- Get Height -->
	<xsl:variable name="jit-height">
		<xsl:choose>
			
			<!-- Keep height -->
			<xsl:when test="$height != 0">
				<xsl:value-of select="$height" />
			</xsl:when>
			
			<!-- Calculate height -->
			<xsl:otherwise>
				<xsl:call-template name="calculate-dimension" mode="jit">
					<xsl:with-param name="a" select="$image/meta/@height" />
					<xsl:with-param name="b" select="$image/meta/@width" />
					<xsl:with-param name="c" select="$width" />
				</xsl:call-template>
			</xsl:otherwise>
			
		</xsl:choose>
	</xsl:variable>
	
	<!-- Resized image -->
	<img data-width="{$image/meta/@width}" data-height="{$image/meta/@height}">
		
		<!-- Title -->
		<xsl:if test="$title != ''">
			<xsl:attribute name="title">
				<xsl:value-of select="$title"/>
			</xsl:attribute>
		</xsl:if>
		
		<!-- Alternative text -->
		<xsl:if test="$alt != ''">
			<xsl:attribute name="alt">
				<xsl:value-of select="$alt"/>
			</xsl:attribute>
		</xsl:if>
	
		<!-- Set width -->
		<xsl:if test="$jit-width != 0 and $jit-width != ''">
			<xsl:attribute name="width">
				<xsl:value-of select="$jit-width" />
			</xsl:attribute>
		</xsl:if>
		
		<!-- Set height -->
		<xsl:if test="$jit-height != 0 and $jit-height != ''">
			<xsl:attribute name="height">
				<xsl:value-of select="$jit-height" />
			</xsl:attribute>
		</xsl:if>
		
		<!-- Set title -->
		<xsl:if test="$title != ''">
			<xsl:attribute name="title">
				<xsl:value-of select="$title" />
			</xsl:attribute>
		</xsl:if>
	
		<!-- Set source -->
		<xsl:attribute name="src">
			<xsl:value-of select="$root" />
			<xsl:choose>
			
				<!-- Resize -->
				<xsl:when test="$mode = 1">
					<xsl:value-of select="concat('/image/1/', $jit-width, '/', $jit-height)" />
				</xsl:when>
				
				<!-- Crop to fill -->
				<xsl:when test="$mode = 2">
					<xsl:value-of select="concat('/image/2/', $jit-width, '/', $jit-height, '/', $position)" />
				</xsl:when>
				
				<!-- Resize canvas -->
				<xsl:when test="$mode = 3">
					<xsl:value-of select="concat('/image/2/', $jit-width, '/', $jit-height, '/', $position)" />
					<xsl:if test="$background-color">
						<xsl:value-of select="concat('/', $background-color)" />
					</xsl:if>
				</xsl:when>
				
				<!-- Direct display -->
				<xsl:otherwise>
					<xsl:text>/workspace/</xsl:text>
				</xsl:otherwise>	
			
			</xsl:choose>
			<xsl:value-of select="$image/@path" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$image/filename" />
		</xsl:attribute>
		
		<!-- Set class -->
		<xsl:if test="$class != ''">
			<xsl:attribute name="class">
				<xsl:value-of select="$class" />
			</xsl:attribute>
		</xsl:if>
	</img>
</xsl:template>

<!-- 
	Calculate missing dimension
-->
<xsl:template name="calculate-dimension" mode="jit">
	<xsl:param name="a" />
	<xsl:param name="b" />
	<xsl:param name="c" />

	<xsl:if test="$c != 0">
		<xsl:value-of select="round($a div $b * $c)" />
	</xsl:if>
</xsl:template>


</xsl:stylesheet>