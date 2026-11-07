public import Graph
import Ordinal
public import Tagged

extension Machine {

    public struct Program<Leaf, Failure: Swift::Error, Mode> {

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
    public subscript(id: Machine.Node<Leaf, Failure, Mode>.ID) -> Machine.Node<Leaf, Failure, Mode> {
        graph[id]
    }
}

extension Machine.Program {

    @inlinable
    public func apply(
        _ transform: Machine.Transform.Erased<Mode>,
        to value: Machine.Value<Mode>
    ) -> Machine.Value<Mode> {
        transform.apply(using: captures, value)
    }

    @inlinable
    public func apply(
        _ transform: Machine.Transform.Throwing<Mode, Failure>,
        to value: Machine.Value<Mode>
    ) throws(Failure) -> Machine.Value<Mode> {
        try transform.apply(using: captures, value)
    }

    @inlinable
    public func combine(
        _ combine: Machine.Combine.Erased<Mode>,
        _ a: Machine.Value<Mode>,
        _ b: Machine.Value<Mode>
    ) -> Machine.Value<Mode> {
        combine.combine(using: captures, a, b)
    }

    @inlinable
    public func next(
        _ next: Machine.Next.Erased<Mode, Machine.Node<Leaf, Failure, Mode>.ID>,
        from value: Machine.Value<Mode>
    ) -> Machine.Node<Leaf, Failure, Mode>.ID {
        next.next(using: captures, value)
    }

    @inlinable
    public func finalize(
        _ finalize: Machine.Finalize.Array<Mode>,
        _ values: [Machine.Value<Mode>]
    ) -> Machine.Value<Mode> {
        finalize.finalize(using: captures, values)
    }
}

#if Analyze
    public import Graph

    extension Machine.Program {

        @inlinable
        public var analyze:
            Graph.Sequential<Machine.Node<Leaf, Failure, Mode>, Machine.Node<Leaf, Failure, Mode>>
                .Analyze<[Machine.Node<Leaf, Failure, Mode>.ID]>
        {
            graph.analyze(using: Machine.Node.extract)
        }
    }
#endif
