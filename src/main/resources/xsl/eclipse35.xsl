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

  <xsl:param name="eclipse.plugin.name">eXo Platform Documentation 3.5</xsl:param>
  <xsl:param name="eclipse.plugin.id">org.exoplatform.doc.35</xsl:param>
  <xsl:param name="eclipse.plugin.provider">eXo Platform</xsl:param>
  
 	<!-- These extensions are required for table printing and other stuff -->
  <xsl:param name="ignore.image.scaling" select="1"/>
  <xsl:param name="tablecolumns.extension" select="0"/>
  <xsl:param name="graphicsize.extension" select="0"/>
  
  <!-- Set chunk.section.depth to 0 to just chunk chapters. -->
  <xsl:param name="chunk.section.depth" select="1"/>
  <xsl:param name="chunk.first.sections" select="1"/>
  
  <!-- turn off a TOC -->
  <xsl:param name="generate.toc">
		/appendix nop
		article/appendix  nop
		/article  toc,title
		book      toc,title, <!-- Remove list of tables, figures, examples -->
		/chapter  nop
		part      nop
		/preface  toc,title
		reference toc,title
		/sect1    nop
		/sect2    nop
		/sect3    nop
		/sect4    nop
		/sect5    nop
		/section  nop
		set       toc,title
	</xsl:param>
 
  
  <!-- ==================================================================== -->
  
  <!-- From: xhtml/chunk-common.xsl 
  	Redefine a new template for the header navigation
  -->
  <xsl:template name="header.navigation">
  <xsl:param name="prev" select="/foo"/>
  <xsl:param name="next" select="/foo"/>
  <xsl:param name="nav.context"/>

  <xsl:variable name="home" select="/*[1]"/>
  <xsl:variable name="up" select="parent::*"/>

  <xsl:variable name="row1" select="$navig.showtitles != 0"/>
  <xsl:variable name="row2" select="count($prev) &gt; 0                                     or (count($up) &gt; 0                                          and generate-id($up) != generate-id($home)                                         and $navig.showtitles != 0)                                     or count($next) &gt; 0"/>

  <xsl:if test="$suppress.navigation = '0' and $suppress.header.navigation = '0'">
    <ul class="docnav">
      <xsl:if test="$row2">
      
      	<!-- PREVIOUS -->
				<xsl:if test="count($prev)&gt;0">
					<li class="previous">
          	<a accesskey="p">
		          <xsl:attribute name="href">
		          	<xsl:call-template name="href.target">
		            	<xsl:with-param name="object" select="$prev"/>
		            </xsl:call-template>
		           </xsl:attribute>
		           <xsl:call-template name="navig.content">
		           	<xsl:with-param name="direction" select="'prev'"/>
		           </xsl:call-template>
             </a>
           </li>
        </xsl:if>
				
				
				<!-- TITLE -->
				<li class="title">
						<xsl:apply-templates select="$up" mode="object.title.markup"/>
          	<!--xsl:when test="count($up) &gt; 0                                   and generate-id($up) != generate-id($home)                                   and $navig.showtitles != 0">
            	<xsl:apply-templates select="$up" mode="object.title.markup"/>
            </xsl:when>
            <xsl:otherwise>&#160;</xsl:otherwise-->
        </li>
        
        <!-- NEXT -->
				<xsl:if test="count($next)&gt;0">
					<li class="next">
		      	<a accesskey="n">
		        	<xsl:attribute name="href">
				        <xsl:call-template name="href.target">
				        	<xsl:with-param name="object" select="$next"/>
				        </xsl:call-template>
		          </xsl:attribute>
		          <xsl:call-template name="navig.content">
		          	<xsl:with-param name="direction" select="'next'"/>
		         	</xsl:call-template>
		        </a>
        	</li>
        </xsl:if>
   		</xsl:if>
   	</ul>
   </xsl:if>
	</xsl:template>
	
	<!-- ==================================================================== -->
	
	<!-- From: xhtml/chunk-common.xsl 
  	Redefine a new template for the footer navigation
  -->
  
  <xsl:template name="footer.navigation">
  <xsl:param name="prev" select="/foo"/>
  <xsl:param name="next" select="/foo"/>
  <xsl:param name="nav.context"/>

  <xsl:variable name="home" select="/*[1]"/>
  <xsl:variable name="up" select="parent::*"/>

  <xsl:variable name="row1" select="count($prev) &gt; 0                                     or count($up) &gt; 0                                     or count($next) &gt; 0"/>

  <xsl:variable name="row2" select="($prev and $navig.showtitles != 0)                                     or (generate-id($home) != generate-id(.)                                         or $nav.context = 'toc')                                     or ($chunk.tocs.and.lots != 0                                         and $nav.context != 'toc')                                     or ($next and $navig.showtitles != 0)"/>

  <xsl:if test="$suppress.navigation = '0' and $suppress.footer.navigation = '0'">
    
		<xsl:if test="$row1 or $row2">
		
		<!-- 1ST LINE -->
     <ul class="docnav">
        <xsl:if test="$row1">

          <!-- PREVIOUS -->
						<xsl:if test="count($prev)&gt;0">
							<li class="previous">
						   <a accesskey="p">
								  <xsl:attribute name="href">
								   <xsl:call-template name="href.target">
								     <xsl:with-param name="object" select="$prev"/>
								    </xsl:call-template>
								   </xsl:attribute>
								   <xsl:call-template name="navig.content">
								    <xsl:with-param name="direction" select="'prev'"/>
								   </xsl:call-template>
						     </a>
							</li>
						</xsl:if>
							
					<!-- UP -->
					<xsl:if test="count($up)&gt;0 and generate-id($up) != generate-id($home)">
						<li class="up">
                <a accesskey="u">
                  <xsl:attribute name="href">
                    <xsl:call-template name="href.target">
                      <xsl:with-param name="object" select="$up"/>
                    </xsl:call-template>
                  </xsl:attribute>
                  <xsl:call-template name="navig.content">
                    <xsl:with-param name="direction" select="'up'"/>
                  </xsl:call-template>
               </a>
						</li>
					</xsl:if>
					
					<!-- HOME -->
					<xsl:if test="$home != .">
						<li class="home">
							<xsl:choose>
                  <xsl:when test="$home != . or $nav.context = 'toc'">
                    <a accesskey="h">
                      <xsl:attribute name="href">
                        <xsl:call-template name="href.target">
                          <xsl:with-param name="object" select="$home"/>
                        </xsl:call-template>
                      </xsl:attribute>
                      <xsl:call-template name="navig.content">
                        <xsl:with-param name="direction" select="'home'"/>
                      </xsl:call-template>
                    </a>
                    <xsl:if test="$chunk.tocs.and.lots != 0 and $nav.context != 'toc'">
                      <xsl:text>&#160;|&#160;</xsl:text>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>&#160;</xsl:otherwise>
                </xsl:choose>

                <xsl:if test="$chunk.tocs.and.lots != 0 and $nav.context != 'toc'">
                  <a accesskey="t">
                    <xsl:attribute name="href">
                      <xsl:apply-templates select="/*[1]" mode="recursive-chunk-filename">
                        <xsl:with-param name="recursive" select="true()"/>
                      </xsl:apply-templates>
                      <xsl:text>-toc</xsl:text>
                      <xsl:value-of select="$html.ext"/>
                    </xsl:attribute>
                    <xsl:call-template name="gentext">
                      <xsl:with-param name="key" select="'nav-toc'"/>
                    </xsl:call-template>
                  </a>
                </xsl:if>
						</li>
					</xsl:if>
					
					<!-- NEXT -->
		      <xsl:if test="count($next)&gt;0">
		      	<li class="next">
		        	<a accesskey="n">
		          	<xsl:attribute name="href">
		            	<xsl:call-template name="href.target">
		              	<xsl:with-param name="object" select="$next"/>
		               </xsl:call-template>
		             </xsl:attribute>
		             	<xsl:call-template name="navig.content">
		              	<xsl:with-param name="direction" select="'next'"/>
		             	</xsl:call-template>
		          </a>
         		</li>
         	</xsl:if>
         	
        </xsl:if>
			</ul>
			
			<!-- 2ND LINE -->
			<ul class="docnavtitle">
          <xsl:if test="$row2">
            <li class="titlefooterprev">
                <xsl:if test="$navig.showtitles != 0">
                  <xsl:apply-templates select="$prev" mode="object.title.markup"/>
                </xsl:if>
            </li>
              
            <li class="titlefooternext">
                <xsl:if test="$navig.showtitles != 0">
                  <xsl:apply-templates select="$next" mode="object.title.markup"/>
                </xsl:if>
            </li>
          </xsl:if>
        </ul>
      </xsl:if>
  </xsl:if>
  
  <!-- FOOTER IN EVERY PAGES -->
  	<div class="UIFooterPageDocument">
			Copyright ©2012. All rights reserved. eXo Platform SAS
		</div>

</xsl:template>


	<!-- ==================================================================== -->
	<!--
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
  -->
  	<!-- ==================================================================== -->
  	
<!-- Remove table number -->
  <xsl:param name="local.l10n.xml" select="document('')"/>
<l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
  <l:l10n language="en">
    <l:context name="title">
      <l:template name="table" text=" "/>
    </l:context>
    <l:context name="xref-number-and-title">
      <l:template name="table" text=" "/>
    </l:context>
  </l:l10n>
</l:i18n>

<xsl:template match="table" mode="label.markup"/>	
	
</xsl:stylesheet>
