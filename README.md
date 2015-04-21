
Site Environment Reports
========================

This suite of scripts generates an environmental report of conditions and
extremes, for use in designing moorings and planning cruises in the vicinity  
of a proposed monitoring
site.


cvs to git 
----------

Originally under CVS control, this repository was transferred to git around
2015-04-20. Some of the original documentation is no longer applicable. 


Use "cvs export -D`fdate` site-environment" to generate a clean version of
the site environment directory structure from the CVS repository without
generating the CVS administration files. You do not
want to do "cvs checkout" because you are going to be populating the
structure with data and modifying the templates for the particular site you are
working with, and a "cvs ci" will hand these changes back to the
repository. This is probably not what you want to do. 

For further processing consult the document
site-environment-report-generation.pdf in the structure (generate it by the
usual route from the .tex file).




