None comparator Query:
buggy-clusterfuzz-codeql-db is a CodeQL database built from clusterfuzz commit ebfce346447911172299f6867ad9567bf48c97c8^1.

The command to build the database was
```
codeql database create ../codeql_python_databases/buggy-clusterfuzz-codeql-db --language=python
```
find_none.ql finds every variable potentially of type None which is used as a comparator or 
as a unary operator with the keyword **not**.

---
Dynamic Variables Query:
buggy-requests is a CodeQL database of a buggy out of date version of the request codebase.
The command to build the database was
```
codeql database create ../codeql_python_databases/buggy-requests-codeql-db --language=python
```
The issue targetted is the 'host' variables, which is dynamically determined at runtime. 
I am testing dataflow analysis queries which identify the uncertain typing of host
and where it is used in method calls. 

source_query_general.ql is able to identify a number of dynamically typed variables determined at
runtime and where they are used in method calls. 'host' is not identified when it is passed to 
urlunparse because it is passed as a parameter array, instead of as its own parameter. This
demonstrates some of the uncertainty in using codeql queries in general - they rely on exact syntax.
