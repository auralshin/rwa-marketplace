// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IRWAAsset {
    struct RWADetails {
        bytes32 _merkleRoot;
        string _rwaAmount;
        string _agreementDate;
        string _rwaPercentage;
        string _rwaCurrency;
    }

    struct MintParams {
        uint256 _tokenId;
        address _user;
        RWADetails details;
    }

    function getTokenDetails(uint256 tokenId) external view returns (RWADetails memory);

    function getTokensByOwner(address _owner) external view returns (uint256[] memory);

    function createRWA(MintParams memory params) external;

    function burnRWA(uint256 tokenId) external;

    function tokenURI(uint256 tokenId) external view returns (string memory);

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function verifyTransactionByNFT(
        uint256 tokenId,
        string calldata transactionID,
        bytes32[] calldata merkleProof
    ) external view returns (bool);
}
