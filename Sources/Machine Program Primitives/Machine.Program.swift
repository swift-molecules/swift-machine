// SDG(specializes): Machine.Program is a directed graph with Graph.Sequential storage
public import Graph_Sequential_Primitives

extension Machine {
    /// A program consisting of a graph of nodes.
    ///
    /// `Program` stores the node graph that represents a defunctionalized parser.
    /// Nodes are allocated sequentially and referenced by their IDs. The program
    /// is generic over:
    /// - `Leaf`: The primitive cursor operations
    /// - `Failure`: The error type for fallible operations
    /// - `Mode`: The capture mode (`Mode.Reference` or `Mode.Unchecked`)
    public struct Program<Leaf, Failure: Swift.Error, Mode> {
        /// The sequentially-allocated node graph.
        public let graph: Graph.Sequential<Node<Leaf, Failure, Mode>, Node<Leaf, Failure, Mode>>

        /// The frozen capture snapshot the interpreter reads at run time.
        public let captures: Machine.Capture.Frozen<Mode>

        /// Optional maximum machine-stack depth enforced at run time.
        // swift-linter:disable:next compound identifier
        // REASON: two-word stored property with no sibling sharing a leading
        // word (API-NAME-002 shape (a)); nothing to group into a namespace.
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
    /// Accesses a node by its ID.
    @inlinable
    public subscript(id: Machine.Node<Leaf, Failure, Mode>.ID) -> Machine.Node<Leaf, Failure, Mode> {
        graph[id]
    }

    /// Analysis accessor for graph algorithms.
    @inlinable
    public var analyze: Graph.Sequential<Machine.Node<Leaf, Failure, Mode>, Machine.Node<Leaf, Failure, Mode>>.Analyze<[Machine.Node<Leaf, Failure, Mode>.ID]> {
        graph.analyze(using: Machine.Node.extract)
    }
}
