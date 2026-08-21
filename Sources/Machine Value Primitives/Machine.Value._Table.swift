extension Machine.Value {

    @usableFromInline
    struct _Table: Sendable {

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
