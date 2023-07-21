// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {MinterUtilities} from "../utils/MinterUtilities.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {ILockup} from "../interfaces/ILockup.sol";
import {IERC721A} from "lib/ERC721A/contracts/interfaces/IERC721A.sol";

contract AllowlistMinter is MinterUtilities {
    address public cre8orsNFT;

    constructor(address _cre8orsNFT) {
        cre8orsNFT = _cre8orsNFT;
        tierPrices[1] = _tier1;
        tierPrices[2] = _tier2;
        tierPrices[3] = _tier3;
    }

    function mintPfp(
        address recipient,
        bytes calldata data
    ) external returns (uint256) {
        (
            Cart[] calldata carts,
            address passportHolderMinter,
            address friendsAndFamilyMinter
        ) = abi.decode(data, (Cart[], uint8, uint256, address, address));
        uint256 quantity = calculateTotalQuantity(carts);
        uint256 remainingMints = quantityLeft(
            passportHolderMinter,
            friendsAndFamilyMinter,
            cre8orsNFT,
            recipient
        );
        require(remainingMints > 0, "No more mints left");
        require(quantity <= remainingMints, "Quantity exceeds remaining mints");
        uint256 totalCost = calculateTotalCost(carts);
        require(
            msg.value >= totalCost,
            "You did not send enough ether to cover the cost"
        );
        uint256 startingTokenId = ICre8ors(cre8orsNFT).adminMint(
            recipient,
            quantity
        );

        uint256 firstId = startingTokenId;
        ILockup lockup = ICre8ors(cre8orsNFT).lockup();
        if (address(lockup) != address(0)) {
            _lockUp(carts, recipient, firstId);
        }
        return firstId;
    }

    function _lockUp(
        Cart[] calldata carts,
        address recipient,
        uint256 startingTokenId
    ) internal {
        for (uint256 i = 0; i < carts.length; i++) {
            if (carts[i].tier == 3) {
                continue;
            }
            uint256 lockupDate = calculateLockupDate(cart[i].tier);
            ICre8ors(cre8orsNFT).setUnlockInfo(
                cre8orsNFT,
                startingTokenId,
                abi.encode(lockupDate, tierPrices[cart[i].tier])
            );
            startingTokenId += 1;
        }
    }
}
