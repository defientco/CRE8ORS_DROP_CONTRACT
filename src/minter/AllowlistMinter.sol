// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {MinterUtilities} from "../utils/MinterUtilities.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {ILockup} from "../interfaces/ILockup.sol";

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
        for (uint256 i = 0; i < carts.length; i++) {
            ICre8ors(cre8orsNFT).adminMint(recipient, cart[i].quantity){
                value: calculatePrice(cart[i].tier, cart[i].quantity)
            };
        }
    }
}
