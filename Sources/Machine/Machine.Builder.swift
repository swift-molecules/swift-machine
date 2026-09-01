public import Graph

extension Machine {

    public struct Builder<Leaf, Failure: Swift.Error, Mode>: ~Copyable {
        @usableFromInline
        var storage: Graph.Sequential<Node<Leaf, Failure, Mode>, Node<Leaf, Failure, Mode>>.Builder

        public var captures: Capture.Store<Mode>

        public let maxDepth: Int?

        @inlinable
        public init(maxDepth: Int? = nil) {
            self.storage = .init()
            self.captures = Capture.Store<Mode>()
            self.maxDepth = maxDepth
        }
    }
}

extension Machine.Builder {

    @inlinable
    public var count: Machine.Node<Leaf, Failure, Mode>.ID.Count {
        storage.count
    }

    @inlinable
    public mutating func allocate(
        _ node: Machine.Node<Leaf, Failure, Mode>
    ) -> Machine.Node<Leaf, Failure, Mode>.ID {
        storage.allocate(node)
    }

    @inlinable
    public subscript(id: Machine.Node<Leaf, Failure, Mode>.ID) -> Machine.Node<Leaf, Failure, Mode>
    {
        get { storage[id] }
        set { storage[id] = newValue }
    }

    @inlinable
    public consuming func build() -> Machine.Program<Leaf, Failure, Mode> {
        Machine.Program(
            graph: storage.build(),
            captures: captures.freeze(),
            maxDepth: maxDepth
        )
    }
}
