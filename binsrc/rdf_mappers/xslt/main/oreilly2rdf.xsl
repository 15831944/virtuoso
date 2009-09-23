<?xml version="1.0" encoding="UTF-8"?>
<!--
 -
 -  $Id$
 -
 -  This file is part of the OpenLink Software Virtuoso Open-Source (VOS)
 -  project.
 -
 -  Copyright (C) 1998-2009 OpenLink Software
 -
 -  This project is free software; you can redistribute it and/or modify it
 -  under the terms of the GNU General Public License as published by the
 -  Free Software Foundation; only version 2 of the License, dated June 1991.
 -
 -  This program is distributed in the hope that it will be useful, but
 -  WITHOUT ANY WARRANTY; without even the implied warranty of
 -  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 -  General Public License for more details.
 -
 -  You should have received a copy of the GNU General Public License along
 -  with this program; if not, write to the Free Software Foundation, Inc.,
 -  51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
-->
<!DOCTYPE xsl:stylesheet [
<!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<!ENTITY bibo "http://purl.org/ontology/bibo/">
<!ENTITY foaf "http://xmlns.com/foaf/0.1/">
<!ENTITY sioc "http://rdfs.org/sioc/ns#">
<!ENTITY owl "http://www.w3.org/2002/07/owl#">
<!ENTITY gr "http://purl.org/goodrelations/v1#">
<!ENTITY book "http://purl.org/NET/book/vocab#">
]>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="&rdf;"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:sioc="&sioc;"
  xmlns:foaf="&foaf;"
  xmlns:bibo="&bibo;"
  xmlns:owl="&owl;"
  xmlns:gr="&gr;"
  xmlns:book="&book;"
  xmlns:virtrdf="http://www.openlinksw.com/schemas/XHTML#"
  xmlns:vi="http://www.openlinksw.com/virtuoso/xslt/"
  xmlns:po="http://purl.org/ontology/po/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:redwood-tags="http://www.holygoat.co.uk/owl/redwood/0.1/tags/"
  version="1.0">

  <xsl:output method="xml" indent="yes"/>

  <xsl:param name="baseUri" />
  <xsl:variable name="resourceURL" select="vi:proxyIRI ($baseUri)"/>
  <xsl:variable  name="docIRI" select="vi:docIRI($baseUri)"/>
  <xsl:variable  name="docproxyIRI" select="vi:docproxyIRI($baseUri)"/>

  <xsl:variable name="uc">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="lc">abcdefghijklmnopqrstuvwxyz</xsl:variable>

  <xsl:template match="/">
      <rdf:RDF>
		<xsl:apply-templates select="html/head"/>
      </rdf:RDF>
  </xsl:template>

  <xsl:template match="html/head">
      <rdf:Description rdf:about="{$docproxyIRI}">
		<rdf:type rdf:resource="&bibo;Document"/>
		<dc:title><xsl:value-of select="$baseUri"/></dc:title>
		<owl:sameAs rdf:resource="{$docIRI}"/>
		<sioc:container_of rdf:resource="{$resourceURL}"/>
		<foaf:topic rdf:resource="{$resourceURL}"/>
		<dcterms:subject rdf:resource="{$resourceURL}"/>
		<foaf:primaryTopic rdf:resource="{$resourceURL}"/>
	  </rdf:Description>
	  <rdf:Description rdf:about="{$resourceURL}">
		<rdf:type rdf:resource="&bibo;Book"/>
		<rdf:type rdf:resource="&book;Book"/>
		<rdf:type rdf:resource="&gr;ProductOrService"/>
		<xsl:apply-templates select="meta"/>
      </rdf:Description>
  </xsl:template>

  <xsl:template match="meta[translate (@name, $uc, $lc)='subtitle']">
      <po:subtitle>
		<xsl:value-of select="@content"/>
      </po:subtitle>
	  <gr:legalName rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
		<xsl:value-of select="@content"/>
	  </gr:legalName>      
  </xsl:template>

  <xsl:template match="meta[translate (@name, $uc, $lc)='object.type']">
	<xsl:if test="@content='book'">
		<rdf:type rdf:resource="&bibo;Book"/>
		<rdf:type rdf:resource="&gr;ProductOrService"/>
	</xsl:if>
  </xsl:template>

  <xsl:template match="meta[translate (@name, $uc, $lc)='book.title']">
      <dc:title>
	  <xsl:value-of select="@content"/>
      </dc:title>
      <gr:legalName rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
		<xsl:value-of select="@content"/>
	  </gr:legalName>
  </xsl:template>

  <xsl:template match="meta[translate (@name, $uc, $lc)='book.author']">
	<bibo:authorList>
		<xsl:value-of select="@content"/>
	</bibo:authorList>
  </xsl:template>

  <xsl:template match="meta[translate (@name, $uc, $lc)='book.isbn']">
      <bibo:isbn13>
	  <xsl:value-of select="@content"/>
      </bibo:isbn13>
      <book:isbn>
	  <xsl:value-of select="@content"/>
      </book:isbn>

  </xsl:template>

  <xsl:template match="meta[translate (@name, $uc, $lc)='book.year']">
      <dc:date>
	  <xsl:value-of select="@content"/>
      </dc:date>
      <gr:validFrom rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">
		<xsl:value-of select="@content"/>
	  </gr:validFrom>
  </xsl:template>

  <xsl:template match="meta[translate (@name, $uc, $lc)='book.link']">
      <bibo:uri rdf:resource="{$resourceURL}" />
  </xsl:template>

  <xsl:template match="meta[translate (@name, $uc, $lc)='book.tags']">
      <redwood-tags:tag>
	  <xsl:value-of select="@content"/>
      </redwood-tags:tag>
  </xsl:template>

  <xsl:template match="meta[translate (@name, $uc, $lc)='reference']">
      <dcterms:references>
	  <xsl:value-of select="@content"/>
      </dcterms:references>
  </xsl:template>

  <xsl:template match="meta[translate (@name, $uc, $lc)='isbn']">
      <bibo:isbn10>
	  <xsl:value-of select="@content"/>
      </bibo:isbn10>
      <xsl:variable name="title">
		<xsl:value-of select="//meta[@name='book.title']/@content" />
      </xsl:variable>
      <xsl:variable name="isbn">
		<xsl:value-of select="//meta[@name='isbn']/@content" />
      </xsl:variable>
      <xsl:variable name="resourceURL">
		<xsl:value-of select="concat('http://www.amazon.com/', translate($title, ' ', '-'), '/dp/', $isbn)"/>
      </xsl:variable>
	  <owl:sameAs rdf:resource="{$resourceURL}" />
  </xsl:template>

  <xsl:template match="meta[translate (@name, $uc, $lc)='ean']">
      <bibo:eanucc13>
	  <xsl:value-of select="@content"/>
      </bibo:eanucc13>
      <gr:hasEAN_UCC-13>
		<xsl:value-of select="@content"/>
      </gr:hasEAN_UCC-13>
  </xsl:template>

  <xsl:template match="meta[translate (@name, $uc, $lc)='graphic']">
      <foaf:img rdf:resource="{@content}"/>
  </xsl:template>

  <xsl:template match="meta[translate (@name, $uc, $lc)='graphic_medium']">
      <foaf:img rdf:resource="{@content}"/>
  </xsl:template>

  <xsl:template match="meta[translate (@name, $uc, $lc)='graphic_large']">
      <foaf:img rdf:resource="{@content}"/>
  </xsl:template>

  <xsl:template match="meta[translate (@name, $uc, $lc)='book_title']">
      <dc:title>
	  <xsl:value-of select="@content"/>
      </dc:title>
  </xsl:template>

  <xsl:template match="meta[translate (@name, $uc, $lc)='author']">
      <dc:creator>
	  <xsl:value-of select="@content"/>
      </dc:creator>
	<xsl:variable name="sas-iri" select="vi:dbpIRI ('', translate (@content, ' ', '_'))"/>
	<xsl:if test="not starts-with ($sas-iri, '#')">
		<rdfs:seeAlso rdf:resource="{$sas-iri}"/>
	</xsl:if>
  </xsl:template>

  <xsl:template match="meta[translate (@name, $uc, $lc)='keywords']">
      <dc:description>
	  <xsl:value-of select="@content"/>
      </dc:description>
      <gr:description>
	  <xsl:value-of select="@content"/>
      </gr:description>
  </xsl:template>

  <xsl:template match="meta[translate (@name, $uc, $lc)='date']">
      <dc:date>
	  <xsl:value-of select="@content"/>
      </dc:date>
  </xsl:template>

  <xsl:template match="meta[translate (@name, $uc, $lc)='publisher']">
      <dc:publisher>
	  <xsl:value-of select="@content"/>
      </dc:publisher>
  </xsl:template>

  <xsl:template match="meta[translate (@name, $uc, $lc)='series']">
      <po:series>
	  <xsl:value-of select="@content"/>
      </po:series>
  </xsl:template>

  <xsl:template match="meta[translate (@name, $uc, $lc)='edition']">
      <po:series>
	  <xsl:value-of select="@content"/>
      </po:series>
  </xsl:template>

  <xsl:template match="*|text()"/>

</xsl:stylesheet>
