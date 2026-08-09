extension Machine.Value {
    // SAFETY: `_Table` stores a single immutable `@Sendable` closure
    // SAFETY: specialised at construction time for `T: ~Copyable`. The
    // SAFETY: closure captures only type metadata (T's layout), not
    // SAFETY: runtime values; the `Sendable` conformance is structural.
    // SAFETY: Encapsulation invariant per [MEM-SAFE-021] — internal table
    // SAFETY: type used only as `_Storage`'s table field.
    /// Table of type-specialized operations.
    ///
    /// The `destroy` function captures only type metadata (`T`'s layout),
    /// not user-provided runtime values. This is acceptable for Embedded
    /// compatibility as it's equivalent to generic specialization—no closure
    /// context with user data, only compiler-generated type information.
    @usableFromInline
    struct _Table: Sendable {
        /// Destroys and deallocates the payload.
        ///
        /// Specialized for `T` at construction time.
        @usableFromInline
        let destroy: @Sendable (UnsafeMutableRawPointer) -> Void

        @usableFromInline
        init<T: ~Copyable>(_: T.Type) {
            unsafe (self.destroy = { raw in
                unsafe raw.assumingMemoryBound(to: T.self).deinitialize(count: 1)
                unsafe raw.deallocate()
            })
        }
    }
}
