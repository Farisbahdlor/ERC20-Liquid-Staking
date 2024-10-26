// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BlumeLiquidStaking is ERC20, Ownable {
    IERC20 public blsToken;  // The BLS token
    uint256 public stakingRatio;  // Ratio of BLS to stBLS (e.g., 1:1)

    constructor(IERC20 _blsToken) ERC20("Staked BLS", "stBLS") Ownable(msg.sender) {
        blsToken = _blsToken;
        stakingRatio = 1;
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(blsToken.allowance(msg.sender, address(this)) >= amount, "Amount allowance at least as large as token staked");

        // Transfer BLS tokens from the staker to this contract
        blsToken.transferFrom(msg.sender, address(this), amount);

        // Mint stBLS tokens to the staker at a 1:1 ratio
        _mint(msg.sender, amount * stakingRatio);
    }

    function unstake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(balanceOf(msg.sender) >= amount, "Insufficient staked balance");

        // Burn stBLS tokens from the user's balance
        _burn(msg.sender, amount);

        // Transfer back BLS tokens from the contract to the user
        blsToken.transfer(msg.sender, amount / stakingRatio);
    }

    function checkStakedBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    // Update staking ratio, only by the owner
    function updateStakingRatio(uint256 newRatio) external onlyOwner {
        require(newRatio > 0, "Staking ratio must be positive");
        stakingRatio = newRatio;
    }
}
