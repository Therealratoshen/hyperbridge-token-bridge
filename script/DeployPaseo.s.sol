// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script, console} from "forge-std/Script.sol";
import {TokenBridge} from "../src/TokenBridge.sol";

contract DeployPaseo is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Paseo network configuration - TODO: Replace with actual addresses
        address tokenGateway = 0x0000000000000000000000000000000000000000;
        address feeToken = 0x0000000000000000000000000000000000000000;

        vm.startBroadcast(deployerPrivateKey);

        // Deploy the professional TokenBridge contract
        TokenBridge bridge = new TokenBridge(tokenGateway, feeToken);

        vm.stopBroadcast();

        console.log("=== PASEO DEPLOYMENT COMPLETE ===");
        console.log("TokenBridge (Professional):", address(bridge));
        console.log("TokenGateway:", tokenGateway);
        console.log("FeeToken:", feeToken);
        console.log("Deployer:", vm.addr(deployerPrivateKey));
    }


}