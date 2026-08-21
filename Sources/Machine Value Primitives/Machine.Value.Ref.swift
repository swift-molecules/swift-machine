extension Machine.Value {

    @safe
    public struct Ref<T: ~Copyable>: ~Copyable, ~Escapable {
        @usableFromInline
        let _pointer: UnsafePointer<T>

        @usableFromInline
        init(_pointer: UnsafePointer<T>) {
            unsafe (self._pointer = _pointer)
        }
    }
}

extension Machine.Value.Ref {

    public var value: T {
        _read { yield unsafe _pointer.pointee }
    }
}
