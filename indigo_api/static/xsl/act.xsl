<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:a="http://www.akomantoso.org/2.0"
  exclude-result-prefixes="a">

  <xsl:output method="html" />
  <!-- base URL of the resolver for resolving ref elements -->
  <xsl:param name="resolverUrl" />
  <!-- default ID scoping to fall back on if we can't find an appropriate one for a node -->
  <xsl:param name="defaultIdScope" />
  <!-- fully-qualified media URL to prepend to relative media urls -->
  <xsl:param name="mediaUrl" />
  <!-- 3-letter language code of document -->
  <xsl:param name="lang" />

  <xsl:template match="a:act">
    <xsl:element name="article" namespace="">
      <xsl:attribute name="class">akn-act</xsl:attribute>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="a:coverPage" />
      <xsl:apply-templates select="a:preface" />
      <xsl:apply-templates select="a:preamble" />
      <xsl:apply-templates select="a:body" />
      <xsl:apply-templates select="a:conclusions" />
    </xsl:element>
  </xsl:template>

  <!-- helper to build an id attribute with an arbitrary value, scoped to the containing doc (if necessary) -->
  <xsl:template name="scoped-id">
    <xsl:param name="id" select="." />

    <xsl:attribute name="id">
      <!-- scope the id to the containing doc, if any, using a default if provided -->
      <xsl:variable name="prefix" select="./ancestor::a:doc[@name][1]/@name"/>
      <xsl:choose>
        <xsl:when test="$prefix != ''">
          <xsl:value-of select="concat($prefix, '/')" />
        </xsl:when>
        <xsl:when test="$defaultIdScope != ''">
          <xsl:value-of select="concat($defaultIdScope, '/')" />
        </xsl:when>
      </xsl:choose>

      <xsl:value-of select="$id" />
    </xsl:attribute>
  </xsl:template>

  <!-- id attribute is scoped if necessary, and the original saved as data-id -->
  <xsl:template match="@id">
    <xsl:call-template name="scoped-id">
      <xsl:with-param name="id" select="." />
    </xsl:call-template>

    <xsl:attribute name="data-id">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>

  <!-- copy over attributes using a data- prefix, except for 'id' which is prefixed if necessary as-is -->
  <xsl:template match="@*">
    <xsl:variable name="attName" select="concat('data-', local-name(.))"/>
    <xsl:attribute name="{$attName}">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>

  <!-- for parts and chapters, include an easily stylable heading -->
  <xsl:template match="a:part">
    <section class="akn-part">
      <xsl:apply-templates select="@*" />
      <h2>
        <xsl:choose>
          <xsl:when test="$lang = 'afr'"><xsl:text>Deel </xsl:text></xsl:when>
          <xsl:when test="$lang = 'ndl'"><xsl:text>Ingcenye </xsl:text></xsl:when>
          <xsl:when test="$lang = 'nso'"><xsl:text>Karolo ya </xsl:text></xsl:when>
          <xsl:when test="$lang = 'sot'"><xsl:text>Karolo </xsl:text></xsl:when>
          <xsl:when test="$lang = 'ssw'"><xsl:text>Incenye </xsl:text></xsl:when>
          <xsl:when test="$lang = 'tsn'"><xsl:text>Karolo </xsl:text></xsl:when>
          <xsl:when test="$lang = 'tso'"><xsl:text>Xiphemu xa </xsl:text></xsl:when>
          <xsl:when test="$lang = 'ven'"><xsl:text>Tshipiḓa tsha </xsl:text></xsl:when>
          <xsl:when test="$lang = 'xho'"><xsl:text>iCandelo </xsl:text></xsl:when>
          <xsl:when test="$lang = 'zul'"><xsl:text>Ingxenye </xsl:text></xsl:when>
          <xsl:otherwise><xsl:text>Part </xsl:text></xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="a:num" />
        <xsl:choose>
          <xsl:when test="./a:heading">
            <xsl:text> – </xsl:text>
            <xsl:apply-templates select="a:heading" mode="inline" />
          </xsl:when>
        </xsl:choose>
      </h2>
      
      <xsl:apply-templates select="./*[not(self::a:num) and not(self::a:heading)]" />
    </section>
  </xsl:template>

  <xsl:template match="a:chapter">
    <section class="akn-chapter">
      <xsl:apply-templates select="@*" />
      <h2>
        <xsl:choose>
          <xsl:when test="$lang = 'afr'"><xsl:text>Hoofstuk </xsl:text></xsl:when>
          <xsl:when test="$lang = 'ndl'"><xsl:text>Isahluko </xsl:text></xsl:when>
          <xsl:when test="$lang = 'nso'"><xsl:text>Kgaolo ya </xsl:text></xsl:when>
          <xsl:when test="$lang = 'sot'"><xsl:text>Kgaolo </xsl:text></xsl:when>
          <xsl:when test="$lang = 'ssw'"><xsl:text>Sehluko </xsl:text></xsl:when>
          <xsl:when test="$lang = 'tsn'"><xsl:text>Kgaolo </xsl:text></xsl:when>
          <xsl:when test="$lang = 'tso'"><xsl:text>Kavanyisa ka </xsl:text></xsl:when>
          <xsl:when test="$lang = 'ven'"><xsl:text>Ndima ya </xsl:text></xsl:when>
          <xsl:when test="$lang = 'xho'"><xsl:text>Isahluko </xsl:text></xsl:when>
          <xsl:when test="$lang = 'zul'"><xsl:text>Isahluko </xsl:text></xsl:when>
          <xsl:otherwise><xsl:text>Chapter </xsl:text></xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="a:num" />
        <br/>
        <xsl:apply-templates select="a:heading" mode="inline" />
      </h2>
      
      <xsl:apply-templates select="./*[not(self::a:num) and not(self::a:heading)]" />
    </section>
  </xsl:template>

  <xsl:template match="a:section">
    <section class="akn-section">
      <xsl:apply-templates select="@*" />
      <h3>
        <xsl:value-of select="a:num" />
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="a:heading" mode="inline" />
      </h3>
      
      <xsl:apply-templates select="./*[not(self::a:num) and not(self::a:heading)]" />
    </section>
  </xsl:template>
  
  <xsl:template match="a:subsection">
    <section class="akn-subsection">
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="./*[not(self::a:heading)]" />
    </section>
  </xsl:template>

  <!-- components/schedules -->
  <xsl:template match="a:doc">
    <!-- a:doc doesn't have an id, so add one -->
    <article class="akn-doc" id="{@name}">
      <xsl:choose>
        <xsl:when test="a:mainBody/a:hcontainer[@name='schedule']">
          <!-- new style schedule -->
          <xsl:apply-templates select="a:mainBody/a:hcontainer[@name='schedule']" />
        </xsl:when>

        <xsl:otherwise>
          <!-- old style schedule -->
          <xsl:apply-templates select="@*" />
          <xsl:if test="a:meta/a:identification/a:FRBRWork/a:FRBRalias">
            <h2>
              <xsl:value-of select="a:meta/a:identification/a:FRBRWork/a:FRBRalias/@value" />
            </h2>
          </xsl:if>
          <xsl:apply-templates select="a:mainBody" />
        </xsl:otherwise>
      </xsl:choose>
    </article>
  </xsl:template>

  <xsl:template match="a:hcontainer[@name='schedule']/a:heading | a:hcontainer[@name='schedule']/a:subheading">
    <h2>
      <xsl:apply-templates />
    </h2>
  </xsl:template>

  <!-- for block elements, generate a span element with a class matching
       the AN name of the node and copy over the attributes -->
  <xsl:template match="a:coverPage | a:preface | a:preamble | a:conclusions">
    <section class="akn-{local-name()}">
      <!-- these components don't have ids in AKN, so add them -->
      <xsl:call-template name="scoped-id">
        <xsl:with-param name="id" select="local-name()" />
      </xsl:call-template>

      <xsl:apply-templates select="@*" />
      <xsl:apply-templates />
    </section>
  </xsl:template>

  <!-- references -->
  <xsl:template match="a:ref">
    <!-- Create an A element that links to this ref -->
    <a class="akn-ref" data-href="{@href}">
      <xsl:attribute name="href">
        <xsl:choose>
          <xsl:when test="starts-with(@href, '/')">
              <xsl:value-of select="concat($resolverUrl, @href)" />
          </xsl:when>
          <xsl:otherwise>
              <xsl:value-of select="@href" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:copy-of select="@*[local-name() != 'href']" />
      <xsl:apply-templates />
    </a>
  </xsl:template>

  <!-- images -->
  <xsl:template match="a:img">
    <img data-src="{@src}">
      <xsl:copy-of select="@*" />

      <!-- make relative image URLs absolute, using the mediaUrl as a base -->
      <xsl:attribute name="src">
        <xsl:choose>
          <xsl:when test="starts-with(@src, 'http://') or starts-with(@src, 'https://')">
            <!-- already absolute -->
            <xsl:value-of select="@src" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat($mediaUrl, @src)" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- indented elements without numbers should not be indented -->
  <xsl:template match="a:paragraph[not(a:num)] | a:subsection[not(a:num)]">
    <section class="akn-paragraph akn--no-indent">
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates />
    </section>
  </xsl:template>

  <!-- for all nodes, generate a SPAN element with a class matching
       the AN name of the node and copy over the attributes -->
  <xsl:template match="*" name="generic-elem">
    <span class="akn-{local-name()}">
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates />
    </span>
  </xsl:template>

  <!-- Special inline mode which doesn't include the akn-foo marker.
       This is used mostly by blocks that format their own headings, and
       don't want akn-heading to be applied to heading elements. -->
  <xsl:template match="*" mode="inline">
    <xsl:apply-templates select="@*" />
    <xsl:apply-templates />
  </xsl:template>
  
  <!-- For HTML table elements, copy them over then apply normal AN
       processing to their contents -->
  <xsl:template match="a:table | a:tr | a:th | a:td">
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*" />
      <xsl:apply-templates select="@id" />
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <!-- special HTML elements -->
  <xsl:template match="a:a">
    <xsl:element name="a">
      <xsl:copy-of select="@href" />
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template match="a:abbr | a:b | a:i | a:span | a:sub | a:sup | a:u">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template match="a:eol">
    <xsl:element name="br" />
  </xsl:template>

</xsl:stylesheet>
