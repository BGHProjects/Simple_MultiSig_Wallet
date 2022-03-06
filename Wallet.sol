// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
pragma abicoder v2;
import "./Destroyable.sol";

contract Wallet is Destroyable {
    // Initial deployment values
    address[] public owners;
    uint256 limit;

    // Transfer variables
    struct Transfer {
        uint256 amount;
        address payable receiver;
        uint256 approvals;
        bool hasBeenSent;
        uint256 id;
    }
    Transfer[] transferRequests;
    mapping(address => mapping(uint256 => bool)) approvals; // Maps address to booleans via indices

    // Contract Events
    event TransferRequestCreated(
        uint256 _id,
        uint256 _amount,
        address _initiator,
        address _receiver
    );
    event ApprovalReceived(uint256 _id, uint256 _approvals, address _approver);
    event TransferApproved(uint256 _id);

    //  Only allow addresses in the owners list to continue executions
    modifier onlyOwners() {
        bool owner = false;
        for (uint256 i = 0; i < owners.length; i++) {
            if (owners[i] == msg.sender) {
                owner = true;
            }
        }
        require(owner == true);
        _; // Continues execution
    }

    // Initialse owners and limit
    constructor(address[] memory _owners, uint256 _limit) {
        owners = _owners;
        limit = _limit;
    }

    // Just need somewhere for the contract to receive money
    // Doesn't actually need to do anything
    function deposit() public payable {}

    // Creates an instance of Transfer and adds it to transferRequests array
    function createTransfer(uint256 _amount, address payable _receiver)
        public
        onlyOwners
    {
        require(msg.sender != _receiver); // Cannot send to yourself
        emit TransferRequestCreated(
            transferRequests.length,
            _amount,
            msg.sender,
            _receiver
        );
        transferRequests.push(
            Transfer(_amount, _receiver, 0, false, transferRequests.length)
        );
    }

    // Returns all pending transfer requests
    function getTransferRequests() public view returns (Transfer[] memory) {
        return transferRequests;
    }

    // Returns the current owners in the contract
    function getOwners() public view returns (address[] memory) {
        return owners;
    }

    // Returns the number of approvals required for a transaction
    function getLimit() public view returns (uint256) {
        return limit;
    }

    // Allows user to approve transfer request
    // Once approval limit is reached, transfers amount to recipient
    function approve(uint256 _id) public onlyOwners {
        require(approvals[msg.sender][_id] == false); // Owner must not have already voted
        require(transferRequests[_id].hasBeenSent == false); // Transfer must not have already been approved

        approvals[msg.sender][_id] = true;
        transferRequests[_id].approvals++;

        emit ApprovalReceived(_id, transferRequests[_id].approvals, msg.sender);

        // Handles if this approval satisfies transfer limit
        if (transferRequests[_id].approvals >= limit) {
            transferRequests[_id].hasBeenSent = true;
            transferRequests[_id].receiver.transfer(
                transferRequests[_id].amount
            );
            emit TransferApproved(_id);
        }
    }
}
