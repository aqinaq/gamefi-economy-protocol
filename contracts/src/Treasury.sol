// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Treasury is Ownable {
    event EthReceived(address indexed from, uint256 amount);
    event EthWithdrawn(address indexed to, uint256 amount);

    constructor() Ownable(msg.sender) {}

    receive() external payable {
        emit EthReceived(msg.sender, msg.value);
    }

    function withdrawETH(address payable to, uint256 amount) external onlyOwner {
        require(to != address(0), "Treasury: zero address");
        require(address(this).balance >= amount, "Treasury: insufficient balance");

        (bool success, ) = to.call{value: amount}("");
        require(success, "Treasury: transfer failed");

        emit EthWithdrawn(to, amount);
    }
}
