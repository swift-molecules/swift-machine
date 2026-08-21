extension Machine.Capture {

    public struct Frozen<Mode> {

        public let slots: [Slot]

        @usableFromInline
        init(__slots: [Slot]) {
            self.slots = __slots
        }
    }
}

extension Machine.Capture.Frozen: Sendable where Mode: Sendable {}
