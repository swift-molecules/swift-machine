extension Machine.Capture {

    public struct Store<Mode> {
        @usableFromInline
        var slots: [Slot]

        @inlinable
        public init() {
            self.slots = []
        }
    }
}

extension Machine.Capture.Store {

    @inlinable
    public consuming func freeze() -> Machine.Capture.Frozen<Mode> {
        Machine.Capture.Frozen(__slots: slots)
    }
}
