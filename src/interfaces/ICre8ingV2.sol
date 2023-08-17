// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface ICre8ingV2 {
    /////////////////////////////////////////////////
    /// EVENTS
    /////////////////////////////////////////////////
    /// @dev Emitted when a CRE8OR begins cre8ing.
    ///     ERC-5192 (recommended for gas efficiency)
    event Locked(uint256 tokenId);
    /// @dev Emitted when a CRE8OR stops cre8ing; either through standard means or
    ///     by expulsion.
    ///     ERC-5192 (recommended for gas efficiency)
    event Unlocked(uint256 tokenId);
    /// @dev Emitted when a CRE8OR is expelled from the Warehouse.
    event Expelled(address, uint256 indexed tokenId);

    /////////////////////////////////////////////////
    /// ERRORS
    /////////////////////////////////////////////////
    /// @notice Missing cre8ing status
    error Cre8ing_NotCre8ing(address, uint256 tokenId);
    /// @notice Cre8ing Closed
    error Cre8ing_Cre8ingClosed();
    /// @notice Token Locked
    error Cre8ing_Locked(uint256 tokenId);

    /////////////////////////////////////////////////
    /// FUNCTIONS
    /////////////////////////////////////////////////
    /// @notice Toggles cre8ing status for multiple tokens.
    /// @param _target The target address.
    /// @param tokenIds Array of token IDs to toggle.
    function toggleCre8ingTokens(
        address _target,
        uint256[] calldata tokenIds
    ) external;

    /// @notice Cre8ing period
    function cre8ingPeriod(
        address,
        uint256
    ) external view returns (bool cre8ing, uint256 current, uint256 total);

    /// @notice open / close staking
    function setCre8ingOpen(address, bool) external;

    /// @notice force removal from staking
    function expelFromWarehouse(address, uint256) external;

    /// @notice function getCre8ingStarted(
    function getCre8ingStarted(
        address _target,
        uint256 tokenId
    ) external view returns (uint256);

    /// @notice array of staked tokenIDs
    /// @dev used in cre8ors ui to quickly get list of staked NFTs.
    function cre8ingTokens(
        address _target
    ) external view returns (uint256[] memory stakedTokens);
}
