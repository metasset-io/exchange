// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {OrderTypes} from "../libraries/OrderTypes.sol";

interface IMetassetExchange {
    function matchAskWithTakerBidUsingETHAndWETH(
        OrderTypes.TakerOrder calldata takerBid,
        OrderTypes.MakerOrder calldata makerAsk,
        OrderTypes.DistributorOrder calldata distributorOrder
    ) external payable;

    function matchAskWithTakerBid(
        OrderTypes.TakerOrder calldata takerBid,
        OrderTypes.MakerOrder calldata makerAsk,
        OrderTypes.DistributorOrder calldata distributorOrder
    ) external;
}
