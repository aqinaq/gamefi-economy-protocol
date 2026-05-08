// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract GameAMM is ERC20 {
    using SafeERC20 for IERC20;

    IERC20 public immutable tokenA;
    IERC20 public immutable tokenB;

    uint256 public reserveA;
    uint256 public reserveB;

    uint256 public constant FEE_NUMERATOR = 997;
    uint256 public constant FEE_DENOMINATOR = 1000;

    event LiquidityAdded(address indexed provider, uint256 amountA, uint256 amountB, uint256 lpMinted);
    event Swapped(address indexed user, address tokenIn, uint256 amountIn, uint256 amountOut);

    constructor(address _tokenA, address _tokenB) ERC20("Game AMM LP", "GAMMLP") {
        require(_tokenA != address(0) && _tokenB != address(0), "AMM: zero address");
        require(_tokenA != _tokenB, "AMM: same token");

        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    function addLiquidity(uint256 amountA, uint256 amountB) external returns (uint256 lpMinted) {
        require(amountA > 0 && amountB > 0, "AMM: zero amount");

        tokenA.safeTransferFrom(msg.sender, address(this), amountA);
        tokenB.safeTransferFrom(msg.sender, address(this), amountB);

        if (totalSupply() == 0) {
            lpMinted = sqrt(amountA * amountB);
        } else {
            uint256 lpA = (amountA * totalSupply()) / reserveA;
            uint256 lpB = (amountB * totalSupply()) / reserveB;
            lpMinted = lpA < lpB ? lpA : lpB;
        }

        require(lpMinted > 0, "AMM: zero LP");

        reserveA += amountA;
        reserveB += amountB;

        _mint(msg.sender, lpMinted);

        emit LiquidityAdded(msg.sender, amountA, amountB, lpMinted);
    }

    function swap(address tokenIn, uint256 amountIn, uint256 minAmountOut) external returns (uint256 amountOut) {
        require(amountIn > 0, "AMM: zero amount");
        require(tokenIn == address(tokenA) || tokenIn == address(tokenB), "AMM: invalid token");

        bool isAIn = tokenIn == address(tokenA);

        IERC20 inputToken = isAIn ? tokenA : tokenB;
        IERC20 outputToken = isAIn ? tokenB : tokenA;

        uint256 reserveIn = isAIn ? reserveA : reserveB;
        uint256 reserveOut = isAIn ? reserveB : reserveA;

        inputToken.safeTransferFrom(msg.sender, address(this), amountIn);

        uint256 amountInWithFee = amountIn * FEE_NUMERATOR;
        amountOut = (amountInWithFee * reserveOut) / ((reserveIn * FEE_DENOMINATOR) + amountInWithFee);

        require(amountOut >= minAmountOut, "AMM: slippage");
        require(amountOut < reserveOut, "AMM: insufficient liquidity");

        if (isAIn) {
            reserveA += amountIn;
            reserveB -= amountOut;
        } else {
            reserveB += amountIn;
            reserveA -= amountOut;
        }

        outputToken.safeTransfer(msg.sender, amountOut);

        emit Swapped(msg.sender, tokenIn, amountIn, amountOut);
    }

    function sqrt(uint256 x) internal pure returns (uint256 y) {
        if (x == 0) return 0;
        uint256 z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
}
