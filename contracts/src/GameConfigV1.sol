// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract GameConfigV1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 public dropRate;
    uint256 public craftingCost;

    function initialize(uint256 _dropRate, uint256 _craftingCost) public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();

        dropRate = _dropRate;
        craftingCost = _craftingCost;
    }

    function setDropRate(uint256 _dropRate) external onlyOwner {
        dropRate = _dropRate;
    }

    function setCraftingCost(uint256 _craftingCost) external onlyOwner {
        craftingCost = _craftingCost;
    }

    function version() external pure virtual returns (string memory) {
        return "V1";
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
