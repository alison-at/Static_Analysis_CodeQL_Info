import python
import semmle.python.dataflow.new.DataFlow

/**
 * Gets a descriptive string for the CodeQL AST class of an assignment target expression (e.g., Name or Attribute).
 */
string getTargetType(Expr target) {
  if target instanceof Name
  then result = "Name (simple variable)"
  else if target instanceof Attribute
  then result = "Attribute (e.g., self.host)"
  else result = "Other Assignment Target Type"
}

/**
 * Gets a descriptive string for the type of the value expression (Expr) being assigned.
 * This primarily flags dangerous literal types or identifies dynamic lookups.
 */
string getAssignedStringType(Expr value) {
  if value instanceof Bytes
  then result = "Potentially VULNERABLE Bytestring ('bytes') Literal" // Catches hardcoded b'string'
  else if value instanceof Unicode or value instanceof Str
  then result = "Unicode/Str Literal (Standard String)"
  else result = "Dynamic Value (Subscript: self._r.headers['Host']) - Source of Vulnerability" // Catches the dynamic lookup
}

from Assign assign, Subscript sub, Expr target
where
  // 1. Find the assignment where the value is the subscript 'headers['Host']'
  assign.getValue() = sub and
  assign.getATarget() = target and

  // 2. Subscript conditions to ensure it's headers['Host']
  exists(Expr baseExpr, StringLiteral indexExpr |
    sub.getObject() = baseExpr and
    baseExpr instanceof Attribute and
    baseExpr.(Attribute).getAttr() = "headers" and
    sub.getIndex() = indexExpr and
    indexExpr.getS() = "Host"
  )
  
select assign, 
  target.toString(), 
  getTargetType(target),
  getAssignedStringType(sub)