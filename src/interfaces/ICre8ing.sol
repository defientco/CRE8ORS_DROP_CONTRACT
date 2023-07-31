// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface ICre8ing {
    /// @dev Emitted when a CRE8OR begins cre8ing.
    event Cre8ed(address, uint256 indexed tokenId);

    /// @dev Emitted when a CRE8OR stops cre8ing; either through standard means or
    ///     by expulsion.
    event Uncre8ed(address, uint256 indexed tokenId);

    /// @dev Emitted when a CRE8OR is expelled from the Warehouse.
    event Expelled(address, uint256 indexed tokenId);

    /// @notice Missing cre8ing status
    error CRE8ING_NotCre8ing(address, uint256 tokenId);

    /// @notice Cre8ing Closed
    error Cre8ing_Cre8ingClosed();

    /// @notice Cre8ing
    error Cre8ing_Cre8ing();

    function cre8ingPeriod(
        address,
        uint256
    ) external view returns (bool cre8ing, uint256 current, uint256 total);

    function setCre8ingOpen(address, bool) external;

    function expelFromWarehouse(address, uint256) external;
}
