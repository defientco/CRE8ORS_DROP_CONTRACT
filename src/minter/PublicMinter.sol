// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {MinterUtilities} from "../utils/MinterUtilities.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {ILockup} from "../interfaces/ILockup.sol";
import {IERC721A} from "lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {IMinterUtilities} from "../interfaces/IMinterUtilities.sol";
import {IAllowlistMinter} from "../interfaces/IAllowlistMinter.sol";
import {SharedPaidMinterFunctions} from "../utils/SharedPaidMinterFunctions.sol";

contract PublicMinter is IAllowlistMinter, SharedPaidMinterFunctions {
    constructor(address _cre8orsNFT, address _minterUtility) {
        cre8orsNFT = _cre8orsNFT;
        minterUtility = _minterUtility;
    }

    function mintPfp(
        address recipient,
        IMinterUtilities.Cart[] memory carts,
        address passportHolderMinter,
        address friendsAndFamilyMinter
    )
        external
        payable
        verifyCost(carts)
        inactiveSale(recipient)
        returns (uint256)
    {
        IMinterUtilities minterUtilities = IMinterUtilities(minterUtility);

        uint256 quantity = minterUtilities.calculateTotalQuantity(carts);

        if (
            quantity >
            IMinterUtilities(minterUtility).quantityLeft(
                passportHolderMinter,
                friendsAndFamilyMinter,
                cre8orsNFT,
                recipient
            )
        ) {
            revert IERC721Drop.Purchase_TooManyForAddress();
        }

        uint256 pfpTokenId = ICre8ors(cre8orsNFT).adminMint(
            recipient,
            quantity
        );
        payable(address(cre8orsNFT)).call{value: msg.value}("");
        _lockUp(carts, pfpTokenId - quantity + 1);
        return pfpTokenId;
    }

    /// @dev Sets a new address for the MinterUtilities contract.
    /// @param _newMinterUtilityContractAddress The address of the new MinterUtilities contract.
    function setNewMinterUtilityContractAddress(
        address _newMinterUtilityContractAddress
    ) external onlyAdmin {
        minterUtilityContractAddress = _newMinterUtilityContractAddress;
    }

    modifier onlyPublicSaleOrAlreadyMinted(address recipient) {
        /**  @dev This is the only change from AllowlistMinter
         * This is so that anyone with a
         *                 pfp can mint from the public sale
         *                 which before public sale being active
         *                 should be only discount/passport holders
         */
        if (
            !ICre8ors(cre8orsNFT).saleDetails().publicSaleActive &&
            ICre8ors(cre8orsNFT).mintedPerAddress(recipient).totalMints == 0
        ) {
            revert IERC721Drop.Sale_Inactive();
        }
        _;
    }
}
