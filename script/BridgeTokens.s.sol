// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script, console} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {TokenBridge} from "../src/TokenBridge.sol";

contract BridgeTokens is Script {
    // Test token addresses (replace with actual deployed tokens)
    address constant USDC_SEPOLIA = 0x1234567890123456789012345678901234567890; // Example
    address constant USDC_PASEO = 0x0987654321098765432109876543210987654321;   // Example

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Configuration
        address bridgeAddress = vm.envAddress("BRIDGE_ADDRESS");
        address tokenAddress = vm.envAddress("TOKEN_ADDRESS");
        string memory tokenSymbol = vm.envString("TOKEN_SYMBOL");
        uint256 amount = vm.envUint("BRIDGE_AMOUNT");
        address recipient = vm.envAddress("RECIPIENT_ADDRESS");
        bytes memory destChain = vm.envBytes("DEST_CHAIN");

        vm.startBroadcast(deployerPrivateKey);

        // Approve tokens first
        IERC20 token = IERC20(tokenAddress);
        token.approve(bridgeAddress, amount);

        // Bridge tokens using professional version with fees
        TokenBridge bridge = TokenBridge(bridgeAddress);
        bridge.bridgeTokens{value: bridge.getTotalFee()}(
            tokenAddress,
            tokenSymbol,
            amount,
            recipient,
            destChain
        );

        vm.stopBroadcast();

        console.log("Bridge transaction completed!");
        console.log("Amount:", amount);
        console.log("Recipient:", recipient);
        console.log("Destination chain:", string(destChain));
    }

    // Helper function to bridge with specific parameters
    function bridgeUSDCToSepolia(uint256 amount, address recipient) external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        address bridgeAddress = vm.envAddress("PASEO_BRIDGE_ADDRESS");

        // Approve USDC
        IERC20(USDC_PASEO).approve(bridgeAddress, amount);

        // Bridge to Sepolia
        TokenBridge(bridgeAddress).bridgeTokens{value: 0.001 ether}(
            USDC_PASEO,
            "USDC",
            amount,
            recipient,
            bytes("ETH_SEPOLIA")
        );

        vm.stopBroadcast();

        // Bridge transaction completed - check TokenBridge for event logs
    }

    // Helper function to bridge with specific parameters from Sepolia to Paseo
    function bridgeUSDCToPaseo(uint256 amount, address recipient) external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        address bridgeAddress = vm.envAddress("SEPOLIA_BRIDGE_ADDRESS");

        // Approve USDC
        IERC20(USDC_SEPOLIA).approve(bridgeAddress, amount);

        // Bridge to Paseo
        TokenBridge(bridgeAddress).bridgeTokens{value: 0.001 ether}(
            USDC_SEPOLIA,
            "USDC",
            amount,
            recipient,
            bytes("PASEO")
        );

        vm.stopBroadcast();

        // Note: Console logging would require import {console} from forge-std
        // console.log("Bridged", amount, "USDC to", recipient, "on Sepolia");
    }

    // Helper function to bridge with specific parameters from Sepolia to Paseo
    function bridgeUSDCToPaseo(uint256 amount, address recipient) external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        address bridgeAddress = vm.envAddress("SEPOLIA_BRIDGE_ADDRESS");

        // Approve USDC
        IERC20(USDC_SEPOLIA).approve(bridgeAddress, amount);

        // Bridge to Paseo
        TokenBridgeEnhanced(bridgeAddress).bridgeTokens{value: 0.001 ether}(
            USDC_SEPOLIA,
            "USDC",
            amount,
            recipient,
            bytes("PASEO")
        );

        vm.stopBroadcast();

        // console.log("Bridged", amount, "USDC to", recipient, "on Paseo");
    }
}