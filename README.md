Notes on current progress:
buggy-requests is a CodeQL database of a buggy out of date version of the request codebase.

The issue targetted is the 'host' variables, which is dynamically determined at runtime. 
I am testing dataflow analysis queries which identify the uncertain typing of host
and where it is used in method calls. 

source_query_general.ql is able to identify a number of dynamically typed variables determined at
runtime and where they are used in method calls. 'host' is not identified when it is passed to 
urlunparse because it is passed as a parameter array, instead of as its own parameter. This
demonstrates some of the uncertainty in using codeql queries in general - they rely on exact syntax.
