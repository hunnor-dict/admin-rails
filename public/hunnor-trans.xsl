<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml"/>

<xsl:template match="entry">
	<xsl:if test="senseGrp">
		<xsl:element name="ol">
			<xsl:attribute name="class">
				<xsl:value-of select="'senseGrp'"/>
				<xsl:if test="count(senseGrp) = 1">
					<xsl:value-of select="' single'"/>
				</xsl:if>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:if>
</xsl:template>

<xsl:template match="senseGrp">
	<li>
		<xsl:if test="sense">
			<xsl:element name="ol">
				<xsl:attribute name="class">
					<xsl:value-of select="'sense'"/>
					<xsl:if test="count(sense) = 1">
						<xsl:value-of select="' single'"/>
					</xsl:if>
				</xsl:attribute>
				<xsl:apply-templates/>
			</xsl:element>
		</xsl:if>
	</li>
</xsl:template>

<xsl:template match="sense">
	<li>
		<xsl:apply-templates/>
	</li>
</xsl:template>

<xsl:template match="lbl">
	<span class="lbl">
		<xsl:apply-templates/>
	</span>
</xsl:template>
	
<xsl:template match="trans">
	<xsl:choose>
		<xsl:when test="preceding-sibling::lbl">
			<span class="glue"><xsl:text> </xsl:text></span>
		</xsl:when>
		<xsl:when test="preceding-sibling::trans">
			<span class="glue"><xsl:text>, </xsl:text></span>
		</xsl:when>
		<xsl:when test="preceding-sibling::q">
			<span class="glue"><xsl:text> </xsl:text></span>
		</xsl:when>
	</xsl:choose>
	<span class="trans"><xsl:apply-templates/></span>
</xsl:template>
	
<xsl:template name="eg">
	<xsl:if test="position() > 1">
		<xsl:text>;</xsl:text>
	</xsl:if>
	<xsl:text> </xsl:text>
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="q">
	<span class="q">
		<xsl:apply-templates/>
	</span>
</xsl:template>

</xsl:stylesheet>
