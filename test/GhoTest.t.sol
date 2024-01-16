// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/StdCheats.sol";
import {IERC20} from "aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import {IPool} from "aave-v3-core/contracts/interfaces/IPool.sol";
import {GhoToken} from "gho-core/src/contracts/gho/GhoToken.sol";
import {IGhoToken} from "gho-core/src/contracts/gho/interfaces/IGhoToken.sol";

contract GhoTest is StdCheats, Test {
    IERC20 dai = IERC20(0xD77b79BE3e85351fF0cbe78f1B58cf8d1064047C);
    IPool pool = IPool(0x617Cf26407193E32a771264fB5e9b8f09715CdfB);
    GhoToken gho = GhoToken(0xcbE9771eD31e761b744D3cB9eF78A1f32DD99211);

    address WE = address(0x1);

    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("goerli"), 8818553);
        // Top up our account with 100 DAI
        deal(address(dai), WE, 100e18);
        // Take control of GHO token
        address owner = gho.owner();
        vm.prank(owner);
        gho.transferOwnership(WE);
        // We start interacting
        vm.startPrank(WE);
    }

    function testMintGho() public {
        // Approve the Aave Pool to pull DAI funds
        dai.approve(address(pool), 100e18);
        // Supply 100 DAI to Aave Pool
        pool.supply(address(dai), 100e18, WE, 0);

        // Mint 10 GHO (2 for variable interest rate mode)
        pool.borrow(address(gho), 10e18, 2, 0, WE);
        assertEq(gho.balanceOf(WE), 10e18);

        // Time flies
        vm.roll(20);

        // We send 10 GHO to a friend
        address FRIEND = address(0x1234);
        gho.transfer(FRIEND, 10e18);
        assertEq(gho.balanceOf(WE), 0);
        assertEq(gho.balanceOf(FRIEND), 10e18);
    }

    function testFacilitator() public {
        // Add Facilitator
        gho.addFacilitator(
            WE,
            IGhoToken.Facilitator({
                bucketCapacity: 1_000_000e18, // 1M GHO
                bucketLevel: 0,
                label: "WeFacilitator"
            })
        );

        // Mint 10 GHO to a friend
        address FRIEND = address(0x1234);
        gho.mint(FRIEND, 10e18);
        assertEq(gho.balanceOf(WE), 0);
        assertEq(gho.balanceOf(FRIEND), 10e18);
    }
}
