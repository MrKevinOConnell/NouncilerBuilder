// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./governor/IGovernor.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NouncilerBuilder is Ownable {
    IGovernor public governor;

    /**
     * @param _governor Address of the external governor contract to be wrapped.
     */
    constructor(address _governor) {
        require(_governor != address(0), "Invalid governor address");
        governor = IGovernor(_governor);
    }

    /**
     * @notice Wrapped propose function. 
     * @param targets List of addresses for the calls.
     * @param values List of ETH values for each call.
     * @param calldatas List of calldatas, one for each target.
     * @param description A description for the proposal.
     * @return The ID of the created proposal.
     */
    function propose(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description
    ) external onlyOwner returns (bytes32) {
        return governor.propose(targets, values, calldatas, description);
    }

    /**
     * @notice Wrapped castVoteWithReason function.
     * @param proposalId The ID of the proposal to vote on.
     * @param support The support value (0 = Against, 1 = For, 2 = Abstain).
     * @param reason The reason for casting the vote.
     * @return The weight of the vote.
     */
    function castVoteWithReason(
        bytes32 proposalId,
        uint256 support,
        string memory reason
    ) external onlyOwner returns (uint256) {
        return governor.castVoteWithReason(proposalId, support, reason);
    }

    /**
     * @notice Wrapped cancel function.
     * @param proposalId The ID of the proposal to cancel.
     */
    function cancel(bytes32 proposalId) external onlyOwner {
        governor.cancel(proposalId);
    }
}

