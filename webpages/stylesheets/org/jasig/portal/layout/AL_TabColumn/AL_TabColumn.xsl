<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="no"/>
  <xsl:param name="alternateLayouts" select="'no alternateLayouts parameter'"/>
  <xsl:param name="lastSessionTabID" select="'no lastSessionTabID parameter'"/>
  <!--modes: view (default), preferences, fragment-->
  <!--<xsl:param name="mode" select="'view'"/>-->
  <xsl:param name="mode" select="'view'"/>
  <!--Target restrictions: tab, column, channel-->
  <xsl:param name="targetRestriction" select="'no targetRestriction parameter'"/>
  <!--<xsl:param name="targetRestriction" select="'channel'"/>-->
  <xsl:param name="targetAction" select="'no targetAction parameter'"/>
  <xsl:param name="selectedID" select="''"/>
  <!--<xsl:param name="selectedID" select="'10'"/>-->
  <xsl:param name="userLayoutRoot" select="'root'"/>
  <!--<xsl:param name="userLayoutRoot" select="'29'"/>-->
  <xsl:param name="focusedTabID">
  <!--Check if lastSession-->
    <xsl:choose>
      <xsl:when test="$lastSessionTabID = /layout/folder/folder[@type='regular' and @hidden='false']/@ID">
        <xsl:value-of select="$lastSessionTabID"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/layout/folder/folder[@type='regular' and @hidden='false'][1]/@ID"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:variable name="validFocusedTabID">
    <xsl:choose>
      <xsl:when test="$focusedTabID = /layout/folder/folder[@type='regular' and @hidden='false']/@ID">
        <xsl:value-of select="$focusedTabID"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/layout/folder/folder[@type='regular' and @hidden='false'][1]/@ID"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!--Create layout fragments for detached content-->
  <xsl:template match="layout_fragment">
    <layout_fragment>
      <content>
        <xsl:apply-templates/>
      </content>
    </layout_fragment>
  </xsl:template>

  <xsl:template match="layout">
    <layout mode="{$mode}" selectedID="{$selectedID}" focusedTabID="{$validFocusedTabID}" targetRestriction="{$targetRestriction}" targetAction="{$targetAction}" userLayoutRoot="{$userLayoutRoot}">
      <!--<xsl:if test="$mode='preferences'"><xsl:call-template name="statusCheck"/></xsl:if>-->
      <xsl:apply-templates select="folder[position()=1]" mode="rootFolder"/>
    </layout>
  </xsl:template>

  <xsl:template match="folder" mode="rootFolder">
    <header/>
    <!--      <xsl:apply-templates select="folder[@type='header']"/>
    </header>-->
    <xsl:choose>
      <!--Conditionally present content depending on whether it is focused or not-->
      <xsl:when test="$userLayoutRoot = 'root'">
        <navigation>
          <xsl:apply-templates select="folder[@type='regular' and @hidden='false']|move_target|add_target"/>
        </navigation>
        <xsl:choose>
          <xsl:when test="/layout/folder//channel[@name='Login']">
            <login>
            <xsl:copy-of select="/layout/folder//channel[@name='Login']"/>
            </login>
          </xsl:when>
          <xsl:when test="$mode='preferences'">
            <actions>
              <xsl:copy-of select="$alternateLayouts"/>
            </actions>
          </xsl:when>
        </xsl:choose>
        <content>
          <!--Select only the non hidden content on the active tab-->
          <xsl:apply-templates select="folder[@type='regular' and @hidden='false' and @ID=$validFocusedTabID]" mode="contentFolders"/>
        </content>
      </xsl:when>
      <xsl:otherwise>
        <focusedContent>
          <xsl:apply-templates select=".//*[@ID = $userLayoutRoot]"/>
        </focusedContent>
      </xsl:otherwise>
    </xsl:choose>
    <footer>
      <xsl:apply-templates select="folder[@type='footer']"/>
    </footer>
  </xsl:template>

  <xsl:template match="folder[@type='header']">
    <xsl:apply-templates select="descendant::channel"/>
  </xsl:template>

  <xsl:template match="/layout/folder/folder[@type='regular' and @hidden='false']">
    <xsl:choose>
      <xsl:when test="@ID=$selectedID and @ID=$focusedTabID">
        <selectedTab name="{@name}" ID="{@ID}" immutable="{@immutable}" unremovable="{@unremovable}"/>
      </xsl:when>
      <xsl:when test="@ID=$focusedTabID">
        <focusedTab name="{@name}" ID="{@ID}" immutable="{@immutable}" unremovable="{@unremovable}"/>
      </xsl:when>
      <xsl:otherwise>
        <inactiveTab name="{@name}" ID="{@ID}" immutable="{@immutable}" unremovable="{@unremovable}"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="folder[@type='footer']">
    <xsl:apply-templates select="descendant::channel"/>
  </xsl:template>

  <xsl:template match="folder" mode="contentFolders">
    <xsl:apply-templates/>
    <!--Copy orphaned channels to one column in the last position of the node set-->
    <!--This is dangerous - no ID or width - can't be selected in the preferences mode-->
    <xsl:if test="channel">
      <column>
        <xsl:apply-templates select="channel"/>
      </column>
    </xsl:if>
  </xsl:template>

  <xsl:template match="folder">
    <xsl:variable name="sumOfWidths"><xsl:value-of select="sum(../folder/@width)"/></xsl:variable>
    <column ID="{@ID}">
      <xsl:attribute name="width">
        <xsl:choose>
          <xsl:when test="$sumOfWidths = 100">
            <xsl:value-of select="@width"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="round(@width div $sumOfWidths * 100)"/>
          </xsl:otherwise>
        </xsl:choose>%      
      </xsl:attribute>
      <xsl:apply-templates select="descendant::channel|descendant::move_target|descendant::add_target"/>
    </column>
  </xsl:template>

  <xsl:template match="channel">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="move_target">
    <xsl:choose>
      <xsl:when test="$targetRestriction='no targetRestriction parameter'">
        <xsl:copy-of select="."/>
      </xsl:when>
      <xsl:when test="$targetRestriction='tab' and name(ancestor::*[2])='layout' and not(preceding-sibling::folder[1]/@type='footer') and not(following-sibling::folder[1]/@type='header') and not(following-sibling::folder[1]/@ID=$selectedID) and not(preceding-sibling::folder[1]/@ID=$selectedID)">
        <xsl:copy-of select="."/>
      </xsl:when>
      <xsl:when test="$targetRestriction='column' and name(ancestor::*[3])='layout'">
        <xsl:copy-of select="."/>
      </xsl:when>
      <xsl:when test="$targetRestriction='channel' and not(name(ancestor::*[3])='layout') and not(name(ancestor::*[2])='layout')">
        <xsl:copy-of select="."/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="add_target">
    <xsl:choose>
      <xsl:when test="$targetRestriction='no targetRestriction parameter'">
        <xsl:copy-of select="."/>
      </xsl:when>
      <xsl:when test="$targetRestriction='tab' and name(ancestor::*[2])='layout' and not(preceding-sibling::folder[1]/@type='footer') and not(following-sibling::folder[1]/@type='header')">
        <xsl:copy-of select="."/>
      </xsl:when>
      <xsl:when test="$targetRestriction='column' and name(ancestor::*[3])='layout'">
        <xsl:copy-of select="."/>
      </xsl:when>
      <xsl:when test="$targetRestriction='channel' and not(name(ancestor::*[3])='layout') and not(name(ancestor::*[2])='layout')">
        <xsl:copy-of select="."/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c)1998-2003. Sonic Software Corporation. All rights reserved.
<metaInformation>
<scenarios/><MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
</metaInformation>
-->