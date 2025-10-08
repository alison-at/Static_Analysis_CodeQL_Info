import java

from Expr e
where e.getParent() instanceof ReturnStmt
select e