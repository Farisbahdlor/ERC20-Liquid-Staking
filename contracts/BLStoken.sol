// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BLS is ERC20 {
    constructor(uint256 initialSupply) ERC20("Blume Staking Token", "BLS") {
        _mint(msg.sender, initialSupply);
    }
}
