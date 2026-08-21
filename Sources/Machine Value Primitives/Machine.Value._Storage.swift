extension Machine.Value {

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
