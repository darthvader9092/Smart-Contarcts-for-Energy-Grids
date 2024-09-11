# Energy Market Smart Contract

This repository contains the code for an **Energy Market** smart contract, implemented in Solidity. The contract allows users to register, place orders for energy (buy/sell), and execute trades in a decentralized energy trading market.

## Features

- **User Registration**: Users can register as either a Consumer, Producer, or Prosumer.
- **Order Placement**: Users can place orders to buy or sell energy units at a specified price.
- **Secure Transaction Execution**: The contract ensures that trades between users are executed securely, with accuracy and precision.
- **Ownership Control**: The contract owner has the sole authority to start trade execution by matching the placed orders.
- **Transparency**: The state of the user (before and after transactions) and details of the orders are recorded and made visible.

## Smart Contract Details

### Functions

- **registerUser(UserType userType)**: Register a new user as either Consumer, Producer, or Prosumer.
- **placeOrder(uint energyUnits, uint energyPricePerUnit, bool isBuyOrder)**: Allows a user to place an order (buy/sell) for energy units at a specific price.
- **matchOrders()**: Matches existing buy/sell orders to execute trades.
- **withdrawBalance()**: Allows users to withdraw their Ether balance from the contract.
- **getOrders()**: Fetch the list of current orders in the market.

### Events

- **UserRegistered**: Emitted when a new user registers.
- **OrderPlaced**: Emitted when an order is placed by a user.
- **TransactionExecuted**: Emitted when a trade is successfully executed between two users.

## Getting Started

### Prerequisites

- Solidity version: ^0.5.0
- Ethereum development environment like [Remix](https://remix.ethereum.org/), [Truffle](https://www.trufflesuite.com/), or [Hardhat](https://hardhat.org/).
- [MetaMask](https://metamask.io/) for interacting with the Ethereum network.

### Deployment

1. Clone this repository:
    ```bash
    git clone https://github.com/yourusername/energy-market-contract.git
    cd energy-market-contract
    ```

2. Deploy the contract to your preferred Ethereum test network (e.g., Rinkeby, Goerli) using Remix or Truffle.

3. Interact with the contract via Remix or through a DApp front-end using Web3.js or Ethers.js.

## Usage

- Register as a user (consumer, producer, or prosumer).
- Place energy buy/sell orders.
- Admin matches orders and executes trades.
- View transaction details and order history.

## License

This project is licensed under the MIT License.

## Acknowledgments

Special thanks to the Solidity and Ethereum developer community for inspiration and resources.
