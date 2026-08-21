public import Graph_Sequential_Primitives

extension Machine {

    public struct Program<Leaf, Failure: Swift.Error, Mode> {

        public let graph: Graph.Sequential<Node<Leaf, Failure, Mode>, Node<Leaf, Failure, Mode>>

        public let captures: Machine.Capture.Frozen<Mode>

        public let maxDepth: Int?

        @usableFromInline
        init(
            graph: Graph.Sequential<Node<Leaf, Failure, Mode>, Node<Leaf, Failure, Mode>>,
            captures: Machine.Capture.Frozen<Mode>,
            maxDepth: Int?
        ) {
            self.graph = graph
            self.captures = captures
            self.maxDepth = maxDepth
        }
    }
}

extension Machine.Program: Sendable where Leaf: Sendable, Mode: Sendable {}

extension Machine.Program {

    @inlinable
    public subscript(id: Machine.Node<Leaf, Failure, Mode>.ID) -> Machine.Node<Leaf, Failure, Mode>
    {
        graph[id]
    }

    @inlinable
    public var analyze:
        Graph.Sequential<Machine.Node<Leaf, Failure, Mode>, Machine.Node<Leaf, Failure, Mode>>
            .Analyze<[Machine.Node<Leaf, Failure, Mode>.ID]>
    {
        graph.analyze(using: Machine.Node.extract)
    }
}
