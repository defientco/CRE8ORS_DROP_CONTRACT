// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ERC721ACH} from "../../src/ERC721ACH.sol";

contract ERC721ACHMock is ERC721ACH {
    constructor() ERC721ACH("ERC-721ACH Mock", "MOCK") {}

    bool hooksEnabled;

    /// @notice error to verify approve hook was executed
    error ApproveHook_Executed();
    /// @notice error to verify setApprovalForAll hook was executed
    error SetApprovalForAllHook_Executed();
    /// @notice error to transferFrom approve hook was executed
    error TransferFromHook_Executed();
    /// @notice error to safeTransferFrom approve hook was executed
    error SafeTransferFromHook_Executed();

    function mint(address to, uint256 quantity) external {
        _mint(to, quantity);
    }

    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    function _requireCallerIsContractOwner() internal view override(ERC721ACH) {
        // Derived contract's implementation here
    }

    /////////////////////////////////////////////////
    /// Hooks
    /////////////////////////////////////////////////

    function _approveHook(address, uint256) internal virtual override {
        revert ApproveHook_Executed();
    }

    function _setApprovalForAllHook(
        address,
        address,
        bool
    ) internal virtual override {
        revert SetApprovalForAllHook_Executed();
    }

    function _transferFromHook(
        address,
        address,
        uint256
    ) internal virtual override {
        revert TransferFromHook_Executed();
    }

    function _safeTransferFromHook(
        address,
        address,
        address,
        uint256,
        bytes memory
    ) internal virtual override {
        revert SafeTransferFromHook_Executed();
    }

    /////////////////////////////////////////////////
    /// Enable Hooks
    /////////////////////////////////////////////////
    function setHooksEnabled(bool _enabled) public {
        hooksEnabled = _enabled;
    }

    function _useBalanceOfHook(
        address
    ) internal view virtual override returns (bool) {
        return hooksEnabled;
    }

    function _useOwnerOfHook(
        uint256
    ) internal view virtual override returns (bool) {
        return hooksEnabled;
    }

    function _useApproveHook(
        address,
        uint256
    ) internal view virtual override returns (bool) {
        return hooksEnabled;
    }

    function _useSetApprovalForAllHook(
        address,
        address,
        bool
    ) internal view virtual override returns (bool) {
        return hooksEnabled;
    }

    function _useGetApprovedHook(
        uint256
    ) internal view virtual override returns (bool) {
        return hooksEnabled;
    }

    function _useIsApprovedForAllHook(
        address,
        address
    ) internal view virtual override returns (bool) {
        return hooksEnabled;
    }

    function _useTransferFromHook(
        address,
        address,
        uint256
    ) internal view virtual override returns (bool) {
        return hooksEnabled;
    }

    function _useSafeTransferFromHook(
        address,
        address,
        address,
        uint256,
        bytes memory
    ) internal view virtual override returns (bool) {
        return hooksEnabled;
    }
}
