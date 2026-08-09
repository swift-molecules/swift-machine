extension Machine.Value {
    // WHY: Category D — structural Sendable workaround (SP-5) per [MEM-SAFE-024].
    // WHY: Immutable `let payload: UnsafeMutableRawPointer` + `let table: _Table`
    // WHY: after construction. UnsafeMutableRawPointer blocks structural inference.
    // WHY: No synchronization, no ~Copyable. Pointee is never mutated.
    // WHY: Encapsulation invariant per [MEM-SAFE-021] — `_Storage` is `@usableFromInline`
    // WHY: but its raw-pointer storage is internal-only; consumers see only the
    // WHY: type-safe `Value` surface.
    // WHEN TO REMOVE: When compiler gains structural Sendable through raw pointers.
    // TRACKING: unsafe-audit-findings.md Category D SP-5.
    /// Reference-counted storage with type-specialized destruction.
    ///
    /// This is NOT `AnyObject`—it's a concrete class type. No `as?` casting
    /// is needed to access the payload.
    @usableFromInline
    final class _Storage: @unchecked Sendable {
        @usableFromInline
        let payload: UnsafeMutableRawPointer

        @usableFromInline
        let table: _Table

        @usableFromInline
        init(payload: UnsafeMutableRawPointer, table: _Table) {
            unsafe (self.payload = payload)
            self.table = table
        }

        deinit {
            unsafe table.destroy(payload)
        }
    }
}
