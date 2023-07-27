// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface ICollectionHolderMint {
    /// @notice Mapping to track whether a specific uint256 value (token ID) has been claimed or not.
    function freeMintClaimed(uint256) external view returns (bool);

    function maxClaimedFree(address) external view returns (uint256);

    /// @notice The address of the collection contract that mints and manages the tokens.
    function _collectionContractAddress() external view returns (address);

    /**
     * @dev Mint function to create a new token, assign it to the specified recipient, and trigger additional actions.
     * @param tokenId The ID of the token to be minted.
     * @param target The address of the `ICre8ors` contract that will handle the minting and PFP token creation.
     * @param recipient The address to whom the newly minted token will be assigned.
     * @return pfpTokenId The ID of the corresponding PFP token that was minted for the `recipient`.
     */
    function mint(
        uint256 tokenId,
        address target,
        address recipient
    ) external returns (uint256 pfpTokenId);
}
