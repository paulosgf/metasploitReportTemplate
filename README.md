# metasploitReportTemplate
Metasploit's V5 PDF report template.

Designed for report only from one host from XML file exported from database with comand: db_export -f xml -a /root/hostname.xml.

This report shows the return of default module, the pentest module from 
https://raw.github.com/darkoperator/Metasploit-Plugins/master/pentest.rb and, optionally, the report of optional exploitations such as sudo, wmap modules, and auto_brute.rc and auto_pass_the_hash.rc resource files.

To convert to PDF, download Apache's FOP from https://xmlgraphics.apache.org/fop/download.html and execute the following command:

xsltproc metasploitReportTemplate.xsl hostname.xml > hostname.fo

apache-fop/bin/fop hostname.fo hostname.pdf
