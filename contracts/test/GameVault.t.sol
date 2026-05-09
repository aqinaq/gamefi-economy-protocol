// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GameToken.sol";
import "../src/GameVault.sol";

contract GameVaultTest is Test {
    GameToken asset;
    GameVault vault;

    address user = address(1);

    function setUp() public {
        asset = new GameToken();
        vault = new GameVault(asset);

        asset.mint(user, 1_000 ether);

        vm.prank(user);
        asset.approve(address(vault), type(uint256).max);
    }

    function testDeposit() public {
        vm.prank(user);
        vault.deposit(100 ether, user);

        assertEq(vault.balanceOf(user), 100 ether);
        assertEq(vault.totalAssets(), 100 ether);
    }

    function testWithdraw() public {
        vm.startPrank(user);

        vault.deposit(100 ether, user);
        vault.withdraw(40 ether, user, user);

        assertEq(vault.balanceOf(user), 60 ether);
        assertEq(vault.totalAssets(), 60 ether);

        vm.stopPrank();
    }

    function testPreviewDeposit() public view {
        assertEq(vault.previewDeposit(100 ether), 100 ether);
    }
}
