// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CryptoBank {

    address public admin;
    uint256 public maxUserEtherBalance;  
    mapping(address => uint256) public userBalancesEther;
    mapping(address => mapping(address => uint256)) public userTokenBalances; // user => token => balance
    bool public paused;

    event EtherDeposit(address indexed user_, uint256 amount_);
    event EtherWithdrawal(address indexed user_, uint256 amount_);
    event MaxEtherBalanceUpdated(uint256 oldMaxBalance, uint256 newMaxBalance);
    event ContractPaused(address indexed admin);
    event ContractUnpaused(address indexed admin);
    event TokenDeposit(address indexed user, address indexed token, uint256 amount);
    event TokenWithdrawal(address indexed user, address indexed token, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    constructor(address admin_, uint256 maxUserEtherBalance_) {
      maxUserEtherBalance = maxUserEtherBalance_;
      admin = admin_;
    }

    function depositEther() external payable whenNotPaused {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        require((userBalancesEther[msg.sender] + msg.value) <= maxUserEtherBalance, "Deposit exceeds max user balance");
        userBalancesEther[msg.sender] += msg.value;

        emit EtherDeposit(msg.sender, msg.value);
    }

    function withdrawEther(uint256 amount_) external whenNotPaused {
        // CEI pattern: Checks + Effects + Interactions
        // Checks
        require(amount_ > 0, "Withdrawal amount must be greater than zero");
        require(amount_ <= userBalancesEther[msg.sender], "Insufficient balance");            
        // Effects - Update state before transfer to prevent re-entrancy,
        userBalancesEther[msg.sender] -= amount_;
        // Interactions - Transfer ether to the user using call
        (bool success,) = msg.sender.call{value: amount_}(""); //here execute funct Receive(possible reentracy)
        require(success, "Transfer failed");

        emit EtherWithdrawal(msg.sender, amount_);
    }

    function depositToken(address token, uint256 amount) external whenNotPaused {
        require(amount > 0, "Deposit amount must be greater than zero");
        require(IERC20(token).transferFrom(msg.sender, address(this), amount), "Token transfer failed");

        userTokenBalances[msg.sender][token] += amount;
        emit TokenDeposit(msg.sender, token, amount);
    }

    function withdrawToken(address token, uint256 amount) external whenNotPaused {
        require(amount > 0, "Withdrawal amount must be greater than zero");
        require(userTokenBalances[msg.sender][token] >= amount, "Insufficient token balance");

        userTokenBalances[msg.sender][token] -= amount;
        require(IERC20(token).transfer(msg.sender, amount), "Token transfer failed");

        emit TokenWithdrawal(msg.sender, token, amount);
    }

    function getTokenBalance(address user, address token) external view returns (uint256) {
        return userTokenBalances[user][token];
    }

    function setMaxEtherBalance(uint256 newMaxUserEtherBalance_) external onlyAdmin {
        maxUserEtherBalance = newMaxUserEtherBalance_;
        emit MaxEtherBalanceUpdated(maxUserEtherBalance, newMaxUserEtherBalance_);
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function transferOwnership(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "New admin cannot be the zero address");
        admin = newAdmin;
    }

    function recoverEtherInContract() external onlyAdmin {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No funds to recover");
        (bool success,) = admin.call{value: contractBalance}("");
        require(success, "Recovery funds failed");
    }

    function recoverTokensInContract(address token, uint256 amount, address recipient) external onlyAdmin {
        require(token != address(0), "Invalid token address");
        require(recipient != address(0), "Invalid recipient address");
        require(amount > 0, "Amount must be greater than zero");
        require(IERC20(token).balanceOf(address(this)) >= amount, "Insufficient token balance in contract");

        require(IERC20(token).transfer(recipient, amount), "Token transfer failed");
    }
    
    function pauseContract() external onlyAdmin {
        paused = true;
        emit ContractPaused(msg.sender);
    }

    function unpauseContract() external onlyAdmin {
        paused = false;
        emit ContractUnpaused(msg.sender);
    }
}