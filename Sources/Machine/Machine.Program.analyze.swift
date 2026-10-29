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
