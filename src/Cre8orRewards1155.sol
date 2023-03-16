// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ERC1155} from "lib/openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import {ERC1155PresetMinterPauser} from "lib/openzeppelin-contracts/contracts/token/ERC1155/presets/ERC1155PresetMinterPauser.sol";
import {ERC1155Supply} from "lib/openzeppelin-contracts/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import {ERC1155URIStorage} from "lib/openzeppelin-contracts/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

/**
 ██████╗██████╗ ███████╗ █████╗  ██████╗ ██████╗ ███████╗
██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝
██║     ██████╔╝█████╗  ╚█████╔╝██║   ██║██████╔╝███████╗
██║     ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██╔══██╗╚════██║
╚██████╗██║  ██║███████╗╚█████╔╝╚██████╔╝██║  ██║███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝                                                       
 */
/// @dev inspiration: https://github.com/ourzora/zora-drops-contracts
contract Cre8orRewards1155 is
    ERC1155Supply,
    ERC1155URIStorage,
    ERC1155PresetMinterPauser,
    Ownable
{
    constructor(string memory uri) ERC1155PresetMinterPauser(uri) Ownable() {
        _setURI(1, uri);
    }

    /// @notice admin function to airdrop to an array of addresses
    /// @param id token ID
    /// @param airdropList list of addresses to airdrop to
    function airdrop(uint256 id, address[] memory airdropList) public {
        for (uint256 i = 0; i < airdropList.length; i++) {
            mint(airdropList[i], id, 1, "0x0");
        }
    }

    /// @notice admin function to update tokenURI for a given token
    /// @param id token ID
    /// @param uri token URI
    function setTokenURI(uint256 id, string memory uri) public {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "ERC1155PresetMinterPauser: must have admin role to change URI"
        );

        _setURI(id, uri);
    }

    /// @dev See {IERC1155MetadataURI-uri}.
    function uri(
        uint256 tokenId
    ) public view override(ERC1155, ERC1155URIStorage) returns (string memory) {
        return ERC1155URIStorage.uri(tokenId);
    }

    /// @dev See {ERC1155-_beforeTokenTransfer}.
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    )
        internal
        virtual
        override(ERC1155Supply, ERC1155PresetMinterPauser, ERC1155)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    /// @dev See {IERC165-supportsInterface}.
    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        virtual
        override(ERC1155PresetMinterPauser, ERC1155)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
