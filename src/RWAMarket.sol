// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IERC20} from "aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import {ERC20} from "aave-v3-core/contracts/dependencies/openzeppelin/contracts/ERC20.sol";
import {Ownable} from "aave-v3-core/contracts/dependencies/openzeppelin/contracts/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {GhoToken} from "gho-core/src/contracts/gho/GhoToken.sol";
import {IGhoToken} from "gho-core/src/contracts/gho/interfaces/IGhoToken.sol";
import {IERC721} from "./NFT/FlattenERC721.sol";
import "./maths/Bancor.sol";

/**
 * @title Liquid Staking Token
 * @dev ERC20 token which represents a claim on the underlying staked token.
 * The staked token is locked in the contract and can be released by burning the LST.
 * The LST can be minted by depositing the staked token.
 * The LST can be burned by withdrawing the staked token.
 */

contract LiquidStakingToken is ERC20, Ownable {
    constructor(
        string memory tokenName,
        string memory tokenSymbol
    ) ERC20(tokenName, tokenSymbol) {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public onlyOwner {
        _burn(from, amount);
    }
}

contract RWAMarket is Ownable, ReentrancyGuard, BancorFormula {
    mapping(address => uint256) public balances;
    uint32 public reserveRatio;
    bool public isMarketCreated = false;
    GhoToken gho = GhoToken(0xcbE9771eD31e761b744D3cB9eF78A1f32DD99211);
    LiquidStakingToken public lstToken;

    event MarketCreated(address indexed creator);
    event Deposited(address indexed depositor, uint256 amount);
    event Withdrawn(address indexed recipient, uint256 amount);
    event Bought(address indexed buyer, uint256 amount);
    event Sold(address indexed seller, uint256 amount);

    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        uint256 _reserveRatio,
        uint256 initialAmount,
        address recipient
    ) Ownable() {
        require(initialAmount > 0, "Initial amount must be greater than 0");
        require(
            _reserveRatio > 0 && _reserveRatio <= 1000000,
            "Invalid reserve ratio"
        );
        require(recipient != address(0), "Invalid recipient address");

        lstToken = new LiquidStakingToken(tokenName, tokenSymbol);
        reserveRatio = uint32(_reserveRatio);
        isMarketCreated = true;

        emit MarketCreated(recipient);
    }

    function deposit(uint256 amount) public onlyOwner {
        require(amount > 0, "Must deposit at least 1 token");
        uint256 amountToMint = calculatePurchaseReturn(
            lstToken.totalSupply(),
            gho.balanceOf(address(this)),
            reserveRatio,
            amount
        );
        require(amountToMint > 0, "Must mint at least 1 token");
        balances[msg.sender] = balances[msg.sender] + amountToMint;
        lstToken.mint(msg.sender, amountToMint);
        emit Deposited(msg.sender, amountToMint);
    }

    function buy(uint256 amount) public payable {
        require(amount > 0, "Must buy at least 1 token");
        require(amount <= gho.balanceOf(msg.sender), "Insufficient balance");
        gho.transferFrom(msg.sender, address(this), amount);
        uint256 amountToBuy = calculatePurchaseReturn(
            lstToken.totalSupply(),
            gho.balanceOf(address(this)),
            reserveRatio,
            amount
        );
        require(amountToBuy > 0, "Must buy at least 1 token");
        balances[msg.sender] = balances[msg.sender] + amountToBuy;
        lstToken.mint(msg.sender, amountToBuy);
        emit Bought(msg.sender, amountToBuy);
    }

    function sell(uint256 amount) public onlyOwner {
        require(amount > 0, "Must sell at least 1 token");
        require(amount <= balances[msg.sender], "Insufficient balance");
        uint256 amountToSell = calculateSaleReturn(
            lstToken.totalSupply(),
            gho.balanceOf(address(this)),
            reserveRatio,
            amount
        );
        gho.transferFrom(address(this), msg.sender, amountToSell);

        balances[msg.sender] = balances[msg.sender] - amountToSell;
        lstToken.burn(msg.sender, amountToSell);
        gho.transfer(msg.sender, amountToSell);
        emit Sold(msg.sender, amountToSell);
    }

    function getBalance() public view returns (uint256) {
        return gho.balanceOf(address(this));
    }
}
