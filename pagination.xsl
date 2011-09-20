<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
	DATA SOURCE PAGINATION
	
	- Author: Nils Hörrmann <http://nilshoerrmann.de> based on a utility by Nick Dunn <http://nick-dunn.co.uk>
	- Version: 2.0
	- Release date: 19th September 2011
	
	# Example usage
	
		<xsl:call-template name="pagination">
			<xsl:with-param name="pagination" select="articles/pagination" />
			<xsl:with-param name="pagination-url" select="concat($root, '/', $root-page, '/?page=$')" />
		</xsl:call-template>

	# Required Parameters
	
	- pagination:        XPath to the data source pagination element
	- pagination-url:    URL used for page links, use $ as placeholder for the page number
	
	# Optional Parameters
	
	- show-range:        Number of pages until the list gets shortened, defaults to 5
	- show-navigation:   Show previous or next links, defaults to true()
	- show-rotation:     Add rotation to next and previous links, defaults to false()
	- label-next:        Custom "Next" label text
	- label-previous:    Custom "Previous" label text
	
	# Class options:
	
	- class-pagination:  Class used for the pagination list
	- class-next:        Class used for the next page link
	- class-previous:    Class used for the previous page link
	- class-selected:    Class used for the selected page
	- class-disabled:    Class used for the disabled page link
	
	# Change log

	## Version 2.0
	
	- HTML5 based markup, switched from <ul /> to <nav />
	- Removed option `$class-page`
	- Changed default classes for navigation to `prev` and `next`
	
	## Version 1.0
	
	- Initial release
-->

<xsl:template name="pagination">
	<xsl:param name="pagination" />
	<xsl:param name="pagination-url" />
	<xsl:param name="show-range" select="5" />
	<xsl:param name="show-navigation" select="true()" />
	<xsl:param name="show-rotation" select="false()" />
	<xsl:param name="label-next" select="'&#187;'" />
	<xsl:param name="label-previous" select="'&#171;'" />
	<xsl:param name="class-pagination" select="'pagination'" />
	<xsl:param name="class-next" select="'next'" />
	<xsl:param name="class-previous" select="'previous'" />
	<xsl:param name="class-selected" select="'selected'" />
	<xsl:param name="class-elipsis" select="'elipsis'" />
	<xsl:param name="class-disabled" select="'disabled'" />

	<!-- Only show pagination if there are more than one page -->
	<xsl:if test="$pagination/@total-pages &gt; 1">

		<!-- Adjust range based on total page iterations -->
		<xsl:variable name="range">
			<xsl:choose>
				<xsl:when test="$show-range &lt; 3">3</xsl:when>
				<xsl:when test="$show-range &lt; $pagination/@total-pages">
					<xsl:value-of select="$show-range" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$pagination/@total-pages - 1" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Current page -->
		<xsl:variable name="page-current">
			<xsl:choose>
				<xsl:when test="$pagination/@current-page = ''">1</xsl:when>
				<xsl:otherwise><xsl:value-of select="$pagination/@current-page" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	
		<!-- Previous page -->
		<xsl:variable name="page-previous">
			<xsl:choose>
				<xsl:when test="$page-current = 1"><xsl:value-of select="$pagination/@total-pages" /></xsl:when>
				<xsl:otherwise><xsl:value-of select="$page-current - 1" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Next page -->
		<xsl:variable name="page-next">
			<xsl:choose>
				<xsl:when test="$page-current = $pagination/@total-pages">1</xsl:when>
				<xsl:otherwise><xsl:value-of select="$page-current + 1" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Last range of page number -->
		<xsl:variable name="range-last">
			<xsl:value-of select="$pagination/@total-pages - $range + 1" />
		</xsl:variable>

		<!-- First page -->
		<xsl:variable name="page-first">
			<xsl:choose>
				<xsl:when test="$page-current &gt;= 1 and $page-current &lt; $range">
					<xsl:text>1</xsl:text>
				</xsl:when>
				<xsl:when test="$page-current &gt; $range-last and $page-current &lt;= $pagination/@total-pages">
					<xsl:value-of select="$range-last" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$page-current - (floor($range div 2))" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Last page -->
		<xsl:variable name="page-last">
			<xsl:value-of select="$page-first + $range - 1" />
		</xsl:variable>
		
		<!-- Pagination -->
		<nav class="{$class-pagination}">
		
			<!-- Previous link -->
			<xsl:if test="$show-navigation = true()">
				<xsl:call-template name="navigation">
					<xsl:with-param name="class" select="$class-previous" />
					<xsl:with-param name="class-disabled" select="$class-disabled" />
					<xsl:with-param name="disabled" select="boolean($page-next = 2)" />
					<xsl:with-param name="link" select="boolean($page-next != 2 or $show-rotation = true())" />
					<xsl:with-param name="pagination-url" select="$pagination-url" />
					<xsl:with-param name="page" select="$page-previous" />
					<xsl:with-param name="label" select="$label-previous" />
				</xsl:call-template>
			</xsl:if>
			
			<!-- Page range -->
			<xsl:call-template name="pagination-numbers">
				<xsl:with-param name="pagination-url" select="$pagination-url" />
				<xsl:with-param name="page-first" select="$page-first" />
				<xsl:with-param name="page-last" select="$page-last" />
				<xsl:with-param name="page-current" select="$page-current" />
				<xsl:with-param name="page-total" select="$pagination/@total-pages" />
				<xsl:with-param name="class-selected" select="$class-selected" />
				<xsl:with-param name="class-elipsis" select="$class-elipsis" />
				<xsl:with-param name="iterations" select="$page-last - $page-first" />
			</xsl:call-template>
			
			<!-- Next link -->
			<xsl:if test="$show-navigation = true()">
				<xsl:call-template name="navigation">
					<xsl:with-param name="class" select="$class-next" />
					<xsl:with-param name="class-disabled" select="$class-disabled" />
					<xsl:with-param name="disabled" select="boolean($page-next = 1)" />
					<xsl:with-param name="link" select="boolean($page-next != 1 or $show-rotation = true())" />
					<xsl:with-param name="pagination-url" select="$pagination-url" />
					<xsl:with-param name="page" select="$page-next" />
					<xsl:with-param name="label" select="$label-next" />
				</xsl:call-template>
			</xsl:if>
		</nav>
	</xsl:if>
</xsl:template>

<!--
	Navigation
-->
<xsl:template name="navigation">
	<xsl:param name="class" />
	<xsl:param name="class-disabled" />
	<xsl:param name="disabled" select="false()" />
	<xsl:param name="link" select="true()" />
	<xsl:param name="pagination-url" />
	<xsl:param name="page" />
	<xsl:param name="label" />

	<!-- Relative page link -->
	<a>
	
		<!-- Class -->
		<xsl:attribute name="class">
			<xsl:value-of select="$class" />
			<xsl:if test="$disabled">
				<xsl:text> </xsl:text>
				<xsl:value-of select="$class-disabled" />
			</xsl:if>
		</xsl:attribute>
		
		<!-- Link -->
		<xsl:if test="$link">
			<xsl:attribute name="href">
				<xsl:call-template name="pagination-url-replace">
					<xsl:with-param name="string" select="$pagination-url" />
					<xsl:with-param name="search" select="'$'" />
					<xsl:with-param name="replace" select="string($page)" />
				</xsl:call-template>
			</xsl:attribute>
		</xsl:if>

		<!-- Label -->
		<xsl:value-of select="$label" />
	</a>
</xsl:template>

<!--
	Pages
-->
<xsl:template name="pagination-numbers">
	<xsl:param name="pagination-url" />
	<xsl:param name="page-first" />
	<xsl:param name="page-last" />
	<xsl:param name="page-current" />
	<xsl:param name="page-total" />
	<xsl:param name="class-selected" />
	<xsl:param name="class-elipsis" />
	<xsl:param name="iterations" />

	<!-- Page number  -->	
	<xsl:variable name="page" select="$page-last - $iterations" />
		
	<!-- Generate ellipsis at the beginning -->
	<xsl:if test="$page = $page-first and $page-first &gt; 1">
		<a>
			<xsl:attribute name="href">
				<xsl:call-template name="pagination-url-replace">
					<xsl:with-param name="string" select="$pagination-url" />
					<xsl:with-param name="search" select="'$'" />
					<xsl:with-param name="replace" select="'1'" />
				</xsl:call-template>
			</xsl:attribute>
			<xsl:text>1</xsl:text>
		</a>
		<xsl:if test="$page != 2">
			<span class="{$class-elipsis}">&#8230;</span>
		</xsl:if> 
	</xsl:if>
	
	<!-- Generate page -->
	<a>
		<xsl:if test="$page = $page-current">
			<xsl:attribute name="class">
				<xsl:value-of select="$class-selected" />
			</xsl:attribute>
		</xsl:if>
		<xsl:attribute name="href">
			<xsl:call-template name="pagination-url-replace">
				<xsl:with-param name="string" select="$pagination-url" />
				<xsl:with-param name="search" select="'$'" />
				<xsl:with-param name="replace" select="string($page)" />
			</xsl:call-template>
		</xsl:attribute>
		<xsl:value-of select="$page" />
	</a>
	
	<!-- Generate ellipsis at the end -->
	<xsl:if test="$page = $page-last and $page-last &lt; $page-total">
		<xsl:if test="$page != ($page-total - 1)">
			<span class="{$class-elipsis}">&#8230;</span>
		</xsl:if> 
		<a>
			<xsl:attribute name="href">
				<xsl:call-template name="pagination-url-replace">
					<xsl:with-param name="string" select="$pagination-url" />
					<xsl:with-param name="search" select="'$'" />
					<xsl:with-param name="replace" select="string($page-total)" />
				</xsl:call-template>
			</xsl:attribute>
			<xsl:value-of select="$page-total" />
		</a>
	</xsl:if>
		
	<!-- Generate next page number -->
	<xsl:if test="$iterations &gt; 0">
		<xsl:call-template name="pagination-numbers">
			<xsl:with-param name="pagination-url" select="$pagination-url" />
			<xsl:with-param name="page-first" select="$page-first" />
			<xsl:with-param name="page-last" select="$page-last" />
			<xsl:with-param name="page-current" select="$page-current" />
			<xsl:with-param name="page-total" select="$page-total" />
			<xsl:with-param name="class-selected" select="$class-selected" />
			<xsl:with-param name="class-elipsis" select="$class-elipsis" />
			<xsl:with-param name="iterations" select="$iterations - 1" />
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<!--
	Page URL
--> 
<xsl:template name="pagination-url-replace">
	<xsl:param name="string" />
	<xsl:param name="search" />
	<xsl:param name="replace" />

	<!-- Replace wildcard by page number -->
	<xsl:value-of select="concat(substring-before($string, $search), $replace, substring-after($string, $search))" />	
</xsl:template>


</xsl:stylesheet>