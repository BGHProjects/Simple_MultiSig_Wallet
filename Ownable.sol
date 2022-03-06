// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
pragma abicoder v2;

// Only allows the owner of the contract to run a function
contract Ownable {
    address internal owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _; // Runs the function
    }

    constructor() {
        owner = msg.sender;
    }
}
