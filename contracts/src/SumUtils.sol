// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SumUtils {
    function sumSolidity(uint256[] memory data) external pure returns (uint256 total) {
        for (uint256 i = 0; i < data.length; i++) {
            total += data[i];
        }
    }

    function sumYul(uint256[] memory data) external pure returns (uint256 total) {
        assembly {
            let len := mload(data)
            let ptr := add(data, 0x20)
            let end := add(ptr, mul(len, 0x20))

            for { } lt(ptr, end) { ptr := add(ptr, 0x20) } {
                total := add(total, mload(ptr))
            }
        }
    }
}
