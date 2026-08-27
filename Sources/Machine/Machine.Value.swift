extension Machine {

    @safe
    public struct Value<Mode> {
        @usableFromInline
        let type: ObjectIdentifier

        @usableFromInline
        let storage: _Storage

        @usableFromInline
        init(type: ObjectIdentifier, storage: _Storage) {
            self.type = type
            self.storage = storage
        }
    }
}

extension Machine.Value {

    @usableFromInline
    func _project<T: ~Copyable>(_: T.Type) -> UnsafePointer<T> {
        unsafe UnsafePointer(storage.payload.assumingMemoryBound(to: T.self))
    }
}

extension Machine.Value {

    @inlinable
    public subscript<T: ~Copyable>(as type: T.Type) -> T {
        _read {
            precondition(
                self.type == ObjectIdentifier(T.self),
                "Machine.Value type mismatch: expected \(T.self), got type with id \(self.type)"
            )
            yield unsafe _project(type).pointee
        }
    }
}

extension Machine.Value {

    @_lifetime(borrow self)
    public func borrow<T: ~Copyable>(as type: T.Type) -> Ref<T> {
        precondition(
            self.type == ObjectIdentifier(T.self),
            "Machine.Value type mismatch: expected \(T.self), got type with id \(self.type)"
        )
        let ref = unsafe Ref(_pointer: _project(type))
        return unsafe _overrideLifetime(ref, borrowing: self)
    }
}

extension Machine.Value where Mode == Machine.Capture.Mode.Reference {

    public func apply<In, Out: Sendable>(_ transform: (In) -> Out) -> Machine.Value<Mode> {
        .make(transform(self[as: In.self]))
    }

    public func apply<In, Out: Sendable, E: Swift.Error>(
        _ transform: (In) throws(E) -> Out
    ) throws(E) -> Machine.Value<Mode> {
        .make(try transform(self[as: In.self]))
    }

    public func combine<A, B, Out: Sendable>(
        _ other: Machine.Value<Mode>,
        using combineFn: (A, B) -> Out
    ) -> Machine.Value<Mode> {
        .make(combineFn(self[as: A.self], other[as: B.self]))
    }
}

extension Machine.Value where Mode == Machine.Capture.Mode.Unchecked {

    public func apply<In, Out>(_ transform: (In) -> Out) -> Machine.Value<Mode> {
        .make(transform(self[as: In.self]))
    }

    public func apply<In, Out, E: Swift.Error>(
        _ transform: (In) throws(E) -> Out
    ) throws(E) -> Machine.Value<Mode> {
        .make(try transform(self[as: In.self]))
    }

    public func combine<A, B, Out>(
        _ other: Machine.Value<Mode>,
        using combineFn: (A, B) -> Out
    ) -> Machine.Value<Mode> {
        .make(combineFn(self[as: A.self], other[as: B.self]))
    }
}

extension Machine.Value where Mode == Machine.Capture.Mode.Reference {

    @inlinable
    public static func make<T: Sendable & ~Copyable>(_ value: consuming T) -> Machine.Value<Mode> {
        let payload = UnsafeMutablePointer<T>.allocate(capacity: 1)
        unsafe payload.initialize(to: value)

        let table = _Table(T.self)
        let storage = unsafe _Storage(
            payload: UnsafeMutableRawPointer(payload),
            table: table
        )

        return Machine.Value<Mode>(
            type: ObjectIdentifier(T.self),
            storage: storage
        )
    }
}

extension Machine.Value where Mode == Machine.Capture.Mode.Unchecked {

    @inlinable
    public static func make<T: ~Copyable>(_ value: consuming T) -> Machine.Value<Mode> {
        let payload = UnsafeMutablePointer<T>.allocate(capacity: 1)
        unsafe payload.initialize(to: value)

        let table = _Table(T.self)
        let storage = unsafe _Storage(
            payload: UnsafeMutableRawPointer(payload),
            table: table
        )

        return Machine.Value<Mode>(
            type: ObjectIdentifier(T.self),
            storage: storage
        )
    }
}

extension Machine.Value: Sendable where Mode: Sendable {}
