// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";

contract VulnerableAccessToken is ERC777 {
    using Address for address;

    uint256 public withdrawalLimit;
    mapping(address => uint256) public lastWithdrawTime;

    constructor(uint256 _withdrawalLimit,address registryAddress)
        ERC777("name", "symbol", new address[](0),registryAddress)
    {
        withdrawalLimit = _withdrawalLimit;
        _mint(address(this), 1000, "", "");
    }

    function mint(uint256 _amount) external {
        _mint(msg.sender, _amount, "", "");
    }

    function withdrawFromContract(uint256 amount) external {
        require(
            block.timestamp > lastWithdrawTime[msg.sender] + 1 days,
            "Withdrawal not allowed yet."
        );
        require(
            amount <= withdrawalLimit,
            "Amount exceeds the withdrawal limit."
        );

        _send(address(this), msg.sender, amount, "", "", false);
        lastWithdrawTime[msg.sender] = block.timestamp;
    }
}