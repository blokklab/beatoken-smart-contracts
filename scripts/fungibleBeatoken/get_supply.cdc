// SPDX-License-Identifier: UNLICENSED
import FungibleBeatoken from "../../contracts/FungibleBeatoken.cdc"

pub fun main(): UFix64 {

    return FungibleBeatoken.totalSupply
}
