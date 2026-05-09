// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/PriceOracle.sol";

contract MockAggregator {
    int256 public answer;
    uint256 public updatedAt;

    constructor(int256 _answer, uint256 _updatedAt) {
        answer = _answer;
        updatedAt = _updatedAt;
    }

    function setAnswer(int256 _answer) external {
        answer = _answer;
    }

    function setUpdatedAt(uint256 _updatedAt) external {
        updatedAt = _updatedAt;
    }

    function latestRoundData()
        external
        view
        returns (uint80, int256, uint256, uint256, uint80)
    {
        return (1, answer, block.timestamp, updatedAt, 1);
    }
}

contract PriceOracleTest is Test {
    MockAggregator feed;
    PriceOracle oracle;

    function setUp() public {
        vm.warp(10 days);

        feed = new MockAggregator(2000e8, block.timestamp);
        oracle = new PriceOracle(address(feed), 1 hours);
    }

    function testReturnsPrice() public view {
        assertEq(oracle.getPrice(), 2000e8);
    }

    function testRevertsOnStalePrice() public {
        feed.setUpdatedAt(block.timestamp - 2 hours);

        vm.expectRevert(PriceOracle.StalePrice.selector);
        oracle.getPrice();
    }

    function testRevertsOnInvalidPrice() public {
        feed.setAnswer(0);

        vm.expectRevert(PriceOracle.InvalidPrice.selector);
        oracle.getPrice();
    }
}
