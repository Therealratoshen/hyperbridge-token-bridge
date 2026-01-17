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
        // Test that the contract deploys with correct parameters
        assertEq(address(tokenBridge.tokenGateway()), mockTokenGateway);
        assertEq(tokenBridge.feeToken(), mockFeeToken);
    }

    // Basic functionality tests for challenge-compliant version
    function test_Constructor() public {
        TokenBridge newBridge = new TokenBridge(address(0x789), address(0xABC));
        assertEq(address(newBridge.tokenGateway()), address(0x789));
        assertEq(newBridge.feeToken(), address(0xABC));
    }
}