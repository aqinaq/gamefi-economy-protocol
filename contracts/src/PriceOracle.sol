// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface AggregatorV3Interface {
    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}

contract PriceOracle {
    AggregatorV3Interface public immutable feed;
    uint256 public immutable maxStaleness;

    error StalePrice();
    error InvalidPrice();

    constructor(address _feed, uint256 _maxStaleness) {
        require(_feed != address(0), "Oracle: zero feed");
        feed = AggregatorV3Interface(_feed);
        maxStaleness = _maxStaleness;
    }

    function getPrice() external view returns (uint256) {
        (, int256 answer,, uint256 updatedAt,) = feed.latestRoundData();

        if (answer <= 0) revert InvalidPrice();
        if (block.timestamp - updatedAt > maxStaleness) revert StalePrice();

        return uint256(answer);
    }
}
