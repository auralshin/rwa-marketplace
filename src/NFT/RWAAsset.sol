// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./flattenERC721.sol";
import {Ownable} from "aave-v3-core/contracts/dependencies/openzeppelin/contracts/Ownable.sol";
import {Strings} from "aave-v3-core/contracts/dependencies/openzeppelin/contracts/Strings.sol";
import {Base64} from "./Base64.sol";
import {MerkleProof} from "./FlattenMerkleProof.sol";
import {Desc} from "./Desc.sol";

contract RWAAsset is ERC721, Ownable {
    using Strings for uint256;

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

    mapping(address => bool) private _eligibleHolders;

    mapping(uint256 => RWADetails) private _tokenURIs;

    mapping(address => uint256[]) public _addressTokenId;

    event RWAMinted(uint256 tokenId, address user);
    event RWABurned(uint256 tokenId);

    constructor(
        string memory name_,
        string memory symbol_
    ) Ownable() ERC721(name_, symbol_) {}

    modifier isNotMinted(uint256 tokenId) {
        require(ownerOf(tokenId) == address(0), "Token already minted.");
        _;
    }

    modifier isMinted(uint256 tokenId) {
        require(ownerOf(tokenId) != address(0), "Token not minted.");
        _;
    }

    modifier isZeroAddress(address user) {
        if (user == address(0)) {
            revert("ZeroAddress");
        }
        _;
    }

    function _setRWADetails(
        uint256 tokenId,
        RWADetails memory rwaDetails
    ) internal virtual {
        _tokenURIs[tokenId] = rwaDetails;
    }

    function getTokenDetails(
        uint256 tokenId
    ) public view returns (RWADetails memory) {
        return _tokenURIs[tokenId];
    }

    function getTokensByOwner(
        address _owner
    ) public view returns (uint256[] memory) {
        return _addressTokenId[_owner];
    }

    function createRWA(
        MintParams memory params
    ) public isNotMinted(params._tokenId) isZeroAddress(params._user) {
        require(params._tokenId > 0, "Token ID must be greater than zero.");
        require(
            bytes(params.details._rwaAmount).length > 0,
            "RWA amount cannot be empty."
        );
        uint256 newTokenId = params._tokenId;
        _mint(params._user, newTokenId);
        _addressTokenId[params._user].push(newTokenId);
        _setRWADetails(newTokenId, params.details);
        emit RWAMinted(newTokenId, params._user);
    }

    function burnRWA(uint256 tokenId) external isMinted(tokenId) {
        _burn(tokenId);
        emit RWABurned(tokenId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        require(
            ownerOf(tokenId) != address(0),
            "URI query for nonexistent token"
        );
        string memory image = Base64.encode(bytes(createSVGParams(tokenId)));
        return
            Desc.getTokenURI(tokenId, _tokenURIs[tokenId]._merkleRoot, image);
    }

    function createSVGParams(
        uint256 tokenId
    ) internal view returns (string memory svg) {
        return
            Desc.makeSVGParams(
                Desc.SVGParams({
                    userAddress: Strings.toHexString(
                        uint256(uint160(ownerOf(tokenId))),
                        20
                    ),
                    tokenId: tokenId,
                    rwaAmount: _tokenURIs[tokenId]._rwaAmount,
                    rwaCurrency: _tokenURIs[tokenId]._rwaCurrency,
                    merkleRoot: _tokenURIs[tokenId]._merkleRoot,
                    agreementDate: _tokenURIs[tokenId]._agreementDate
                })
            );
    }

    function verifyTransactionByNFT(
        uint256 tokenId,
        string calldata transactionID,
        bytes32[] calldata merkleProof
    ) public view isMinted(tokenId) returns (bool) {
        return
            Desc.verifyTransaction(
                tokenId,
                _tokenURIs[tokenId]._merkleRoot,
                transactionID,
                merkleProof
            );
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        super.transferFrom(from, to, tokenId);

        // Remove tokenId from the sender's list
        removeTokenIdFromList(from, tokenId);

        // Add tokenId to the receiver's list
        _addressTokenId[to].push(tokenId);
    }

    function removeTokenIdFromList(address user, uint256 tokenId) private {
        uint256[] storage tokens = _addressTokenId[user];
        for (uint256 i = 0; i < tokens.length; i++) {
            if (tokens[i] == tokenId) {
                tokens[i] = tokens[tokens.length - 1];
                tokens.pop();
                break;
            }
        }
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
