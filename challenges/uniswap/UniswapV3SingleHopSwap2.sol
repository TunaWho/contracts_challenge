// SPDX-License-Identifier: MIT

/**
Swap WETH for USDC and then USDC for DAI.

exactInput - Sell all of input token.
exactOutput - Buy specific amount of output token.
Here is the interface for Uniswap V3 router, ISwapRouter.

*/


pragma solidity ^0.8.17;

import "./IERC20.sol";

interface ISwapRouter {
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint deadline;
        uint amountIn;
        uint amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    function exactInputSingle(
        ExactInputSingleParams calldata params
    ) external payable returns (uint amountOut);

    struct ExactInputParams {
        bytes path;
        address recipient;
        uint deadline;
        uint amountIn;
        uint amountOutMinimum;
    }

    function exactInput(
        ExactInputParams calldata params
    ) external payable returns (uint amountOut);

    struct ExactOutputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint deadline;
        uint amountOut;
        uint amountInMaximum;
        uint160 sqrtPriceLimitX96;
    }

    function exactOutputSingle(
        ExactOutputSingleParams calldata params
    ) external payable returns (uint amountIn);

    struct ExactOutputParams {
        bytes path;
        address recipient;
        uint deadline;
        uint amountOut;
        uint amountInMaximum;
    }

    function exactOutput(
        ExactOutputParams calldata params
    ) external payable returns (uint amountIn);
}

contract UniswapV3MultiHopSwap {
    ISwapRouter private constant router =
        ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);

    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    IERC20 private constant weth = IERC20(WETH);
    IERC20 private constant dai = IERC20(DAI);

    function swapExactInputMultiHop(uint amountIn, uint amountOutMin) external {
        weth.transferFrom(msg.sender, address(this), amountIn);
        weth.approve(address(router), amountIn);

        bytes memory path = abi.encodePacked(
            WETH,
            uint24(3000),
            USDC,
            uint24(100),
            DAI
        );

        ISwapRouter.ExactInputParams memory params = ISwapRouter
            .ExactInputParams({
                path: path,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: amountOutMin
            });

        router.exactInput(params);
    }

    function swapExactOutputMultiHop(
        uint amountOut,
        uint amountInMax
    ) external {
        weth.transferFrom(msg.sender, address(this), amountInMax);
        weth.approve(address(router), amountInMax);

        bytes memory path = abi.encodePacked(
            DAI,
            uint24(100),
            USDC,
            uint24(3000),
            WETH
        );

        ISwapRouter.ExactOutputParams memory params = ISwapRouter
            .ExactOutputParams({
                path: path,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountOut: amountOut,
                amountInMaximum: amountInMax
            });

        uint amountIn = router.exactOutput(params);

        if (amountIn < amountInMax) {
            weth.approve(address(router), 0);
            weth.transfer(msg.sender, amountInMax - amountIn);
        }
    }
}