// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GameToken.sol";
import "../src/GameAMM.sol";
import "../src/GameAMMFactory.sol";

contract GameAMMFactoryTest is Test {
    GameToken tokenA;
    GameToken tokenB;
    GameAMMFactory factory;

    function setUp() public {
        tokenA = new GameToken();
        tokenB = new GameToken();
        factory = new GameAMMFactory();
    }

    function testCreateAMM() public {
        address ammAddress = factory.createAMM(address(tokenA), address(tokenB));

        assertTrue(ammAddress != address(0));

        GameAMM amm = GameAMM(ammAddress);

        assertEq(address(amm.tokenA()), address(tokenA));
        assertEq(address(amm.tokenB()), address(tokenB));
    }

    function testCreateAMMDeterministic() public {
        bytes32 salt = keccak256("GAME_AMM");

        address predicted = factory.predictAMMAddress(address(tokenA), address(tokenB), salt);

        address deployed = factory.createAMMDeterministic(address(tokenA), address(tokenB), salt);

        assertEq(predicted, deployed);
    }
}