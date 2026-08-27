extension Machine.Frame {

    @safe
    public enum Sequence {

        case second(b: NodeID, combine: Machine.Combine.Erased<Mode>)

        case combine(firstHandle: Machine.Value<Mode>.Handle, combine: Machine.Combine.Erased<Mode>)
    }
}
