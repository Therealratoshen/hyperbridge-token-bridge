// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {TokenBridge} from "../src/TokenBridge.sol";

contract CounterTest is Test {
    TokenBridge public tokenBridge;

    function setUp() public {
        // Deploy TokenBridgeEnhanced with dummy addresses for testing counter functionality
        address dummyGateway = address(0x123);
        address dummyFeeToken = address(0x456);
        tokenBridge = new TokenBridge(dummyGateway, dummyFeeToken);
        tokenBridge.setNumber(0);
    }

    function test_Increment() public {
        tokenBridge.increment();
        assertEq(tokenBridge.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        tokenBridge.setNumber(x);
        assertEq(tokenBridge.number(), x);
    }

    function test_GetNumber() public {
        tokenBridge.setNumber(42);
        assertEq(tokenBridge.getNumber(), 42);
    }
}
