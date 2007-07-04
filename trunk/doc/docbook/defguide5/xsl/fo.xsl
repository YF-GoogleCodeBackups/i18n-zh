<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version='1.0'>

  <xsl:import href="../../../../lib/docbook/docbook5-xsl/fo/docbook.xsl"/>

  <xsl:param name="l10n.gentext.language" select="'en'"/>

  <!-- These extensions are required for table printing and other stuff -->
  <xsl:param name="use.extensions">1</xsl:param>
  <xsl:param name="tablecolumns.extension">0</xsl:param>
  <xsl:param name="fop.extensions">0</xsl:param>
  <xsl:param name="fop1.extensions">1</xsl:param>

  <xsl:param name="draft.mode" select="no"/>

  <xsl:param name="variablelist.as.blocks" select="1" />
  <xsl:param name="admon.textlabel" select="0" />
  <xsl:param name="admon.graphics" select="1" />
  <xsl:param name="admon.graphics.path">images/</xsl:param>
  <xsl:param name="admon.graphics.extension">.png</xsl:param>
  <xsl:param name="section.autolabel" select="1" />
  <xsl:attribute-set name="sidebar.properties" use-attribute-sets="formal.object.properties">
    <xsl:attribute name="border-style">solid</xsl:attribute>
    <xsl:attribute name="border-width">.1mm</xsl:attribute>
    <xsl:attribute name="background-color">#EEEEEE</xsl:attribute>
  </xsl:attribute-set>

  <!-- Prevent blank pages in output -->
  <xsl:template name="book.titlepage.before.verso">
  </xsl:template>
  <xsl:template name="book.titlepage.verso">
  </xsl:template>
  <xsl:template name="book.titlepage.separator">
  </xsl:template>

  <!-- Font related Settings -->
  <xsl:param name="body.font.family">sans-serif</xsl:param>
  <xsl:param name="dingbat.font.family">sans-serif</xsl:param>
  <xsl:param name="monospace.font.family">monospace</xsl:param>
  <xsl:param name="title.font.family">sans-serif</xsl:param>

  <!-- More space in the center header for long text -->
  <xsl:attribute-set name="header.content.properties">
    <xsl:attribute name="font-family">
      <xsl:value-of select="$body.font.family"/>
    </xsl:attribute>
    <xsl:attribute name="margin-left">-5em</xsl:attribute>
    <xsl:attribute name="margin-right">-5em</xsl:attribute>
  </xsl:attribute-set>


  <!-- Improve the TOC. -->
  <xsl:template name="toc.line">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>

    <xsl:variable name="label">
      <xsl:apply-templates select="." mode="label.markup"/>
    </xsl:variable>

    <fo:block text-align-last="justify"
        end-indent="{$toc.indent.width}pt"
        last-line-end-indent="-{$toc.indent.width}pt">
      <fo:inline keep-with-next.within-line="always">
        <fo:basic-link internal-destination="{$id}">

            <!-- Chapter titles should be bold. -->
            <xsl:choose>
              <xsl:when test="local-name(.) = 'chapter'">
                <xsl:attribute name="font-weight">bold</xsl:attribute>
              </xsl:when>
            </xsl:choose>

            <xsl:if test="$label != ''">
              <xsl:copy-of select="$label"/>
              <xsl:value-of select="$autotoc.label.separator"/>
            </xsl:if>
            <xsl:apply-templates select="." mode="titleabbrev.markup"/>
          </fo:basic-link>
      </fo:inline>
      <fo:inline keep-together.within-line="always">
        <xsl:text> </xsl:text>
        <fo:leader leader-pattern="dots"
            leader-pattern-width="3pt"
            leader-alignment="reference-area"
            keep-with-next.within-line="always"/>
        <xsl:text> </xsl:text>
        <fo:basic-link internal-destination="{$id}">
          <fo:page-number-citation ref-id="{$id}"/>
        </fo:basic-link>
      </fo:inline>
    </fo:block>
  </xsl:template>

  <!--###################################################
                     Paper & Page Size
      ################################################### -->

  <!-- Paper type, no headers on blank pages, no double sided printing -->
  <xsl:param name="paper.type" select="'A4'"/>
  <xsl:param name="double.sided">0</xsl:param>
  <xsl:param name="headers.on.blank.pages">0</xsl:param>
  <xsl:param name="footers.on.blank.pages">0</xsl:param>

  <!-- Space between paper border and content (chaotic stuff, don't touch) -->
  <xsl:param name="page.margin.top">5mm</xsl:param>
  <xsl:param name="region.before.extent">10mm</xsl:param>
  <xsl:param name="body.margin.top">10mm</xsl:param>

  <xsl:param name="body.margin.bottom">15mm</xsl:param>
  <xsl:param name="region.after.extent">10mm</xsl:param>
  <xsl:param name="page.margin.bottom">5mm</xsl:param>

  <xsl:param name="page.margin.outer">15mm</xsl:param>
  <xsl:param name="page.margin.inner">15mm</xsl:param>

  <!-- No intendation of Titles -->
  <xsl:param name="title.margin.left">0pc</xsl:param>


  <!--###################################################
                     Fonts & Styles
      ################################################### -->

  <!-- Default Font size -->
  <xsl:param name="body.font.master">12</xsl:param>

  <!-- Line height in body text -->
  <xsl:param name="line-height">1.4</xsl:param>

  <!-- Monospaced fonts are smaller than regular text -->
  <xsl:attribute-set name="monospace.properties">
    <xsl:attribute name="font-family">
        <xsl:value-of select="$monospace.font.family"/>
    </xsl:attribute>
    <xsl:attribute name="font-size">0.8em</xsl:attribute>
  </xsl:attribute-set>

  <!--###################################################
                           Callouts
      ################################################### -->

  <!-- We want to use callouts... -->
  <xsl:param name="callout.extensions">1</xsl:param>

  <!-- Place callout bullets at this column in programmlisting.-->
  <xsl:param name="callout.defaultcolumn">90</xsl:param>

  <!--
    No, don't use crappy graphics for the callout bullets. This setting
    enables some weird Unicode rendering for some fancy bullet points
    in callouts. By default, this can only count to 10 and produces
    strange results if you ever have more than 10 callouts for one
    programlisting. We will fix that next.
  -->
  <xsl:param name="callout.graphics">0</xsl:param>

  <!--
    Again, fun with DocBook XSL: The callout bullets are rendered in
    two places: In the programlisting itself and in the list below
    the listing, with the actual callout text. The rendering in the
    programlisting is some XSL transformer extension (e.g. a Saxon
    extension), so we can't change that without messing with the
    extensions. We only can turn it off by setting this limit to
    zero, then, a simple bracket style like "(3)" and "(4)" will
    be used in the programlisting.
  -->
  <xsl:param name="callout.unicode.number.limit" select="'0'"></xsl:param>

  <!--
    The callout bullets in the actual callout list will be rendered
    with an XSL FO template. The default template is broken: limited to 10
    nice looking Unicode bullet points and then it doesn't print anything,
    the fallback doesn't work. We implement our own template, which is not
    as complicated, more ugly, but works. As always, function is more
    important than form.
  -->
  <xsl:template name="callout-bug">
    <xsl:param name="conum" select='1'/>
    <fo:inline
      color="black"
      padding-top="0.1em"
      padding-bottom="0.1em"
      padding-start="0.2em"
      padding-end="0.2em"
      baseline-shift="0.1em"
      font-family="{$monospace.font.family}"
      font-weight="bold"
      font-size="75%">
      <xsl:text>(</xsl:text>
      <xsl:value-of select="$conum"/>
      <xsl:text>)</xsl:text>
    </fo:inline>
  </xsl:template>

  <!--###################################################
                     Tables
      ################################################### -->

  <!-- The table width should be adapted to the paper size -->
  <xsl:param name="default.table.width">17.4cm</xsl:param>

  <!-- Some padding inside tables -->
  <xsl:attribute-set name="table.cell.padding">
    <xsl:attribute name="padding-left">4pt</xsl:attribute>
    <xsl:attribute name="padding-right">4pt</xsl:attribute>
    <xsl:attribute name="padding-top">4pt</xsl:attribute>
    <xsl:attribute name="padding-bottom">4pt</xsl:attribute>
  </xsl:attribute-set>

  <!-- Only hairlines as frame and cell borders in tables -->
  <xsl:param name="table.frame.border.thickness">0.1pt</xsl:param>
  <xsl:param name="table.cell.border.thickness">0.1pt</xsl:param>


  <!--###################################################
                           Labels
      ################################################### -->

  <!-- Label Chapters and Sections (numbering) -->
  <xsl:param name="chapter.autolabel">1</xsl:param>
  <xsl:param name="section.autolabel" select="1"/>
  <xsl:param name="section.label.includes.component.label" select="1"/>

  <!--###################################################
                           Titles
      ################################################### -->

  <!-- Chapter title size -->
  <xsl:attribute-set name="chapter.titlepage.recto.style">
    <xsl:attribute name="text-align">left</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.8"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  <!-- Why is the font-size for chapters hardcoded in the XSL FO templates?
      Let's remove it, so this sucker can use our attribute-set only... -->
  <xsl:template match="title" mode="chapter.titlepage.recto.auto.mode">
    <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format"
      xsl:use-attribute-sets="chapter.titlepage.recto.style">
      <xsl:call-template name="component.title">
        <xsl:with-param name="node" select="ancestor-or-self::chapter[1]"/>
      </xsl:call-template>
    </fo:block>
  </xsl:template>

  <!-- Sections 1, 2 and 3 titles have a small bump factor and padding -->
  <xsl:attribute-set name="section.title.level1.properties">
    <xsl:attribute name="space-before.optimum">0.8em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.8em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">0.8em</xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.5"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="space-after.optimum">0.1em</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.1em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">0.1em</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="section.title.level2.properties">
    <xsl:attribute name="space-before.optimum">0.6em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.6em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">0.6em</xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.25"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="space-after.optimum">0.1em</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.1em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">0.1em</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="section.title.level3.properties">
    <xsl:attribute name="space-before.optimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">0.4em</xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.0"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="space-after.optimum">0.1em</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.1em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">0.1em</xsl:attribute>
  </xsl:attribute-set>

  <!-- Titles of formal objects (tables, examples, ...) -->
  <xsl:attribute-set name="formal.title.properties" use-attribute-sets="normal.para.spacing">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">0.6em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">0.8em</xsl:attribute>
  </xsl:attribute-set>

  <!--###################################################
                        Programlistings
      ################################################### -->

  <!-- Verbatim text formatting (programlistings) -->
  <xsl:attribute-set name="verbatim.properties">
    <xsl:attribute name="space-before.minimum">1em</xsl:attribute>
    <xsl:attribute name="space-before.optimum">1em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">1em</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.1em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">0.1em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">0.1em</xsl:attribute>
    <xsl:attribute name="border-color">#444444</xsl:attribute>
    <xsl:attribute name="border-style">solid</xsl:attribute>
    <xsl:attribute name="border-width">0.1pt</xsl:attribute>
    <xsl:attribute name="padding-top">0.5em</xsl:attribute>
    <xsl:attribute name="padding-left">0.5em</xsl:attribute>
    <xsl:attribute name="padding-right">0.5em</xsl:attribute>
    <xsl:attribute name="padding-bottom">0.5em</xsl:attribute>
    <xsl:attribute name="margin-left">0.5em</xsl:attribute>
    <xsl:attribute name="margin-right">0.5em</xsl:attribute>
  </xsl:attribute-set>

  <!-- Shade (background) programlistings -->
  <xsl:param name="shade.verbatim">1</xsl:param>
  <xsl:attribute-set name="shade.verbatim.style">
    <xsl:attribute name="background-color">#F0F0F0</xsl:attribute>
  </xsl:attribute-set>

  <!-- The horrible list spacing problems, this is much better. -->
  <xsl:attribute-set name="list.block.spacing">
    <xsl:attribute name="space-before.optimum">0.8em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.8em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">0.8em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">0.1em</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.1em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">0.1em</xsl:attribute>
  </xsl:attribute-set>

</xsl:stylesheet>
