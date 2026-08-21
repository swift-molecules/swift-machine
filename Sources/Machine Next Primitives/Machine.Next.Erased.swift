extension Machine.Next {

    @safe
    public struct Erased<Mode, NodeID>: Sendable {

        public let capture: Machine.Capture.RawID

        @usableFromInline
        let _next:
            @Sendable (
                borrowing Machine.Capture.Frozen<Mode>,
                Machine.Value<Mode>
            ) -> NodeID
    }
}

extension Machine.Next.Erased {

    @inlinable
    public func next(
        using captures: borrowing Machine.Capture.Frozen<Mode>,
        _ value: Machine.Value<Mode>
    ) -> NodeID {
        _next(captures, value)
    }
}

extension Machine.Next.Erased where Mode == Machine.Capture.Mode.Reference {

    @inlinable
    public init<In>(
        capture: Machine.Capture.ID<@Sendable (In) -> NodeID>
    ) where NodeID: Sendable {
        let raw = capture.raw
        self.capture = raw
        self._next = { captures, value in
            captures.withRaw(raw, as: (@Sendable (In) -> NodeID).self) { nextFn in
                nextFn(value[as: In.self])
            }
        }
    }
}

extension Machine.Next.Erased where Mode == Machine.Capture.Mode.Unchecked {

    @inlinable
    public init<In>(
        capture: Machine.Capture.ID<(In) -> NodeID>
    ) {
        let raw = capture.raw
        self.capture = raw
        self._next = { captures, value in
            captures.withRaw(raw, as: ((In) -> NodeID).self) { nextFn in
                nextFn(value[as: In.self])
            }
        }
    }
}
