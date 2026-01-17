// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script, console} from "forge-std/Script.sol";
import {TokenBridge} from "../src/TokenBridge.sol";

contract DeploySepolia is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // ETH Sepolia network configuration
        address tokenGateway = 0x0000000000000000000000000000000000000000; // TODO: Replace with actual TokenGateway
        address feeToken = 0x0000000000000000000000000000000000000000;    // TODO: Replace with actual fee token

        vm.startBroadcast(deployerPrivateKey);

        TokenBridge bridge = new TokenBridge(tokenGateway, feeToken);

        vm.stopBroadcast();

        console.log("TokenBridge deployed to:", address(bridge));
        console.log("TokenGateway:", tokenGateway);
        console.log("FeeToken:", feeToken);
        console.log("Owner:", bridge.OWNER());
    }
}