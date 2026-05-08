// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./GameConfigV1.sol";

contract GameConfigV2 is GameConfigV1 {
    uint256 public rareDropRate;

    function setRareDropRate(uint256 _rareDropRate) external onlyOwner {
        rareDropRate = _rareDropRate;
    }

    function version() external pure override returns (string memory) {
        return "V2";
    }
}
