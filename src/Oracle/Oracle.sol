// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Oracle {
    uint256 public price;
    uint256 public percentage = 80;


    function setPrice(uint256 _price) public {
        price = _price;
    }

    function getPrice(uint256 tokenId) public view returns (uint256) {
        return price;
    }

    function getPercentage(uint256 tokenId) public view returns (uint256) {
        return percentage;
    }
}