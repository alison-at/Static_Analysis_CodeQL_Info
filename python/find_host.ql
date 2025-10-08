
/*
import python

from Assign assign, Expr target, Expr value, Subscript sub, Expr base, Expr indexExpr, StringLiteral strLit
where
  // Find assignments like host = ...
  assign.getATarget() = target and
  assign.getValue() = value and

  // The value is a subscript expression (e.g., something[key])
  value = sub and
  
  base = sub.getObject() and
  indexExpr = sub.getIndex() and

  // The base is an attribute access to "headers" (like self._r.headers)
  base instanceof Attribute and
  base.(Attribute).getAttr() = "headers" and

  // The index is the string literal "Host"
  indexExpr instanceof StringLiteral and
  indexExpr.(StringLiteral).getValue() = "Host" and

  value = strLit
select value, 
  (strLit.getClass().getName() = "Bytes") as isBytes, 
  (strLit.getClass().getName() = "Unicode") as isUnicode, 
  "Is this 'Host' value bytes or unicode?"
  */
 import python

from Subscript sub, Expr baseExpr, StringLiteral indexExpr
where
  sub.getObject() = baseExpr and
  sub.getIndex() = indexExpr and
  (indexExpr instanceof Bytes or indexExpr instanceof Unicode) and
  indexExpr.getS() = "Host"
select baseExpr.toString(), sub, "Subscript with index 'Host'"
