# 🏦 CryptoBank - Decentralized Ether and Token Bank

A Solidity-based smart contract for securely managing Ether and ERC20 tokens with advanced features such as pausing, role-based access control, and recovery mechanisms. The contract follows best practices like the Checks-Effects-Interactions (CEI) pattern and uses `call` for Ether transfers to prevent gas limit issues.

## 📑 Table of Contents
- [🧑‍💻 Features](#-features)
- [🎨 Technology Stack](#-technology-stack)
- [🗂️ Project Structure](#-project-structure)
- [📖 How to Use This Repo](#-how-to-use-this-repo)
- [🔮 Future Improvements](#-future-improvements)
- [📜 License](#-license)

## 🧑‍💻 Features
- **Ether Deposits and Withdrawals**: Users can deposit and withdraw Ether securely, with a configurable maximum balance per user.
- **ERC20 Token Support**: Users can deposit and withdraw ERC20 tokens.
- **Pausing**: Admins can pause all operations to mitigate risks during emergencies.
- **Role-Based Access Control**: Only the admin can perform critical operations like pausing, unpausing, and recovering funds.
- **Recovery Mechanisms**: Admins can recover accidentally sent Ether or ERC20 tokens.
- **CEI Pattern**: Implements the Checks-Effects-Interactions pattern to prevent reentrancy attacks.
- **Use of `call` for Ether Transfers**: Ensures compatibility with contracts that require more than 2300 gas for receiving Ether.

### 📜 Available Functions

| Function Name             | Description                                                                                     | Access Control       |
|---------------------------|-------------------------------------------------------------------------------------------------|----------------------|
| `depositEther()`          | Allows users to deposit Ether into the contract.                                               | Public               |
| `withdrawEther(uint256)`  | Allows users to withdraw their Ether balance.                                                   | Public               |
| `depositToken(address, uint256)` | Allows users to deposit ERC20 tokens into the contract.                                   | Public               |
| `withdrawToken(address, uint256)` | Allows users to withdraw their ERC20 token balance.                                     | Public               |
| `setMaxEtherBalance(uint256)` | Updates the maximum Ether balance allowed per user.                                         | Admin Only           |
| `pauseContract()`         | Pauses all contract operations.                                                                | Admin Only           |
| `unpauseContract()`       | Resumes all contract operations.                                                               | Admin Only           |
| `recoverEtherInContract()` | Recovers all Ether held in the contract.                                                      | Admin Only           |
| `recoverTokensInContract(address, uint256, address)` | Recovers ERC20 tokens held in the contract.                        | Admin Only           |
| `transferOwnership(address)` | Transfers admin rights to another address.                                                  | Admin Only           |

### 🔒 Security Considerations
1. **CEI Pattern**: All Ether withdrawals follow the Checks-Effects-Interactions pattern to prevent reentrancy attacks.
2. **Use of `call`**: Ether transfers use `call` instead of `transfer` or `send` to avoid gas limit issues.
3. **Pausing**: The contract can be paused during emergencies to prevent unauthorized operations.
4. **Role-Based Access Control**: Only the admin can perform sensitive operations like pausing, unpausing, and fund recovery.


## 🎨 Technology Stack

### Key Technologies
| Technology       | Purpose & Advantages                                                                                     |
|------------------|----------------------------------------------------------------------------------------------------------|
| **Solidity**     | A secure and efficient programming language for writing Ethereum-based smart contracts.                  |
| **CEI Pattern**  | Prevents reentrancy attacks by following the Checks-Effects-Interactions design pattern.                 |
| **call**         | Ensures Ether transfers are compatible with contracts requiring more than 2300 gas.                      |
| **Remix**        | A powerful web-based IDE for writing, testing, and deploying smart contracts.                            |

### Design Practices
- **Use of Audited Libraries**: Leverages OpenZeppelin's well-audited libraries to ensure security and reliability.
- **Event Logging**: Implements detailed event logging for all critical operations to enhance transparency and traceability.
- **Security Best Practices**: Follows Solidity security guidelines, including the use of `call` and CEI.

## 🗂️ Project Structure

The project is organized as follows:

```
src/
├── CryptoBank.sol  # Main contract implementation
```

## 📖 How to Use This Repo

Follow these steps to set up and deploy the contract:

### ⚙️ Setup

1. Clone the repository:
   ```sh
   git clone https://github.com/your-username/CryptoBank.git
   cd CryptoBank
   ```

### 🚀 Deployment

1. Compile the contract using Remix, Foundry, or your preferred deployment tool.

2. Deploy the contract using Remix, Foundry, or your preferred deployment tool.

### 🧪 Testing

Test the contract using Remix, Foundry, or your preferred deployment tool.

## 🔮 Future Improvements

- **Multi-Token Support**: Add support for additional token standards like ERC721 and ERC1155.
- **Dynamic Limits**: Allow the admin to set dynamic Ether and token limits for users.
- **Governance Integration**: Introduce a governance mechanism to decentralize decision-making for critical operations.
- **Staking Rewards**: Implement a staking mechanism to reward users for holding tokens in the contract.
- **Upgradeable Contract**: Use a proxy pattern to make the contract upgradeable for future feature additions.
- **Multisignature Wallet Support**: Integrate multisignature wallets for critical administrative actions to enhance security and decentralization.

## 📜 License

This project is licensed under the GPL-3.0 License. See the `LICENSE` file for details.