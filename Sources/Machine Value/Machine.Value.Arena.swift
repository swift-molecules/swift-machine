extension Machine.Value {

    public struct Arena: ~Copyable {
        @usableFromInline
        var values: [Machine.Value<Mode>?]

        @usableFromInline

        var nextSlot: UInt32

        @usableFromInline
        var generation: UInt32

        @inlinable
        public init(capacity: Int = 64) {
            self.values = [Machine.Value<Mode>?](repeating: nil, count: capacity)
            self.nextSlot = 0
            self.generation = 0
        }
    }
}

extension Machine.Value.Arena {

    @inlinable
    public mutating func allocate(
        _ value: consuming Machine.Value<Mode>
    ) -> Machine.Value<Mode>.Handle {
        let slot = nextSlot
        if Int(slot) >= values.count {
            values.append(contentsOf: repeatElement(nil, count: values.count))
        }
        values[Int(slot)] = value
        nextSlot += 1
        return Machine.Value._makeHandle(slot: slot, generation: generation)
    }

    @inlinable
    package func validateHandle(_ handle: Machine.Value<Mode>.Handle, operation: StaticString) {
        guard handle.generation == generation else {
            fatalError(
                "Arena.\(operation): stale handle (generation \(handle.generation), current \(generation))"
            )
        }
    }

    @inlinable
    public func read(_ handle: Machine.Value<Mode>.Handle) -> Machine.Value<Mode> {
        validateHandle(handle, operation: "read")
        let slot = Machine.Value<Mode>._slot(handle)
        guard let value = values[Int(slot)] else {
            fatalError("Arena.read: slot \(slot) is empty")
        }
        return value
    }

    @inlinable
    public mutating func release(_ handle: Machine.Value<Mode>.Handle) -> Machine.Value<Mode> {
        validateHandle(handle, operation: "release")
        let slot = Machine.Value<Mode>._slot(handle)
        guard let value = values[Int(slot)] else {
            fatalError("Arena.release: slot \(slot) is empty")
        }
        values[Int(slot)] = nil
        return value
    }

    @inlinable
    public mutating func reset() {
        (0..<Int(nextSlot)).forEach { values[$0] = nil }
        nextSlot = 0
        generation &+= 1
    }
}
