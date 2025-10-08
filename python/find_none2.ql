import python

from 
   Expr E
where
    exists(E) and
    E instanceof None
select 
    E.toString()