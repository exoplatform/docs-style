<?xml version='1.0'?>

<!--
  Copyright 2008 JBoss, a division of Red Hat
  License: LGPL
  Author: Mark Newton <mark.newton@jboss.org>
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:param name="use.simplified.author.group" select="1"/>

  <!-- XHTML settings -->
  <!--
  <xsl:param name="html.stylesheet" select="'css/seamframework.css'"/>
     
  <xsl:param name="siteHref" select="'http://www.seamframework.org'"/>
  <xsl:param name="docHref" select="'http://www.seamframework.org/Documentation'"/>
  <xsl:param name="siteLinkText" select="'SeamFramework.org'"/>
  -->  

  <!-- XHTML and PDF --> 
 <!--  Enable extensions (needed for callouts) -->
 <xsl:param name="use.extensions">1</xsl:param>

 <!-- For backwards compatibility we want to use callouts specified using programlistingco elements -->
 <xsl:param name="callouts.extension">1</xsl:param>

 <!-- Use graphical callouts as they look nicer with highlighed code. -->
  <xsl:param name="callout.graphics">1</xsl:param>
  <xsl:param name="callout.graphics.number.limit">15</xsl:param>
 <xsl:param name="callout.graphics.extension">.png</xsl:param>

  <xsl:param name="callout.graphics.path">
    <xsl:if test="$img.src.path != ''">
      <xsl:value-of select="$img.src.path"/>
    </xsl:if>
    <xsl:text>images/callouts/</xsl:text>
  </xsl:param>
 
  <xsl:param name="admon.graphics.path">
    <xsl:if test="$img.src.path != ''">
      <xsl:value-of select="$img.src.path"/>
    </xsl:if>
    <xsl:text>background/</xsl:text>
  </xsl:param>
  
   <!--Specify location of callout icons -->
   <xsl:param name="callout.defaultcolumn">1</xsl:param>

 <!-- TOC -->
  <xsl:param name="section.autolabel" select="1"/>
  
 <!-- Include the chapter no -->
   <xsl:param name="section.label.includes.component.label" select="1" />
   
</xsl:stylesheet>
