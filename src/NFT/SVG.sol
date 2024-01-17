// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.10;

import {Strings} from "aave-v3-core/contracts/dependencies/openzeppelin/contracts/Strings.sol";
import "./Base64.sol";

/// @title NFTSVG
/// @notice Provides a function for generating an SVG associated with a Uniswap NFT
library NFTSVG {
    using Strings for uint256;
    struct SVGParams {
        string merkleProof;
        string userAddress;
        uint256 tokenId;
        string rwaAmount;
        string rwaCurrency;
        bytes32 merkleRoot;
        string agreementDate;
    }

    function generateSVG(
        SVGParams memory params
    ) internal pure returns (string memory svg) {
        return
            string(
                abi.encodePacked(
                    generateSVGDefs(),
                    generateSVGBorderText(params.merkleRoot),
                    generateSVGCardMantle(),
                    generateInvoiceDetails(
                        Strings.toString(params.tokenId),
                        params.rwaAmount,
                        params.rwaCurrency,
                        params.merkleProof,
                        params.agreementDate
                    ),
                    generateSVGRareSparkle(),
                    "</svg>"
                )
            );
    }

    function generateSVGDefs() private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<svg width="290" height="500" viewBox="0 0 290 500" xmlns="http://www.w3.org/2000/svg"',
                " xmlns:xlink='http://www.w3.org/1999/xlink'>",
                "<defs>",
                '<filter id="f1"><feImage result="p0" xlink:href="data:image/svg+xml;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            "<svg width='290' height='500' viewBox='0 0 290 500' xmlns='http://www.w3.org/2000/svg'><rect width='290px' height='500px' fill='#020071'/></svg>"
                        )
                    )
                ),
                '"/><feImage result="p1" xlink:href="data:image/svg+xml;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            "<svg width='290' height='500' viewBox='0 0 290 500' xmlns='http://www.w3.org/2000/svg'><circle cx='61' cy='393' r='120px' fill='#c17fc9'/></svg>"
                        )
                    )
                ),
                '"/><feBlend mode="overlay" in="p0" in2="p1" /><feBlend mode="exclusion" in2="p1" /><feBlend mode="overlay" in2="p1" result="blendOut" /><feGaussianBlur ',
                'in="blendOut" stdDeviation="69" /></filter> <clipPath id="corners"><rect width="290" height="500" rx="42" ry="42" /></clipPath>',
                '<path id="text-path-a" d="M40 12 H250 A28 28 0 0 1 278 40 V460 A28 28 0 0 1 250 488 H40 A28 28 0 0 1 12 460 V40 A28 28 0 0 1 40 12 z" />',
                '<path id="minimap" d="M234 444C234 457.949 242.21 463 253 463" />',
                '<filter id="top-region-blur"><feGaussianBlur in="SourceGraphic" stdDeviation="24" /></filter>',
                '<linearGradient id="grad-up" x1="1" x2="0" y1="1" y2="0"><stop offset="0.0" stop-color="white" stop-opacity="1" />',
                '<stop offset=".9" stop-color="white" stop-opacity="0" /></linearGradient>',
                '<linearGradient id="grad-down" x1="0" x2="1" y1="0" y2="1"><stop offset="0.0" stop-color="white" stop-opacity="1" /><stop offset="0.9" stop-color="white" stop-opacity="0" /></linearGradient>',
                '<mask id="fade-up" maskContentUnits="objectBoundingBox"><rect width="1" height="1" fill="url(#grad-up)" /></mask>',
                '<mask id="fade-down" maskContentUnits="objectBoundingBox"><rect width="1" height="1" fill="url(#grad-down)" /></mask>',
                '<mask id="none" maskContentUnits="objectBoundingBox"><rect width="1" height="1" fill="white" /></mask>',
                '<linearGradient id="grad-symbol"><stop offset="0.7" stop-color="white" stop-opacity="1" /><stop offset=".95" stop-color="white" stop-opacity="0" /></linearGradient>',
                '<mask id="fade-symbol" maskContentUnits="userSpaceOnUse"><rect width="290px" height="200px" fill="url(#grad-symbol)" /></mask></defs>',
                '<g clip-path="url(#corners)">',
                '<rect fill="none" x="0px" y="0px" width="290px" height="500px" />',
                '<rect style="filter: url(#f1)" x="0px" y="0px" width="290px" height="500px" />',
                ' <g style="filter:url(#top-region-blur); transform:scale(1.5); transform-origin:center top;">',
                '<rect fill="none" x="0px" y="0px" width="290px" height="500px" />',
                '<ellipse cx="50%" cy="0px" rx="180px" ry="120px" fill="#000" opacity="0.85" /></g>',
                '<rect x="0" y="0" width="290" height="500" rx="42" ry="42" fill="rgba(0,0,0,0)" stroke="rgba(255,255,255,0.2)" /></g>'
            )
        );
    }


    function generateSVGBorderText(
        bytes32 merkleRoot
    ) private pure returns (string memory svg) {
        string memory merkleRootStr = Strings.toHexString(uint256(merkleRoot), 32);
        svg = string(
            abi.encodePacked(
                '<text text-rendering="optimizeSpeed">',
                '<textPath startOffset="-100%" fill="white" font-family="\'Inter\', monospace" font-size="10px" xlink:href="#text-path-a">',
                "RWA",
                unicode" • ",
                "Invoice",
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s" repeatCount="indefinite" />',
                '</textPath> <textPath startOffset="0%" fill="white" font-family="\'Inter\', monospace" font-size="10px" xlink:href="#text-path-a">',
                merkleRootStr,
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s" repeatCount="indefinite" /> </textPath>',
                '<textPath startOffset="50%" fill="white" font-family="\'Inter\', monospace" font-size="10px" xlink:href="#text-path-a">',
                "RWA",
                unicode" • ",
                "Invoice",
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s"',
                ' repeatCount="indefinite" /></textPath><textPath startOffset="-50%" fill="white" font-family="\'Inter\', monospace" font-size="10px" xlink:href="#text-path-a">',
                "RWA is a decentralized invoice management system.",
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s" repeatCount="indefinite" /></textPath></text>'
            )
        );
    }

    function generateSVGCardMantle() private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<g mask="url(#fade-symbol)"><rect fill="none" x="0px" y="0px" width="290px" height="200px" /> <text y="70px" x="22px" fill="white" font-family="\'Inter\', monospace" font-weight="bold" font-size="34px">',
                "RWA",
                '</text><text y="115px" x="22px" fill="white" font-family="\'Inter\', monospace" font-weight="bold" font-size="34px">',
                "Invoice",
                "</text></g>",
                '<rect x="16" y="16" width="258" height="468" rx="26" ry="26" fill="rgba(0,0,0,0)" stroke="rgba(255,255,255,0.2)" />'
            )
        );
    }

    function generateInvoiceDetails(
        string memory invoiceID,
        string memory rwaAmount,
        string memory rwaCurrency,
        string memory merkleProof,
        string memory agreementDate
    ) private pure returns (string memory svg) {
        uint256 str2length = bytes(invoiceID).length + 12;
        uint256 str3length = bytes(rwaAmount).length + 16;
        uint256 str4length = bytes(rwaCurrency).length + 17;
        uint256 str6length = bytes(merkleProof).length + 14;
        uint256 str8length = bytes(agreementDate).length + 14;
        svg = string(
            abi.encodePacked(
                ' <g style="transform:translate(22px, 204px)">',
                '<rect width="',
                uint256(7 * (str2length + 4)).toString(),
                'px" height="26px" rx="8px" ry="8px" fill="rgba(0,0,0,0.6)" />',
                '<text x="12px" y="17px" font-family="\'Inter\', monospace" font-size="12px" fill="white"><tspan fill="rgba(255,255,255,0.6)">Invoice Id: </tspan>',
                invoiceID,
                "</text></g>",
                ' <g style="transform:translate(22px, 244px)">',
                '<rect width="',
                uint256(7 * (str3length + 3)).toString(),
                'px" height="26px" rx="8px" ry="8px" fill="rgba(0,0,0,0.6)" />',
                '<text x="12px" y="17px" font-family="\'Inter\', monospace" font-size="12px" fill="white"><tspan fill="rgba(255,255,255,0.6)">Invoice Amt: </tspan>',
                rwaAmount,
                "</text></g>",
                ' <g style="transform:translate(22px, 284px)">',
                '<rect width="',
                uint256(7 * (str4length + 4)).toString(),
                // uint256(7 * (str5length + 4)).toString(),
                'px" height="26px" rx="8px" ry="8px" fill="rgba(0,0,0,0.6)" />',
                '<text x="12px" y="17px" font-family="\'Inter\', monospace" font-size="12px" fill="white"><tspan fill="rgba(255,255,255,0.6)">Invoice Currency: </tspan>',
                rwaCurrency,
                "</text></g>",
                ' <g style="transform:translate(22px, 324px)">',
                '<rect width="',
                uint256(7 * (str8length + 4)).toString(),
                // uint256(7 * (str5length + 4)).toString(),
                'px" height="26px" rx="8px" ry="8px" fill="rgba(0,0,0,0.6)" />',
                '<text x="12px" y="17px" font-family="\'Inter\', monospace" font-size="12px" fill="white"><tspan fill="rgba(255,255,255,0.6)">Invoice Date: </tspan>',
                agreementDate,
                "</text></g>",


                ' <g style="transform:translate(22px, 364px)">',
                '<rect width="',
                uint256(7 * (str6length + 4)).toString(),
                'px" height="26px" rx="8px" ry="8px" fill="rgba(0,0,0,0.6)" />',
                '<text x="12px" y="17px" font-family="\'Inter\', monospace" font-size="12px" fill="white"><tspan fill="rgba(255,255,255,0.6)">Merkle Proof: </tspan>',
                merkleProof,
                "</text></g>"
            )
        );
    }

    function generateSVGRareSparkle() private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<g style="transform:translate(186px, 50px)">',
                "</g>"
            )
        );
    }
}