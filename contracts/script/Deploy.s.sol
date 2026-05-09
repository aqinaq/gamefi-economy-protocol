// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

import "../src/GameToken.sol";
import "../src/GameItems.sol";
import "../src/Treasury.sol";
import "../src/GameAMMFactory.sol";
import "../src/GameVault.sol";
import "../src/GameConfigV1.sol";
import "../src/PriceOracle.sol";
import "../src/GameGovernor.sol";

import "@openzeppelin/contracts/governance/TimelockController.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        GameToken token = new GameToken();
        GameItems items = new GameItems();
        Treasury treasury = new Treasury();
        GameAMMFactory factory = new GameAMMFactory();
        GameVault vault = new GameVault(token);

        GameConfigV1 configImpl = new GameConfigV1();
        bytes memory initData = abi.encodeWithSelector(
            GameConfigV1.initialize.selector,
            10,
            100 ether
        );
        ERC1967Proxy configProxy = new ERC1967Proxy(address(configImpl), initData);

        address[] memory proposers = new address[](0);
        address[] memory executors = new address[](0);

        TimelockController timelock = new TimelockController(
            2 days,
            proposers,
            executors,
            msg.sender
        );

        GameGovernor governor = new GameGovernor(token, timelock);

        timelock.grantRole(timelock.PROPOSER_ROLE(), address(governor));
        timelock.grantRole(timelock.EXECUTOR_ROLE(), address(0));

        treasury.transferOwnership(address(timelock));

        vm.stopBroadcast();

        console2.log("GameToken:", address(token));
        console2.log("GameItems:", address(items));
        console2.log("Treasury:", address(treasury));
        console2.log("GameAMMFactory:", address(factory));
        console2.log("GameVault:", address(vault));
        console2.log("GameConfigProxy:", address(configProxy));
        console2.log("Timelock:", address(timelock));
        console2.log("GameGovernor:", address(governor));
    }
}
