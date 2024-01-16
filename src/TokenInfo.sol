// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";


contract TokenInfo is ChainlinkClient, ConfirmedOwner {
    using Chainlink for Chainlink.Request;

    uint256 public price;
    uint256 public percentage;
    bytes32 private jobId;
    uint256 private fee;

    event RequestPrice(bytes32 indexed requestId, uint256 price);
    event RequestPercentage(bytes32 indexed requestId, uint256 percentage);

    constructor() ConfirmedOwner(msg.sender) {
        setChainlinkToken(0x779877A7B0D9E8603169DdbD7836e478b4624789);
        setChainlinkOracle(0x6090149792dAAeE9D1D568c9f9a6F6B46AA29eFD);
        jobId = "ca98366cc7314957b8c012c72f05aeeb";
        fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job)
    }

    function getPrice() public returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfillPrice.selector
        );
        // Set the URL to perform the GET request on
        req.add(
            "get",
            "url" // TODO: Add url of adapter
        );

        req.add("path", "ADD PATH"); // TODO: Add json path in this format : data,price

        // Multiply the result by 1000000000000000000 to remove decimals
        int256 timesAmount = 10 ** 18;
        req.addInt("times", timesAmount);

        // Sends the request
        return sendChainlinkRequest(req, fee);
    }

    function getPercentage() public returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfillPercentage.selector
        );

        // Set the URL to perform the GET request on
        req.add(
            "get",
            "url" // TODO: Add url of adapter
        );

        req.add("path", "ADD PATH"); // TODO: Add json path in this format : data,percentage

 
        int256 timesAmount = 1;
        req.addInt("times", timesAmount);

        // Sends the request
        return sendChainlinkRequest(req, fee);
    }

    /**
     * Receive the response in the form of uint256
     */
    function fulfillPrice(
        bytes32 _requestId,
        uint256 _price
    ) public recordChainlinkFulfillment(_requestId) {
        emit RequestPrice(_requestId, _price);
        price = _price;
    }

        function fulfillPercentage(
        bytes32 _requestId,
        uint256 _percentage
    ) public recordChainlinkFulfillment(_requestId) {
        emit RequestPercentage(_requestId, _percentage);
        percentage = _percentage;
    }
}
