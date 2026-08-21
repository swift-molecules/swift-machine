public import Graph_Sequential_Primitives

extension Machine {

    @safe
    public enum Node<Leaf, Failure: Swift.Error, Mode> {

        case leaf(Leaf)

        case pure(Value<Mode>)

        case map(child: ID, transform: Transform.Erased<Mode>)

        case tryMap(child: ID, transform: Transform.Throwing<Mode, Failure>)

        case flatMap(child: ID, next: Next.Erased<Mode, ID>)

        case sequence(a: ID, b: ID, combine: Combine.Erased<Mode>)

        case oneOf([ID])

        case many(child: ID, finalize: Finalize.Array<Mode>)

        case fold(child: ID, initial: Value<Mode>, combine: Combine.Erased<Mode>)

        case optional(child: ID, wrapSome: Transform.Erased<Mode>, noneValue: Value<Mode>)

        case ref(ID)

        case hole
    }
}

extension Machine.Node: Sendable
where Leaf: Sendable, Failure: Sendable, Mode: Sendable {}

extension Machine.Node {

    public typealias ID = Graph.Node<Self>
}

extension Machine.Node {

    public var adjacent: [ID] {
        switch self {
        case .leaf, .pure, .hole: return []
        case .map(let child, _): return [child]
        case .tryMap(let child, _): return [child]
        case .flatMap(let child, _): return [child]
        case .sequence(let a, let b, _): return [a, b]
        case .oneOf(let ids): return ids
        case .many(let child, _): return [child]
        case .fold(let child, _, _): return [child]
        case .optional(let child, _, _): return [child]
        case .ref(let id): return [id]
        }
    }

    public static var extract: Graph.Adjacency.Extract<Self, Self, [ID]> {
        Graph.Adjacency.Extract { $0.adjacent }
    }
}
