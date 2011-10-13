all: doc

doc: doc_man doc_html

doc_html: html-stamp

html-stamp: grml2hd.txt
	asciidoc -b xhtml11 grml2hd.txt
	touch html-stamp

doc_man: man-stamp

man-stamp: grml2hd.txt
	asciidoc -d manpage -b docbook grml2hd.txt
	sed -i 's/<emphasis role="strong">/<emphasis role="bold">/' grml2hd.xml
	xsltproc --novalid --nonet /usr/share/xml/docbook/stylesheet/nwalsh/manpages/docbook.xsl grml2hd.xml
	# ugly hack to avoid duplicate empty lines in manpage
	# note: docbook-xsl 1.71.0.dfsg.1-1 is broken! make sure you use 1.68.1.dfsg.1-0.2!
	cp grml2hd.8 grml2hd.8.tmp
	uniq grml2hd.8.tmp > grml2hd.8
	# ugly hack to avoid '.sp' at the end of a sentence or paragraph:
	sed -i 's/\.sp//' grml2hd.8
	rm grml2hd.8.tmp
	touch man-stamp

clean:
	rm -rf grml2hd.html grml2hd.xml grml2hd.8 html-stamp man-stamp
