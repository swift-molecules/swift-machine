extension Machine.Value {

    public struct Handle: Hashable, Sendable {

        public let index: Int

        public let generation: UInt32

        @inlinable
        public init(index: Int, generation: UInt32) {
            self.index = index
            self.generation = generation
        }
    }
}

extension Machine.Value {

    @usableFromInline
    static func _makeHandle(slot: UInt32, generation: UInt32) -> Handle {
        Handle(index: Int(slot), generation: generation)
    }

    @usableFromInline
    static func _slot(_ handle: Handle) -> UInt32 {
        UInt32(handle.index)
    }
}
