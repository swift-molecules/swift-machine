extension Machine.Capture {

    public struct Slot: Sendable {
        @usableFromInline
        let type: ObjectIdentifier

        @usableFromInline
        let storage: _Storage

        #if DEBUG
            @usableFromInline

            let debugName: String
        #endif

        @usableFromInline
        init<T>(_ value: T) {
            let pointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
            unsafe pointer.initialize(to: value)

            self.type = ObjectIdentifier(T.self)
            self.storage = unsafe _Storage(
                payload: UnsafeMutableRawPointer(pointer),
                destroy: { raw in
                    unsafe raw.assumingMemoryBound(to: T.self).deinitialize(count: 1)
                    unsafe raw.deallocate()
                }
            )
            #if DEBUG
                #if hasFeature(Embedded)
                    self.debugName = "<embedded: reflection unavailable>"
                #else
                    self.debugName = String(reflecting: T.self)
                #endif
            #endif
        }
    }
}

extension Machine.Capture.Slot {

    @usableFromInline
    func _project<T>(_: T.Type) -> UnsafePointer<T> {
        unsafe UnsafePointer(storage.payload.assumingMemoryBound(to: T.self))
    }

    public func read<T>(_: T.Type) -> T {
        #if DEBUG
            precondition(
                type == ObjectIdentifier(T.self),
                "Capture type mismatch: expected \(T.self), stored \(debugName)"
            )
        #else
            precondition(type == ObjectIdentifier(T.self))
        #endif
        return unsafe _project(T.self).pointee
    }
}
