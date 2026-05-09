// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/governance/TimelockController.sol";
import "../src/GameToken.sol";
import "../src/GameGovernor.sol";
import "../src/Treasury.sol";

contract GameGovernorTest is Test {
    GameToken token;
    TimelockController timelock;
    GameGovernor governor;
    Treasury treasury;

    address voter = address(1);

    function setUp() public {
        token = new GameToken();

        address[] memory proposers = new address[](0);
        address[] memory executors = new address[](0);

        timelock = new TimelockController(2 days, proposers, executors, address(this));
        governor = new GameGovernor(token, timelock);
        treasury = new Treasury();

        timelock.grantRole(timelock.PROPOSER_ROLE(), address(governor));
        timelock.grantRole(timelock.EXECUTOR_ROLE(), address(0));

        treasury.transferOwnership(address(timelock));

        token.mint(voter, 100_000 ether);

        vm.prank(voter);
        token.delegate(voter);
    }

    function testGovernorParameters() public view {
        assertEq(governor.votingDelay(), 7200);
        assertEq(governor.votingPeriod(), 50400);
        assertEq(governor.quorumNumerator(), 4);
        assertEq(owner(treasury), address(timelock));
    }

    function owner(Treasury t) internal view returns (address) {
        return t.owner();
    }
}
