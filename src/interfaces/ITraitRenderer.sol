// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/**
 ██████╗██████╗ ███████╗ █████╗  ██████╗ ██████╗ ███████╗
██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝
██║     ██████╔╝█████╗  ╚█████╔╝██║   ██║██████╔╝███████╗
██║     ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██╔══██╗╚════██║
╚██████╗██║  ██║███████╗╚█████╔╝╚██████╔╝██║  ██║███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝                                                     
 */
interface ITraitRenderer {
    /// @notice Missing trait
    error Trait_NonExisting(uint256 _traitId);

    /// @notice TraitId higher than max allowed
    error Trait_MoreThanMax(uint256 _traitId);

    /// @notice Updated trait
    event Trait_Updated(uint256 _traitId);

    /// @notice Read trait for given tokenId
    function trait(uint256, uint256) external view returns (string memory);

    /// @notice Read all traits for given tokenId
    function tokenTraits(uint256) external view returns (string[] memory);

    /// @notice Read number of traits
    function numberOfTraits() external view returns (uint256);
}
