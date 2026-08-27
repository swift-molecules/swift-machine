public import Machine_Program

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
