import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.ApiGraphs

private module NoneFlowConfig implements DataFlow::ConfigSig {

  predicate isSource(DataFlow::Node source) {
    exists(Assign assign, Expr lhs |
      assign.getValue() instanceof None and
      //this is redundant over two lines, checking that the assigned variable is the source
      assign.getATarget() = lhs and
      source.asExpr() = lhs
    )
  }

  predicate isSink(DataFlow::Node sink) {
    // Existing sinks: left or any comparator of a comparison
    exists(Compare cmp |
      sink.asExpr() = cmp.getLeft() or

      //there is no getRight() because comparisons can have multiple comparators
      // we check each comparator to see if the sink matches any of them
      exists(Expr right |
        cmp.getAComparator() = right and
        sink.asExpr() = right
      )
    )
    or
    // New sink: unary expressions with operator "not"
    exists(UnaryExpr ue |
      sink.asExpr() = ue and
      ue.getOp().toString() = "not"
    )
  }


/** 
   predicate isSink(DataFlow::Node sink) {
    exists(Compare cmp |
        sink.asExpr() = cmp.getLeft() or
        exists(Expr right |
        cmp.getAComparator() = right and
        sink.asExpr() = right
        )
    )
    }*/

}

module Flow = TaintTracking::Global<NoneFlowConfig>;

from Flow::PathNode source, Flow::PathNode sink
where Flow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "Value that may be None flows into this comparison operand."
