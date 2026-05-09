import { AMMCreated as AMMCreatedEvent } from "../generated/GameAMMFactory/GameAMMFactory"
import { AMMCreated } from "../generated/schema"

export function handleAMMCreated(event: AMMCreatedEvent): void {
  let entity = new AMMCreated(event.transaction.hash.concatI32(event.logIndex.toI32()))
  entity.amm = event.params.amm
  entity.tokenA = event.params.tokenA
  entity.tokenB = event.params.tokenB
  entity.salt = event.params.salt
  entity.save()
}
