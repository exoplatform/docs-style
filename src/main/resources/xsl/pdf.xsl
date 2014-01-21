<?xml version='1.0'?>

<!DOCTYPE xsl:stylesheet [
<!ENTITY lowercase "'abcdefghijklmnopqrstuvwxyz'">
<!ENTITY uppercase "'ABCDEFGHIJKLMNOPQRSTUVWXYZ'">
 ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
				xmlns="http://www.w3.org/TR/xhtml1/transitional"
				xmlns:fo="http://www.w3.org/1999/XSL/Format"
				xmlns:jbh="java:org.jboss.highlight.renderer.FORenderer"
				exclude-result-prefixes="jbh">
   
<!--###################################################
		Importing XSL pages
#######################################################-->

	<xsl:import href="http://docbook.sourceforge.net/release/xsl/1.76.1/fo/docbook.xsl" />
	<xsl:import href="common.xsl" />
   
<!--###################################################
		Pager and page
#######################################################-->
	  
	<!-- Paper type -->
	<xsl:param name="paper.type" select="'A4'" />
	
	<!-- Space between paper border and content. WARNING: Should not change this! -->
	<xsl:param name="page.margin.top">10mm</xsl:param>
	<xsl:param name="region.before.extent">10mm</xsl:param>
	<xsl:param name="body.margin.top">12mm</xsl:param>
	<xsl:param name="body.margin.bottom">15mm</xsl:param>
	<xsl:param name="region.after.extent">10mm</xsl:param>
	<xsl:param name="page.margin.bottom">9mm</xsl:param>
	<xsl:param name="page.margin.outer">19.5mm</xsl:param>
	<xsl:param name="page.margin.inner">19.5mm</xsl:param>
	
<!--###################################################
		 Titlepage
#######################################################-->

	<!-- Hiding copyright, edited by -->
	<xsl:template name="book.titlepage.recto">
		<xsl:choose>
			<xsl:when test="bookinfo/title">
				<xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/title" />
			</xsl:when>
			<xsl:when test="info/title">
				<xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/title" />
			</xsl:when>
			<xsl:when test="title">
				<xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="title" />
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- Hiding duplicated book title, written by and copyright -->
	<xsl:template name="book.titlepage.verso">
		<xsl:choose>
			<xsl:when test="bookinfo/abstract">
				<xsl:apply-templates mode="titlepage.mode" select="bookinfo/abstract"/>
			</xsl:when>
			<xsl:when test="info/abstract">
				<xsl:apply-templates mode="titlepage.mode" select="info/abstract"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- Showing Book icon and properties of book title -->
	<xsl:template match="title" mode="book.titlepage.recto.auto.mode">
		<fo:block keep-with-next.within-column="always" hyphenate="false">
			<fo:table table-layout="fixed" padding-bottom="5pt">
				<fo:table-column column-number="1" column-width="8%"/>
				<fo:table-column column-number="2" column-width="92%"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell>
							<fo:block>
								<fo:external-graphic src="http://docs.exoplatform.com/public/content/org.exoplatform.doc.style/background/guide.png"
													 padding-left="1pt" width="27px" content-width="scale-to-fit"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell>
							<fo:block xsl:use-attribute-sets="book.titlepage.recto.style"
									  text-align="left"
									  font-size="25px"
									  font-weight="bold"
									  color="#285A92"
									  padding-bottom="4px"
									  font-family="{$title.font.family}">
								<xsl:call-template name="division.title">
									<xsl:with-param name="node" select="ancestor-or-self::book[1]"/>
								</xsl:call-template>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
			<fo:block border-bottom="0.5pt dotted #CFCFCF"/>
			<fo:block padding-bottom="10px"/>
		</fo:block>	
	</xsl:template>
	
	<!-- Preventing blank pages between book title and book abstract -->
    <xsl:template name="book.titlepage.before.verso"></xsl:template>
	
<!--###################################################
		 Table Of Contents (so-called TOC)
###################################################-->

	<!-- Generating TOC -->
	<xsl:param name="generate.toc">set toc book toc</xsl:param>
	
	<!-- Including section levels in TOC: Chapter X, Section levels 1 and 2 (X.1 and X.1.x) -->
	<xsl:param name="toc.section.depth">2</xsl:param>
	
	<!-- Style of elements in the TOC page -->
	<xsl:template name="toc.line">
		<xsl:variable name="id">
			<xsl:call-template name="object.id" />
		</xsl:variable>
		<xsl:variable name="label">
			<xsl:apply-templates select="." mode="label.markup" />
		</xsl:variable>
		<fo:block text-align-last="justify" end-indent="{$toc.indent.width}pt"
				  last-line-end-indent="-{$toc.indent.width}pt">
			<fo:inline keep-with-next.within-line="always">
				<fo:basic-link internal-destination="{$id}">
					<!-- Bolding chapter titles -->
					<xsl:choose>
						<xsl:when test="local-name(.) = 'chapter'">
							<xsl:attribute name="font-weight">bold</xsl:attribute>
						</xsl:when>
					</xsl:choose>
					<xsl:if test="$label != ''">
						<xsl:copy-of select="$label" />
						<xsl:value-of select="$autotoc.label.separator" />
					</xsl:if>
					<xsl:apply-templates select="." mode="titleabbrev.markup" />
				</fo:basic-link>
			</fo:inline>
			<fo:inline keep-together.within-line="always">
				<xsl:text> </xsl:text>
				<fo:leader leader-pattern="dots" leader-pattern-width="3pt"
						   leader-alignment="reference-area" keep-with-next.within-line="always" />
				<xsl:text> </xsl:text>
				<fo:basic-link internal-destination="{$id}">
					<fo:page-number-citation ref-id="{$id}" />
				</fo:basic-link>
			</fo:inline>
		</fo:block>
	</xsl:template>
   
<!--###################################################
		 Fonts, Styles & Space
#######################################################-->

	<!-- Line height -->
	<xsl:param name="line-height" select="1.5" />
	
	<!-- Left alignment -->
    <xsl:param name="alignment">left</xsl:param>
    <xsl:param name="hyphenate">true</xsl:param>
	
	<!-- Default font size -->
    <xsl:param name="body.font.master">11</xsl:param>
    <xsl:param name="body.font.small">8</xsl:param>
	
	<!-- Font types -->
	<xsl:template name="pickfont-sans">
      <xsl:variable name="font">
         <xsl:choose>
            <xsl:when test="$l10n.gentext.language = 'ja-JP'">
               <xsl:text>KochiMincho,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'ko-KR'">
               <xsl:text>BaekmukBatang,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'zh-CN'">
               <xsl:text>ARPLKaitiMGB,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'bn-IN'">
               <xsl:text>LohitBengali,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'ta-IN'">
               <xsl:text>LohitTamil,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'pa-IN'">
               <xsl:text>LohitPunjabi,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'hi-IN'">
               <xsl:text>LohitHindi,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'gu-IN'">
               <xsl:text>LohitGujarati,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'zh-TW'">
               <xsl:text>ARPLMingti2LBig5,</xsl:text>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="$fop1.extensions != 0">
            <xsl:copy-of select="$font" />
            <xsl:text>DejaVuLGCSans,sans-serif</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="$font" />
            <xsl:text>sans-serif</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template name="pickfont-serif">
      <xsl:variable name="font">
         <xsl:choose>
            <xsl:when test="$l10n.gentext.language = 'ja-JP'">
               <xsl:text>KochiMincho,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'ko-KR'">
               <xsl:text>BaekmukBatang,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'zh-CN'">
               <xsl:text>ARPLKaitiMGB,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'bn-IN'">
               <xsl:text>LohitBengali,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'ta-IN'">
               <xsl:text>LohitTamil,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'pa-IN'">
               <xsl:text>LohitPunjabi,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'hi-IN'">
               <xsl:text>LohitHindi,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'gu-IN'">
               <xsl:text>LohitGujarati,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'zh-TW'">
               <xsl:text>ARPLMingti2LBig5,</xsl:text>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="$fop1.extensions != 0">
            <xsl:copy-of select="$font" />
            <xsl:text>DejaVuLGCSans,serif</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="$font" />
            <xsl:text>serif</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template name="pickfont-mono">
      <xsl:variable name="font">
         <xsl:choose>
            <xsl:when test="$l10n.gentext.language = 'ja-JP'">
               <xsl:text>KochiMincho,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'ko-KR'">
               <xsl:text>BaekmukBatang,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'zh-CN'">
               <xsl:text>ARPLKaitiMGB,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'bn-IN'">
               <xsl:text>LohitBengali,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'ta-IN'">
               <xsl:text>LohitTamil,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'pa-IN'">
               <xsl:text>LohitPunjabi,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'hi-IN'">
               <xsl:text>LohitHindi,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'gu-IN'">
               <xsl:text>LohitGujarati,</xsl:text>
            </xsl:when>
            <xsl:when test="$l10n.gentext.language = 'zh-TW'">
               <xsl:text>ARPLMingti2LBig5,</xsl:text>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="$fop1.extensions != 0">
            <xsl:copy-of select="$font" />
            <xsl:text>DejaVuLGCSans,monospace</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="$font" />
            <xsl:text>monospace</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:param name="title.font.family">
	  <xsl:call-template name="pickfont-sans" />
   </xsl:param>

   <xsl:param name="body.font.family">
      <xsl:call-template name="pickfont-sans" />
   </xsl:param>

   <xsl:param name="monospace.font.family">
      <xsl:call-template name="pickfont-mono" />
   </xsl:param>

   <xsl:param name="sans.font.family">
      <xsl:call-template name="pickfont-sans" />
   </xsl:param>
   
	<!-- Monospaced fonts are smaller than regular text -->
	<xsl:attribute-set name="monospace.properties">
		<xsl:attribute name="font-size">9pt</xsl:attribute>
		<xsl:attribute name="font-family">
			<xsl:value-of select="$monospace.font.family" />
		</xsl:attribute>
	</xsl:attribute-set>
	<xsl:param name="body.font.size" select="'75%'" />
	<xsl:param name="chapter.title.font.size" select="'60%'" /> 
	<xsl:param name="section.title.font.size" select="'60%'" /> 
	<xsl:param name="title.font.size" select="'60%'" />
	
	<!-- Space around paragraphs -->
	<xsl:attribute-set name="normal.para.spacing">
		<xsl:attribute name="space-before.minimum">2mm</xsl:attribute>
		<xsl:attribute name="space-before.optimum">2mm</xsl:attribute>
		<xsl:attribute name="space-before.maximum">2mm</xsl:attribute>
	</xsl:attribute-set>
	
<!--###################################################
		 Header
#######################################################-->

	<!-- Defining which content is displayed in header -->
	<xsl:template name="header.content">
		<xsl:param name="pageclass" select="''" />
		<xsl:param name="sequence" select="''" />
		<xsl:param name="position" select="''" />
		<xsl:param name="gentext-key" select="''" />
		<xsl:choose>
			<xsl:when test="$sequence = 'blank'"></xsl:when>
			<!-- Extracting 'Chapter' + Chapter Number from the full Chapter title, with a dirty, dirty hack -->
			<xsl:when test="($position='left' and $gentext-key='chapter')">
				<xsl:variable name="text">
					<xsl:call-template name="component.title.nomarkup" />
				</xsl:variable>
				<xsl:variable name="chapt">
					<xsl:value-of select="substring-before($text, '&#xA0;')" />
				</xsl:variable>
				<xsl:variable name="remainder">
					<xsl:value-of select="substring-after($text, '&#xA0;')" />
				</xsl:variable>
				<xsl:variable name="chapt-num">
					<xsl:value-of select="substring-before($remainder, '&#xA0;')" />
				</xsl:variable>
				<xsl:variable name="text1">
					<xsl:value-of select="concat(substring($text, 0), '')"  />
				</xsl:variable>
				<fo:inline keep-together.within-line="always" font-weight="bold" color="#285A92" font-size="9pt">
					<xsl:value-of select="$text1" />
				</fo:inline>
			</xsl:when>
			<xsl:when test="($sequence='even' and $position='left')">
				<xsl:variable name="text">
				   <xsl:call-template name="component.title.nomarkup" />
				</xsl:variable>
				<fo:inline keep-together.within-line="always" font-weight="bold" color="#285A92" font-size="9pt">
				   <xsl:choose>
					  <xsl:when test="string-length($text) &gt; '33'">
						 <xsl:value-of select="concat(substring($text, 0), '')" />
					  </xsl:when>
					  <xsl:otherwise>
						 <xsl:value-of select="$text" />
					  </xsl:otherwise>
				   </xsl:choose>
				</fo:inline>
			</xsl:when>
			<xsl:when test="($sequence='odd' and $position='right')">
				<fo:inline keep-together.within-line="always" color="#285A92" font-size="9pt">
				   <fo:retrieve-marker retrieve-class-name="section.head.marker"
									   retrieve-position="first-including-carryover"
									   retrieve-boundary="page-sequence" />
				</fo:inline>
			</xsl:when>
			<xsl:when test="($position='right')">
				<fo:inline keep-together.within-line="always" color="#285A92" font-size="9pt" font-style="italic">
				 eXo Platform 4.0
				</fo:inline>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- Properties of bottom border of header -->
	<xsl:template name="head.sep.rule">
		<xsl:param name="pageclass" />
		<xsl:param name="sequence" />
		<xsl:param name="gentext-key" />
		<xsl:if test="$header.rule != 0">
			<xsl:attribute name="border-bottom-width">1pt</xsl:attribute>
			<xsl:attribute name="border-bottom-style">solid</xsl:attribute>
			<xsl:attribute name="border-bottom-color">#285A92</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<!-- Column width for header & footer -->
	<xsl:param name="header.column.widths" select="'1 0 1'" />
	<xsl:param name="header.rule" select="1" />

<!--###################################################
		 Footer
#######################################################-->

    <!-- Inserting copyright text to footer -->
	<xsl:template name="footer.content">
		<xsl:param name="pageclass" select="''"/>
		<xsl:param name="sequence" select="''"/>
		<xsl:param name="position" select="''"/>
		<fo:block>  
			<xsl:choose>
				<xsl:when test="$pageclass = 'titlepage'">
					<!-- No footer on title pages -->
				</xsl:when>
				<xsl:when test="$position = 'left'">
					<xsl:apply-templates select="//copyright[1]" mode="titlepage.mode"/>
				</xsl:when>
				<xsl:when test="$position = 'right'">
					<xsl:apply-templates select="." mode="titleabbrev.markup"/>
				</xsl:when>
				<xsl:when test="$position = 'center'">
					p.<fo:page-number/>
				</xsl:when>
				<xsl:when test="$sequence = 'blank'">
				</xsl:when>
				<xsl:when test="$sequence = 'odd'">
				</xsl:when>
				<xsl:when test="$sequence = 'even'">
				</xsl:when>
			</xsl:choose>
		</fo:block>
	</xsl:template>
	
    <!-- Text in footers -->
	<xsl:attribute-set name="footer.content.properties">
		<xsl:attribute name="font-style">italic</xsl:attribute>
		<xsl:attribute name="font-size">8pt</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- Properties of bottom border of footer -->
	<xsl:template name="foot.sep.rule">
		<xsl:param name="pageclass" />
		<xsl:param name="sequence" />
		<xsl:param name="gentext-key" />
		<xsl:if test="$footer.rule != 0">
			<xsl:attribute name="border-top-width">0.5pt</xsl:attribute>
			<xsl:attribute name="border-top-style">solid</xsl:attribute>
			<xsl:attribute name="border-top-color">#285A92</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
<!--###################################################
		   Footnote
#######################################################-->

	<xsl:param name="footnote.font.size">
		<xsl:value-of select="$body.font.master * 0.8" />
		<xsl:text>pt</xsl:text>
	</xsl:param>
	<xsl:param name="footnote.number.format" select="'1'" />
	<xsl:param name="footnote.number.symbols" select="''" />
	<xsl:attribute-set name="footnote.mark.properties">
		<xsl:attribute name="font-size">75%</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="font-style">normal</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="footnote.properties">
		<xsl:attribute name="padding-top">48pt</xsl:attribute>
		<xsl:attribute name="font-family">
			<xsl:value-of select="$body.fontset" />
		</xsl:attribute>
		<xsl:attribute name="font-size">
			<xsl:value-of select="$footnote.font.size" />
		</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="font-style">normal</xsl:attribute>
		<xsl:attribute name="text-align">
			<xsl:value-of select="$alignment" />
		</xsl:attribute>
		<xsl:attribute name="start-indent">0pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="footnote.sep.leader.properties">
		<xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="leader-pattern">rule</xsl:attribute>
		<xsl:attribute name="leader-length">1in</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- Column width for footer -->
	<xsl:param name="footer.column.widths" select="'1 1 1'" />
	
<!--###################################################
          Labels
#######################################################-->

	<!-- Label chapters, sections and qandadiv (numbering) -->
	<xsl:param name="chapter.autolabel" select="1"/>
	<xsl:param name="section.autolabel" select="1"/>
	<xsl:param name="qandadiv.autolabel" select="0" />
	<xsl:param name="section.label.includes.component.label" select="1"/>
	
	<!-- Autolabel levels of sections -->
	<xsl:param name="section.autolabel.max.depth">4</xsl:param>
	
<!--###################################################
		 Titles
#######################################################-->

    <!-- Color commonly used for titles -->
	<xsl:param name="title.color">#444444</xsl:param>
	
	<!-- No indentation of titles -->
	<xsl:param name="body.start.indent">0pt</xsl:param>
	
	<!--- Properties of chapter titles -->
	<xsl:attribute-set name="chapter.titlepage.recto.style">
		<xsl:attribute name="color">
			<xsl:value-of select="$title.color"/>
		</xsl:attribute>
		<xsl:attribute name="font-size">30px</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="text-align">left</xsl:attribute>
		<xsl:attribute name="border-bottom">1px dotted #CFCFCF</xsl:attribute>
		<xsl:attribute name="padding-bottom">5px</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- Properties of simplesect titles -->
	<xsl:template match="title" mode="simplesect.titlepage.recto.auto.mode">
		<xsl:param name="content">
			<xsl:call-template name="inline.boldseq">
				<xsl:with-param name="content">
					<xsl:apply-templates/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:param>
		<fo:block border-bottom="1px none" color="#444444" font-size="$body.font.master * 1pt" font-weight="bold" 
				  padding-bottom="2.8px" padding-top="1.2px">
			<xsl:copy-of select="$content"/>
		</fo:block>
	</xsl:template>
	
	<!-- Common properties used for all section titles at all levels -->
	<xsl:attribute-set name="section.title.properties">
		<xsl:attribute name="font-family">
			<xsl:value-of select="$title.font.family" />
		</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="color">
			<xsl:value-of select="$title.color" />
		</xsl:attribute>
		
		<!-- Font size is calculated dynamically by section.heading template -->
		<xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
		<xsl:attribute name="space-before.minimum">0.8em</xsl:attribute>
		<xsl:attribute name="space-before.optimum">1.0em</xsl:attribute>
		<xsl:attribute name="space-before.maximum">1.2em</xsl:attribute>
		<xsl:attribute name="text-align">left</xsl:attribute>
		<xsl:attribute name="start-indent">
			<xsl:value-of select="$title.margin.left" />
		</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- Properties of section2 -->
	<xsl:attribute-set name="section.title.level1.properties">  
		<xsl:attribute name="font-size">
			<xsl:value-of select="$body.font.master * 1.6" />
			<xsl:text>pt</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="border-bottom">1px dotted #CFCFCF</xsl:attribute>
	</xsl:attribute-set>
	
    <!-- Properties of section3 -->
	<xsl:attribute-set name="section.title.level2.properties">
		<xsl:attribute name="font-size">
			<xsl:value-of select="$body.font.master * 1.4" />
			<xsl:text>pt</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="border-bottom">1px dotted #CFCFCF</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- Properties of section4 -->
	<xsl:attribute-set name="section.title.level3.properties">
		<xsl:attribute name="font-size">
			<xsl:value-of select="$body.font.master * 1.3" />
			<xsl:text>pt</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="border-bottom">1px dotted #CFCFCF</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- Properties of section5 -->
	<xsl:attribute-set name="section.title.level4.properties">
		<xsl:attribute name="font-size">
			<xsl:value-of select="$body.font.master * 1.2" />
			<xsl:text>pt</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="border-bottom">1px dotted #CFCFCF</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- Properties of section6 -->
	<xsl:attribute-set name="section.title.level5.properties">
		<xsl:attribute name="font-size">
			<xsl:value-of select="$body.font.master * 1.1" />
			<xsl:text>pt</xsl:text>
		</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- Properties of section7 -->
	<xsl:attribute-set name="section.title.level6.properties">
		<xsl:attribute name="font-size">
			<xsl:value-of select="$body.font.master" />
			<xsl:text>pt</xsl:text>
		</xsl:attribute>
	</xsl:attribute-set>
   
<!--###################################################
		  Listitems
#######################################################-->

	<!-- Format variable lists as blocks (prevents horizontal overflow) -->
	<xsl:param name="variablelist.as.blocks">1</xsl:param>

	<!-- Indentation and space of listitems -->
	<xsl:attribute-set name="list.block.spacing">
		<xsl:attribute name="margin-left">
			<xsl:choose>
				<xsl:when test="self::itemizedlist">1em</xsl:when>
				<xsl:otherwise>0pt</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="space-before.optimum">0.75em</xsl:attribute>
		<xsl:attribute name="space-before.minimum">0.70em</xsl:attribute>
		<xsl:attribute name="space-before.maximum">0.80em</xsl:attribute>
		<xsl:attribute name="space-after.optimum">0.75em</xsl:attribute>
		<xsl:attribute name="space-after.minimum">0.70em</xsl:attribute>
		<xsl:attribute name="space-after.maximum">0.80em</xsl:attribute>
	</xsl:attribute-set>

    <!-- Space around individual listitems in the list -->
	<xsl:attribute-set name="list.item.spacing">
		<xsl:attribute name="space-before.optimum">0.40em</xsl:attribute>
		<xsl:attribute name="space-before.minimum">0.40em</xsl:attribute>
		<xsl:attribute name="space-before.maximum">0.40em</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- Listitem in abstracts and highlights -->
	<xsl:template match="abstract/itemizedlist/listitem | abstract/itemizedlist//itemizedlist/listitem | highlights/itemizedlist/listitem | highlights/itemizedlist//itemizedlist/listitem">
		<fo:list-item margin-top="0.1cm">
			<fo:list-item-label end-indent="label-end()">
				<fo:block>
					<fo:external-graphic src="http://docs.exoplatform.com/public/content/org.exoplatform.doc.style/background/list-arrow-right.png" width="5px" content-width="scale-to-fit"/>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:apply-templates />
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	
	<!-- Listitem in sections and simplesects -->
	<xsl:template match="section/itemizedlist//itemizedlist/listitem | simplesect/itemizedlist//itemizedlist/listitem">
		<xsl:variable name="id">
			<xsl:call-template name="object.id"/>
		</xsl:variable>
		<xsl:variable name="itemsymbol">
			<xsl:call-template name="list.itemsymbol">
				<xsl:with-param name="node" select="parent::itemizedlist"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="item.contents">
			<fo:list-item-label end-indent="label-end()">
				<fo:block font-size="7.5pt" font-weight="bold">
					<xsl:choose>
						<xsl:when test="$itemsymbol='circle'">o</xsl:when>
						<xsl:otherwise>o</xsl:otherwise>
					</xsl:choose>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<xsl:apply-templates/> 
			</fo:list-item-body>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="parent::*/@spacing = 'compact'">
				<fo:list-item id="{$id}" xsl:use-attribute-sets="compact.list.item.spacing">
					<xsl:copy-of select="$item.contents"/>
				</fo:list-item>
			</xsl:when>
			<xsl:otherwise>
				<fo:list-item id="{$id}" xsl:use-attribute-sets="list.item.spacing">
					<xsl:copy-of select="$item.contents"/>
				</fo:list-item>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Size of listitem -->
	<xsl:attribute-set name="itemizedlist.label.properties">
		<xsl:attribute name="font-size">
			<xsl:value-of select="$body.font.master * 1.23" />
			<xsl:text>pt</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="margin-top">0.08cm</xsl:attribute>
	</xsl:attribute-set>
	
<!--###################################################
		  Tables
#######################################################-->

	<!-- Alternate colors for table rows -->
	<xsl:template name="table.row.properties">
		<xsl:variable name="rownum">
			<xsl:number from="tgroup" count="row"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$rownum mod 2 = 0">
				<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
			</xsl:when>
			<xsl:when test="$rownum mod 2 = 1">
				<xsl:attribute name="background-color">#F9F9F9</xsl:attribute>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
    <!-- Padding inside tables -->
	<xsl:attribute-set name="table.cell.padding">
		<xsl:attribute name="keep-together.within-column">auto</xsl:attribute>
		<xsl:attribute name="padding-left">4pt</xsl:attribute>
		<xsl:attribute name="padding-right">4pt</xsl:attribute>
		<xsl:attribute name="padding-top">2pt</xsl:attribute>
		<xsl:attribute name="padding-bottom">2pt</xsl:attribute>
	</xsl:attribute-set>
   
	<!-- Text alignment of header titles and table borders--> 
	<xsl:template name="table.cell.properties"> 
		<xsl:if test="ancestor::thead or ancestor::tfoot">	
			<xsl:attribute name="background-color">#F0F0F0</xsl:attribute>	
			<xsl:attribute name="text-align">left</xsl:attribute>
		</xsl:if>
		<xsl:attribute name="border-style">solid</xsl:attribute>
		<xsl:attribute name="border-width">0.75px</xsl:attribute>
		<xsl:attribute name="border-color">#CFCFCF</xsl:attribute>          		
	</xsl:template>
	
	<!-- Removing Table Heading-->
	<xsl:template name="table.block">
		<xsl:param name="table.layout" select="NOTANODE"/>
		<xsl:variable name="id">
			<xsl:call-template name="object.id"/>
		</xsl:variable>
		<xsl:variable name="keep.together"></xsl:variable>
		<xsl:choose>
			<xsl:when test="self::table">
				<fo:block id="{$id}" xsl:use-attribute-sets="table.properties">
					<xsl:if test="$keep.together != ''">
						<xsl:attribute name="keep-together.within-column">auto</xsl:attribute>
					</xsl:if>
					<xsl:copy-of select="$table.layout"/>
					<xsl:call-template name="table.footnote.block"/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block id="{$id}" xsl:use-attribute-sets="informaltable.properties">
					<xsl:copy-of select="$table.layout"/>
					<xsl:call-template name="table.footnote.block"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
<!--###################################################
		  Programlistings & verbatim elements
#######################################################-->

	<!-- Font type of programlisting -->
	<xsl:param name="programlisting.font" select="'verdana,helvetica,sans-serif'" />

	<!-- Font size of programlisting -->
	<xsl:param name="programlisting.font.size" select="'80%'" />
	
	<!-- Properties of monospace verbatim -->
	<xsl:attribute-set name="monospace.verbatim.properties" use-attribute-sets="verbatim.properties monospace.properties">
		<xsl:attribute name="text-align">start</xsl:attribute>
		<xsl:attribute name="wrap-option">wrap</xsl:attribute>
		<xsl:attribute name="hyphenation-character">&#x25BA;</xsl:attribute>
	</xsl:attribute-set>
	<xsl:param name="hyphenate.verbatim.characters">&#x25BA;</xsl:param>
	
	<!-- Properties of shade verbatim -->
	<xsl:param name="shade.verbatim" select="1" />
	<xsl:attribute-set name="shade.verbatim.style">
		<xsl:attribute name="wrap-option">wrap</xsl:attribute>
		<xsl:attribute name="background-color">
			<xsl:choose>
				<xsl:when test="ancestor::note"> <xsl:text>red</xsl:text> </xsl:when>
				<xsl:when test="ancestor::warning"> <xsl:text>#7B1E1E</xsl:text> </xsl:when>
				<xsl:when test="ancestor::tip"> <xsl:text>#7E917F</xsl:text> </xsl:when>
				<xsl:otherwise>
					<xsl:text>black</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="color">
			<xsl:choose>
				<xsl:when test="ancestor::note"> <xsl:text>red</xsl:text> </xsl:when>
				<xsl:when test="ancestor::caution"> <xsl:text>#533500</xsl:text> </xsl:when>
				<xsl:when test="ancestor::important"> <xsl:text>white</xsl:text> </xsl:when>
				<xsl:when test="ancestor::warning"> <xsl:text>white</xsl:text> </xsl:when>
				<xsl:when test="ancestor::tip"> <xsl:text>white</xsl:text> </xsl:when>
				<xsl:otherwise>
					<xsl:text>red</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="padding-left">12pt</xsl:attribute>
		<xsl:attribute name="padding-right">12pt</xsl:attribute>
		<xsl:attribute name="padding-top">6pt</xsl:attribute>
		<xsl:attribute name="padding-bottom">6pt</xsl:attribute>
		<xsl:attribute name="margin-left">
			<xsl:value-of select="$title.margin.left" />
		</xsl:attribute>
	</xsl:attribute-set>
	
    <!-- Vertical space around the various verbatim-type elements -->
	<xsl:attribute-set name="verbatim.properties">
		<xsl:attribute name="line-height">0.5</xsl:attribute>
		<xsl:attribute name="space-before.minimum">0.4em</xsl:attribute>
		<xsl:attribute name="space-before.optimum">0.5em</xsl:attribute>
		<xsl:attribute name="space-before.maximum">0.6em</xsl:attribute>
		<xsl:attribute name="space-after.minimum">0.4em</xsl:attribute>
		<xsl:attribute name="space-after.optimum">0.5em</xsl:attribute>
		<xsl:attribute name="space-after.maximum">0.6em</xsl:attribute>
		<xsl:attribute name="hyphenate">false</xsl:attribute>
		<xsl:attribute name="wrap-option">wrap</xsl:attribute>
		<xsl:attribute name="white-space-collapse">false</xsl:attribute>
		<xsl:attribute name="white-space-treatment">preserve</xsl:attribute>
		<xsl:attribute name="linefeed-treatment">preserve</xsl:attribute>
		<xsl:attribute name="text-align">start</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- Styles and highlighting for programlisting types -->
	<xsl:template match="programlisting|programlisting[@language='XML']|programlisting[@language='JAVA']|programlisting[@language='XHTML']|programlisting[@language='JSP']|programlisting[@language='CSS']">
		<xsl:variable name="language">
			<xsl:value-of select="s:toUpperCase(string(@language))" xmlns:s="java:java.lang.String" />
		</xsl:variable>
		<xsl:variable name="hilighter" select="jbh:new()" />
		<xsl:variable name="parsable" select="jbh:isParsable($language)"/>
		<fo:block background-color="#F5F5F5" border-style="solid" border-width=".3mm"
				 border-color="#CCCCCC" font-family="{$programlisting.font}"
				 font-size="{$programlisting.font.size}" space-before="12pt" space-after="12pt"
				 linefeed-treatment="preserve" white-space-collapse="false"
				 white-space-treatment="preserve" padding-bottom="5pt" padding-top="5pt"
				 padding-right="12pt" padding-left="12pt" padding="20pt" margin="0">
			<xsl:choose>
				<xsl:when test="$parsable = 'true'">
				   <xsl:for-each select="node()">
					  <xsl:choose>
						 <xsl:when test="self::text()">
							<xsl:variable name="child.content" select="." />
							<xsl:variable name="caller" select="jbh:parseText($hilighter, $language, string($child.content), 'UTF-8')" />
							<xsl:variable name="noOfTokens" select="jbh:getNoOfTokens($caller)" />
							<xsl:call-template name="iterator">
							   <xsl:with-param name="caller" select="$caller" />
							   <xsl:with-param name="noOfTokens" select="$noOfTokens" />
							</xsl:call-template>
						 </xsl:when>
						 <xsl:otherwise>
							<fo:inline>
							   <xsl:call-template name="anchor" />
							</fo:inline>
						 </xsl:otherwise>
					  </xsl:choose>
				   </xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
				   <xsl:apply-templates />
				</xsl:otherwise>
			</xsl:choose>
		</fo:block>
	</xsl:template>
	<xsl:template name="iterator">
		<xsl:param name="caller" />
		<xsl:param name="noOfTokens" />
		<xsl:param name="i" select="0" />
		<xsl:variable name="style" select="jbh:getStyle($caller, $i)" />
		<xsl:variable name="token" select="jbh:getToken($caller, $i)" />
		<xsl:choose>
			<xsl:when test="$style = 'java_keyword'">
				<fo:inline color="#7F1B55" font-weight="bold">
					<xsl:value-of select="$token" />
				</fo:inline>
			</xsl:when>
			<xsl:when test="$style = 'java_plain'">
				<fo:inline color="#000000">
					<xsl:value-of select="$token" />
				</fo:inline>
			</xsl:when>
			<xsl:when test="$style = 'java_type'">
				<fo:inline color="#000000">
					<xsl:value-of select="$token" />
				</fo:inline>
			</xsl:when>
			<xsl:when test="$style = 'java_separator'">
				<fo:inline color="#000000">
					<xsl:value-of select="$token" />
				</fo:inline>
			</xsl:when>
			<xsl:when test="$style = 'java_literal'">
				<fo:inline color="#2A00FF">
					<xsl:value-of select="$token" />
				</fo:inline>
			</xsl:when>
			<xsl:when test="$style = 'java_comment'">
				<fo:inline color="#3F7F5F">
					<xsl:value-of select="$token" />
				</fo:inline>
			</xsl:when>
			<xsl:when test="$style = 'java_javadoc_comment'">
				<fo:inline color="#3F5FBF" font-style="italic">
					<xsl:value-of select="$token" />
				</fo:inline>
			</xsl:when>
			<xsl:when test="$style = 'java_operator'">
				<fo:inline color="#000000">
					<xsl:value-of select="$token" />
				</fo:inline>
			</xsl:when>
			<xsl:when test="$style = 'java_javadoc_tag'">
				<fo:inline color="#7F9FBF" font-weight="bold" font-style="italic">
					<xsl:value-of select="$token" />
				</fo:inline>
			</xsl:when>
			<xsl:when test="$style = 'xml_plain'">
				<fo:inline color="#000000">
					<xsl:value-of select="$token" />
				</fo:inline>
			</xsl:when>
			<xsl:when test="$style = 'xml_char_data'">
				<fo:inline color="#000000">
					<xsl:value-of select="$token" />
				</fo:inline>
			</xsl:when>
			<xsl:when test="$style = 'xml_tag_symbols'">
				<fo:inline color="#008080">
					<xsl:value-of select="$token" />
				</fo:inline>
			</xsl:when>
			<xsl:when test="$style = 'xml_comment'">
				<fo:inline color="#3F5FBF">
					<xsl:value-of select="$token" />
				</fo:inline>
			</xsl:when>
			<xsl:when test="$style = 'xml_attribute_value'">
				<fo:inline color="#2A00FF">
					<xsl:value-of select="$token" />
				</fo:inline>
			</xsl:when>
			<xsl:when test="$style = 'xml_attribute_name'">
				<fo:inline color="#7F007F" font-weight="bold">
					<xsl:value-of select="$token" />
				</fo:inline>
			</xsl:when>
			<xsl:when test="$style = 'xml_processing_instruction'">
				<fo:inline color="#000000" font-weight="bold" font-style="italic">
					<xsl:value-of select="$token" />
				</fo:inline>
			</xsl:when>
			<xsl:when test="$style = 'xml_tag_name'">
				<fo:inline color="#3F7F7F">
					<xsl:value-of select="$token" />
				</fo:inline>
			</xsl:when>
			<xsl:when test="$style = 'xml_rife_tag'">
				<fo:inline color="#000000">
					<xsl:value-of select="$token" />
				</fo:inline>
			</xsl:when>
			<xsl:when test="$style = 'xml_rife_name'">
				<fo:inline color="#008CCA">
					<xsl:value-of select="$token" />
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline color="black">
					<xsl:value-of select="$token" />
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$i &lt; $noOfTokens - 1">
			<xsl:call-template name="iterator">
				<xsl:with-param name="caller" select="$caller" />
				<xsl:with-param name="noOfTokens" select="$noOfTokens" />
				<xsl:with-param name="i" select="$i + 1" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
<!--###################################################
		 Quandaset
#######################################################-->

	<!-- Style of question -->
	<xsl:template match="question">
		<xsl:variable name="id">
		 <xsl:call-template name="object.id" />
		</xsl:variable>
		<xsl:variable name="entry.id">
			<xsl:call-template name="object.id">
				<xsl:with-param name="object" select="parent::*" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="deflabel">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::*[@defaultlabel]">
					<xsl:value-of select="(ancestor-or-self::*[@defaultlabel])[last()] /@defaultlabel" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$qanda.defaultlabel" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<fo:list-item id="{$entry.id}" xsl:use-attribute-sets="list.item.spacing">
			<fo:list-item-label end-indent="label-end()">
				<xsl:choose>
					<xsl:when test="$deflabel = 'none'">
						<fo:block />
					</xsl:when>
					<xsl:otherwise>
						<fo:block>
							<xsl:apply-templates select="." mode="label.markup" />
							<xsl:if test="$deflabel = 'number' and not(label)">
								<xsl:apply-templates select="." mode="intralabel.punctuation" />
							</xsl:if>
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<xsl:choose>
					<xsl:when test="$deflabel = 'none'">
						<fo:block font-weight="bold">
							<xsl:apply-templates select="*[local-name(.)!='label']" />
						</fo:block>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="*[local-name(.)!='label']" />
					</xsl:otherwise>
				</xsl:choose>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
   
	<!-- Style of answer -->
	<xsl:template match="answer">
		<xsl:variable name="id">
			<xsl:call-template name="object.id" />
		</xsl:variable>
		<xsl:variable name="entry.id">
			<xsl:call-template name="object.id">
				<xsl:with-param name="object" select="parent::*" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="deflabel">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::*[@defaultlabel]">
					<xsl:value-of select="(ancestor-or-self::*[@defaultlabel])[last()] /@defaultlabel" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$qanda.defaultlabel" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:list-item xsl:use-attribute-sets="list.item.spacing">
			<fo:list-item-label end-indent="label-end()">
				<xsl:choose>
					<xsl:when test="$deflabel = 'none'">
						<fo:block />
					</xsl:when>
					<xsl:otherwise>
						<fo:block>
							<xsl:variable name="answer.label">
								<xsl:apply-templates select="." mode="label.markup" />
							</xsl:variable>
							<xsl:copy-of select="$answer.label" />
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<xsl:apply-templates select="*[local-name(.)!='label']" />
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

<!--###################################################
		 Admonitions 
#######################################################-->

	<!-- Enabling use of admon graphic -->
	<xsl:param name="admon.graphics" select="1"/>
	
	<!-- Defining image extensions that can be used -->
	<xsl:param name="admon.graphics.extension" select="'.png'"/>
	
	<!-- Size of admon graphic -->
	<xsl:template match="*" mode="admon.graphic.width">
		<xsl:param name="node" select="."/>
		<xsl:text>16px</xsl:text>
	</xsl:template>
	
	<!-- Size of tip admon -->
	<xsl:template match="tip" mode="admon.graphic.width">
		<xsl:param name="node" select="."/>
		<xsl:text>10px</xsl:text>
	</xsl:template>
	
	<!-- Properties of admon title -->
	<xsl:attribute-set name="admonition.title.properties">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="color">#4C5253</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="hyphenate">false</xsl:attribute>
		<xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- Properties of admons (background-color, border and space -->
	<xsl:attribute-set name="graphical.admonition.properties">
		<xsl:attribute name="color">#3C4A55</xsl:attribute>
		<xsl:attribute name="background-color">
			<xsl:choose>
				<xsl:when test="self::note">#DEE3FA</xsl:when>
				<xsl:when test="self::warning">#FCF4D4</xsl:when>
				<xsl:when test="self::tip">#E6FADE</xsl:when>
				<xsl:otherwise>#404040</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="border">
			<xsl:choose>
				<xsl:when test="self::note">1px solid #2F5E92</xsl:when>
				<xsl:when test="self::tip">1px solid #39C522</xsl:when>
				<xsl:when test="self::warning">1px solid #EDAD00</xsl:when>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="space-before.optimum">1em</xsl:attribute>
		<xsl:attribute name="space-before.minimum">0.8em</xsl:attribute>
		<xsl:attribute name="space-before.maximum">1.2em</xsl:attribute>
		<xsl:attribute name="space-after.optimum">1em</xsl:attribute>
		<xsl:attribute name="space-after.minimum">0.8em</xsl:attribute>
		<xsl:attribute name="space-after.maximum">1em</xsl:attribute>
		<xsl:attribute name="padding">5px 2px 5px 5px</xsl:attribute>
		<xsl:attribute name="margin">5px 0</xsl:attribute>
	</xsl:attribute-set>

<!--###################################################
		  Example
#######################################################-->

	<!-- Properties of example title -->
	<xsl:attribute-set name="formal.title.properties">
		<xsl:attribute name="font-size">10pt</xsl:attribute> 
		<xsl:attribute name="color">#393939</xsl:attribute>	  	  
	</xsl:attribute-set>
	
	<!-- Properties of example content -->
	<xsl:attribute-set name="example.properties">
		<xsl:attribute name="font-size">10pt</xsl:attribute> 
		<xsl:attribute name="color">#393939</xsl:attribute>	  
		<xsl:attribute name="border-left">1pt solid #CCCCCC</xsl:attribute>
		<xsl:attribute name="padding-left">2pt</xsl:attribute>    	
	</xsl:attribute-set>
	
<!--###################################################
		 Link
#######################################################-->

	<!-- Hiding URL -->
	<xsl:param name="ulink.show" select="0"/>
	
	<!-- Properties of link: color and underline -->
	<xsl:attribute-set name="xref.properties">
		<xsl:attribute name="font-style">normal</xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
		<xsl:attribute name="color">
			<xsl:choose>
				<xsl:when test="ancestor::note or ancestor::caution or ancestor::important or ancestor::warning or ancestor::tip">
					<xsl:text>#0C46BC</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>#285A92</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:attribute-set>
	
<!--###################################################
          Abstract
#######################################################-->

	<!-- Abstract in book -->
	<xsl:template match="abstract" mode="titlepage.mode">
		<xsl:variable name="keep.together"></xsl:variable>
		<fo:block xsl:use-attribute-sets="normal.para.spacing" background-color="#f8f8f8" border="0.5px solid #cfcfcf" padding="5px">
			<xsl:if test="$keep.together != ''">
				<xsl:attribute name="keep-together.within-column">
					<xsl:value-of select="$keep.together"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="anchor"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
  
	<!-- Abstract in chapters -->
	<xsl:template match="abstract">
		<xsl:variable name="keep.together"></xsl:variable>
		<fo:block xsl:use-attribute-sets="normal.para.spacing" background-color="white" padding-top="5px">
			<xsl:if test="$keep.together != ''">
				<xsl:attribute name="keep-together.within-column">
					<xsl:value-of select="$keep.together"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="anchor"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

<!--###################################################
          Prompt
#######################################################-->

	<xsl:template match="prompt">
		<xsl:param name="content">
			<xsl:call-template name="simple.xlink">
				<xsl:with-param name="content">
					<xsl:apply-templates/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:param>
		<fo:inline color="#444444" font-family="Helvetica Neue,Helvetica,Arial,sans-serif" font-size="10pt">
			<xsl:call-template name="anchor"/>
			<xsl:if test="@dir">
				<xsl:attribute name="direction">
					<xsl:choose>
						<xsl:when test="@dir = 'ltr' or @dir = 'lro'">ltr</xsl:when>
						<xsl:otherwise>rtl</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:copy-of select="$content"/>
		</fo:inline>
	</xsl:template>
	
<!--###################################################
          Citetitle
#######################################################-->
	  
	<xsl:template match="citetitle">
		<xsl:param name="content">
		<xsl:call-template name="inline.monoseq">
		  <xsl:with-param name="content">
			<xsl:apply-templates/>
		  </xsl:with-param>
		</xsl:call-template>
		</xsl:param>
		<fo:inline background-color="#444444" color="#FFFFFF" font-style="normal" font-size="8pt"
				   padding-top="0.4em" padding-bottom="0.4em" font-family="$title.fontset">
			<xsl:call-template name="anchor"/>
			<xsl:if test="@dir">
				<xsl:attribute name="direction">
					<xsl:choose>
						<xsl:when test="@dir = 'ltr' or @dir = 'lro'">ltr</xsl:when>
						<xsl:otherwise>rtl</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:copy-of select="$content"/>
		</fo:inline>
	</xsl:template>

<!--###################################################
         Code
#######################################################-->

	<xsl:template match="code">
		<xsl:param name="content">
			<xsl:call-template name="inline.monoseq">
				<xsl:with-param name="content">
					<xsl:apply-templates/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:param>
		<fo:inline background-color="#FEE9CC" color="#DD1144" font-size="12pt" border-bottom="0.5pt solid #FFDEB0" border-top="0.5pt solid #FFDEB0">
			<xsl:call-template name="anchor"/>
			<xsl:if test="@dir">
				<xsl:attribute name="direction">
					<xsl:choose>
						<xsl:when test="@dir = 'ltr' or @dir = 'lro'">ltr</xsl:when>
						<xsl:otherwise>rtl</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:copy-of select="$content"/>
		</fo:inline>
	</xsl:template>
	
<!--###################################################
         Screen
#######################################################-->

	<xsl:template match="screen">    
		<xsl:variable name="keep.together"></xsl:variable>
		<fo:block font-family="Verdana,Arial,Sans-serif" color="#393939" background-color="#F4F4F4" font-size="8pt" space-before="10pt" space-after="10pt"
				  linefeed-treatment="preserve" white-space-collapse="false"
		          white-space-treatment="preserve" padding-bottom="7pt" padding-top="7pt"
		          padding-right="10pt" padding-left="10pt" margin="0">        
			<xsl:if test="$keep.together != ''">
				<xsl:attribute name="keep-together.within-column"><xsl:value-of
							   select="$keep.together"/></xsl:attribute>
			</xsl:if>
			<xsl:call-template name="anchor"/>
			<xsl:apply-templates/>	
		</fo:block>
	</xsl:template>
	
<!--###################################################
         Term
#######################################################-->

	<xsl:template match="term">
		<xsl:param name="content">
			<xsl:call-template name="simple.xlink">
				<xsl:with-param name="content">
					<xsl:apply-templates/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:param>
		<fo:inline color="#2E398C" font-style="normal" font-size="9pt">
			<xsl:call-template name="anchor"/>
			<xsl:if test="@dir">
				<xsl:attribute name="direction">
					<xsl:choose>
						<xsl:when test="@dir = 'ltr' or @dir = 'lro'">ltr</xsl:when>
						<xsl:otherwise>rtl</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:copy-of select="$content"/>
		</fo:inline>
	</xsl:template>
	
<!--###################################################
          Guibutton
#######################################################-->

	<xsl:template match="guibutton">
		<xsl:param name="content">
			<xsl:call-template name="inline.boldseq">
				<xsl:with-param name="content">
					<xsl:apply-templates/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:param>
		<fo:inline color="#FFFFFF" background-color="#4E73AA" background-image="linear-gradient(to bottom, #5A85C5, #3C5781)" padding-top="2px" padding-bottom="2px" font-family="Helvetica Neue, Helvetica,Lucida,Arial,sans-serif" font-size="9pt">
			<xsl:copy-of select="$content"/>
		</fo:inline>
	</xsl:template>
	
<!--###################################################
          Guilabel
#######################################################-->

	<xsl:template match="guilabel">
		<xsl:param name="content">
			<xsl:call-template name="inline.boldseq">
				<xsl:with-param name="content">
					<xsl:apply-templates/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:param>
		<fo:inline background-color="#F0F0F0" padding-top="2px" padding-bottom="2px" color="#393939" font-size="9pt">      
			<xsl:copy-of select="$content"/>
		</fo:inline>
	</xsl:template>
	
<!--###################################################
		 Highlights
#######################################################-->

	<xsl:template match="highlights">
		<xsl:variable name="keep.together"></xsl:variable>
		<fo:block xsl:use-attribute-sets="normal.para.spacing" background-color="white" padding="0px 5px 1px" margin-bottom="10px">
			<xsl:if test="$keep.together != ''">
				<xsl:attribute name="keep-together.within-column"><xsl:value-of select="$keep.together"/></xsl:attribute>
			</xsl:if>
			<xsl:call-template name="anchor"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
<!--###################################################
           Menuchoice
#######################################################-->

	<!-- Separator character of menuchoice -->   	  	
	<xsl:param name="menuchoice.menu.separator">
		<fo:inline color="#393939" font-style="normal"> &#8594; </fo:inline>
	</xsl:param>
	
	<!-- Properties of guimenu -->
	<xsl:template match="guimenu"> 	 
		<xsl:param name="content"> 	 
			<xsl:call-template name="inline.boldseq"> 	 
				<xsl:with-param name="content"> 	 
					<xsl:apply-templates/> 	 
				</xsl:with-param> 	 
			</xsl:call-template> 	 
		</xsl:param>
		<fo:inline background-color="#F0F0F0" color="#393939" font-size="8.5pt" padding-top="1.5px" padding-bottom="1.5px">      
			<xsl:copy-of select="$content"/>
		</fo:inline>
	</xsl:template>
	
	<!-- Properties of guisubmenu -->
	<xsl:template match="guisubmenu">
		<xsl:param name="content">
			<xsl:call-template name="inline.boldseq">
				<xsl:with-param name="content">
					<xsl:apply-templates/>
				</xsl:with-param>	
			</xsl:call-template>
		</xsl:param>
		<fo:inline background-color="#F0F0F0" color="#393939" font-size="8.5pt" padding-top="1.5px" padding-bottom="1.5px">       	
			<xsl:copy-of select="$content"/>
		</fo:inline>
	</xsl:template>
	
	<!-- Properties of guimenuitem -->
	<xsl:template match="guimenuitem">
		<xsl:param name="content">
			<xsl:call-template name="inline.boldseq">
				<xsl:with-param name="content">
					<xsl:apply-templates/>	
				</xsl:with-param>
			</xsl:call-template>	
		</xsl:param>	
		<fo:inline background-color="#F0F0F0" color="#393939" font-size="8.5pt" padding-top="1.5px" padding-bottom="1.5px">      	
			<xsl:copy-of select="$content"/>
		</fo:inline>
	</xsl:template>
	
<!--###################################################
          Command
#######################################################-->

	<xsl:template match="command"> 	 
		<xsl:param name="content"> 	 
			<xsl:call-template name="inline.monoseq"> 	 
				<xsl:with-param name="content"> 	 
					<xsl:apply-templates/> 	 
				</xsl:with-param> 	 
			</xsl:call-template> 	 
		</xsl:param> 	 
		<fo:inline background-color="#F8F8F8" font-size="16px" font-family="verdana,helvetica,sans-serif" font-style="italic" font-weight="bold" padding-top="1px" padding-bottom="1px">
			<xsl:copy-of select="$content"/>
		</fo:inline>
	</xsl:template>
	
<!--###################################################
          Filename
#######################################################-->

	<xsl:template match="filename"> 	 
		<xsl:param name="content">
			<xsl:call-template name="inline.monoseq">
				<xsl:with-param name="content">
					<xsl:apply-templates/>
				</xsl:with-param> 	 
			</xsl:call-template>
		</xsl:param>
		<fo:inline color="#DD1144" background-color="#F7F7F9" font-size="12px" letter-spacing="0.1pt" font-family="Monaco,Menlo,Consolas,Courier New,monospace" border-bottom="0.8px dotted #CFCFCF">      
			<xsl:copy-of select="$content"/>
		</fo:inline> 	 
	</xsl:template>
	
<!--###################################################
         Parameter
#######################################################-->

	<xsl:template match="parameter">
		<xsl:param name="content">
			<xsl:call-template name="inline.monoseq">
				<xsl:with-param name="content">
					<xsl:apply-templates/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:param>
		<fo:inline background-color="#F7F7F9" color="#DD1144" 
				   font-size="12pt" font-style="italic"
				   border-bottom="0.5pt solid #E1E1E8" border-top="0.5pt solid #E1E1E8">
			<xsl:call-template name="anchor"/>
			<xsl:if test="@dir">
				<xsl:attribute name="direction">
					<xsl:choose>
						<xsl:when test="@dir = 'ltr' or @dir = 'lro'">ltr</xsl:when>
						<xsl:otherwise>rtl</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:copy-of select="$content"/>
		</fo:inline>
	</xsl:template>
	
<!--###################################################
          Misc
#######################################################-->

	<!-- Enabling scalefit for large images -->
    <xsl:param name="graphicsize.extension" select="'1'" />
	
	<!-- Turning on fo extensions -->
	<xsl:param name="fop.extensions" select="1" />
	
	<!-- Calling component.title.nomarkup -->
	<xsl:template name="component.title.nomarkup">
		<xsl:param name="node" select="." />
		<xsl:variable name="id">
			<xsl:call-template name="object.id">
				<xsl:with-param name="object" select="$node" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="title">
			<xsl:apply-templates select="$node" mode="object.title.markup">
				<xsl:with-param name="allow-anchors" select="1" />
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:copy-of select="$title" />
	</xsl:template>
	<l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"> 
		<l:l10n language="en"> 
			<l:context name="title">
				<!-- Changing "Example number title" into "Example: title" -->
				<l:template name="example" text="Example: %t "/>
			</l:context> 
			<!-- Showing the text "Table of Contents" at the beginning of TOC page -->
			<l:gentext key="TableofContents" text="Table of Contents"/>
		</l:l10n>
	</l:i18n>
	
	<!-- Enabling use.extensions and tablecolumns.extension to use colspec syntax in Docbook XML if any -->
	<xsl:param name="use.extensions" select="1"/>
	<xsl:param name="tablecolumns.extension" select="1"/>
</xsl:stylesheet>