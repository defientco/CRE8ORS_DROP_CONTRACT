// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/**
 * @title Friends and Family Minter Interface
 * @notice Interface for the FriendsAndFamilyMinter contract, which allows minting new tokens with discounts for friends and family.
 */
interface IFriendsAndFamilyMinter {
    // Events
    error MissingDiscount();
    error ExistingDiscount();

    // Functions
    function hasDiscount(address recipient) external view returns (bool);

    function cre8orsNFT() external view returns (address);

    function minterUtilityContractAddress() external view returns (address);

    function maxClaimedFree(address) external view returns (uint256);

    function mint(address recipient) external returns (uint256);

    function addDiscount(address recipient) external;

    function removeDiscount(address recipient) external;

    function setNewMinterUtilityContractAddress(
        address _newMinterUtilityContractAddress
    ) external;
}
