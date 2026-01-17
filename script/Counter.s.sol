// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {TokenBridge} from "../src/TokenBridge.sol";

contract CounterScript is Script {
    TokenBridge public tokenBridge;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Dummy addresses for demonstration (replace with actual deployed addresses)
        address dummyGateway = address(0x1234567890123456789012345678901234567890);
        address dummyFeeToken = address(0x0987654321098765432109876543210987654321);

        vm.startBroadcast(deployerPrivateKey);

        tokenBridge = new TokenBridge(dummyGateway, dummyFeeToken);

        // Demonstrate counter functionality
        tokenBridge.setNumber(10);
        tokenBridge.increment();

        vm.stopBroadcast();

        console.log("TokenBridge deployed with Counter functionality!");
        console.log("Address:", address(tokenBridge));
        console.log("Counter value:", tokenBridge.number());
    }
}
