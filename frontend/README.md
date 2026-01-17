# Hyperbridge Token Bridge Frontend

A simple web interface for bridging tokens across chains using Hyperbridge protocol.

## Features

- 🔗 Connect MetaMask wallet
- 🌉 Bridge tokens between supported networks
- 📊 Real-time transaction status updates
- 🎯 User-friendly interface

## Primary Network Pair

- **Source**: Paseo Testnet
- **Destination**: ETH Sepolia

## All Supported Network Pairs

- **Paseo** ↔ **ETH Sepolia** (Primary)
- **BSC Testnet** ↔ **ETH Sepolia**
- **Optimism Sepolia** ↔ **ETH Sepolia**

## Setup

### Prerequisites

- Python 3.x (for the development server)
- MetaMask or compatible Web3 wallet
- Test tokens on the source network

### Running the Frontend

1. **Start the development server:**
   ```bash
   cd frontend
   python3 server.py
   ```

2. **Open your browser** and navigate to:
   ```
   http://localhost:8000
   ```

3. **Connect your wallet:**
   - Click "Connect Wallet" button
   - Approve MetaMask connection
   - Switch to the desired source network if prompted

## Usage

1. **Select Networks:**
   - Choose source chain (where your tokens are)
   - Choose destination chain (where you want to receive tokens)

2. **Enter Token Details:**
   - Token contract address (e.g., USDC on Sepolia)
   - Token symbol (e.g., "USDC")
   - Amount to bridge
   - Recipient address (your address on destination chain)

3. **Bridge Tokens:**
   - Click "Bridge Tokens" button
   - Approve token spending in MetaMask
   - Confirm the bridge transaction
   - Wait for confirmation

## Configuration

Before using the bridge, you need to deploy the `TokenBridge` contract and update the contract addresses in `index.html`:

```javascript
const CONTRACT_ADDRESSES = {
    '11155111': { // ETH Sepolia
        tokenGateway: '0x...', // Your deployed TokenBridge address
        feeToken: '0x...' // Fee token address
    },
    'paseo': {
        tokenGateway: '0x...',
        feeToken: '0x...'
    }
    // Add other networks as needed
};
```

## Development

The frontend is built with:
- **HTML5** for structure
- **CSS3** for styling
- **Vanilla JavaScript** for functionality
- **ethers.js v6** for Web3 interactions

## Security Notes

- This is a demo frontend for development/testing purposes
- Always verify contract addresses before bridging real tokens
- Test with small amounts first
- Ensure you're on the correct network before bridging

## Troubleshooting

- **"MetaMask not installed"**: Install MetaMask browser extension
- **"Failed to connect wallet"**: Refresh the page and try again
- **"Contract addresses not configured"**: Update the contract addresses in the code
- **Transaction fails**: Check if you have sufficient tokens and gas fees