// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ERC721A} from "lib/ERC721A/contracts/ERC721A.sol";
import {IERC721A} from "lib/ERC721A/contracts/IERC721A.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";

/**
 ██████╗██████╗ ███████╗ █████╗  ██████╗ ██████╗ ███████╗
██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝
██║     ██████╔╝█████╗  ╚█████╔╝██║   ██║██████╔╝███████╗
██║     ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██╔══██╗╚════██║
╚██████╗██║  ██║███████╗╚█████╔╝╚██████╔╝██║  ██║███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝                                                       
 */
contract Burn721Minter {
    /// @notice Storage for contract mint information
    struct ContractMintInfo {
        address burnToken;
        uint256 burnQuantity;
    }

    /// @notice Event for a new contract initialized
    /// @dev admin function indexer feedback
    event NewMinterInitialized(
        address indexed target,
        address burnToken,
        uint256 burnQuantity
    );

    /// @notice Contract information mapping storage
    mapping(address => ContractMintInfo) internal _contractInfos;

    /// @notice Read Contract information mapping storage
    function contractInfos(
        address target
    ) public view returns (ContractMintInfo memory) {
        return _contractInfos[target];
    }

    /// @notice Getter for admin role associated with the contract to handle minting
    /// @param target target for contract to check admin
    /// @param user user address
    /// @return boolean if address is admin
    function isAdmin(address target, address user) public view returns (bool) {
        return IERC721Drop(target).isAdmin(user);
    }

    /// @notice Default initializer for burn data from a specific contract
    /// @param target target for contract to set mint data
    /// @param data data to init with
    function initializeWithData(
        address target,
        bytes memory data
    ) external onlyAdmin(target) {
        // data format: description, imageURI, animationURI, tokenId
        (address burnToken, uint256 burnQuantity) = abi.decode(
            data,
            (address, uint256)
        );
        _contractInfos[target] = ContractMintInfo({
            burnToken: burnToken,
            burnQuantity: burnQuantity
        });
        emit NewMinterInitialized({
            target: msg.sender,
            burnToken: burnToken,
            burnQuantity: burnQuantity
        });
    }

    /// @notice mint function
    /// @dev This allows the user to purchase an edition
    /// @dev at the given price in the contract.
    function purchase(
        address target,
        uint256 quantity
    ) external payable returns (uint256) {
        uint256 firstMintedTokenId = IERC721Drop(target).adminMint(
            msg.sender,
            quantity
        );

        return firstMintedTokenId;
    }

    /////////////////////////////////////////////////
    /// MODIFIERS
    /////////////////////////////////////////////////

    /// @notice Only allow for users with admin access
    modifier onlyAdmin(address target) {
        if (!isAdmin(target, msg.sender)) {
            revert IERC721Drop.Access_OnlyAdmin();
        }

        _;
    }
}
