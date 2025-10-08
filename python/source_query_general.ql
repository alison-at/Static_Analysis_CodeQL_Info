/**
 * @kind path-problem
 * @problem.severity warning
 * @id python/general-dynamic-data-to-method
 * @name Dynamic Data Flow to Method Argument
 * @tags security experimental taint
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.ApiGraphs

private module GeneralDynamicFlowConfig implements DataFlow::ConfigSig {
    /*
  // Define untrusted sources using API::Node -> DataFlow::Node via .asSource()
  predicate isSource(DataFlow::Node source) {
    source = API::moduleImport("flask").getMember("request").getMember("args").asSource() or
    source = API::moduleImport("flask").getMember("request").getMember("form").asSource() or
    source = API::moduleImport("flask").getMember("request").getMember("json").asSource() or
    source = API::moduleImport("os").getMember("environ").asSource() or
    source = API::moduleImport("builtins").getMember("input").asSource()
  }*/

  predicate isSource(DataFlow::Node source) {
  exists(API::Node apiNode |
    (
      apiNode = API::moduleImport("flask").getMember("request").getMember("args") or
      apiNode = API::moduleImport("flask").getMember("request").getMember("form") or
      apiNode = API::moduleImport("flask").getMember("request").getMember("json") or
      apiNode = API::moduleImport("os").getMember("environ") or
      apiNode = API::moduleImport("builtins").getMember("input")
    ) and
    source = apiNode.getAValueReachableFromSource()
    )
    }

  // Sink: any argument to any function
  predicate isSink(DataFlow::Node sink) {
    exists(Call call |
      sink.asExpr() = call.getAnArg()
    )
  }
}

module Flow = TaintTracking::Global<GeneralDynamicFlowConfig>;

from Flow::PathNode source, Flow::PathNode sink
where Flow::flowPath(source, sink)
select sink, source,
  "Untrusted data from a dynamic source flows into a method argument in '" +
  sink.getNode().asExpr().getScope().getName() + "'. Review for potential type confusion or security issues."
