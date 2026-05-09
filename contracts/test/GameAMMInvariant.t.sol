// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GameToken.sol";
import "../src/GameAMM.sol";

contract GameAMMInvariantTest is Test {
    GameToken tokenA;
    GameToken tokenB;
    GameAMM amm;

    address user = address(1);

    function setUp() public {
        tokenA = new GameToken();
        tokenB = new GameToken();
        amm = new GameAMM(address(tokenA), address(tokenB));

        tokenA.mint(user, 1_000_000 ether);
        tokenB.mint(user, 1_000_000 ether);

        vm.startPrank(user);
        tokenA.approve(address(amm), type(uint256).max);
        tokenB.approve(address(amm), type(uint256).max);
        amm.addLiquidity(100_000 ether, 100_000 ether);
        vm.stopPrank();

        targetContract(address(amm));
    }

    function invariantPoolAlwaysHasLiquidity() public view {
        assertGt(tokenA.balanceOf(address(amm)), 0);
        assertGt(tokenB.balanceOf(address(amm)), 0);
    }

    function invariantTotalLpSupplyPositive() public view {
        assertGt(amm.totalSupply(), 0);
    }
}
