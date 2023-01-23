// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ITraitRenderer} from "./interfaces/ITraitRenderer.sol";

/**
 ██████╗██████╗ ███████╗ █████╗  ██████╗ ██████╗ ███████╗
██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝
██║     ██████╔╝█████╗  ╚█████╔╝██║   ██║██████╔╝███████╗
██║     ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██╔══██╗╚════██║
╚██████╗██║  ██║███████╗╚█████╔╝╚██████╔╝██║  ██║███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝                                                       
 */
contract TraitRenderer is ITraitRenderer {
    /// @dev tokenId to cre8ing start time (0 = not cre8ing).
    mapping(uint256 => string)[] internal traits;

    /// @notice Read number of traits
    function numberOfTraits() external view returns (uint256) {
        return traits.length;
    }

    /// @notice Read trait for given tokenId
    /// @param _traitId id of trait
    /// @param _tokenId id of token
    function trait(uint256 _traitId, uint256 _tokenId)
        external
        view
        returns (string memory)
    {
        if (_traitId >= traits.length) {
            revert Trait_NonExisting(_traitId);
        }
        return traits[_traitId][_tokenId];
    }

    /// @notice Read all traits for given tokenId
    /// @param _tokenId id of token
    function tokenTraits(uint256 _tokenId)
        external
        view
        returns (string[] memory _traits)
    {
        _traits = new string[](traits.length);
        for (uint256 i = 0; i < traits.length; ) {
            _traits[i] = traits[i][_tokenId];
            unchecked {
                i += 1;
            }
        }
    }
}
