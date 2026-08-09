extension Machine.Value {
    // SAFETY: Encapsulates unsafe internals behind a safe API; see
    // SAFETY: [MEM-SAFE-024] for the absorber-pattern taxonomy.
    /// A `~Escapable` reference to a stored value.
    ///
    /// Carries a lifetime dependency back to the `Value`, ensuring the
    /// reference cannot outlive its storage. Access the payload via
    /// the `value` property (`_read` accessor).
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
    /// Borrow access to the referenced value.
    public var value: T {
        _read { yield unsafe _pointer.pointee }
    }
}
