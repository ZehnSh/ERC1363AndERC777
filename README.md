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

---
---
---
---

ERC-1363 is a token standard that extends the ERC-20 token standard by introducing additional functions and interfaces to enable more advanced token interactions. It provides enhanced functionality for contracts to accept token payments, create token payable crowdsales, enable token-based services, and more.

The key components of ERC-1363 are:

- `transferAndCall` and `transferFromAndCall`: These functions allow token transfers while triggering a callback function, `onTransferReceived`, in the recipient contract. The recipient contract can perform specific actions upon receiving the tokens, such as updating balances, executing logic, or triggering events. The transfer and callback are atomic, ensuring that either the entire transaction is successful or it reverts completely.

- `approveAndCall`: This function enables the approval of tokens for a specific spender contract while triggering a callback function, `onApprovalReceived`, in the spender contract. This allows for more sophisticated authorization and interaction patterns, such as token-based subscriptions or multi-step transactions. The approval and callback are also atomic, ensuring consistent and reliable execution.

- ERC1363Receiver interface: Contracts that want to accept token payments using `transferAndCall` or `transferFromAndCall` must implement the `ERC1363Receiver` interface. This interface defines the required function, `onTransferReceived`, which is called when tokens are transferred to the contract. The atomicity ensures that the tokens are either received and processed completely or the entire transaction is reverted.

- ERC1363Spender interface: Contracts that want to accept token approvals using `approveAndCall` must implement the `ERC1363Spender` interface. This interface defines the required function, `onApprovalReceived`, which is called when token approvals are granted to the contract. The atomicity guarantees that the approvals are either accepted entirely, enabling further interactions, or the transaction is reverted.

By implementing the ERC-1363 interface, contracts can accept token payments, create token payable crowdsales, offer services in exchange for tokens, facilitate token-based subscriptions, and enable various token utility use cases. It provides a standardized and atomic way for contracts to interact with ERC-20 tokens, ensuring consistent and reliable execution of token transfers and callbacks.

---
## ERC-777 and Hooks

ERC-777 is a token standard for fungible tokens on the Ethereum blockchain that improves upon the ERC-20 standard. It introduces a more advanced token transfer mechanism and additional features, one of which is the concept of hooks.

Hooks in the context of ERC-777 refer to a powerful feature that allows smart contracts to define and execute pre and post-transfer actions during token transfers. Hooks enable customized behaviors and actions to be executed before and after tokens are sent or received.

ERC-777 introduces two types of hooks:

1. **TokensToSend**: The TokensToSend hook is called before updating the token contract's holdings during a token transfer. This hook allows the sender to define conditions and actions that should be executed before the transfer occurs. For example, a contract implementing the TokensToSend hook could check for certain requirements, perform additional validations, or execute specific logic before allowing the transfer to proceed.

2. **TokensReceived**: The TokensReceived hook is called after the token contract's holdings are updated during a token transfer. This hook enables the receiver to specify actions that should be performed upon receiving the tokens. The contract implementing the TokensReceived hook can execute custom logic based on the received tokens, update internal state, trigger events, or interact with other contracts.

By utilizing hooks, ERC-777 provides a flexible mechanism for extending the behavior of token transfers. It allows smart contracts to define additional rules, validations, or actions beyond the basic transfer functionality provided by the token contract. Hooks can be used to enforce complex transfer conditions, implement advanced authorization mechanisms, trigger events, or integrate with other decentralized applications (dApps) within the Ethereum ecosystem.

## Token Control Contracts

Token Control Contracts are smart contracts that leverage the ERC-777 token standard to gain greater control and flexibility over token transfers. These contracts act as intermediaries between the ERC-777 token contract and the token holders, allowing for the implementation of custom logic and rules for token transfers.

To interact with an ERC-777 token contract, the Token Control Contract imports the ERC777 contract from a library and holds a reference to an instance of the ERC777 token. This reference is obtained through the constructor of the Token Control Contract by passing the address of an existing ERC777 token contract as a parameter.

Token Control Contracts make use of the hooks provided by ERC-777 to define pre and post-transfer actions. By implementing the TokensToSend hook, the Token Control Contract can specify conditions and actions that need to be executed before a token transfer occurs. This could include checking for certain requirements, performing additional validations, or executing custom logic. On the other hand, by implementing the TokensReceived hook, the Token Control Contract can define actions that should be performed upon receiving tokens, such as executing custom logic, updating internal state, triggering events, or interacting with other contracts.www

---
# ERC-777 Security Considerations

## Pros

- ERC-777 introduces the concept of hooks, allowing for customized behaviors and additional validation logic during token transfers. This can enhance security by enabling developers to implement specific checks and safeguards.
- The "TokensToSend" hook provides an opportunity to validate certain conditions before a transfer occurs, reducing the risk of unauthorized or incorrect token transfers.
- ERC-777 supports the use of events, which can be used to provide real-time notifications of token transfers and other important contract events.
- It allows for more efficient token transfers, reducing the potential for reentrancy attacks.

## Cons

- The flexibility provided by hooks can introduce complexity, making the implementation more challenging and potentially increasing the risk of vulnerabilities if not properly implemented or audited.
- As ERC-777 is a newer standard, it may have a smaller ecosystem and fewer tooling options compared to ERC-20, which could impact the availability of security-related resources and expertise.
- The introduction of new features and functionalities may require additional security considerations and thorough testing to ensure they do not introduce unforeseen vulnerabilities.

# ERC-1363 Security Considerations

ERC-1363 inherits the security considerations of ERC-777 and adds some improvements.

## Pros

- The integration of EIP-712 for structured data hashing and signing enhances the security of token transfers by providing a standardized way to verify transaction data integrity and authenticity.
- The simplified token approval process through the transferAndCall function reduces the potential for human error and simplifies the user experience, which can indirectly contribute to security by minimizing the risk of incorrect approval configurations.

## Cons

- ERC-1363 is built upon ERC-777, which means it inherits any potential security risks associated with ERC-777 itself.
- As with any new standard, there may be a learning curve and potential undiscovered vulnerabilities that could be exploited.

---
---

## ERC1363 Improved Upon ERC777

### Standardized Interface
ERC-1363 introduces a standardized interface that extends ERC-20 and ERC-777 interfaces. It defines new functions and events, such as `transferAndCall` and `onTransferReceived`, which allow tokens to support both ERC-20 and ERC-777 functionalities. This standardization enables developers to implement a single token contract that is compatible with multiple token standards, reducing complexity and enhancing interoperability.

### Simplified Token Approval Process
ERC-1363 simplifies the token approval process by introducing the `transferAndCall` function. This function combines the token transfer and callback functionality in a single step. It allows users to approve token transfers and trigger a callback function in a single transaction, reducing the need for separate approve and call transactions. This streamlines the approval process, reduces the potential for approval misconfigurations, and improves user experience.
