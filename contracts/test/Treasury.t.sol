// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Treasury.sol";

contract TreasuryTest is Test {
    Treasury treasury;

    address payable user = payable(address(1));

    function setUp() public {
        treasury = new Treasury();
        vm.deal(address(this), 10 ether);
    }

    function testReceiveETH() public {
        payable(address(treasury)).transfer(1 ether);
        assertEq(address(treasury).balance, 1 ether);
    }

    function testWithdrawETH() public {
        payable(address(treasury)).transfer(1 ether);

        treasury.withdrawETH(user, 0.5 ether);

        assertEq(user.balance, 0.5 ether);
        assertEq(address(treasury).balance, 0.5 ether);
    }

    function testOnlyOwnerCanWithdraw() public {
        payable(address(treasury)).transfer(1 ether);

        vm.prank(user);
        vm.expectRevert();
        treasury.withdrawETH(user, 0.5 ether);
    }
}
