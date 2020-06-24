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


<!-- This allow the text fit into table's cell space -->
<xsl:template match="text()[parent::entry]">
    <xsl:call-template name="intersperse-with-zero-spaces">
        <xsl:with-param name="str" select="."/>
    </xsl:call-template>
</xsl:template>
<xsl:template name="intersperse-with-zero-spaces">
    <xsl:param name="str"/>
    <xsl:variable name="spacechars">
        &#x9;&#xA;
        &#x2000;&#x2001;&#x2002;&#x2003;&#x2004;&#x2005;
        &#x2006;&#x2007;&#x2008;&#x2009;&#x200A;&#x200B;
    </xsl:variable>

    <xsl:if test="string-length($str) &gt; 0">
        <xsl:variable name="c1" select="substring($str, 1, 1)"/>
        <xsl:variable name="c2" select="substring($str, 2, 1)"/>

        <xsl:value-of select="$c1"/>
        <xsl:if test="$c2 != '' and
            not(contains($spacechars, $c1) or
            contains($spacechars, $c2))">
            <xsl:text>&#x200B;</xsl:text>
        </xsl:if>

        <xsl:call-template name="intersperse-with-zero-spaces">
            <xsl:with-param name="str" select="substring($str, 2)"/>
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template match="/">
<fo:root>	
<!-- Initial document layout -->
<fo:layout-master-set>
    <fo:simple-page-master master-name="report"
        page-height="297mm"
        page-width="220mm"
        margin-top="1cm"
        margin-bottom="1cm"
        margin-left="1cm"
        margin-right="1cm">
  	  <fo:region-body   margin="1cm"/>
	  <fo:region-before extent="2cm"/>
	  <fo:region-after  extent="1cm"/>
	  <fo:region-start  extent="2cm"/>
	  <fo:region-end    extent="2cm"/>
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
<fo:table table-omit-header-at-break="true" table-omit-footer-at-break="true" table-layout="fixed" width="100%">
  <fo:table-column column-width="40mm"/>
  <fo:table-column column-width="140mm"/>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="/MetasploitV5/hosts/host/created-at"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="/MetasploitV5/hosts/host/address"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="/MetasploitV5/hosts/host/mac"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="/MetasploitV5/hosts/host/name"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="/MetasploitV5/hosts/host/state"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="/MetasploitV5/hosts/host/os-name"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="/MetasploitV5/hosts/host/os-flavor"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="/MetasploitV5/hosts/host/os-sp"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="/MetasploitV5/hosts/host/os-lang"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="/MetasploitV5/hosts/host/arch"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="/MetasploitV5/hosts/host/purpose"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="/MetasploitV5/hosts/host/info"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="/MetasploitV5/hosts/host/comments"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="/MetasploitV5/hosts/host/virtual-host"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="/MetasploitV5/hosts/host/vuln-count"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="/MetasploitV5/hosts/host/service-count"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="/MetasploitV5/hosts/host/exploit-attempt-count"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="/MetasploitV5/hosts/host/cred-count"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="/MetasploitV5/hosts/host/os-family"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="/MetasploitV5/hosts/host/host_details"/>
	  </xsl:call-template>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
  </fo:table-body>
</fo:table>
</fo:flow>
<xsl:apply-templates/>
</fo:page-sequence> 

<!-- Header -->
<fo:page-sequence master-name="exploits" master-reference="report">
<fo:static-content flow-name="xsl-region-before">
      <fo:block font-family="Helvetica" font-size="8pt" text-align="center">
	      <xsl:value-of select="/MetasploitV5/hosts/host/created-at" />
	<xsl:apply-templates/>
      </fo:block>
</fo:static-content>

<xsl:if test="/MetasploitV5/hosts/host/exploit_attempts/exploit_attempt/*">
<!-- Footer -->
<fo:static-content flow-name="xsl-region-after">
     <fo:block font-family="Helvetica" font-size="8pt" text-align="center">
         <fo:page-number />
     </fo:block>
</fo:static-content>

<fo:flow flow-name="xsl-region-body">

<!-- Table title -->
<fo:block font-family="Helvetica" text-align="center" font-size="12pt" font-weight="bold" space-before="9pt">
 Exploits Attempted
</fo:block>

<!-- Data's header & footer -->
<fo:table table-omit-header-at-break="true" table-omit-footer-at-break="true" table-layout="fixed" width="100%">
  <fo:table-column column-width="40mm"/>
  <fo:table-column column-width="140mm"/>
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

<!-- for each child node tests if child of parent's node is equal this, and if it is, jump to next children -->
<xsl:for-each select="MetasploitV5/hosts/host/exploit_attempts">
<xsl:for-each select="exploit_attempt">
<xsl:if test="(vuln-id != preceding-sibling::exploit_attempt[1]/vuln-id) or position()=1">
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Exploited:
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="exploited"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="username"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="module"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="port"/>
	  </xsl:call-template>
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
           <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="proto"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="fail-reason"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="fail-detail"/>
	  </xsl:call-template>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell padding-before="0.5cm">
        <fo:block/>
      </fo:table-cell>
    </fo:table-row>

</xsl:if>
</xsl:for-each>

</xsl:for-each>
</fo:table-body>
</fo:table>
</fo:flow>
<xsl:apply-templates/>
</xsl:if>
</fo:page-sequence> 

<!-- Header -->
<fo:page-sequence master-name="services" master-reference="report">
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

<fo:flow flow-name="xsl-region-body">

<!-- Table title -->
<fo:block font-family="Helvetica" text-align="center" font-size="12pt" font-weight="bold" space-before="9pt">
 Services found
</fo:block>

<!-- Data's header & footer -->
<fo:table table-omit-header-at-break="true" table-omit-footer-at-break="true" table-layout="fixed" width="100%">
  <fo:table-column column-width="40mm"/>
  <fo:table-column column-width="140mm"/>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="name"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="port"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="proto"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="state"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="info"/>
	  </xsl:call-template>
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

<!-- Header -->
<fo:page-sequence master-name="notes" master-reference="report">
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

<fo:flow flow-name="xsl-region-body">

<!-- Table title -->
<fo:block font-family="Helvetica" text-align="center" font-size="12pt" font-weight="bold" space-before="9pt">
 Notes About Scan
</fo:block>

<!-- Data's header & footer -->
<fo:table table-omit-header-at-break="true" table-omit-footer-at-break="true" table-layout="fixed" width="100%">
  <fo:table-column column-width="40mm"/>
  <fo:table-column column-width="140mm"/>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="ntype"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="critical"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="seen"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="data"/>
	  </xsl:call-template>
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

<!-- Header -->
<fo:page-sequence master-name="vulnerabilities" master-reference="report">
<fo:static-content flow-name="xsl-region-before">
      <fo:block font-family="Helvetica" font-size="8pt" text-align="center">
	      <xsl:value-of select="/MetasploitV5/hosts/host/created-at" />
	<xsl:apply-templates/>
      </fo:block>
</fo:static-content>

<!-- new line variabe to fit CVE's cell -->
<xsl:variable name="newline"><xsl:text>&#xa;</xsl:text></xsl:variable>
<!-- Footer -->
<fo:static-content flow-name="xsl-region-after">
     <fo:block font-family="Helvetica" font-size="8pt" text-align="center">
         <fo:page-number />
     </fo:block>
</fo:static-content>

<fo:flow flow-name="xsl-region-body">

<!-- Table title -->
<fo:block font-family="Helvetica" text-align="center" font-size="12pt" font-weight="bold" space-before="9pt">
 Vulnerabilities
</fo:block>

<!-- Data's header & footer -->
<fo:table table-omit-header-at-break="true" table-omit-footer-at-break="true" table-layout="fixed" width="100%">
  <fo:table-column column-width="40mm"/>
  <fo:table-column column-width="140mm"/>
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
           <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="name"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="info"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="vuln-attempt-count"/>
	  </xsl:call-template>
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
	<xsl:for-each select="refs/ref">
          <xsl:call-template name="intersperse-with-zero-spaces">
            <!-- concatenate CVE's lines with new line char -->
            <xsl:with-param name="str" select="concat(., $newline)" />
	        </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="vuln_details"/>
	  </xsl:call-template>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>

  <xsl:for-each select="vuln_attempts/vuln_attempt">
    <xsl:if test="(module != preceding-sibling::vuln_attempt[1]/module) or position()=1">
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Exploited:
        </fo:block>
      </fo:table-cell>	
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">	
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="exploited"/>
	  </xsl:call-template>	
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="module"/>
	  </xsl:call-template>	
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="fail-reason"/>
	  </xsl:call-template>	
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="fail-detail"/>
	  </xsl:call-template>	
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="username"/>
	  </xsl:call-template>	
        </fo:block>
      	</fo:table-cell>
    </fo:table-row>

<!-- Include passwords found on brute force scan -->
    <fo:table-row>
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt" font-weight="bold">
          Passord:
        </fo:block>
      </fo:table-cell>	
      <fo:table-cell>
        <fo:block wrap-option="wrap" font-family="Helvetica" text-align="left" font-size="9pt">	
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="password"/>
	  </xsl:call-template>	
        </fo:block>
      	</fo:table-cell>
    </fo:table-row>
    <fo:table-row>
     <fo:table-cell padding-before="0.5cm">
       <fo:block/>
     </fo:table-cell>
    </fo:table-row>
    </xsl:if>	
</xsl:for-each>

</xsl:for-each>
</fo:table-body>
<xsl:apply-templates/>
</fo:table>

</fo:flow>
<xsl:apply-templates/>
</fo:page-sequence> 

<!-- Metasploit's team had droped out module info support -->
<xsl:if test="/MetasploitV5/module_details/module_detail/*">
<xsl:if test="/MetasploitV5/hosts/host/exploit_attempts/exploit_attempt">
<!-- Header -->
<fo:page-sequence master-name="modules" master-reference="report">
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

<fo:flow flow-name="xsl-region-body">
<!-- Table title -->
<fo:block font-family="Helvetica" text-align="center" font-size="12pt" font-weight="bold" space-before="9pt">
 Modules
</fo:block>

<!-- Data's header & footer -->
<fo:table table-omit-header-at-break="true" table-omit-footer-at-break="true" table-layout="fixed" width="100%">
  <fo:table-column column-width="40mm"/>
  <fo:table-column column-width="140mm"/>
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
<!-- using key to search modules info -->
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="file"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="mtype"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="refname"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="fullname"/>
	  </xsl:call-template> 
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="name"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="rank"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="description"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="disclosure-date"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="default-target"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="stance"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="module_authors/name"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="module_refs/name"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="module_archs/name"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="module_platforms/name"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="module_targets/name"/>
	  </xsl:call-template>
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
</xsl:if>

<xsl:if test="/MetasploitV5/web_sites/*">
<!-- Header -->
<fo:page-sequence master-name="webservers" master-reference="report">
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

<fo:flow flow-name="xsl-region-body">
<!-- Module WMAP -->
<!-- Table title -->
<fo:block font-family="Helvetica" text-align="center" font-size="12pt" font-weight="bold" space-before="9pt">
 Web Sites
</fo:block>

<!-- Data's header & footer -->
<fo:table table-omit-header-at-break="true" table-omit-footer-at-break="true" table-layout="fixed" width="100%">
  <fo:table-column column-width="40mm"/>
  <fo:table-column column-width="140mm"/>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="vhost"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="comments"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="options"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="host"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="port"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="ssl"/>
	  </xsl:call-template>
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
<!-- Header -->
<fo:page-sequence master-name="webpages" master-reference="report">
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

<fo:flow flow-name="xsl-region-body">
<!-- Table title -->
<fo:block font-family="Helvetica" text-align="center" font-size="12pt" font-weight="bold" space-before="9pt">
 Web Pages
</fo:block>

<!-- Data's header & footer -->
<fo:table table-omit-header-at-break="true" table-omit-footer-at-break="true" table-layout="fixed" width="100%">
  <fo:table-column column-width="40mm"/>
  <fo:table-column column-width="140mm"/>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="web_page"/>
	  </xsl:call-template>
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
<!-- Header -->
<fo:page-sequence master-name="webforms" master-reference="report">
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

<fo:flow flow-name="xsl-region-body">
<!-- Table title -->
<fo:block font-family="Helvetica" text-align="center" font-size="12pt" font-weight="bold" space-before="9pt">
 Web Forms
</fo:block>

<!-- Data's header & footer -->
<fo:table table-omit-header-at-break="true" table-omit-footer-at-break="true" table-layout="fixed" width="100%">
  <fo:table-column column-width="40mm"/>
  <fo:table-column column-width="140mm"/>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="web_form"/>
	  </xsl:call-template>
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
<!-- Header -->
<fo:page-sequence master-name="webvulns" master-reference="report">
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

<fo:flow flow-name="xsl-region-body">
<!-- Table title -->
<fo:block font-family="Helvetica" text-align="center" font-size="12pt" font-weight="bold" space-before="9pt">
 Web Vulnerabilities
</fo:block>

<!-- Data's header & footer -->
<fo:table table-omit-header-at-break="true" table-omit-footer-at-break="true" table-layout="fixed" width="100%">
  <fo:table-column column-width="40mm"/>
  <fo:table-column column-width="140mm"/>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="path"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="method"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="params"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="pname"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="risk"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="name"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="query"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="category"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="confidence"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="description"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="blame"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="request"/>
	  </xsl:call-template>
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
           <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="proof"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="owner"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="payload"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="vhost"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="host"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="port"/>
	  </xsl:call-template>
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
          <xsl:call-template name="intersperse-with-zero-spaces">
    	    <xsl:with-param name="str" select="ssl"/>
	  </xsl:call-template>
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
