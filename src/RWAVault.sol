// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IERC20} from "aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import {Ownable} from "aave-v3-core/contracts/dependencies/openzeppelin/contracts/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {AccessControl} from "aave-v3-core/contracts/dependencies/openzeppelin/contracts/AccessControl.sol";
import {IPool} from "aave-v3-core/contracts/interfaces/IPool.sol";
import {GhoToken} from "gho-core/src/contracts/gho/GhoToken.sol";
import {IGhoToken} from "gho-core/src/contracts/gho/interfaces/IGhoToken.sol";
import {IERC721} from "./NFT/FlattenERC721.sol";
import {IRWAAsset} from "./NFT/IRWAAsset.sol";
import "./maths/Bancor.sol";
import "./Oracle/Oracle.sol";
import {LendingToken} from "./NFT/LendingToken.sol";
import "./RWAMarket.sol";

contract RWAVault is
    Ownable,
    ReentrancyGuard,
    AccessControl,
    BancorFormula,
    Oracle
{
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant MARKET_CREATOR_ROLE =
        keccak256("MARKET_CREATOR_ROLE");

    struct Market {
        uint256 tokenId;
        uint256 price;
        uint256 percentage;
        address seller;
        address buyer;
        bool isApproved;
    }
    RWAMarket[] public deployedMarkets;

    event MarketCreated(address indexed creator, address marketAddress);

    mapping(address => uint256) public balances;
    mapping(uint256 => Market) public markets;
    IERC721 public tradingToken;
    IERC20 dai = IERC20(0xD77b79BE3e85351fF0cbe78f1B58cf8d1064047C);
    IPool pool = IPool(0x617Cf26407193E32a771264fB5e9b8f09715CdfB);
    GhoToken gho = GhoToken(0xcbE9771eD31e761b744D3cB9eF78A1f32DD99211);
    IRWAAsset rwa = IRWAAsset(0xcbE9771eD31e761b744D3cB9eF78A1f32DD99211);
    event MarketCreated(
        uint256 tokenId,
        uint256 price,
        uint256 percentage,
        address seller
    );
    event MarketApproved(uint256 tokenId);

    constructor() Ownable() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
        _setupRole(MARKET_CREATOR_ROLE, msg.sender);
    }

    function proposeMarketCreation(uint256 tokenId) public payable {
        require(tokenId != 0, "Token does not exist");
        IRWAAsset.RWADetails memory details = rwa.getTokenDetails(tokenId);
        uint256 price = stringToUint(details._rwaAmount);
        uint256 percentage = getPercentage(tokenId);
        rwa.transferFrom(msg.sender, address(this), tokenId);
        Market memory market = Market({
            tokenId: tokenId,
            price: price,
            percentage: percentage,
            seller: msg.sender,
            buyer: address(this),
            isApproved: false
        });
        emit MarketCreated(tokenId, price, percentage, msg.sender);
    }

    function approveMarketCreation(
        uint256 tokenId
    ) public onlyRole(MARKET_CREATOR_ROLE) {
        Market storage market = markets[tokenId];

        // Check if the market exists for the token
        require(market.tokenId != 0, "Market does not exist");

        // Approve the market
        market.isApproved = true;
        gho.mint(
            market.seller,
            (market.price * market.percentage * 1e18) / 100
        );
        gho.mint(
            address(this),
            (market.price * (100 - market.percentage) * 1e18) / 100
        );
        uint256 initialAmount = (market.price * (market.percentage) * 1e18) /
            100;
        createMarket(
            "Liquid Staking Token " + string(market.tokenId),
            "LST",
            market.percentage,
            initialAmount,
            market.seller
        );
        // Emit an event (optional)
        emit MarketApproved(tokenId);
    }

    function createMarket(
        string memory tokenName,
        string memory tokenSymbol,
        uint256 reserveRatio,
        uint256 initialAmount,
        address recipient
    ) public {
        RWAMarket newMarket = new RWAMarket(
            tokenName,
            tokenSymbol,
            reserveRatio,
            initialAmount,
            recipient
        );
        gho.mint(address(this), initialAmount);
        newMarket.deposit(initialAmount);
        deployedMarkets.push(newMarket);
        emit MarketCreated(msg.sender, address(newMarket));
    }

    function stringToUint(string memory s) public pure returns (uint256) {
        bytes memory b = bytes(s);
        uint256 result = 0;
        for (uint256 i = 0; i < b.length; i++) {
            uint256 c = uint256(uint8(b[i]));
            if (c >= 48 && c <= 57) {
                result = result * 10 + (c - 48);
            }
        }
        return result;
    }
}
