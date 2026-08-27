extension Machine.Transform {

    @safe
    public struct Throwing<Mode, Failure: Swift.Error>: Sendable {

        public let capture: Machine.Capture.RawID

        @usableFromInline
        let _apply:
            @Sendable (
                borrowing Machine.Capture.Frozen<Mode>,
                Machine.Value<Mode>
            ) throws(Failure) -> Machine.Value<Mode>
    }
}

extension Machine.Transform.Throwing {

    @inlinable
    public func apply(
        using captures: borrowing Machine.Capture.Frozen<Mode>,
        _ value: Machine.Value<Mode>
    ) throws(Failure) -> Machine.Value<Mode> {
        try _apply(captures, value)
    }
}

extension Machine.Transform.Throwing where Mode == Machine.Capture.Mode.Reference {

    @inlinable
    public init<In, Out: Sendable>(
        capture: Machine.Capture.ID<@Sendable (In) throws(Failure) -> Out>
    ) {
        let raw = capture.raw
        self.capture = raw

        self._apply = { captures, value throws(Failure) -> Machine.Value<Mode> in
            let slot = captures.slots[raw.rawValue]
            let transform = slot.read((@Sendable (In) throws(Failure) -> Out).self)
            return try value.apply(transform)
        }
    }
}

extension Machine.Transform.Throwing where Mode == Machine.Capture.Mode.Unchecked {

    @inlinable
    public init<In, Out>(
        capture: Machine.Capture.ID<(In) throws(Failure) -> Out>
    ) {
        let raw = capture.raw
        self.capture = raw

        self._apply = { captures, value throws(Failure) -> Machine.Value<Mode> in
            let slot = captures.slots[raw.rawValue]
            let transform = slot.read(((In) throws(Failure) -> Out).self)
            return try value.apply(transform)
        }
    }
}
