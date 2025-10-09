Notes on current progress:
buggy-requests is a CodeQL database of a buggy out of date version of the request codebase.

The issue targetted is the 'host' variables, which is dynamically determined at runtime. 
I am testing dataflow analysis queries which identify the uncertain typing of host
and where it is used in method calls. 
