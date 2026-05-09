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

        vm.roll(block.number + 1);
        vm.roll(block.number + 1);
    }

    function testGovernorParameters() public view {
        assertEq(governor.votingDelay(), 7200);
        assertEq(governor.votingPeriod(), 50400);
        assertEq(governor.quorumNumerator(), 4);
        assertEq(treasury.owner(), address(timelock));
    }

    function testProposalLifecycle() public {
        address[] memory targets = new address[](1);
        uint256[] memory values = new uint256[](1);
        bytes[] memory calldatas = new bytes[](1);

        targets[0] = address(treasury);
        values[0] = 0;
        calldatas[0] = abi.encodeWithSelector(
            bytes4(keccak256("transferOwnership(address)")),
            voter
        );

        string memory description = "Transfer treasury ownership to voter";

        vm.prank(voter);
        uint256 proposalId = governor.propose(
            targets,
            values,
            calldatas,
            description
        );

        vm.roll(block.number + governor.votingDelay() + 1);

        vm.prank(voter);
        governor.castVote(proposalId, 1);

        vm.roll(block.number + governor.votingPeriod() + 1);

        bytes32 descriptionHash = keccak256(bytes(description));

        governor.queue(targets, values, calldatas, descriptionHash);

        vm.warp(block.timestamp + 2 days + 1);

        governor.execute(targets, values, calldatas, descriptionHash);

        assertEq(treasury.owner(), voter);
    }
}
