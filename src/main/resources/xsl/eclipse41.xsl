<?xml version='1.0'?>

<!--
  Copyright 2008 JBoss, a division of Red Hat
  License: LGPL
  Author: Mark Newton <mark.newton@jboss.org>
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
								xmlns:rf="java:org.jboss.highlight.XhtmlRendererFactory"
                exclude-result-prefixes="#default">

  <xsl:import href="http://docbook.sourceforge.net/release/xsl/1.76.1/eclipse/eclipse3.xsl"/>
  	<xsl:param name="html.stylesheet" select="'css/exo.css'" />
	<xsl:param name="html.stylesheet.type" select="'text/css'" />

  <xsl:param name="eclipse.plugin.name">eXo Platform Documentation 4.1</xsl:param>
  <xsl:param name="eclipse.plugin.id">PLF41</xsl:param>
  <xsl:param name="eclipse.plugin.provider">eXo Platform</xsl:param>
  
  <!-- Table of content Depth & Numbering -->
 <xsl:param name="chapter.autolabel" select="1"/>
 <xsl:param name="part.autolabel" select="'1'"/>
 <xsl:param name="section.autolabel" select="'1'"/>
 <xsl:param name="section.label.includes.component.label" select="'1'"/>
 <xsl:param name="section.autolabel.max.depth">4</xsl:param>
  
  <!--Callouts-->
   <!--  Enable extensions (needed for callouts) -->
 <xsl:param name="use.extensions">1</xsl:param>

 <!-- For backwards compatibility we want to use callouts specified using programlistingco elements -->
 <xsl:param name="callouts.extension">1</xsl:param>

 <!-- Use graphical callouts as they look nicer with highlighed code. -->
  <xsl:param name="callout.graphics">1</xsl:param>
  <xsl:param name="callout.graphics.number.limit">15</xsl:param>
 <xsl:param name="callout.graphics.extension">.png</xsl:param>
  
   <!--Specify location of callout icons -->
   <xsl:param name="callout.defaultcolumn">1</xsl:param>

 	<!-- These extensions are required for table printing and other stuff -->
  <xsl:param name="ignore.image.scaling" select="1"/>
  <xsl:param name="tablecolumns.extension" select="0"/>
  <xsl:param name="graphicsize.extension" select="0"/>
  
  <!-- Set chunk.section.depth to 0 to just chunk chapters. -->
  <xsl:param name="chunk.section.depth" select="4"/>
  <xsl:param name="chunk.first.sections" select="1"/>
  
  <!--Display fixed book name rather than bk0X.html and fixed chapter name rather than bkXXchYY.html -->
  <xsl:param name="use.id.as.filename" select="1"/>
  
  <!-- turn off a TOC -->
  <xsl:param name="generate.toc">
		/appendix nop
		article/appendix  nop
		/article  toc,title
		/book     nop <!-- Remove list of tables, figures, examples -->
		/chapter  nop
		qandaset toc
		part      nop
		/preface  toc,title
		reference toc,title
		sect1     toc,title
		sect2     toc,title
		/sect3    nop
		/sect4    nop
		/sect5    nop
		section   toc,title
		set       toc
	</xsl:param>
 
    <xsl:param name="generate.section.toc.level" select="3"/>
    
    <xsl:template match="section[@role = 'NotInToc']" mode="toc" />
  <!-- ==================================================================== -->
  
  <!-- From: xhtml/chunk-common.xsl 
  	Redefine a new template for the header navigation
  -->

  <xsl:template name="header.navigation">
    <xsl:variable name="row1" select="$navig.showtitles != 0"/>
  </xsl:template>
	
	<!-- ==================================================================== -->
	
	<!-- From: xhtml/chunk-common.xsl 
  	Redefine a new template for the footer navigation
  -->
  
  <xsl:template name="footer.navigation">
	<xsl:param name="prev" select="/foo" />
	<xsl:param name="next" select="/foo" />
	<xsl:param name="nav.context" />

	<xsl:variable name="home" select="/*[1]" />
	<xsl:variable name="up" select="parent::*" />

	<xsl:variable name="row1" select="count($prev) &gt; 0 or count($up) &gt; 0 or count($next) &gt; 0" />
	<xsl:variable name="row2" select="($prev and $navig.showtitles != 0) or (generate-id($home) != generate-id(.)                                         or $nav.context = 'toc')                                     or ($chunk.tocs.and.lots != 0                                         and $nav.context != 'toc')                                     or ($next and $navig.showtitles != 0)" />

	<xsl:if test="$suppress.navigation = '0' and $suppress.footer.navigation = '0'">
	
		<div class="doc-navigation clearfix">
				<ul class="btn-group  doc-navtitle">
					
					<!-- PREVIOUS AND NEXT -->
					<xsl:if test="count($prev)&gt;0">
						<li class="previous btn">
							<a>
								<xsl:attribute name="href">
							   <xsl:call-template name="href.target">
							     <xsl:with-param name="object" select="$prev" />
							    </xsl:call-template>
							   </xsl:attribute>
								<xsl:call-template name="navig.content">
									<xsl:with-param name="direction" select="'prev'" />
								</xsl:call-template>
								<xsl:apply-templates select="$prev" mode="object.title.markup" />
							</a>
						</li>
					</xsl:if>
					<xsl:if test="count($next)&gt;0">
						<li class="next btn">
							<a>
								<xsl:attribute name="href">
	            					<xsl:call-template name="href.target">
	              					<xsl:with-param name="object" select="$next" />
	               					</xsl:call-template>
	             				</xsl:attribute>
								<xsl:call-template name="navig.content">
									<xsl:with-param name="direction" select="'next'" />
								</xsl:call-template>
								<xsl:apply-templates select="$next" mode="object.title.markup" />
							</a>
						</li>
					</xsl:if>
				</ul>

				<!-- UP AND HOME -->
				<ul class="btn-group doc-nav">		
					<xsl:if test="count($up)&gt;0 and generate-id($up) != generate-id($home)">
						<li class="up btn">
							<a>
								<xsl:attribute name="href">
                   					<xsl:call-template name="href.target">
                     						<xsl:with-param name="object" select="$up" />
                   					</xsl:call-template>
                 					</xsl:attribute>
								<xsl:call-template name="navig.content">
									<xsl:with-param name="direction" select="'up'" />
								</xsl:call-template>
								Up to top
							</a>
						</li>
					</xsl:if>
					
						<li class="home btn">	
							<xsl:choose>
								<xsl:when test="$home != . or $nav.context = 'toc'">
									<a>
										<xsl:attribute name="href">
                      							<xsl:call-template name="href.target">
                         							<xsl:with-param name="object" select="$home" />
                      							</xsl:call-template>
                    						</xsl:attribute>
										<xsl:call-template name="navig.content">
											<xsl:with-param name="direction" select="'home'" />
										</xsl:call-template>
										Home
									</a>
									<xsl:if test="$chunk.tocs.and.lots != 0 and $nav.context != 'toc'">
										<xsl:text>&#160;|&#160;</xsl:text>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									&#160;
								</xsl:otherwise>
							</xsl:choose>
						</li>
					</ul>
				</div>
		</xsl:if>


								<!-- xsl:if test="$chunk.tocs.and.lots != 0 and $nav.context != 'toc'">
									<a accesskey="t">
										<xsl:attribute name="href">
                     						<xsl:apply-templates select="/*[1]" mode="recursive-chunk-filename">
												<xsl:with-param name="recursive" select="true()" />
                      						</xsl:apply-templates>
                      						<xsl:text>-toc</xsl:text>
                      						<xsl:value-of select="$html.ext" />
                    					</xsl:attribute>
										<xsl:call-template name="gentext">
											<xsl:with-param name="key" select="'nav-toc'" />
										</xsl:call-template>
									</a>
						</xsl:if-->


			<!-- 2ND LINE -->
				<!-- ul class="docnavtitle">
					<xsl:if test="$row2">
						<li class="titlefooterprev">
							<xsl:if test="$navig.showtitles != 0">
								<xsl:apply-templates select="$prev" mode="object.title.markup" />
							</xsl:if>
						</li>

						<li class="titlefooternext">
							<xsl:if test="$navig.showtitles != 0">
								<xsl:apply-templates select="$next" mode="object.title.markup" />
							</xsl:if>
						</li>
					</xsl:if>
				</ul -->

	<!-- FOOTER IN EVERY PAGES -->
	<div class="UIFooterPageDocument">
		Copyright ©2013. All rights reserved. eXo Platform SAS
	</div>

	<!-- DISQUS -->
	<div id="disqus_thread"></div>
	<script type="text/javascript">
		var disqus_shortname = 'docswebsite'; // required: replace example with your forum shortname
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

</xsl:template>


	<!-- ==================================================================== -->

	<xsl:template match="programlisting">
    
    <xsl:variable name="language">
      <xsl:value-of select="s:toUpperCase(string(@language))" xmlns:s="java:java.lang.String"/>
    </xsl:variable>
    
    <xsl:variable name="factory" select="rf:instance()"/>
    <xsl:variable name="hiliter" select="rf:getRenderer($factory, string($language))"/>

    <pre class="{$language}">
    <xsl:choose>
      <xsl:when test="$hiliter">
            <xsl:for-each select="node()">
              <xsl:choose>
                <xsl:when test="self::text()">
                  <xsl:variable name="child.content" select="."/>
          
                  <xsl:value-of select="jhr:highlight($hiliter, $language, string($child.content), 'UTF-8', true())"
            xmlns:jhr="com.uwyn.jhighlight.renderer.Renderer" disable-output-escaping="yes"/>
          </xsl:when>
                <xsl:otherwise>
                  <xsl:variable name="targets" select="key('id', @linkends)"/>
                  <xsl:variable name="target" select="$targets[1]"/>
                  <xsl:choose>
                  <xsl:when test="$target">
                  <a>
                    <xsl:if test="@id or @xml:id">
                      <xsl:attribute name="id">
                        <xsl:value-of select="(@id|@xml:id)[1]"/>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="href">
                      <xsl:call-template name="href.target">
                        <xsl:with-param name="object" select="$target"/>
                      </xsl:call-template>
                    </xsl:attribute>
                  </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="anchor"/>
                  </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </pre>
    
  </xsl:template>
  
  	<!-- ==================================================================== -->
  	
<!-- Remove table number. Remove the navigation label to fix the header, footer navigation display in IE -->
  <xsl:param name="local.l10n.xml" select="document('')"/>
<l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
  <l:l10n language="en">
    <l:context name="title">
      <l:template name="table" text=" "/>
	  <l:template name="example" text="Example: %t"/>
    </l:context>
    <l:gentext key="TableofContents" text=""/>
    <l:context name="xref-number-and-title">
      <l:template name="table" text=" "/>
	  <l:template name="example" text=" "/>     	 
    </l:context>	
	<l:gentext key="nav-home" text=" "/> 
	<l:gentext key="nav-next" text=""/>
	<l:gentext key="nav-prev" text=" "/>
	<l:gentext key="nav-up" text=" "/>
	<l:gentext key="Abstract" text=" "/>
  </l:l10n>
</l:i18n>

<xsl:template match="table" mode="label.markup"/>	

<!--This section override the defaul template of docbook-xsl-->
<xsl:template name="book.titlepage.recto">
  <p xmlns="http://www.w3.org/1999/xhtml">
    <xsl:attribute name="id">
      <xsl:text>title</xsl:text>
    </xsl:attribute>
  </p>
  <xsl:choose>
    <xsl:when test="bookinfo/title">
      <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/title"/>
    </xsl:when>
    <xsl:when test="info/title">
      <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/title"/>
    </xsl:when>
    <xsl:when test="title">
      <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="title"/>
    </xsl:when>
  </xsl:choose>

 
   <!--Remove this template to not display the Gatein logo
 <xsl:choose>
    <xsl:when test="bookinfo/subtitle">
      <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/subtitle"/>
    </xsl:when>
    <xsl:when test="info/subtitle">
      <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/subtitle"/>
    </xsl:when>
    <xsl:when test="subtitle">
      <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="subtitle"/>
    </xsl:when>
  </xsl:choose>
   -->
 
<!-- Remove templates to not display information of author
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/corpauthor"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/corpauthor"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/authorgroup"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/authorgroup"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/author"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/author"/>
-->
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/othercredit"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/othercredit"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/releaseinfo"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/releaseinfo"/>
<!--  Remove copyrights under each chapter title
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/copyright"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/copyright"/> 
-->
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/legalnotice"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/legalnotice"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/pubdate"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/pubdate"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/revision"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/revision"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/revhistory"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/revhistory"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/abstract"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/abstract"/>
</xsl:template>

<!-- Customized display format for FAQs -->

<xsl:template match="question" mode="label.markup">
   <xsl:text>Q</xsl:text>
   <xsl:number level="single" count="qandaentry" format="1"/>
</xsl:template>
	
</xsl:stylesheet>
