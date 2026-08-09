extension Machine.Capture.Slot {
    // WHY: Category D — structural Sendable workaround (SP-5) per [MEM-SAFE-024].
    // WHY: Immutable pointer + @Sendable destroy function. UnsafeMutableRawPointer
    // WHY: blocks structural inference. No synchronization.
    // WHY: Encapsulation invariant per [MEM-SAFE-021] — `_Storage` is `@usableFromInline`
    // WHY: but its raw-pointer storage is internal-only; consumers see only the
    // WHY: type-safe `Slot` surface.
    // WHEN TO REMOVE: When compiler gains structural Sendable through raw pointers.
    // TRACKING: unsafe-audit-findings.md Category D SP-5.
    /// Reference-counted storage for the erased payload.
    @usableFromInline
    final class _Storage: @unchecked Sendable {
        @usableFromInline
        let payload: UnsafeMutableRawPointer

        @usableFromInline
        let destroy: @Sendable (UnsafeMutableRawPointer) -> Void

        @usableFromInline
        init(
            payload: UnsafeMutableRawPointer,
            destroy: @escaping @Sendable (UnsafeMutableRawPointer) -> Void
        ) {
            unsafe (self.payload = payload)
            unsafe (self.destroy = destroy)
        }

        deinit {
            unsafe destroy(payload)
        }
    }
}
