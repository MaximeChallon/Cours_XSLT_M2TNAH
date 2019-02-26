﻿<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs tei"
    version="2.0">
    <!-- Attention une sortie HTML => exclusion du préfixe tei des résultats -->

    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/> <!-- pour éviter les espaces non voulus -->
    <xsl:template match="/">
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <title>
                    <xsl:value-of select="//titleStmt/title"/>
                </title>
            </head>
            <body>
                <h2><xsl:value-of select="//body/head"/></h2>
                <span>
                    <link href="{//pb/@facs}">lien vers le manuscrit</link>
                </span>
                <div>
                    <head>Index des noms propres</head>
                    <ul><xsl:call-template name="index"/></ul>
                </div>        
                <div>
                    <h2>Transcription facsimilaire</h2>
                    <div>
                        <ul>
                        <xsl:apply-templates select="//text//div" mode="orig"/>
                        </ul>
                    </div>
                </div>
                <div>
                    <h2>Transcription normalisée</h2>
                    <div>
                        <ul><xsl:apply-templates select="//text//div" mode="reg"/></ul>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="l" mode="orig">
        <xsl:element name="li">
            <xsl:attribute name="n">
                <xsl:number count="l"  level="single"/>
            </xsl:attribute>
        <xsl:value-of select="text() |
            .//orig/text() |
            .//abbr/text()|
            persName/text()|
            persName//orig/text() |
            persName//abbr/text()"/> <!-- Utiliser text() permet d'éviter les espaces entres balises -->
        </xsl:element>
    </xsl:template>
    <xsl:template match="l" mode="reg">
        <xsl:element name="li">
        <xsl:attribute name="n">
            <xsl:number count="l" format="1" level="single"/>
        </xsl:attribute><xsl:value-of select="text() |
            .//reg/text() |
            .//expan//text()|
            persName/text()|
            persName//reg/text() |
            persName//expan//text()"/> <!-- Utiliser text() permet d'éviter les espaces entres balises -->
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="index">
        <xsl:for-each select="//listPerson//persName">
            <li>
            <xsl:value-of select="."/>
             <xsl:variable name="idPerson">
                 <xsl:value-of select="parent::person/@xml:id"/>
             </xsl:variable>
            <xsl:text> : </xsl:text>
           <xsl:for-each select="ancestor::TEI//body//persName[replace(@ref, '#','')=$idPerson]">
               <xsl:value-of select="text() |
                   .//reg/text() |
                   .//expan//text()"/>
               <xsl:text> (v.</xsl:text>
               <xsl:value-of select="count(parent::l/preceding-sibling::l) + 1"/>
               <xsl:text>)</xsl:text>
               <xsl:if test="position()!= last()">, </xsl:if>
               <xsl:if test="position() = last()">.</xsl:if>
           </xsl:for-each>
            </li>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>