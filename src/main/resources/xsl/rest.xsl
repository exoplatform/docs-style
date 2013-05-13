<?xml version='1.0'?>

<!-- Copyright 2008 JBoss, a division of Red Hat License: GPL Author: Jeff 
	Fearn <jfearn@redhat.com> Author: Tammy Fox <tfox@redhat.com> Author: Andy 
	Fitzsimon <afitzsim@redhat.com> Author: Mark Newton <mark.newton@jboss.org> -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">
	<xsl:import
		href="http://docbook.sourceforge.net/release/xsl/1.76.1/xhtml/chunk.xsl" />

	<xsl:output method="html" />
	<!-- xsl:param name="html.stylesheet" select="'../css/website.css'" />
	<xsl:param name="html.stylesheet.type" select="'text/css'" /-->

	<!-- Table of content Depth & Numbering -->
	<xsl:param name="section.autolabel">
		0
	</xsl:param>
	<xsl:param name="section.label.includes.component.label">
		1
	</xsl:param>
	<xsl:param name="section.autolabel.max.depth">
		2
	</xsl:param>

	<!-- Display the navigation -->
	<xsl:param name="navig.graphics">
		0
	</xsl:param>
	<!-- Display the chapter name rather than bkXXchYY.html -->
	<xsl:param name="use.id.as.filename" select="1" />

	<xsl:param name="generate.section.toc.level" select="0" />
	<xsl:param name="suppress.navigation" select="1" />

	<xsl:param name="header.rule" select="0" />
	<xsl:param name="footer.rule" select="0" />
	<xsl:param name="css.decoration" select="0" />
	<xsl:param name="ulink.target" />
	<xsl:param name="table.cell.border.style" />

	<!-- Set chunk.section.depth to 0 to just chunk chapters. -->
	<xsl:param name="chunk.section.depth" select="2" />
	<xsl:param name="chunk.first.sections" select="1" />
	<xsl:param name="chunk.toc" select="''" />
	<xsl:param name="chunker.output.doctype-public" select="'-//W3C//DTD XHTML 1.0 Strict//EN'" />
	<xsl:param name="chunker.output.doctype-system"
		select="'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'" />
	<xsl:param name="chunker.output.encoding" select="'UTF-8'" />

	<!-- remove title page -->
	<xsl:template name="book.titlepage.recto" />
	<xsl:template name="book.titlepage.before.verso" />

	<!-- TOC -->
	<xsl:param name="generate.toc">
		set toc
		book nop
		article nop
		chapter nop
		qandaset nop
		sect1 nop
		sect2 nop
		sect3 nop
		sect4 nop
		sect5 nop
		section nop
		part nop
	</xsl:param>


	<xsl:template name="banner">
		<div class="uiHeaderPageDocument">
			<div class="clearFix topBannerSignin">
				<div class="pull-right">
					<div class="btn-group">
						<a href="http://community.exoplatform.com/portal/private/classic" class="btn btn-darkGray">Sign In</a>
						<a href="http://community.exoplatform.com/portal/private/classic/register" class="btn btn-lightBlue">Register</a>
					</div>
				</div>
				<a href="http://community.exoplatform.com/" class="logo pull-left"
					target="_blank">
					<img alt="Home" src="../../background/Logo.png"></img>
				</a>

				<div class="menu">
					<ul class="navigationTop clearFix">
						<li>
							<a href="http://community.exoplatform.org/portal/public/classic/home"
								target="_blank">Home</a>
						</li>
						<li>
							<a href="http://community.exoplatform.org/portal/public/classic/forum"
								target="_blank">Forums</a>
						</li>
						<li>
							<a href="http://docs.exoplatform.com" class="selectedNavigationTab">Documentation</a>
						</li>
						<li>
							<a
								href="http://learn.exoplatform.com/Downloading-eXo-Platform-Community-Edition-En2.html"
								target="_blank">Downloads</a>
						</li>
						<li>
							<a href="http://forge.exoplatform.org/" target="_blank">Forge</a>
						</li>
						<li>
							<a href="http://www.exoplatform.com/company/en/Content-types/Plugins"
								target="_blank">Plugins</a>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="breadcrumbs">
	<xsl:param name="this.node" select="." />
	<ul class="breadcrumb">
		<li class="">
			<a href="/">eXo Platform Documentation</a>
		</li>
		<li>
			<img class="uiIconMiniArrowRight" alt="Home" src="../../background/ListBG.gif"></img>
		</li>
		<li class="">
			<a href="/PLF40/rest-api/">REST API Documentation</a>
		</li>
		<li>
			<img class="uiIconMiniArrowRight" alt="Home" src="../../background/ListBG.gif"></img>
		</li>
		<xsl:for-each select="$this.node/ancestor::*">
			<xsl:choose>
				<!-- Skip chapter link -->
				<xsl:when test="self::chapter">
				</xsl:when>

				<!-- Apply only for section link -->
				<xsl:otherwise>
					<li class="">
						<a>
							<xsl:attribute name="href">
		            			<xsl:call-template name="href.target">
		             				<xsl:with-param name="object" select="." />
		              				<xsl:with-param name="context"
								select="$this.node" />
		           				</xsl:call-template>
	          				</xsl:attribute>
							<xsl:apply-templates select="." mode="title.markup" />
						</a>
					</li>
					<li>
						<img class="uiIconMiniArrowRight" alt="Home"
							src="../../background/ListBG.gif"></img>
					</li>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<!-- And display the current node, but not as a link -->
		<li class="active">
			<xsl:apply-templates select="$this.node" mode="title.markup" />
		</li>
	</ul>
	</xsl:template>

	<xsl:template name="rest.header">
		<div class="border-bottom-dottted clearfix">
			<div class="pull-right">
				<div id="DisplayModesDropDown" class="dropdown uiDropdownWithIcon">

					<div data-toggle="dropdown" class="btn dropdown-toggle">
						<span>Jump to</span>
						<span class="spiter"></span>
						<span class="caret"></span>
					</div>
					<ul role="menu" class="dropdown-menu">
						<li>
							<a
								href="javascript:ajaxGet('/PLF40/portal/intranet/home?portal:componentId=34a391b5-82ad-4b86-9bea-90388c4def3b&amp;interactionstate=JBPNS_rO0ABXdkAAJvcAAAAAEADENoYW5nZU9wdGlvbgAIb2JqZWN0SWQAAAABAA5BTExfQUNUSVZJVElFUwALdWljb21wb25lbnQAAAABABREaXNwbGF5TW9kZXNEcm9wRG93bgAHX19FT0ZfXw**&amp;portal:type=action&amp;ajaxRequest=true')"
								class="OptionItem">All Activities</a>
						</li>
						<li>
							<a
								href="javascript:ajaxGet('/PLF40/rest-api/calendar:componentId=34a391b5-82ad-4b86-9bea-90388c4def3b&amp;interactionstate=JBPNS_rO0ABXdeAAJvcAAAAAEADENoYW5nZU9wdGlvbgAIb2JqZWN0SWQAAAABAAhNWV9TUEFDRQALdWljb21wb25lbnQAAAABABREaXNwbGF5TW9kZXNEcm9wRG93bgAHX19FT0ZfXw**&amp;portal:type=action&amp;ajaxRequest=true')"
								class="OptionItem">My Spaces</a>
						</li>
						<li>
							<a
								href="javascript:ajaxGet('/PLF40/rest-api/calendar:componentId=34a391b5-82ad-4b86-9bea-90388c4def3b&amp;interactionstate=JBPNS_rO0ABXdhAAJvcAAAAAEADENoYW5nZU9wdGlvbgAIb2JqZWN0SWQAAAABAAtDT05ORUNUSU9OUwALdWljb21wb25lbnQAAAABABREaXNwbGF5TW9kZXNEcm9wRG93bgAHX19FT0ZfXw**&amp;portal:type=action&amp;ajaxRequest=true')"
								class="OptionItem">Connections</a>
						</li>
						<li>
							<a
								href="javascript:ajaxGet('/PLF40/rest-api/calendar:componentId=34a391b5-82ad-4b86-9bea-90388c4def3b&amp;interactionstate=JBPNS_rO0ABXdjAAJvcAAAAAEADENoYW5nZU9wdGlvbgAIb2JqZWN0SWQAAAABAA1NWV9BQ1RJVklUSUVTAAt1aWNvbXBvbmVudAAAAAEAFERpc3BsYXlNb2Rlc0Ryb3BEb3duAAdfX0VPRl9f&amp;portal:type=action&amp;ajaxRequest=true')"
								class="OptionItem">My Activities</a>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="html.head.section">
		<xsl:call-template name="banner" />
		<div class="uiBox restService" />
		<div class="uiContentBox" />
		<div class="border-bottom-dottted">
			<xsl:call-template name="breadcrumbs" />
		</div>
		<!-- xsl:call-template name="rest.header" / -->
	</xsl:template>

	<xsl:template name="user.header.content">
		<xsl:if test="self::section">
			<xsl:call-template name="html.head.section" />
		</xsl:if>
	</xsl:template>


	<xsl:template name="user.footer.content">
		<xsl:if test="self::section">
					<div xmlns="" class="UIFooterPageDocument">
						Copyright 2013. All rights reserved. eXo Platform SAS
					</div><script xmlns="" src="http://www.google-analytics.com/ga.js" type="text/javascript"/><script xmlns="" type="text/javascript">
						var pageTracker = _gat._getTracker("UA-1292368-24");
						pageTracker._initData();
						pageTracker._trackPageview();
					</script><script xmlns="" src="http://lfov.net/webrecorder/js/listen.js" type="text/Javascript"/>
					<script xmlns="" type="text/Javascript">
						_lf_cid = "LF_df197061";
						_lf_remora();
					</script>
			
			<!-- DISQUS -->
			<div id="disqus_thread"></div>
			<script type="text/javascript">
				var disqus_shortname = 'docswebsite'; /* required: replace example with your forum shortname */
				/* * * DON'T EDIT BELOW THIS LINE * * */
				(function() {
				var dsq = document.createElement('script'); dsq.type = 'text/javascript';
				dsq.async = true;
				dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
				(document.getElementsByTagName('head')[0] ||
				document.getElementsByTagName('body')[0]).appendChild(dsq);
				})();
		
			</script>
			<noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
			<a href="http://disqus.com" class="dsq-brlink">blog comments powered by<span class="logo-disqus">Disqus</span></a>
		</xsl:if>
	</xsl:template>
		
	<!-- ****************** FROM html-common.xsl ****************** -->

	<!-- Remove the numbers in front of each table & example http://www.sagehill.net/docbookxsl/PrintTableStyles.html#TablesUnnumbered -->
	<xsl:param name="local.l10n.xml" select="document('')" />
	<l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
		<l:l10n language="en">
			<l:context name="title">
				<l:template name="table" text=" " /><!-- leave the space here -->
				<l:template name="example" text="Example: %t" /><!-- leave 
					the space here -->
			</l:context>
			<l:context name="xref-number-and-title">
				<l:template name="table" text=" " /><!-- leave the space here -->
				<l:template name="example" text=" " />
			</l:context>
			<l:context name="title-numbered">
				<l:template name="chapter" text="%t" />
			</l:context>
			<l:context name="title-numbered">
				<l:template name="sect1" text="%t" />
			</l:context>
			<l:context name="title-numbered">
				<l:template name="sect2" text="%t" />
			</l:context>
			<l:gentext key="TableofContents" text="" />
			<l:gentext key="Abstract" text=" " />
		</l:l10n>
	</l:i18n>


	<!-- From: xhtml/block.xsl Reason: h5 instead of <b>, remove default title 
		end punctuation Version: 1.74.0 -->
	<xsl:template match="formalpara/title|formalpara/info/title">
		<xsl:variable name="titleStr">
			<xsl:apply-templates />
		</xsl:variable>
		<h5 xmlns="http://www.w3.org/1999/xhtml" class="formalpara">
			<xsl:copy-of select="$titleStr" />
		</h5>
	</xsl:template>

	<!-- From: xhtml/block.xsl Reason: default class (otherwise) to formalpara 
		Version: 1.74.0 -->
	<xsl:template match="formalpara">
		<xsl:call-template name="paragraph">
			<xsl:with-param name="class">
				<xsl:choose>
					<xsl:when test="@role and $para.propagates.style != 0">
						<xsl:value-of select="@role" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>formalpara</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="content">
				<xsl:call-template name="anchor" />
				<xsl:apply-templates />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="abstract">
		<div class="abstract">
			<xsl:call-template name="paragraph">
				<xsl:with-param name="class">
					<xsl:if test="@role and $para.propagates.style != 0">
						<xsl:value-of select="@role" />
					</xsl:if>
				</xsl:with-param>
				<xsl:with-param name="content">
					<xsl:if test="position() = 1 and parent::listitem">
						<xsl:call-template name="anchor">
							<xsl:with-param name="node" select="parent::listitem" />
						</xsl:call-template>
					</xsl:if>

					<xsl:call-template name="anchor" />
					<xsl:apply-templates />
				</xsl:with-param>
			</xsl:call-template>
		</div>
	</xsl:template>

	<!--xsl:template match="section[@role = 'NotInToc']" mode="toc" / -->

</xsl:stylesheet>