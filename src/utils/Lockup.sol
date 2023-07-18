// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ILockup} from "../interfaces/ILockup.sol";
import {MetadataRenderAdminCheck} from "../metadata/MetadataRenderAdminCheck.sol";

/**
 ██████╗██████╗ ███████╗ █████╗  ██████╗ ██████╗ ███████╗
██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝
██║     ██████╔╝█████╗  ╚█████╔╝██║   ██║██████╔╝███████╗
██║     ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██╔══██╗╚════██║
╚██████╗██║  ██║███████╗╚█████╔╝╚██████╔╝██║  ██║███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝                                                     
 */
contract Lockup is ILockup, MetadataRenderAdminCheck {
    /// @notice Lockup information mapping storage
    mapping(address => mapping(uint256 => TokenLockupInfo))
        internal _lockupInfos;

    /// @notice retieves unlock date for token
    /// @param _target contract target
    /// @param _tokenId tokenId to retrieve unlock date
    function unlockInfo(
        address _target,
        uint256 _tokenId
    ) public view returns (TokenLockupInfo memory info) {
        info = _lockupInfos[_target][_tokenId];
    }

    /// @notice retrieves locked state for token
    /// @param _target contract target
    /// @param _tokenId tokenId to retrieve lock state
    function isLocked(
        address _target,
        uint256 _tokenId
    ) external view returns (bool) {
        return block.timestamp < unlockInfo(_target, _tokenId).unlockDate;
    }

    /// @notice sets unlock tier for token
    /// @param _target target contract
    /// @param _tokenId tokenId to set unlock date for
    /// @param _unlockData unlock information
    function setUnlockInfo(
        address _target,
        uint256 _tokenId,
        bytes memory _unlockData
    ) external requireSenderAdmin(_target) {
        // data format: uint64 unlockDate, uint256 priceToUnlock
        (uint64 _unlockDate, uint256 _priceToUnlock) = abi.decode(
            _unlockData,
            (uint64, uint256)
        );
        _lockupInfos[_target][_tokenId] = TokenLockupInfo({
            unlockDate: _unlockDate,
            priceToUnlock: _priceToUnlock
        });

        emit TokenLockupUpdated({
            target: _target,
            tokenId: _tokenId,
            unlockDate: _unlockDate,
            priceToUnlock: _priceToUnlock
        });
    }

    function unlock(address _target, uint256 _tokenId) private {
        uint64 newUnlockDate = uint64(block.timestamp);
        _lockupInfos[_target][_tokenId] = TokenLockupInfo({
            unlockDate: newUnlockDate,
            priceToUnlock: 0
        });

        emit TokenLockupUpdated({
            target: _target,
            tokenId: _tokenId,
            unlockDate: newUnlockDate,
            priceToUnlock: 0
        });
    }

    /// @notice pay to unlock a locked token
    /// @param _target target contract
    /// @param _tokenId tokenId to unlock
    function payToUnlock(
        address payable _target,
        uint256 _tokenId
    ) public payable {
        // verify paid unlock price
        uint256 priceToPay = _lockupInfos[_target][_tokenId].priceToUnlock;
        if (msg.value < priceToPay) {
            revert Unlock_WrongPrice(priceToPay);
        }

        // unlock token
        unlock(_target, _tokenId);

        // send funds to the target
        (bool success, ) = _target.call{value: priceToPay}("");
        require(success, "Transfer failed.");

        // if the payment is more than the unlock price, refund the extra
        if (msg.value > priceToPay) {
            uint256 refundAmount = msg.value - priceToPay;
            (bool refundSuccess, ) = msg.sender.call{value: refundAmount}("");
            require(refundSuccess, "Refund failed.");
        }
    }
}
