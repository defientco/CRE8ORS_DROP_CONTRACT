// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IAllowlistMinter {
    error NoMoreMintsLeft();

    error TooEarlyForMinting();

    /// @dev Sets a new address for the MinterUtilities contract.
    /// @param _newMinterUtilityContractAddress The address of the new MinterUtilities contract.
    function setNewMinterUtilityContractAddress(address _newMinterUtilityContractAddress) external;
}
