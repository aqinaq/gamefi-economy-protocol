

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./GameAMM.sol";

contract GameAMMFactory {
    event AMMCreated(address indexed amm, address indexed tokenA, address indexed tokenB, bytes32 salt);

    function createAMM(address tokenA, address tokenB) external returns (address amm) {
        amm = address(new GameAMM(tokenA, tokenB));
        emit AMMCreated(amm, tokenA, tokenB, bytes32(0));
    }

    function createAMMDeterministic(
        address tokenA,
        address tokenB,
        bytes32 salt
    ) external returns (address amm) {
        amm = address(new GameAMM{salt: salt}(tokenA, tokenB));
        emit AMMCreated(amm, tokenA, tokenB, salt);
    }

    function predictAMMAddress(
        address tokenA,
        address tokenB,
        bytes32 salt
    ) external view returns (address predicted) {
        bytes memory bytecode = abi.encodePacked(
            type(GameAMM).creationCode,
            abi.encode(tokenA, tokenB)
        );

        bytes32 hash = keccak256(
            abi.encodePacked(bytes1(0xff), address(this), salt, keccak256(bytecode))
        );

        predicted = address(uint160(uint256(hash)));
    }
}
