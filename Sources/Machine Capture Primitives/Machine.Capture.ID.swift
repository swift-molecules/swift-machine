extension Machine.Capture {

    public struct ID<Value>: Hashable, Sendable {

        public let raw: RawID

        @usableFromInline
        init(_ raw: RawID) {
            self.raw = raw
        }
    }
}

extension Machine.Capture.ID {

    @inlinable
    public var rawValue: Int { raw.rawValue }
}
