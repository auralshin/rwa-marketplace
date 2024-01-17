// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.10;

import "./SVG.sol";
import {Strings} from "aave-v3-core/contracts/dependencies/openzeppelin/contracts/Strings.sol";
import "./Base64.sol";
import "./FlattenMerkleProof.sol";

library Desc {
    struct SVGParams {
        string userAddress;
        uint256 tokenId;
        string rwaAmount;
        string rwaCurrency;
        bytes32 merkleRoot;
        string agreementDate;
    }

    function makeSVGParams(
        SVGParams memory params
    ) internal pure returns (string memory svg) {
        return
            NFTSVG.generateSVG(
                NFTSVG.SVGParams({
                    merkleProof: truncateHexadecimal(Strings.toHexString(
                        uint256(params.merkleRoot),
                        32
                    )),
                    userAddress: params.userAddress,
                    tokenId: params.tokenId,
                    rwaAmount: params.rwaAmount,
                    rwaCurrency: params.rwaCurrency,
                        
                    merkleRoot: params.merkleRoot,
                    agreementDate: truncateHexadecimal(params.agreementDate)
                })
            );
    }

    function getTokenURI(
        uint256 tokenId,
        bytes32 _merkleRoot,
        string memory image
    ) internal pure returns (string memory) {
        string memory tokenString = Strings.toString(tokenId);

        string memory merkleRootStr = Strings.toHexString(
            uint256(_merkleRoot),
            32
        );
        string memory description = string(
            abi.encodePacked(
                "This is a RWA built on Aave. The merkle root of this token is",
                merkleRootStr,
                ". To know more about this, please visit https://github.com/auralshin/rwa-marketplace."
            )
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":" Token ID #',
                                tokenString,
                                '", "description":"',
                                description,
                                '", "image": "data:image/svg+xml;base64,',
                                image,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function truncateHexadecimal(
        string memory hexString
    ) public pure returns (string memory) {
        bytes memory bytesString = bytes(hexString);

        if (
            bytesString.length >= 2 &&
            bytesString[0] == 0x30 &&
            (bytesString[1] == 0x78 || bytesString[1] == 0x58)
        ) {
            bytes memory firstPart = new bytes(2);
            firstPart[0] = bytesString[0];
            firstPart[1] = bytesString[1];

            bytes memory lastPart = new bytes(3);
            lastPart[0] = bytesString[bytesString.length - 3];
            lastPart[1] = bytesString[bytesString.length - 2];
            lastPart[2] = bytesString[bytesString.length - 1];

            string memory truncatedHex = string(
                abi.encodePacked(firstPart, "...", lastPart)
            );
            return truncatedHex;
        }
        return hexString;
    }

    function verifyTransaction(
        uint256 tokenId,
        bytes32 _merkleRoot,
        string calldata _transactionID,
        bytes32[] calldata _merkleProof
    ) internal pure returns (bool _doesExist) {
        require(tokenId > 0, "Token ID must be greater than zero.");

        bytes32 leaf = keccak256(abi.encodePacked(_transactionID));
        return _doesExist = MerkleProof.verify(_merkleProof, _merkleRoot, leaf);
    }
}