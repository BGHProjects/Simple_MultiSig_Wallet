// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
pragma abicoder v2;

import "./Ownable.sol";

contract Destroyable is Ownable {
    function destroy() public onlyOwner {
        /*
        Need to cast msg.sender to address payable
        because address is not the same as address payable
        (address has fewer methods than address payable
        and hence has a smaller memory requirement)
        */
        address payable receiver = payable(msg.sender);
        selfdestruct(receiver);
    }
}
