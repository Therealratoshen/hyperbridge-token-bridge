// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ITokenGateway, TeleportParams} from "@hyperbridge/core/apps/TokenGateway.sol";
// For bridging existing ERC20 tokens, IERC20 is appropriate
// Hyperbridge's HyperFungibleToken is for gateway-controlled tokens
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Combined TokenBridge and Counter contract
// TokenBridge provides cross-chain token bridging with Hyperbridge
// Counter provides basic counting functionality for demonstration

contract TokenBridge {
    ITokenGateway public immutable TOKEN_GATEWAY;
    address public immutable FEE_TOKEN;
    address public immutable OWNER;

    // Fee configuration
    uint256 public constant RELAYER_FEE = 0.001 ether; // 0.001 ETH in wei
    uint256 public constant PROTOCOL_FEE = 50; // 0.5% in basis points

    // Fee tracking
    mapping(address => uint256) public accumulatedFees; // token => accumulated protocol fees

    // Counter functionality (from Counter.sol)
    uint256 public number;

    event TokensBridged(
        address indexed user,
        address indexed token,
        uint256 amount,
        address recipient,
        bytes destChain,
        uint256 relayerFee,
        uint256 protocolFee
    );

    event FeesWithdrawn(
        address indexed token,
        uint256 amount,
        address indexed to
    );

    constructor(address _tokenGateway, address _feeToken) {
        TOKEN_GATEWAY = ITokenGateway(_tokenGateway);
        FEE_TOKEN = _feeToken;
        OWNER = msg.sender;
    }
    
    /// @notice Bridge ERC20 tokens to another chain using Hyperbridge teleport with fee handling
    /// @dev This function calculates protocol fees, handles relayer fees, and initiates cross-chain transfer
    /// @param token The ERC20 token contract address to bridge
    /// @param symbol The token symbol (e.g., "USDC", "WETH") used for asset identification
    /// @param amount The amount of tokens to bridge (in token's smallest unit, before fees)
    /// @param recipient The recipient address on the destination chain
    /// @param destChain The destination chain identifier as bytes (e.g., chain name or ID)
    function bridgeTokens(
        address token,
        string memory symbol,
        uint256 amount,
        address recipient,
        bytes memory destChain
    ) external payable {
        // Calculate protocol fee (0.5% of amount)
        uint256 protocolFee = (amount * PROTOCOL_FEE) / 10000;
        uint256 netAmount = amount - protocolFee;

        // Ensure user sends enough native tokens for relayer fee
        require(msg.value >= RELAYER_FEE, "Insufficient relayer fee");

        // Refund excess native tokens
        if (msg.value > RELAYER_FEE) {
            (bool success,) = payable(msg.sender).call{value: msg.value - RELAYER_FEE}("");
            require(success, "Refund failed");
        }

        // Transfer net tokens from sender to this contract (excluding protocol fee)
        require(IERC20(token).transferFrom(msg.sender, address(this), netAmount), "Transfer failed");

        // Accumulate protocol fee for this token
        accumulatedFees[token] += protocolFee;

        // Approve the gateway to spend net tokens
        IERC20(token).approve(address(TOKEN_GATEWAY), netAmount);
        IERC20(FEE_TOKEN).approve(address(TOKEN_GATEWAY), type(uint256).max);

        // Compute assetId as keccak256 of symbol
        bytes32 assetId = keccak256(abi.encodePacked(symbol));

        // Prepare teleport parameters with fees
        TeleportParams memory params = TeleportParams({
            amount: netAmount,                          // Amount after protocol fee
            relayerFee: RELAYER_FEE,                    // Fee for relayers
            assetId: assetId,
            redeem: true,                               // Redeem ERC20 on destination
            to: bytes32(uint256(uint160(recipient))),  // Convert address to bytes32
            dest: destChain,
            timeout: uint64(block.timestamp + 3600),   // 1 hour timeout
            nativeCost: RELAYER_FEE,                    // Use native tokens for relayer fee
            data: ""                                    // No additional data
        });

        // Initiate the cross-chain transfer
        TOKEN_GATEWAY.teleport(params);

        // Emit event for transparency
        emit TokensBridged(
            msg.sender,
            token,
            netAmount,
            recipient,
            destChain,
            RELAYER_FEE,
            protocolFee
        );
    }

    /// @notice Calculate the net amount after protocol fee
    /// @param amount The gross amount
    /// @return netAmount The amount after deducting protocol fee
    /// @return protocolFee The protocol fee amount
    function calculateFees(uint256 amount) public pure returns (uint256 netAmount, uint256 protocolFee) {
        protocolFee = (amount * PROTOCOL_FEE) / 10000;
        netAmount = amount - protocolFee;
    }

    /// @notice Withdraw accumulated protocol fees (only owner)
    /// @param token The token to withdraw fees for
    /// @param amount The amount to withdraw
    function withdrawFees(address token, uint256 amount) external {
        require(msg.sender == OWNER, "Only owner can withdraw fees");
        require(amount <= accumulatedFees[token], "Insufficient accumulated fees");

        accumulatedFees[token] -= amount;
        require(IERC20(token).transfer(OWNER, amount), "Fee withdrawal failed");

        emit FeesWithdrawn(token, amount, OWNER);
    }

    /// @notice Get total relayer fee required for bridging
    function getTotalFee() external pure returns (uint256) {
        return RELAYER_FEE;
    }

    /// @notice Estimate bridge cost for a given amount
    /// @param amount The amount to bridge
    /// @return netAmount Amount that will be received
    /// @return protocolFee Protocol fee charged
    /// @return totalNativeFee Total native tokens needed
    function estimateBridgeCost(uint256 amount) external pure returns (
        uint256 netAmount,
        uint256 protocolFee,
        uint256 totalNativeFee
    ) {
        (netAmount, protocolFee) = calculateFees(amount);
        totalNativeFee = RELAYER_FEE;
    }

    // Counter functionality (from Counter.sol)

    /// @notice Set the counter to a specific number
    /// @param newNumber The new value for the counter
    function setNumber(uint256 newNumber) external {
        number = newNumber;
    }

    /// @notice Increment the counter by 1
    function increment() external {
        number++;
    }

    /// @notice Get the current counter value
    /// @return The current counter value
    function getNumber() external view returns (uint256) {
        return number;
    }
}