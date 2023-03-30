// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ERC721A} from "lib/ERC721A/contracts/ERC721A.sol";
import {IERC721A} from "lib/ERC721A/contracts/IERC721A.sol";
import {AccessControl} from "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
import {IERC2981, IERC165} from "lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol";
import {ReentrancyGuard} from "lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
import {MerkleProof} from "lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";
import {IERC721Drop} from "./interfaces/IERC721Drop.sol";
import {IMetadataRenderer} from "./interfaces/IMetadataRenderer.sol";
import {ERC721DropStorageV1} from "./storage/ERC721DropStorageV1.sol";
import {OwnableSkeleton} from "./utils/OwnableSkeleton.sol";
import {IOwnable} from "./interfaces/IOwnable.sol";
import {Cre8ing} from "./Cre8ing.sol";

/**
 ██████╗██████╗ ███████╗ █████╗  ██████╗ ██████╗ ███████╗
██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝
██║     ██████╔╝█████╗  ╚█████╔╝██║   ██║██████╔╝███████╗
██║     ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██╔══██╗╚════██║
╚██████╗██║  ██║███████╗╚█████╔╝╚██████╔╝██║  ██║███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝                                                       
 */
contract Burn721Minter {
    /// @notice Getter for admin role associated with the contract to handle minting
    /// @param target drop contract address
    /// @param user user address
    /// @return boolean if address is admin
    function isAdmin(address target, address user) public view returns (bool) {
        return IERC721Drop(target).isAdmin(user);
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
