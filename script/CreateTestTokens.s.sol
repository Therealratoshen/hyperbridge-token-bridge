// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script, console} from "forge-std/Script.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Simple test ERC20 token for bridging tests
contract TestToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 1000000 * 10**decimals()); // Mint 1M tokens
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract CreateTestTokens is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        // Deploy test tokens
        TestToken usdc = new TestToken("USD Coin", "USDC");
        TestToken weth = new TestToken("Wrapped Ether", "WETH");
        TestToken dai = new TestToken("Dai Stablecoin", "DAI");

        vm.stopBroadcast();

        console.log("Test tokens deployed successfully!");
        console.log("USDC:", address(usdc));
        console.log("WETH:", address(weth));
        console.log("DAI:", address(dai));
        console.log("Deployer received 1,000,000 of each token");
    }

    // Deploy tokens on Paseo
    function deployOnPaseo() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        TestToken usdc = new TestToken("USD Coin", "USDC");
        TestToken pas = new TestToken("Paseo Token", "PAS");

        vm.stopBroadcast();

        console.log("Paseo Test Tokens:");
        console.log("USDC:", address(usdc));
        console.log("PAS:", address(pas));
    }

    // Deploy tokens on Sepolia
    function deployOnSepolia() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        TestToken usdc = new TestToken("USD Coin", "USDC");
        TestToken weth = new TestToken("Wrapped Ether", "WETH");

        vm.stopBroadcast();

        console.log("Sepolia Test Tokens:");
        console.log("USDC:", address(usdc));
        console.log("WETH:", address(weth));
    }
}