<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

<!-- Metasploit's V5 PDF report template. -->
<!-- Designed for report only from one host from XML file exported from database with comand: db_export -f xml -a /root/hostname.xml -->
<!-- This report shows the return of default module, the pentest module from https://raw.github.com/darkoperator/Metasploit-Plugins/master/pentest.rb and, 
optionally, the report of optional exploitations such as sudo, wmap modules, and auto_brute.rc and auto_pass_the_hash.rc resource files.-->
<!-- To convert to PDF, download Apache's FOP from https://xmlgraphics.apache.org/fop/download.html and execute the following command:
xsltproc template.xsl hostname.xml > hostname.fo
apache-fop/bin/fop hostname.fo hostname.pdf -->
<!-- Licence GPL -->

<!-- Key for search which modules was used on this pentest -->
<xsl:key name="keyModuleName" match="/MetasploitV5/module_details/module_detail" use="fullname" />

<!-- Don't show other trash beyond what we want-->
<xsl:template match="//*[@type='form']">
        <xsl:value-of select="name()"/>
	</xsl:template>
<xsl:template match="text()"/>

<xsl:template match="/">
<fo:root>	

<!-- Initial document layout -->
<fo:layout-master-set>
    <fo:simple-page-master master-name="report"
        page-height="28cm"
        page-width="20cm"
        margin-top="1cm"
        margin-bottom="1cm"
        margin-left="1cm"
        margin-right="1cm">
        <fo:region-body
                margin-top="2cm"
                margin-bottom="2cm" />
	<fo:region-before extent="1.5cm"/>
        <fo:region-after extent="1.5cm"/>
    </fo:simple-page-master>

<fo:page-sequence-master master-name="principal" master-reference="report">
    <fo:repeatable-page-master-reference
	    master-name="report"
	    master-reference="report"
	    odd-or-even="even" />
</fo:page-sequence-master>
</fo:layout-master-set>

<!-- Header -->
<fo:page-sequence master-name="report" initial-page-number="1" master-reference="report">
<fo:static-content flow-name="xsl-region-before">
      <fo:block font-family="Helvetica" font-size="8pt" text-align="center">
	      <xsl:value-of select="/MetasploitV5/hosts/host/created-at" />
	<xsl:apply-templates/>
      </fo:block>
</fo:static-content>

<!-- Footer -->
<fo:static-content flow-name="xsl-region-after">
     <fo:block font-family="Helvetica" font-size="8pt" text-align="center">
         <fo:page-number />
     </fo:block>
</fo:static-content>

<!-- Logo & title of report -->
<fo:flow flow-name="xsl-region-body">
	<fo:block text-align="center">
		<fo:external-graphic src="file:metasploit.jpg" width="50" height="61px"/>
	</fo:block>
	<fo:block font-family="Helvetica" font-size="32pt" font-weight="bold" color="blue"
          text-align="center" space-after="20pt"> 
	  Metasploit Scan Report for <xsl:value-of select="/MetasploitV5/hosts/host/name" />
	<xsl:apply-templates/>
      </fo:block>

<!-- Table title -->
<fo:block font-family="Helvetica" text-align="center" font-size="12pt" font-weight="bold" space-before="9pt">
 Host Features
</fo:block>

<!-- Data's header & footer -->
<fo:table table-omit-header-at-break="true" table-omit-footer-at-break="true">
  <fo:table-column column-width="40mm"/>
  <fo:table-column column-width="160mm"/>
    <fo:table-header>
     <fo:table-row>
      <fo:table-cell>
       <fo:block font-family="Helvetica" text-align="left" font-size="12pt" font-weight="bold">
        Attribute
      </fo:block>
	</fo:table-cell>
	<fo:table-cell>
      <fo:block font-family="Helvetica" text-align="left" font-size="12pt" font-weight="bold">
        Value
      </fo:block>
    </fo:table-cell>
    </fo:table-row>
  </fo:table-header>

<!-- Host's report -->
  <fo:table-body>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Created at:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
		<xsl:value-of select="/MetasploitV5/hosts/host/created-at" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Address:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
		<xsl:value-of select="/MetasploitV5/hosts/host/address" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>    
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          MAC:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
		<xsl:value-of select="/MetasploitV5/hosts/host/mac" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>    
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Name:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
		<xsl:value-of select="/MetasploitV5/hosts/host/name" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>    
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          State:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
		<xsl:value-of select="/MetasploitV5/hosts/host/state" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>    
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          OS Name:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
		<xsl:value-of select="/MetasploitV5/hosts/host/os-name" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>    
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          OS Flavor:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
		<xsl:value-of select="/MetasploitV5/hosts/host/os-flavor" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>    
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          OS Version:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
		<xsl:value-of select="/MetasploitV5/hosts/host/os-sp" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>    
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          OS Language:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
		<xsl:value-of select="/MetasploitV5/hosts/host/os-lang" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>    
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Architecture:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
		<xsl:value-of select="/MetasploitV5/hosts/host/arch" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>    
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Purpose:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
		<xsl:value-of select="/MetasploitV5/hosts/host/purpose" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>    
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Information:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
		<xsl:value-of select="/MetasploitV5/hosts/host/info" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>    
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Comments:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
		<xsl:value-of select="/MetasploitV5/hosts/host/comments" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>    
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Virtual Host:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
		<xsl:value-of select="/MetasploitV5/hosts/host/virtual-host" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>    
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Vulnerabilities:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
		<xsl:value-of select="/MetasploitV5/hosts/host/vuln-count" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>    
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Services:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
		<xsl:value-of select="/MetasploitV5/hosts/host/service-count" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>    
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
         Exploits Tried: 
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
		<xsl:value-of select="/MetasploitV5/hosts/host/exploit-attempt-count" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>    
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Credentials Count:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
		<xsl:value-of select="/MetasploitV5/hosts/host/cred-count" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>    
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          OS Family:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
		<xsl:value-of select="/MetasploitV5/hosts/host/os-family" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>    
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Host Details:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
		<xsl:value-of select="/MetasploitV5/hosts/host/host_details" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
  </fo:table-body>
</fo:table>
</fo:flow>
<xsl:apply-templates/>
</fo:page-sequence> 

<fo:page-sequence master-name="exploits" master-reference="report">
<fo:flow flow-name="xsl-region-body">

<!-- Table title -->
<fo:block font-family="Helvetica" text-align="center" font-size="12pt" font-weight="bold" space-before="9pt">
 Exploits Attempted
</fo:block>

<!-- Data's header & footer -->
<fo:table table-omit-header-at-break="true" table-omit-footer-at-break="true">
  <fo:table-column column-width="40mm"/>
  <fo:table-column column-width="160mm"/>
    <fo:table-header>
     <fo:table-row>
      <fo:table-cell>
       <fo:block font-family="Helvetica" text-align="left" font-size="12pt" font-weight="bold">
        Attribute
      </fo:block>
	</fo:table-cell>
	<fo:table-cell>
      <fo:block font-family="Helvetica" text-align="left" font-size="12pt" font-weight="bold">
        Value
      </fo:block>
    </fo:table-cell>
    </fo:table-row>
  </fo:table-header>

<!-- Service found x module executed -->
<fo:table-body>
<xsl:for-each select="/MetasploitV5/hosts/host/exploit_attempts/exploit_attempt">
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Exploited:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="/MetasploitV5/hosts/host/exploit_attempts/exploit_attempt/exploited" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          User:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="/MetasploitV5/hosts/host/exploit_attempts/exploit_attempt/username" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Module:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="/MetasploitV5/hosts/host/exploit_attempts/exploit_attempt/module" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Port:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="/MetasploitV5/hosts/host/exploit_attempts/exploit_attempt/port" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Protocol:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="/MetasploitV5/hosts/host/exploit_attempts/exploit_attempt/proto" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Fail Reason:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="/MetasploitV5/hosts/host/exploit_attempts/exploit_attempt/fail-reason" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Fail Details:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="/MetasploitV5/hosts/host/exploit_attempts/exploit_attempt/fail-detail" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
</xsl:for-each>
  </fo:table-body>
</fo:table>
</fo:flow>
<xsl:apply-templates/>
</fo:page-sequence> 

<fo:page-sequence master-name="services" master-reference="report">
<fo:flow flow-name="xsl-region-body">

<!-- Table title -->
<fo:block font-family="Helvetica" text-align="center" font-size="12pt" font-weight="bold" space-before="9pt">
 Services found
</fo:block>

<!-- Data's header & footer -->
<fo:table table-omit-header-at-break="true" table-omit-footer-at-break="true">
  <fo:table-column column-width="40mm"/>
  <fo:table-column column-width="160mm"/>
    <fo:table-header>
     <fo:table-row>
      <fo:table-cell>
       <fo:block font-family="Helvetica" text-align="left" font-size="12pt" font-weight="bold">
        Attribute
      </fo:block>
	</fo:table-cell>
	<fo:table-cell>
      <fo:block font-family="Helvetica" text-align="left" font-size="12pt" font-weight="bold">
        Value
      </fo:block>
    </fo:table-cell>
    </fo:table-row>
  </fo:table-header>

<!-- Services found -->
<fo:table-body>
<xsl:for-each select="/MetasploitV5/hosts/host/services/service">
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Service Name:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="name" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Port:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="port" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Protocol:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="proto" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          State:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="state" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Information:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="info" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
     <fo:table-cell padding-before="0.5cm">
       <fo:block/>
     </fo:table-cell>
    </fo:table-row>	
</xsl:for-each>
</fo:table-body>
</fo:table>
</fo:flow>
<xsl:apply-templates/>
</fo:page-sequence>

<fo:page-sequence master-name="notes" master-reference="report">
<fo:flow flow-name="xsl-region-body">

<!-- Table title -->
<fo:block font-family="Helvetica" text-align="center" font-size="12pt" font-weight="bold" space-before="9pt">
 Notes About Scan
</fo:block>

<!-- Data's header & footer -->
<fo:table table-omit-header-at-break="true" table-omit-footer-at-break="true">
  <fo:table-column column-width="40mm"/>
  <fo:table-column column-width="160mm"/>
    <fo:table-header>
     <fo:table-row>
      <fo:table-cell>
       <fo:block font-family="Helvetica" text-align="left" font-size="12pt" font-weight="bold">
        Attribute
      </fo:block>
	</fo:table-cell>
	<fo:table-cell>
      <fo:block font-family="Helvetica" text-align="left" font-size="12pt" font-weight="bold">
        Value
      </fo:block>
    </fo:table-cell>
    </fo:table-row>
  </fo:table-header>

<!-- Notes -->
<fo:table-body>
<xsl:for-each select="/MetasploitV5/hosts/host/notes/note">
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Note Type:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="ntype" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Critical:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="critical" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Seen:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="seen" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Data:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="data" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
     <fo:table-cell padding-before="0.5cm">
       <fo:block/>
     </fo:table-cell>
    </fo:table-row>	
</xsl:for-each>
</fo:table-body>
</fo:table>
</fo:flow>
<xsl:apply-templates/>
</fo:page-sequence>

<fo:page-sequence master-name="vulnerabilities" master-reference="report">
<fo:flow flow-name="xsl-region-body">

<!-- Table title -->
<fo:block font-family="Helvetica" text-align="center" font-size="12pt" font-weight="bold" space-before="9pt">
 Vulnerabilities
</fo:block>

<!-- Data's header & footer -->
<fo:table table-omit-header-at-break="true" table-omit-footer-at-break="true">
  <fo:table-column column-width="40mm"/>
  <fo:table-column column-width="160mm"/>
    <fo:table-header>
     <fo:table-row>
      <fo:table-cell>
       <fo:block font-family="Helvetica" text-align="left" font-size="12pt" font-weight="bold">
        Attribute
      </fo:block>
	</fo:table-cell>
	<fo:table-cell>
      <fo:block font-family="Helvetica" text-align="left" font-size="12pt" font-weight="bold">
        Value
      </fo:block>
    </fo:table-cell>
    </fo:table-row>
  </fo:table-header>

<!-- Vulnerabilities -->
<fo:table-body>
<xsl:for-each select="/MetasploitV5/hosts/host/vulns/vuln">
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Vulnerability Name:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="name" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Vulnerability Information:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="info" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Vulnerability Attempts Count:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="vuln-attempt-count" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          CVE:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
	<xsl:for-each select="refs">
          <xsl:value-of select="ref" />
	</xsl:for-each>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Vulnerability Details:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="vuln_details" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>

<xsl:for-each select="vuln_attempts/vuln_attempt">
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Exploited:
        </fo:block>
      </fo:table-cell>	
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">	
          <xsl:value-of select="exploited" />	
        </fo:block>
      	</fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          User:
        </fo:block>
      </fo:table-cell>	
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">	
          <xsl:value-of select="username" />	
        </fo:block>
      	</fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Module:
        </fo:block>
      </fo:table-cell>	
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">	
          <xsl:value-of select="module" />	
        </fo:block>
      	</fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Fail Reason:
        </fo:block>
      </fo:table-cell>	
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">	
          <xsl:value-of select="fail-reason" />	
        </fo:block>
      	</fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Fail Details:
        </fo:block>
      </fo:table-cell>	
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">	
          <xsl:value-of select="fail-detail" />	
        </fo:block>
      	</fo:table-cell>
    </fo:table-row>
    <fo:table-row>
     <fo:table-cell padding-before="0.5cm">
       <fo:block/>
     </fo:table-cell>
    </fo:table-row>	
</xsl:for-each>
</xsl:for-each>
</fo:table-body>
<xsl:apply-templates/>
</fo:table>

</fo:flow>
<xsl:apply-templates/>
</fo:page-sequence> 




<xsl:if test="/MetasploitV5/hosts/host/exploit_attempts/exploit_attempt">
<fo:page-sequence master-name="modules" master-reference="report">
<fo:flow flow-name="xsl-region-body">
<!-- Table title -->
<fo:block font-family="Helvetica" text-align="center" font-size="12pt" font-weight="bold" space-before="9pt">
 Modules
</fo:block>

<!-- Data's header & footer -->
<fo:table table-omit-header-at-break="true" table-omit-footer-at-break="true">
  <fo:table-column column-width="40mm"/>
  <fo:table-column column-width="160mm"/>
    <fo:table-header>
     <fo:table-row>
      <fo:table-cell>
       <fo:block font-family="Helvetica" text-align="left" font-size="12pt" font-weight="bold">
        Attribute
      </fo:block>
	</fo:table-cell>
	<fo:table-cell>
      <fo:block font-family="Helvetica" text-align="left" font-size="12pt" font-weight="bold">
        Value
      </fo:block>
    </fo:table-cell>
    </fo:table-row>
  </fo:table-header>

<!-- Modules Info -->

<xsl:for-each select="/MetasploitV5/hosts/host/exploit_attempts/exploit_attempt">
<xsl:variable name="module_index" select="/MetasploitV5/hosts/host/exploit_attempts/exploit_attempt" />
<xsl:for-each select = "key('keyModuleName', $module_index/module)">
<fo:table-body>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          File:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select = "file"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Module Type:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select = "mtype"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Reference:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select = "refname"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Path Name:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">       
	  <xsl:value-of select = "fullname"/> 
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Name:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select = "name"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Rank:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select = "rank"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Description:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select = "description"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Disclosure Date:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select = "disclosure-date"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Default Target:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select = "default-target"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Stance:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select = "stance"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Module Author:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select = "module_authors/name"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Module References:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">	  
	  <xsl:value-of select = "module_refs/name"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Module Interpreter:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select = "module_archs/name"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Module Plataforms:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select = "module_platforms/name"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Module Targets:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
	  <xsl:value-of select = "module_targets/name"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
     <fo:table-cell padding-before="0.5cm">
       <fo:block/>
     </fo:table-cell>
    </fo:table-row>

</fo:table-body>
</xsl:for-each> 
</xsl:for-each>
</fo:table>
</fo:flow>
<xsl:apply-templates/>
</fo:page-sequence>
</xsl:if>


<xsl:if test="/MetasploitV5/web_sites">
<fo:page-sequence master-name="webservers" master-reference="report">
<fo:flow flow-name="xsl-region-body">
<!-- Module WMAP -->
<!-- Table title -->
<fo:block font-family="Helvetica" text-align="center" font-size="12pt" font-weight="bold" space-before="9pt">
 Web Sites
</fo:block>

<!-- Data's header & footer -->
<fo:table table-omit-header-at-break="true" table-omit-footer-at-break="true">
  <fo:table-column column-width="40mm"/>
  <fo:table-column column-width="160mm"/>
    <fo:table-header>
     <fo:table-row>
      <fo:table-cell>
       <fo:block font-family="Helvetica" text-align="left" font-size="12pt" font-weight="bold">
        Attribute
      </fo:block>
	</fo:table-cell>
	<fo:table-cell>
      <fo:block font-family="Helvetica" text-align="left" font-size="12pt" font-weight="bold">
        Value
      </fo:block>
    </fo:table-cell>
    </fo:table-row>
  </fo:table-header>

<!-- Web server -->
<fo:table-body>
<xsl:for-each select="/MetasploitV5/web_sites/web_site">

    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Virtual Host:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="vhost" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Comments:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="comments" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Options:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="options" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Host:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="host" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Port:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="port" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          TLS:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="ssl" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
   
 <fo:table-row>
     <fo:table-cell padding-before="0.5cm">
       <fo:block/>
     </fo:table-cell>
    </fo:table-row>	
</xsl:for-each>
</fo:table-body>
</fo:table>
</fo:flow>
<xsl:apply-templates/>
</fo:page-sequence>

<xsl:if test="/MetasploitV5/web_pages/web_page">
<fo:page-sequence master-name="webpages" master-reference="report">
<fo:flow flow-name="xsl-region-body">
<!-- Table title -->
<fo:block font-family="Helvetica" text-align="center" font-size="12pt" font-weight="bold" space-before="9pt">
 Web Pages
</fo:block>

<!-- Data's header & footer -->
<fo:table table-omit-header-at-break="true" table-omit-footer-at-break="true">
  <fo:table-column column-width="40mm"/>
  <fo:table-column column-width="160mm"/>
    <fo:table-header>
     <fo:table-row>
      <fo:table-cell>
       <fo:block font-family="Helvetica" text-align="left" font-size="12pt" font-weight="bold">
        Attribute
      </fo:block>
	</fo:table-cell>
	<fo:table-cell>
      <fo:block font-family="Helvetica" text-align="left" font-size="12pt" font-weight="bold">
        Value
      </fo:block>
    </fo:table-cell>
    </fo:table-row>
  </fo:table-header>

<!-- Web pages -->
<fo:table-body>
<xsl:for-each select="/MetasploitV5/web_pages">
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Web Page:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="web_page" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
     <fo:table-cell padding-before="0.5cm">
       <fo:block/>
     </fo:table-cell>
    </fo:table-row>	
</xsl:for-each>
</fo:table-body>
</fo:table>
</fo:flow>
<xsl:apply-templates/>
</fo:page-sequence>
</xsl:if>

<xsl:if test="/MetasploitV5/web_forms/web_form">
<fo:page-sequence master-name="webforms" master-reference="report">
<fo:flow flow-name="xsl-region-body">
<!-- Table title -->
<fo:block font-family="Helvetica" text-align="center" font-size="12pt" font-weight="bold" space-before="9pt">
 Web Forms
</fo:block>

<!-- Data's header & footer -->
<fo:table table-omit-header-at-break="true" table-omit-footer-at-break="true">
  <fo:table-column column-width="40mm"/>
  <fo:table-column column-width="160mm"/>
    <fo:table-header>
     <fo:table-row>
      <fo:table-cell>
       <fo:block font-family="Helvetica" text-align="left" font-size="12pt" font-weight="bold">
        Attribute
      </fo:block>
	</fo:table-cell>
	<fo:table-cell>
      <fo:block font-family="Helvetica" text-align="left" font-size="12pt" font-weight="bold">
        Value
      </fo:block>
    </fo:table-cell>
    </fo:table-row>
  </fo:table-header>

<!-- Web forms -->
<fo:table-body>
<xsl:for-each select="/MetasploitV5/web_forms">
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Web Form:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="web_form" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
     <fo:table-cell padding-before="0.5cm">
       <fo:block/>
     </fo:table-cell>
    </fo:table-row>	
</xsl:for-each>
</fo:table-body>
</fo:table>
</fo:flow>
<xsl:apply-templates/>
</fo:page-sequence>
</xsl:if>

<xsl:if test="/MetasploitV5/web_vulns/web_vuln">
<fo:page-sequence master-name="webvulns" master-reference="report">
<fo:flow flow-name="xsl-region-body">
<!-- Table title -->
<fo:block font-family="Helvetica" text-align="center" font-size="12pt" font-weight="bold" space-before="9pt">
 Web Vulnerabilities
</fo:block>

<!-- Data's header & footer -->
<fo:table table-omit-header-at-break="true" table-omit-footer-at-break="true">
  <fo:table-column column-width="40mm"/>
  <fo:table-column column-width="160mm"/>
    <fo:table-header>
     <fo:table-row>
      <fo:table-cell>
       <fo:block font-family="Helvetica" text-align="left" font-size="12pt" font-weight="bold">
        Attribute
      </fo:block>
	</fo:table-cell>
	<fo:table-cell>
      <fo:block font-family="Helvetica" text-align="left" font-size="12pt" font-weight="bold">
        Value
      </fo:block>
    </fo:table-cell>
    </fo:table-row>
  </fo:table-header>

<!-- Web vulnerabilities -->
<fo:table-body>
<xsl:for-each select="/MetasploitV5/web_vulns/web_vuln">
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Path:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="path" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Method:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="method" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Params:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="params" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Param Name:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="pname" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Risk:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="risk" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Name:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="name" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Query:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="query" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Category:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="category" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Confidence:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="confidence" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Description:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="description" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Blame:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="blame" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Request:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="request" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Proof:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="proof" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Owner:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="owner" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Payload:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="payload" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Vhost:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="vhost" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Host:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="host" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Port:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="port" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          TLS:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:value-of select="ssl" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
     <fo:table-cell padding-before="0.5cm">
       <fo:block/>
     </fo:table-cell>
    </fo:table-row>	
</xsl:for-each>
</fo:table-body>
</fo:table>
</fo:flow>
<xsl:apply-templates/>
</fo:page-sequence>
</xsl:if>
</xsl:if>	

</fo:root>
</xsl:template>
</xsl:stylesheet>
