// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {TokenBridge} from "../src/TokenBridge.sol";

contract TokenBridgeTest is Test {
    TokenBridge public tokenBridge;
    address public mockTokenGateway = address(0x123);
    address public mockFeeToken = address(0x456);

    function setUp() public {
        tokenBridge = new TokenBridge(mockTokenGateway, mockFeeToken);
    }

    function test_Deployment() public {
        assertEq(address(tokenBridge.TOKEN_GATEWAY()), mockTokenGateway);
        assertEq(tokenBridge.FEE_TOKEN(), mockFeeToken);
        assertEq(tokenBridge.OWNER(), address(this));
    }

    function test_FeeCalculations() public {
        uint256 amount = 1000000; // 1M wei
        (uint256 netAmount, uint256 protocolFee) = tokenBridge.calculateFees(amount);

        // Protocol fee should be 0.5% of 1M = 5000
        assertEq(protocolFee, 5000);
        assertEq(netAmount, 995000); // 1M - 5000

        // Total fee should be 0.001 ether
        assertEq(tokenBridge.getTotalFee(), 0.001 ether);
    }

    function test_EstimateBridgeCost() public {
        uint256 amount = 2000000; // 2M wei
        (uint256 netAmount, uint256 protocolFee, uint256 totalNativeFee) = tokenBridge.estimateBridgeCost(amount);

        assertEq(protocolFee, 10000); // 0.5% of 2M
        assertEq(netAmount, 1990000); // 2M - 10000
        assertEq(totalNativeFee, 0.001 ether);
    }
}