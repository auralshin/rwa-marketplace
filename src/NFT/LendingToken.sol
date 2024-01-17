// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./flattenERC721.sol";
import {Ownable} from "aave-v3-core/contracts/dependencies/openzeppelin/contracts/Ownable.sol";
import {AccessControl} from "aave-v3-core/contracts/dependencies/openzeppelin/contracts/AccessControl.sol";

contract LendingToken is ERC721, Ownable, AccessControl {
    uint256 private _nextTokenId;
    struct RWADetails {
        bytes32 _merkleRoot;
        string _rwaAmount;
        string _agreementDate;
        string _rwaCurrency;
    }

    struct MintParams {
        uint256 _tokenId;
        address _user;
        RWADetails details;
    }
    constructor() ERC721("Real World Asset", "RWA") Ownable() {}

    mapping(uint256 => string) private _tokenURIs;
    mapping(uint256 => RWADetails) public rwaDetails;

    function safeMint(address to, RWADetails memory rwaDetails) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _setRWADetails(tokenId, rwaDetails);
        _safeMint(to, tokenId);
    }

    function _setRWADetails(
        uint256 tokenId,
        RWADetails memory _rwaDetails
    ) internal virtual {
        rwaDetails[tokenId] = _rwaDetails;
        _tokenURIs[tokenId] = string(
            abi.encodePacked(
                _rwaDetails._merkleRoot,
                _rwaDetails._rwaAmount,
                _rwaDetails._agreementDate,
                _rwaDetails._rwaCurrency
            )
        );
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }

    function getDetails(uint256 tokenId) public view returns (RWADetails memory) {
        RWADetails memory details = rwaDetails[tokenId];
       
        
        return details;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
