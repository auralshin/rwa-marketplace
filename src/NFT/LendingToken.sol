// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./flattenERC721.sol";
import {Ownable} from "aave-v3-core/contracts/dependencies/openzeppelin/contracts/Ownable.sol";
import {AccessControl} from "aave-v3-core/contracts/dependencies/openzeppelin/contracts/AccessControl.sol";

contract LendingToken is ERC721, Ownable, AccessControl {
    uint256 private _nextTokenId;

    constructor() ERC721("MyToken", "MTK") Ownable() {}

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
