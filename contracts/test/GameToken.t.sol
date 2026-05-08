// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GameToken.sol";

contract GameTokenTest is Test {
    GameToken token;

    address user = address(1);

    function setUp() public {
        token = new GameToken();
    }

    function testInitialSupply() public {
        uint256 supply = token.totalSupply();

        assertEq(supply, 1_000_000 ether);
    }

    function testMint() public {
        token.mint(user, 100 ether);

        assertEq(token.balanceOf(user), 100 ether);
    }
}