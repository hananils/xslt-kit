<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	exclude-element-prefixes="str">

<!--
	Twitter
-->
<xsl:template match="statuses" mode="twitter">
	<xsl:param name="lang" select="'en'" />
	<xsl:param name="format" select="'M D, Y'" />
	<xsl:param name="replies" select="true()" />
	<xsl:param name="max" select="10" />
	
	<!-- Set quotes -->
	<xsl:variable name="opening-quote">
		<xsl:choose>
			<xsl:when test="$lang = 'de'">&#8222;</xsl:when>
			<xsl:otherwise>&#8220;</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="closing-quote">
		<xsl:choose>
			<xsl:when test="$lang = 'de'">&#8220;</xsl:when>
			<xsl:otherwise>&#8221;</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- Tweets -->
	<xsl:choose>
		
		<!-- Include replies -->
		<xsl:when test="$replies = true()">
			<xsl:apply-templates select="status[position() &lt;= $max]" mode="twitter">
				<xsl:with-param name="lang" select="$lang" />
				<xsl:with-param name="format" select="$format" />
				<xsl:with-param name="opening-quote" select="$opening-quote" />
				<xsl:with-param name="closing-quote" select="$closing-quote" />
			</xsl:apply-templates>
		</xsl:when>
		
		<!-- Exclude replies -->
		<xsl:otherwise>
			<xsl:apply-templates select="status[not(starts-with(text, '@'))][position() &lt;= $max]" mode="twitter">
				<xsl:with-param name="lang" select="$lang" />
				<xsl:with-param name="format" select="$format" />
				<xsl:with-param name="opening-quote" select="$opening-quote" />
				<xsl:with-param name="closing-quote" select="$closing-quote" />
			</xsl:apply-templates>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- List of tweets -->
<xsl:template match="status" mode="twitter">
	<xsl:param name="lang" />
	<xsl:param name="format" />
	<xsl:param name="opening-quote" />
	<xsl:param name="closing-quote" />

	<article>
		<xsl:apply-templates select="." mode="tweet">
			<xsl:with-param name="lang" select="$lang" />
			<xsl:with-param name="format" select="$format" />
			<xsl:with-param name="opening-quote" select="$opening-quote" />
			<xsl:with-param name="closing-quote" select="$closing-quote" />
		</xsl:apply-templates>
	</article>
</xsl:template>

<!-- Tweet -->
<xsl:template match="status" mode="tweet">
	<xsl:param name="lang" />
	<xsl:param name="format" />
	<xsl:param name="opening-quote" />
	<xsl:param name="closing-quote" />

	<xsl:choose>
	
		<!-- Retweet -->
		<xsl:when test="retweeted_status/*">
			<xsl:attribute name="class">retweet</xsl:attribute>
			
			<blockquote cite="https://twitter.com/{retweeted_status/user/screen_name}/status/{retweeted_status/id}">
				<xsl:apply-templates select="str:tokenize(retweeted_status/text,' ')" mode="tweet">
					<xsl:with-param name="tweet" select="." />
					<xsl:with-param name="opening-quote" select="$opening-quote" />
					<xsl:with-param name="closing-quote" select="$closing-quote" />
				</xsl:apply-templates>
			</blockquote>
			
			<!-- Reference -->
			<footer>
				<a href="https://twitter.com/{retweeted_status/user/screen_name}/status/{retweeted_status/id}" title="{retweeted_status/user/name}, @{retweeted_status/user/screen_name}">
					<xsl:value-of select="retweeted_status/user/name" />
					<xsl:text>, </xsl:text>
					<xsl:call-template name="datetime-twitter">
						<xsl:with-param name="date" select="retweeted_status/created_at" />
						<xsl:with-param name="format" select="$format" />
						<xsl:with-param name="lang" select="$lang" />
					</xsl:call-template>
				</a>
			</footer>
		</xsl:when>
		
		<!-- Original Tweet -->
		<xsl:otherwise>
			<p>
				<xsl:apply-templates select="str:tokenize(text)" mode="tweet">
					<xsl:with-param name="tweet" select="." />
				</xsl:apply-templates>
			</p>
				
			<!-- Reference -->
			<footer>
				<a href="https://twitter.com/{user/screen_name}/status/{id}" title="{user/name}, @{user/screen_name}">
					<xsl:call-template name="datetime-twitter">
						<xsl:with-param name="date" select="created_at" />
						<xsl:with-param name="format" select="$format" />
						<xsl:with-param name="lang" select="$lang" />
					</xsl:call-template>
				</a>
			</footer>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Text -->
<xsl:template match="token" mode="tweet">
	<xsl:param name="opening-quote" />
	<xsl:param name="closing-quote" />
	
	<!-- Opening quotes -->
	<xsl:variable name="quote-start">
		<xsl:choose>
			<xsl:when test="starts-with(., '&quot;')">
				<xsl:value-of select="$opening-quote" />
				<xsl:value-of select="substring-after(., '&quot;')" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="." />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- Closing quotes -->
	<xsl:variable name="quote-end">
		<xsl:choose>
			<xsl:when test="substring-before($quote-start, '&quot;') != ''">
				<xsl:value-of select="substring-before($quote-start, '&quot;')" />
				<xsl:value-of select="$closing-quote" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$quote-start" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Word -->
	<xsl:value-of select="$quote-end"/>
	<xsl:text> </xsl:text>
</xsl:template>

<!-- Username -->
<xsl:template match="token[starts-with(., '@')]" mode="tweet" priority="1">
	<xsl:param name="tweet" />
	
	<!-- Extract username -->
	<xsl:variable name="name">
		<xsl:call-template name="plain">
			<xsl:with-param name="string" select="current()" />
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="user" select="$tweet//user_mention[screen_name = $name]" />

	<!-- Link user -->
	<xsl:choose>
	
		<!-- User name not found -->
		<xsl:when test="count($user) = 0">
			<a href="https://twitter.com/{$name}" title="{$name}" class="username">
				<em>@</em>
				<xsl:value-of select="$name" />
			</a>
		</xsl:when>
		
		<!-- Existing user -->
		<xsl:otherwise>
			<a href="https://twitter.com/{$user/screen_name}" title="{$user/name}" class="username">
				<em>@</em>
				<xsl:value-of select="$user/screen_name" />
			</a>
		</xsl:otherwise>
	</xsl:choose>
	
	<!-- Add remaining string -->
	<xsl:value-of select="substring-after(current(), $name)"/>
	<xsl:text> </xsl:text>
</xsl:template>

<!-- Hashtag -->
<xsl:template match="token[starts-with(., '#')]" mode="tweet" priority="1">
	<xsl:param name="tweet" />
	
	<!-- Get plain tag -->
	<xsl:variable name="tag">
		<xsl:call-template name="plain">
			<xsl:with-param name="string" select="current()" />
		</xsl:call-template>
	</xsl:variable>

	<!-- Link tag -->
	<a href="https://twitter.com/search?q=%23{$tag}" class="hashtag">
		<em>#</em>
		<xsl:value-of select="$tag" />
	</a>
	
	<!-- Add remaining string -->
	<xsl:value-of select="substring-after(current(), $tag)"/>
	<xsl:text> </xsl:text>
</xsl:template>

<!-- Link -->
<xsl:template match="token[starts-with(., 'http')]" mode="tweet" priority="1">
	<xsl:param name="tweet" />
	<xsl:variable name="url" select="$tweet//*[url = current()]" />
	<xsl:variable name="url-mix" select="$tweet//*[starts-with(current(), url)]" />

	<xsl:choose>
		
		<!-- URL found -->
		<xsl:when test="url">
			<a href="{$url/expanded_url}">
				<xsl:value-of select="$url/display_url" />
			</a>
		</xsl:when>
		<xsl:when test="$url-mix">
			<a href="{$url-mix/expanded_url}">
				<xsl:value-of select="$url-mix/display_url" />
			</a>
			<xsl:value-of select="substring-after(., $url-mix/url)" />
		</xsl:when>
		
		<!-- URL not found -->
		<xsl:otherwise>
			<a href="{.}">
				<xsl:value-of select="."/>
			</a>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text> </xsl:text>
</xsl:template>

<!-- Get plain value -->
<xsl:template name="plain">
	<xsl:param name="string" />
	<xsl:variable name="apostroph">&apos;</xsl:variable>
	<xsl:variable name="nopunctation" select="translate($string, '#@,;.:-_!/()=?´`', '')" />
	<xsl:choose>
		<xsl:when test="contains($nopunctation, $apostroph)">
			<xsl:value-of select="substring-before($nopunctation, $apostroph)"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$nopunctation"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>
