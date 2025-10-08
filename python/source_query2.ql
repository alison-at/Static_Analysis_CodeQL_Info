/**
 * @kind path-problem
 * @problem.severity error
 * @id python/str-bytes-type-confusion
 * @tags security experimental
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.RemoteFlowSources

private module TypeConfusedConfig implements DataFlow::ConfigSig {
  
  // 1. Define the SOURCE: The dynamic header value from headers['Host']
  predicate isSource(DataFlow::Node source) {
    // Looks for the Subscript access to 'headers['Host']'
    exists(Subscript sub, Attribute attr, StringLiteral index |
      sub.getObject() = attr and
      attr.getAttr() = "headers" and
      index.getS() = "Host" and // Specifically targets the 'Host' key
      source.asExpr() = sub
    )
  }

  // 2. Define the SINK: An argument to the vulnerable function 'urlunparse'
  predicate isSink(DataFlow::Node sink) {
    exists(Call call | 
      call.getFunc().(Name).getId() = "urlunparse" and
      // The sink is one of the arguments to urlunparse
      sink.asExpr() = call.getAnArg()
    )
  }
}

// 3. Create the global taint tracking flow model using the configuration
module Flow = TaintTracking::Global<TypeConfusedConfig>; 

// 4. Select the results where the taint flows from source to sink
from Flow::PathNode source, Flow::PathNode sink
where Flow::flowPath(source, sink)
select sink.getNode().asExpr(), source.getNode().asExpr(), 
  "The dynamic header value from 'headers['Host']' reaches 'urlunparse' inside method '" +
  // FIX: Using getScope().getName() on the sink's expression
  sink.getNode().asExpr().getScope().getName() + "', " +
  "posing a risk of str/bytes type confusion in Python 3."