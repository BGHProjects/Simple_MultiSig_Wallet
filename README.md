# Simple_MultiSig_Wallet
A multiple signature wallet built with Solidity (0.8.7)

- Made to be run in a Remix IDE environment (https://remix.ethereum.org/#optimize=false&runs=200&evmVersion=null&version=soljson-v0.8.7+commit.e28d00a7.js)
- Allows users to add a number of addresses to approve transactions, and the number of approvals requied for a transaction to be approved
- Users can see the number of approvals required, owners of the contract, and all pending transfers
- Destroyable through the selfdestruct() command
