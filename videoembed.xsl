<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- 

        ### VIDEO EMBED: Embedding Vimeo and YouTube videos ###
        ###
        ### Written by: Brian Zerangue

        TO USE TEMPLATE, CALL TEMPLATE LIKE SO...
        
        <xsl:call-template name="video-media">
            <xsl:with-param name="width" select="640"/>
            <xsl:with-param name="height" select="348"/>
            <xsl:with-param name="element" select="video-url"/>
        </xsl:call-template>
    -->
        
<xsl:template name="video-media">
        <xsl:param name="element"/>
        <xsl:param name="width"/>
        <xsl:param name="height"/>
        <xsl:param name="color" select="'ffffff'"/>
        <xsl:param name="title" select="'0'"/>
        <xsl:param name="byline" select="'0'"/>
        <xsl:param name="portrait" select="'0'"/>
        <xsl:param name="frameborder" select="'0'"/>
        <xsl:param name="video-id">
            <xsl:choose>
                <xsl:when test="contains($element,'youtube.com/watch?v=')">
                    <xsl:value-of select="substring-after($element,'youtube.com/watch?v=')"/>
                </xsl:when>
                <xsl:when test="contains($element,'youtube.com/v/')">
                    <xsl:value-of select="substring-after($element,'youtube.com/v/')"/>
                </xsl:when>
                <xsl:when test="contains($element,'youtu.be/')">
                    <xsl:value-of select="substring-after($element,'youtube.com/watch?v=')"/>
                </xsl:when>
                <xsl:when test="contains($element,'vimeo.com')">
                    <xsl:value-of select="substring-after($element,'vimeo.com/')"/>
                </xsl:when>
            </xsl:choose>
        </xsl:param>
        
        <div class="video-container">
            <xsl:choose>
                <xsl:when test="contains($element,'youtube.com') or contains($element, 'youtu.be')">
                    <iframe class="youtube-player" type="text/html" width="{$width}" height="{$height}" src="http://www.youtube.com/embed/{$video-id}" frameborder="{$frameborder}">
                        <xsl:comment> You Tube Player </xsl:comment>
                    </iframe>
                </xsl:when>
                <xsl:when test="contains($element,'vimeo.com')">
                    <iframe class="vimeo-player" type="text/html" width="{$width}" height="{$height}" src="http://player.vimeo.com/video/{$video-id}?title={$title}&amp;byline={$byline}&amp;portrait={$portrait}&amp;color={$color}" frameborder="{$frameborder}">
                        <xsl:comment> Vimeo Player </xsl:comment>
                    </iframe> 
                </xsl:when>
            </xsl:choose>
        </div>
    </xsl:template>
    
</xsl:stylesheet>