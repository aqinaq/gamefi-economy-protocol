// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SumUtils.sol";

contract SumUtilsTest is Test {
    SumUtils utils;

    function setUp() public {
        utils = new SumUtils();
    }

    function testSolidityAndYulReturnSameResult() public {
        uint256[] memory data = new uint256[](5);
        data[0] = 1;
        data[1] = 2;
        data[2] = 3;
        data[3] = 4;
        data[4] = 5;

        assertEq(utils.sumSolidity(data), 15);
        assertEq(utils.sumYul(data), 15);
        assertEq(utils.sumSolidity(data), utils.sumYul(data));
    }

    function testGasComparison() public view {
        uint256[] memory data = new uint256[](10);

        for (uint256 i = 0; i < data.length; i++) {
            data[i] = i + 1;
        }

        utils.sumSolidity(data);
        utils.sumYul(data);
    }
}
