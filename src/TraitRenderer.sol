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
    /// @notice maximum number of traits in renderer.
    uint256 public MAX_TRAITS;

    /// @dev tokenId to cre8ing start time (0 = not cre8ing).
    mapping(uint256 => mapping(uint256 => string)) internal traits;

    /// @notice Read number of traits
    function numberOfTraits() public view returns (uint256) {
        uint256 count = 0;
        for (uint256 i = 0; i < MAX_TRAITS; ) {
            if (bytes(traits[i][0]).length > 0) {
                count += 1;
            }
            unchecked {
                i += 1;
            }
        }
        return count;
    }

    constructor(uint256 _max) {
        MAX_TRAITS = _max;
    }

    modifier onlyValidTraits(uint256 _traitId) {
        if (_traitId >= MAX_TRAITS || bytes(traits[_traitId][0]).length < 1) {
            revert Trait_NonExisting(_traitId);
        }

        _;
    }

    /// @notice Read trait for given tokenId
    /// @param _traitId id of trait
    /// @param _tokenId id of token
    function trait(uint256 _traitId, uint256 _tokenId)
        external
        view
        onlyValidTraits(_traitId)
        returns (string memory)
    {
        return traits[_traitId][_tokenId];
    }

    /// @notice Read all traits for given tokenId
    /// @param _tokenId id of token
    function tokenTraits(uint256 _tokenId)
        external
        view
        returns (string[] memory _traits)
    {
        _traits = new string[](MAX_TRAITS);
        for (uint256 i = 0; i < MAX_TRAITS; ) {
            _traits[i] = traits[i][_tokenId];
            unchecked {
                i += 1;
            }
        }
    }

    /// @notice Set values for a traitId
    /// @param _traitId id of trait
    /// @param _traitUri URI for the trait
    function setTrait(uint256 _traitId, string[] memory _traitUri) external {
        for (uint256 i = 0; i < _traitUri.length; ) {
            traits[_traitId][i] = _traitUri[i];
            unchecked {
                i += 1;
            }
        }
        emit Trait_Updated(_traitId);
    }
}
