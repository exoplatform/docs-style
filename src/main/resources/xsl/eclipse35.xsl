<?xml version='1.0'?>

<!--
  Copyright 2008 JBoss, a division of Red Hat
  License: LGPL
  Author: Mark Newton <mark.newton@jboss.org>
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="http://docbook.sourceforge.net/release/xsl/1.76.1/eclipse/eclipse3.xsl"/>

  <xsl:param name="eclipse.plugin.name">eXo Platform Documentation 3.5</xsl:param>
  <xsl:param name="eclipse.plugin.id">org.exoplatform.doc.35</xsl:param>
  <xsl:param name="eclipse.plugin.provider">eXo Platform</xsl:param>
  
  
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
      	<li class="previous">
					<xsl:if test="count($prev)&gt;0">
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
           </xsl:if>
				</li>
				
				<!-- TITLE -->
				<li class="title">
					<xsl:choose>
          	<xsl:when test="count($up) &gt; 0                                   and generate-id($up) != generate-id($home)                                   and $navig.showtitles != 0">
            	<xsl:apply-templates select="$up" mode="object.title.markup"/>
            </xsl:when>
            <xsl:otherwise>&#160;</xsl:otherwise>
          </xsl:choose>
        </li>
        
        <!-- NEXT -->
        <li class="next">
					<xsl:if test="count($next)&gt;0">
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
		      </xsl:if>
        </li>
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
					<li class="previous">
						<xsl:if test="count($prev)&gt;0">
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
						   </xsl:if>
					</li>
							
					<!-- UP -->
					<li class="up">
						<xsl:choose>
                <xsl:when test="count($up)&gt;0                                   and generate-id($up) != generate-id($home)">
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
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
					</li>
					
					<!-- HOME -->
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
					
							
					<!-- NEXT -->
					<li class="next">
		      	<xsl:if test="count($next)&gt;0">
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
		      		</xsl:if>
         </li>
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
</xsl:template>


	<!-- ==================================================================== -->
  
</xsl:stylesheet>
