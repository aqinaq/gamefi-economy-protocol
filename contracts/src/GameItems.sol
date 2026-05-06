// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC1155} from "openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";

contract GameItems is ERC1155, Ownable {
    uint256 public constant WOOD = 1;
    uint256 public constant IRON = 2;
    uint256 public constant SWORD = 3;

    constructor(address initialOwner)
        ERC1155("ipfs://gamefi-economy/{id}.json")
        Ownable(initialOwner)
    {}

    function mint(address to, uint256 id, uint256 amount) external onlyOwner {
        _mint(to, id, amount, "");
    }

    function craftSword() external {
        _burn(msg.sender, WOOD, 2);
        _burn(msg.sender, IRON, 1);
        _mint(msg.sender, SWORD, 1, "");
    }
}