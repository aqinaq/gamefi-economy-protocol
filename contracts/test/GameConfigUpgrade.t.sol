// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "../src/GameConfigV1.sol";
import "../src/GameConfigV2.sol";

contract GameConfigUpgradeTest is Test {
    GameConfigV1 config;

    function setUp() public {
        GameConfigV1 implementation = new GameConfigV1();

        bytes memory initData = abi.encodeWithSelector(
            GameConfigV1.initialize.selector,
            10,
            100 ether
        );

        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), initData);

        config = GameConfigV1(address(proxy));
    }

    function testInitialValues() public view {
        assertEq(config.dropRate(), 10);
        assertEq(config.craftingCost(), 100 ether);
        assertEq(config.version(), "V1");
    }

    function testUpgradeToV2() public {
        GameConfigV2 implementationV2 = new GameConfigV2();

        config.upgradeToAndCall(address(implementationV2), "");

        GameConfigV2 upgraded = GameConfigV2(address(config));

        upgraded.setRareDropRate(3);

        assertEq(upgraded.version(), "V2");
        assertEq(upgraded.dropRate(), 10);
        assertEq(upgraded.craftingCost(), 100 ether);
        assertEq(upgraded.rareDropRate(), 3);
    }
}
