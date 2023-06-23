# ERC777 Reentrancy Attack Demo

This project demonstrates an ERC777 reentrancy attack on the `tokensReceived` hook. It consists of the following components:

- ERC1820Registry: The contract representing the ERC1820 registry.
- ERC777TokenContract: The vulnerable ERC777 token contract that allows the reentrancy attack. It has an initial supply of 1000 tokens.
- attackerContract: The malicious contract that exploits the reentrancy vulnerability in the ERC777 token contract.
- attacker: The signer account used for the attack.
- withdrawalLimit: The maximum amount of tokens that can be withdrawn.

## Test Cases

### Deployment Check

Verifies if the contracts are deployed and logs their addresses.

### Registry Value Update

Ensures that the attacker contract updates the registry value correctly.

### Token Balance Check

Retrieves the total supply of tokens from the ERC777 token contract and verifies if it matches the expected value of 1000.

### Attacker Contract Balance Check

Verifies that the balance of the attacker contract is initially 0.

### Start Attack and Check Attacker Contract Balance

Executes the attack function and checks the balance of the attacker contract after the attack.

### Prevent Immediate Re-Attack

Ensures that claiming tokens immediately after the attack is not allowed within a 1-day cooldown period.

These tests showcase the reentrancy attack vulnerability in the ERC777 token contract by utilizing the `tokensReceived` hook. The project demonstrates the importance of properly securing token transfers and preventing reentrancy attacks in smart contract development.
