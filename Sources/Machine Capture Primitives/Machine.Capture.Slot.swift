extension Machine.Capture {
    /// Table-based erased storage for a captured value.
    ///
    /// `Slot` stores a type-erased value using raw pointer storage and a
    /// type-specialized destroy function. No existentials (`AnyObject`, `Any`)
    /// or dynamic casts (`as?`, `as!`) are used.
    ///
    /// `Slot` wraps `_Storage` (itself `@unchecked Sendable`, per
    /// unsafe-audit-findings.md Category D SP-5) plus a plain `ObjectIdentifier`
    /// and `String`, all of which are `Sendable` — so `Slot` conforms to plain
    /// `Sendable` rather than asserting `@unchecked` a second time (IMPL-076).
    public struct Slot: Sendable {
        @usableFromInline
        let type: ObjectIdentifier

        @usableFromInline
        let storage: _Storage

        #if DEBUG
            @usableFromInline
            // swift-linter:disable:next compound identifier
            // REASON: two-word stored property with no sibling sharing a leading
            // word (API-NAME-002 shape (a)) — renamed from `typeName` to
            // `debugName` precisely so it no longer shares the `type` leading
            // word with the sibling `type: ObjectIdentifier` property above;
            // debug-only diagnostic field, no namespace to group into.
            //
            // `String(reflecting:)` requires runtime type metadata that
            // Embedded Swift does not provide, so an Embedded DEBUG build
            // stores a fixed, non-reflective placeholder instead — the
            // mismatch precondition itself (see `read(_:)` below) still
            // fires on every platform; only the diagnostic's type name is
            // unavailable under Embedded.
            let debugName: String
        #endif

        /// Creates a slot storing the given value.
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
    /// Single choke-point for payload projection.
    ///
    /// All `assumingMemoryBound` calls for reading go through here.
    @usableFromInline
    func _project<T>(_: T.Type) -> UnsafePointer<T> {
        unsafe UnsafePointer(storage.payload.assumingMemoryBound(to: T.self))
    }

    /// Reads the stored value, checking the type matches.
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
