import python

predicate isFunctionOrCall(Expr expr, string kind) {
  (expr instanceof Call and kind = "Function call")
}

from Expr e, string k
where isFunctionOrCall(e, k)
select e, k, e.getLocation(), e.toString()
