// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IFreeMinter {
    error MissingDiscount();
    error FreeMintAlreadyClaimed();
    error DuplicatesFound();

    function mint(
        uint256[] calldata passportTokenIDs,
        address recipient
    ) external returns (uint256);

    function addDiscount(address[] calldata recipient) external;

    function removeDiscount(address recipient) external;

    /// @dev Checks if the specified recipient has a discount.
    /// @param recipient The address of the recipient to check for the discount.
    /// @return A boolean indicating whether the recipient has a discount or not.
    function hasDiscount(address recipient) external view returns (bool);
}
