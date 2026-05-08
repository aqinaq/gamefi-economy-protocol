// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GameToken.sol";
import "../src/GameAMM.sol";

contract GameAMMTest is Test {
    GameToken tokenA;
    GameToken tokenB;
    GameAMM amm;

    address user = address(1);

    function setUp() public {
        tokenA = new GameToken();
        tokenB = new GameToken();
        amm = new GameAMM(address(tokenA), address(tokenB));

        tokenA.mint(user, 10_000 ether);
        tokenB.mint(user, 10_000 ether);

        vm.startPrank(user);
        tokenA.approve(address(amm), type(uint256).max);
        tokenB.approve(address(amm), type(uint256).max);
        vm.stopPrank();
    }

    function testAddLiquidity() public {
        vm.prank(user);
        amm.addLiquidity(100 ether, 100 ether);

        assertEq(amm.reserveA(), 100 ether);
        assertEq(amm.reserveB(), 100 ether);
        assertGt(amm.balanceOf(user), 0);
    }

    function testSwapTokenAForTokenB() public {
        vm.startPrank(user);

        amm.addLiquidity(100 ether, 100 ether);

        uint256 beforeBalance = tokenB.balanceOf(user);
        amm.swap(address(tokenA), 10 ether, 1 ether);
        uint256 afterBalance = tokenB.balanceOf(user);

        assertGt(afterBalance, beforeBalance);

        vm.stopPrank();
    }

    function testSlippageReverts() public {
        vm.startPrank(user);

        amm.addLiquidity(100 ether, 100 ether);

        vm.expectRevert();
        amm.swap(address(tokenA), 10 ether, 99 ether);

        vm.stopPrank();
    }
}
