// SPDX-License-Identifier: MIT
import { getAccountAddress } from "flow-js-testing";

const UFIX64_PRECISION = 8;

// UFix64 values shall be always passed as strings
export const toUFix64 = (value) => value.toFixed(UFIX64_PRECISION);

export const getBeatokenAdminAddress = async () => getAccountAddress("BeatokenAdmin");
export const getFungibleTokenAddress = async () => getAccountAddress("FungibleToken");
export const getNonFungibleTokenAddress = async () => getAccountAddress("NonFungibleToken");
