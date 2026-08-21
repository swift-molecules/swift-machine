extension Machine.Capture.Slot {

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
