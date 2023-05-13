// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

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
contract BurnCrosschainMinter {
    /// @notice Storage for contract mint information
    struct ContractMintInfo {
        string secretPasscode;
    }

    /// @notice Event for a new contract initialized
    /// @dev admin function indexer feedback
    event NewMinterInitialized(address indexed target);

    /// @notice Contract information mapping storage
    mapping(address => ContractMintInfo) internal _contractInfos;

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
        (bytes32 hashedFrom, uint256 burnQuantity, string memory passcode) = abi
            .decode(data, (bytes32, uint256, string));
        _contractInfos[target] = ContractMintInfo({secretPasscode: passcode});
        emit NewMinterInitialized({target: target});
    }

    /// @notice mint function
    /// @dev This allows the user to purchase an edition
    /// @dev at the given price in the contract.
    function purchase(
        address target,
        uint256 quantity,
        bytes calldata data
    ) external returns (uint256) {
        (
            bytes32 hashedFrom,
            uint256 burnQuantity,
            string memory encryptedPasscode
        ) = abi.decode(data, (bytes32, uint256, string));
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
    /// @param target target for contract to check admin access
    modifier onlyAdmin(address target) {
        if (!isAdmin(target, msg.sender)) {
            revert IERC721Drop.Access_OnlyAdmin();
        }

        _;
    }
}
