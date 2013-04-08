<?xml version='1.0'?>

<!-- Copyright 2008 JBoss, a division of Red Hat License: GPL Author: Jeff 
	Fearn <jfearn@redhat.com> Author: Tammy Fox <tfox@redhat.com> Author: Andy 
	Fitzsimon <afitzsim@redhat.com> Author: Mark Newton <mark.newton@jboss.org> -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">

	<xsl:import
		href="http://docbook.sourceforge.net/release/xsl/1.76.1/xhtml/chunk.xsl" />

	<xsl:include href="rest-html-common.xsl" />

	<xsl:param name="img.src.path">./
	</xsl:param>
	<!-- Table of content Depth & Numbering -->
	<xsl:param name="section.autolabel">1</xsl:param>
	<xsl:param name="section.label.includes.component.label">1</xsl:param>
	<xsl:param name="section.autolabel.max.depth">2</xsl:param>

	<!-- Display the navigation -->
	<xsl:param name="navig.graphics">0</xsl:param>
	<!-- Display the chapter name rather than bkXXchYY.html -->
	<xsl:param name="use.id.as.filename" select="1" />

	<!-- Remove the numbers in front of each table & example http://www.sagehill.net/docbookxsl/PrintTableStyles.html#TablesUnnumbered -->
	<xsl:param name="local.l10n.xml" select="document('')" />
	<l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
		<l:l10n language="en">
			<l:context name="title">
				<l:template name="table" text=" " /><!-- leave the space here -->
				<l:template name="example" text="Example: %t" /><!-- leave the space here -->
			</l:context>
			<l:context name="xref-number-and-title">
				<l:template name="table" text=" " /><!-- leave the space here -->
				<l:template name="example" text=" " />
			</l:context>
			<l:context name="title-numbered">
       			<l:template name="chapter" text="%t"/>
     		</l:context>
			<l:gentext key="TableofContents" text="" />
			<l:gentext key="Abstract" text=" " />
		</l:l10n>
	</l:i18n>

	<xsl:template match="table" mode="label.markup" />
	<!--xsl:template match="section[@role = 'NotInToc']" mode="toc" / -->

</xsl:stylesheet>
