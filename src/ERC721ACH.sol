// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ERC721AC} from "ERC721C/erc721c/ERC721AC.sol";

/**
 * @title ERC721ACH
 * @author Cre8ors Inc.
 * @notice Extends Limit Break's ERC721-AC implementation with Hook functionality, which
 *         allows the contract owner to override hooks associated with core ERC721 functions.
 */
contract ERC721ACH is ERC721AC {
    /// @notice Contract constructor
    /// @param _contractName The name for the token contract
    /// @param _contractSymbol The symbol for the token contract
    constructor(
        string memory _contractName,
        string memory _contractSymbol
    ) ERC721AC(_contractName, _contractSymbol) {}

    /// @inheritdoc
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    /////////////////////////////////////////////////
    /// ERC721 overrides
    /////////////////////////////////////////////////

    /// @inheritdoc
    function balanceOf(
        address owner
    ) public view virtual override returns (uint256) {
        if (_useBalanceOfHook(owner)) {
            return _balanceOfHook(owner);
        }
        return super.balanceOf(owner);
    }

    /// @inheritdoc
    function ownerOf(
        uint256 tokenId
    ) public view virtual override returns (address) {
        if (_useOwnerOfHook(tokenId)) {
            return _ownerOfHook(tokenId);
        }
        return super.ownerOf(tokenId);
    }

    /// @inheritdoc
    function approve(
        address approved,
        uint256 tokenId
    ) public payable virtual override {
        if (_useApproveHook(approved, tokenId)) {
            _approveHook(approved, tokenId);
        } else {
            super.approve(approved, tokenId);
        }
    }

    /// @inheritdoc
    function setApprovalForAll(
        address operator,
        bool approved
    ) public virtual override {
        if (_useSetApprovalForAllHook(msg.sender, operator, approved)) {
            _setApprovalForAllHook(msg.sender, operator, approved);
        } else {
            super.setApprovalForAll(operator, approved);
        }
    }

    /// @inheritdoc
    function getApproved(
        uint256 tokenId
    ) public view virtual override returns (address) {
        if (_useGetApprovedHook(tokenId)) {
            return _getApprovedHook(tokenId);
        }
        return super.getApproved(tokenId);
    }

    /// @inheritdoc
    function isApprovedForAll(
        address owner,
        address operator
    ) public view virtual override returns (bool) {
        if (_useIsApprovedForAllHook(owner, operator)) {
            return _isApprovedForAllHook(owner, operator);
        }
        return super.isApprovedForAll(owner, operator);
    }

    /// @inheritdoc
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public payable virtual override {
        if (_useTransferFromHook(from, to, tokenId)) {
            _transferFromHook(from, to, tokenId);
        } else {
            super.transferFrom(from, to, tokenId);
        }
    }

    /// @inheritdoc
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public payable virtual override {
        if (_useSafeTransferFromHook(msg.sender, from, to, tokenId, data)) {
            _safeTransferFromHook(msg.sender, from, to, tokenId, data);
        } else {
            super.safeTransferFrom(from, to, tokenId, data);
        }
    }

    /// @inheritdoc
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public payable virtual override {
        if (_useSafeTransferFromHook(msg.sender, from, to, tokenId, "")) {
            _safeTransferFromHook(msg.sender, from, to, tokenId, "");
        } else {
            super.safeTransferFrom(from, to, tokenId);
        }
    }

    /////////////////////////////////////////////////
    /// ERC721 Hooks
    /////////////////////////////////////////////////

    /// @notice balanceOf Hook for custom implementation.
    /// @param owner The address to query the balance of
    /// @dev Returns the balance of the specified address
    function _balanceOfHook(address) internal view virtual returns (uint256) {}

    /// @notice Check if the balanceOf function should use hook.
    /// @param owner The address to query the balance of
    /// @dev Returns whether or not to use the hook for balanceOf function
    function _useBalanceOfHook(address) internal view virtual returns (bool) {}

    /// @notice ownerOf Hook for custom implementation.
    /// @param tokenId The token ID to query the owner of
    /// @dev Returns the owner of the specified token ID
    function _ownerOfHook(uint256) internal view virtual returns (address) {}

    /// @notice Check if the ownerOf function should use hook.
    /// @param tokenId The token ID to query the owner of
    /// @dev Returns whether or not to use the hook for ownerOf function
    function _useOwnerOfHook(uint256) internal view virtual returns (bool) {}

    /// @notice approve Hook for custom implementation.
    /// @param approved The address to be approved for the given token ID
    /// @param tokenId The token ID to be approved
    function _approveHook(address approved, uint256 tokenId) internal virtual {}

    /// @notice Check if the approve function should use hook.
    /// @param approved The address to be approved for the given token ID
    /// @param tokenId The token ID to be approved
    /// @dev Returns whether or not to use the hook for approve function
    function _useApproveHook(
        address,
        uint256
    ) internal view virtual returns (bool) {}

    /// @notice setApprovalForAll Hook for custom implementation.
    /// @param owner The address to extend operators for
    /// @param operator The address to add to the set of authorized operators
    /// @param approved True if the operator is approved, false to revoke approval
    function _setApprovalForAllHook(
        address owner,
        address operator,
        bool approved
    ) internal virtual {}

    /// @notice Check if the setApprovalForAll function should use hook.
    /// @param owner The address to extend operators for
    /// @param operator The address to add to the set of authorized operators
    /// @param approved True if the operator is approved, false to revoke approval
    /// @dev Returns whether or not to use the hook for setApprovalForAll function
    function _useSetApprovalForAllHook(
        address owner,
        address operator,
        bool approved
    ) internal view virtual returns (bool) {}

    /// @notice getApproved Hook for custom implementation.
    /// @param tokenId The token ID to query the approval of
    /// @dev Returns the approved address for a token ID, or zero if no address set
    function _getApprovedHook(
        uint256 tokenId
    ) internal view virtual returns (address) {}

    /// @notice Check if the getApproved function should use hook.
    /// @param tokenId The token ID to query the approval of
    /// @dev Returns whether or not to use the hook for getApproved function
    function _useGetApprovedHook(
        uint256 tokenId
    ) internal view virtual returns (bool) {}

    /// @notice isApprovedForAll Hook for custom implementation.
    /// @param owner The address that owns the NFTs
    /// @param operator The address that acts on behalf of the owner
    /// @dev Returns whether an operator is approved by a given owner
    function _isApprovedForAllHook(
        address owner,
        address operator
    ) internal view virtual returns (bool) {}

    /// @notice Check if the isApprovedForAll function should use hook.
    /// @param owner The address that owns the NFTs
    /// @param operator The address that acts on behalf of the owner
    /// @dev Returns whether or not to use the hook for isApprovedForAll function
    function _useIsApprovedForAllHook(
        address owner,
        address operator
    ) internal view virtual returns (bool) {}

    /// @notice transferFrom Hook for custom implementation.
    /// @param from The current owner of the NFT
    /// @param to The new owner
    /// @param tokenId The NFT to transfer
    function _transferFromHook(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}

    /// @notice Check if the transferFrom function should use hook.
    /// @param from The current owner of the NFT
    /// @param to The new owner
    /// @param tokenId The NFT to transfer
    /// @dev Returns whether or not to use the hook for transferFrom function
    function _useTransferFromHook(
        address from,
        address to,
        uint256 tokenId
    ) internal view virtual returns (bool) {}

    /// @notice safeTransferFrom Hook for custom implementation.
    /// @param sender The address which calls `safeTransferFrom`
    /// @param from The current owner of the NFT
    /// @param to The new owner
    /// @param tokenId The NFT to transfer
    /// @param data Additional data with no specified format, sent in call to `to`
    function _safeTransferFromHook(
        address sender,
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual {}

    /// @notice Check if the safeTransferFrom function should use hook.
    /// @param sender The address which calls `safeTransferFrom`
    /// @param from The current owner of the NFT
    /// @param to The new owner
    /// @param tokenId The NFT to transfer
    /// @param data Additional data with no specified format, sent in call to `to`
    /// @dev Returns whether or not to use the hook for safeTransferFrom function
    function _useSafeTransferFromHook(
        address sender,
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal view virtual returns (bool) {}

    /////////////////////////////////////////////////
    /// ERC721C Override
    /////////////////////////////////////////////////

    /// @notice Override the function to throw if caller is not contract owner
    function _requireCallerIsContractOwner() internal view virtual override {}
}
