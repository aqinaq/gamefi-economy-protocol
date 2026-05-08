// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GameItems.sol";

contract GameItemsTest is Test {
    GameItems items;
    address player = address(1);
    uint256 constant GOLD = 1;

    function setUp() public {
        items = new GameItems();
    }

    function testMintItem() public {
        items.mint(player, GOLD, 10);
        assertEq(items.balanceOf(player, GOLD), 10);
    }

    function testBatchMint() public {
        uint256[] memory ids = new uint256[](2);
        uint256[] memory amounts = new uint256[](2);

        ids[0] = 1;
        ids[1] = 2;
        amounts[0] = 100;
        amounts[1] = 50;

        items.mintBatch(player, ids, amounts);

        assertEq(items.balanceOf(player, 1), 100);
        assertEq(items.balanceOf(player, 2), 50);
    }
}
