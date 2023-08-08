// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Cre8orsERC6551} from "../utils/Cre8orsERC6551.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {ICre8ing} from "../interfaces/ICre8ing.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {ISubscription} from "../subscription/interfaces/ISubscription.sol";
import {Admin} from "../subscription/abstracts/Admin.sol";

contract DNAMinter is Cre8orsERC6551, Admin {
    ///@notice The address of the collection contract for DNA airdrops.
    address public dnaNft;

    /// @notice Initializes the contract with the address of the Cre8orsNFT contract.
    /// @param _dnaNft The address of the Cre8ors DNA contract to be used.
    /// @param _registry The address of the ERC6551 registry contract to be used.
    /// @param _implementation The address of the ERC6551 implementation contract to be used.
    constructor(
        address _dnaNft,
        address _registry,
        address _implementation
    ) Cre8orsERC6551(_registry, _implementation) {
        dnaNft = _dnaNft;
    }

    /// @notice Set the Cre8orsNFT contract address.
    /// @dev This function can only be called by an admin, identified by the
    ///     "cre8orsNFT" contract address.
    /// @param _dnaNft The new address of the DNA contract to be set.
    function setDnaNFT(address _dnaNft) public onlyAdmin(dnaNft) {
        dnaNft = _dnaNft;
    }

    /// @notice Set ERC6551 registry
    /// @param _registry ERC6551 registry
    function setErc6551Registry(address _registry) public onlyAdmin(dnaNft) {
        erc6551Registry = _registry;
    }

    /// @notice Set ERC6551 account implementation
    /// @param _implementation ERC6551 account implementation
    function setErc6551Implementation(
        address _implementation
    ) public onlyAdmin(dnaNft) {
        erc6551AccountImplementation = _implementation;
    }
}
