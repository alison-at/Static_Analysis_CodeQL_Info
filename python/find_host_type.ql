import python

/**
 * Gets a descriptive string for the CodeQL AST class of an assignment target expression.
 */
string getTargetType(Expr target) {
  if target instanceof Name
  then result = "Name (simple variable)"
  else if target instanceof Attribute
  then result = "Attribute (e.g., self.host)"
  else if target instanceof Subscript
  then result = "Subscript (e.g., list[i])"
  else result = "Other Expression Type"
}

from Assign assign, Subscript sub, Expr target
where
  // Find the assignment statement where the value is the subscript expression
  assign.getValue() = sub and
  assign.getATarget() = target and

  // Conditions for the subscript expression
  exists(Expr baseExpr, StringLiteral indexExpr |
    sub.getObject() = baseExpr and
    sub.getIndex() = indexExpr and
    (indexExpr instanceof Bytes or indexExpr instanceof Unicode) and
    indexExpr.getS() = "Host"
  )
  
select target, getTargetType(target), "Host variable assignment target and its CodeQL AST class."