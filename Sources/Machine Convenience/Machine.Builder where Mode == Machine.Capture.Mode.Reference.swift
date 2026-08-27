public import Machine_Program

extension Machine.Builder where Mode == Machine.Capture.Mode.Reference {

    @inlinable
    public mutating func transform<In, Out: Sendable>(
        _ fn: @escaping @Sendable (In) -> Out
    ) -> Machine.Transform.Erased<Mode> {
        let captureID = captures.insert(fn)
        return Machine.Transform.Erased<Mode>(capture: captureID)
    }

    @inlinable
    public mutating func throwingTransform<In, Out: Sendable>(
        _ fn: @escaping @Sendable (In) throws(Failure) -> Out
    ) -> Machine.Transform.Throwing<Mode, Failure> {
        let captureID = captures.insert(fn)
        return Machine.Transform.Throwing<Mode, Failure>(capture: captureID)
    }

    @inlinable
    public mutating func combine<A, B, Out: Sendable>(
        _ fn: @escaping @Sendable (A, B) -> Out
    ) -> Machine.Combine.Erased<Mode> {
        let captureID = captures.insert(fn)
        return Machine.Combine.Erased<Mode>(capture: captureID)
    }

    @inlinable
    public mutating func next<In>(
        _ fn: @escaping @Sendable (In) -> Machine.Node<Leaf, Failure, Mode>.ID
    ) -> Machine.Next.Erased<Mode, Machine.Node<Leaf, Failure, Mode>.ID> {
        let captureID = captures.insert(fn)
        return Machine.Next.Erased<Mode, Machine.Node<Leaf, Failure, Mode>.ID>(capture: captureID)
    }

    @inlinable
    public mutating func finalize<T: Sendable>(
        elementType: T.Type
    ) -> Machine.Finalize.Array<Mode> {
        Machine.Finalize.Array<Mode>(elementType: T.self, store: &captures)
    }
}
