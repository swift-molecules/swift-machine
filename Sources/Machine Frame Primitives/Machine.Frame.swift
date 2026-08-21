extension Machine {

    @safe
    public enum Frame<NodeID, Checkpoint, Mode, Failure: Swift.Error, Extra> {

        case map(transform: Transform.Erased<Mode>)

        case tryMap(transform: Transform.Throwing<Mode, Failure>)

        case flatMap(next: Next.Erased<Mode, NodeID>)

        case sequence(Sequence)

        case oneOf(alternatives: [NodeID], index: Int, savedCheckpoint: Checkpoint)

        case many(
            child: NodeID,
            savedCheckpoint: Checkpoint,
            resultHandles: [Value<Mode>.Handle],
            finalize: Finalize.Array<Mode>
        )

        case fold(
            child: NodeID,
            savedCheckpoint: Checkpoint,
            accumulatorHandle: Value<Mode>.Handle,
            combine: Combine.Erased<Mode>
        )

        case optional(
            savedCheckpoint: Checkpoint,
            wrapSome: Transform.Erased<Mode>,
            noneHandle: Value<Mode>.Handle
        )

        case recursiveExit

        case extra(Extra)
    }
}
