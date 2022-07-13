// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title OrderTypes
 * @notice This library contains order types for the Metasset exchange.
 */
library OrderTypes {
    // keccak256("MakerOrder(bool isOrderAsk,address signer,address collection,uint256 price,uint256 tokenId,uint256 amount,address strategy,address currency,uint256 nonce,uint256 startTime,uint256 endTime,uint256 minPercentageToAsk,uint256 distributorPercentage)")
    bytes32 internal constant MAKER_ORDER_HASH =
        0x6a319bde40a4fa0597ddf6a7ff7ed7c4efb3cdec0274615df6392a753786af91;

    // keccak256("DistributorOrder(address signer,address distributor,bytes32 makerOrderHash,bytes params)")
    bytes32 internal constant DISTRIBUTOR_ORDER_HASH =
        0x597f4482cb70c3e6383ea07e367a0df44f58a8d5c214a22186eaa64fe88aae5d;

    struct MakerOrder {
        bool isOrderAsk; // true --> ask / false --> bid
        address signer; // signer of the maker order
        address collection; // collection address
        uint256 price; // price (used as )
        uint256 tokenId; // id of the token
        uint256 amount; // amount of tokens to sell/purchase (must be 1 for ERC721, 1+ for ERC1155)
        address strategy; // strategy for trade execution (e.g., DutchAuction, StandardSaleForFixedPrice)
        address currency; // currency (e.g., WETH)
        uint256 nonce; // order nonce (must be unique unless new maker order is meant to override existing one e.g., lower ask price)
        uint256 startTime; // startTime in timestamp
        uint256 endTime; // endTime in timestamp
        uint256 minPercentageToAsk; // slippage protection (9000 --> 90% of the final price must return to ask)
        uint256 distributorPercentage; // (500 = 5%, 1,000 = 10%)
        uint8 v; // v: parameter (27 or 28)
        bytes32 r; // r: parameter
        bytes32 s; // s: parameter
    }

    struct TakerOrder {
        bool isOrderAsk; // true --> ask / false --> bid
        address taker; // msg.sender
        uint256 price; // final price for the purchase
        uint256 tokenId;
        uint256 minPercentageToAsk; // // slippage protection (9000 --> 90% of the final price must return to ask)
        bytes params; // other params (e.g., tokenId)
    }

    struct DistributorOrder {
        address signer; // Metasset signer of the distributor order
        address distributor; // address of the distributor
        bytes32 makerOrderHash; // hash of the maker order
        bytes params; // additional parameters
        uint8 v; // v: parameter (27 or 28)
        bytes32 r; // r: parameter
        bytes32 s; // s: parameter
    }

    function hash(MakerOrder memory makerOrder)
        internal
        pure
        returns (bytes32)
    {
        return
            keccak256(
                abi.encode(
                    MAKER_ORDER_HASH,
                    makerOrder.isOrderAsk,
                    makerOrder.signer,
                    makerOrder.collection,
                    makerOrder.price,
                    makerOrder.tokenId,
                    makerOrder.amount,
                    makerOrder.strategy,
                    makerOrder.currency,
                    makerOrder.nonce,
                    makerOrder.startTime,
                    makerOrder.endTime,
                    makerOrder.minPercentageToAsk,
                    makerOrder.distributorPercentage
                )
            );
    }

    function hash(DistributorOrder memory distributorOrder)
        internal
        pure
        returns (bytes32)
    {
        return
            keccak256(
                abi.encode(
                    DISTRIBUTOR_ORDER_HASH,
                    distributorOrder.signer,
                    distributorOrder.distributor,
                    distributorOrder.makerOrderHash,
                    keccak256(distributorOrder.params)
                )
            );
    }
}
