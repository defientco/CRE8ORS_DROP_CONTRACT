// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {IMinterUtilities} from "../interfaces/IMinterUtilities.sol";
import {ILockup} from "../interfaces/ILockup.sol";
import {IPaidMinter} from "../interfaces/IPaidMinter.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {ICre8ing} from "../interfaces/ICre8ing.sol";
import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract PaidMinter is IPaidMinter {
    address public cre8orsNFT;
    address public minterUtility;
    address public freeMinter;

    constructor(
        address _cre8orsNFT,
        address _minterUtility,
        address _freeMinter
    ) {
        cre8orsNFT = _cre8orsNFT;
        minterUtility = _minterUtility;
        freeMinter = _freeMinter;
    }

    function mint(
        address recipient,
        uint256[] memory carts,
        bytes32[] calldata merkleProof
    )
        external
        payable
        arrayLengthMustBe3(carts)
        onlyPreSaleOrAlreadyMinted(recipient)
        checkProof(recipient, merkleProof)
        verifyCost(carts)
        returns (uint256)
    {
        (uint256 pfpTokenId, uint256 quantity) = abi.decode(
            _mint(recipient, carts),
            (uint256, uint256)
        );
        payable(address(cre8orsNFT)).call{value: msg.value}("");
        _lockUp(carts, pfpTokenId - quantity + 1);

        return pfpTokenId;
    }

    function mint(
        address recipient,
        uint256[] memory carts
    )
        external
        payable
        verifyCost(carts)
        onlyPublicSaleOrAlreadyMinted(recipient)
        returns (uint256)
    {
        (uint256 pfpTokenId, uint256 quantity) = abi.decode(
            _mint(recipient, carts),
            (uint256, uint256)
        );
        payable(address(cre8orsNFT)).call{value: msg.value}("");
        _lockUp(carts, pfpTokenId - quantity + 1);
        return pfpTokenId;
    }

    function _mint(
        address _recipient,
        uint256[] memory carts
    ) internal returns (bytes memory) {
        uint256 quantity = _calculateTotalQuantity(carts);

        if (
            quantity >
            IMinterUtilities(minterUtility).quantityLeft(freeMinter, _recipient)
        ) {
            revert IERC721Drop.Purchase_TooManyForAddress();
        }

        uint256 pfpTokenId = ICre8ors(cre8orsNFT).adminMint(
            _recipient,
            quantity
        );
        return abi.encode(pfpTokenId, quantity);
    }

    /// @dev Sets a new address for the MinterUtilities contract.
    /// @param _newMinterUtilityContractAddress The address of the new MinterUtilities contract.
    function setNewMinterUtilityContractAddress(
        address _newMinterUtilityContractAddress
    ) external onlyAdmin {
        minterUtility = _newMinterUtilityContractAddress;
    }

    function _calculateTotalQuantity(
        uint256[] memory carts
    ) internal pure returns (uint256) {
        uint256 totalQuantity;
        for (uint256 i = 0; i < carts.length; i++) {
            totalQuantity += carts[i];
        }
        return totalQuantity;
    }

    function _lockUp(uint256[] memory carts, uint256 startingTokenId) internal {
        uint256 tokenId = startingTokenId;
        IMinterUtilities.TierInfo[] memory tiers = abi.decode(
            IMinterUtilities(minterUtility).getTierInfo(),
            (IMinterUtilities.TierInfo[])
        );
        for (uint256 i = 0; i < carts.length; i++) {
            if (i == 3 || carts[i] == 0) {
                continue;
            }
            bytes memory lockUpDateAndPrice = _getLockUpDateAndPrice(
                tiers,
                i + 1
            );
            for (uint256 j = 0; j < carts[i]; j++) {
                ICre8ors(
                    IERC721ACH(cre8orsNFT).getHook(
                        IERC721ACH.HookType.BeforeTokenTransfers
                    )
                ).cre8ing().lockUp(cre8orsNFT).setUnlockInfo(
                        cre8orsNFT,
                        tokenId,
                        lockUpDateAndPrice
                    );
                tokenId++;
            }
        }
    }

    function _getLockUpDateAndPrice(
        IMinterUtilities.TierInfo[] memory tiers,
        uint256 tier
    ) internal view onlyValidTier(tier) returns (bytes memory) {
        IMinterUtilities.TierInfo memory selectedTier = tiers[tier - 1];
        uint256 lockupDate = block.timestamp + selectedTier.lockup;
        uint256 tierPrice = selectedTier.price;

        return abi.encode(lockupDate, tierPrice);
    }

    modifier checkProof(address _recipient, bytes32[] calldata merkleProof) {
        if (
            !MerkleProof.verify(
                merkleProof,
                IERC721Drop(cre8orsNFT).saleDetails().presaleMerkleRoot,
                keccak256(
                    abi.encode(
                        _recipient,
                        uint256(8),
                        uint256(150000000000000000)
                    )
                )
            )
        ) {
            revert IERC721Drop.Presale_MerkleNotApproved();
        }
        _;
    }

    modifier onlyPreSaleOrAlreadyMinted(address recipient) {
        if (
            ICre8ors(cre8orsNFT).saleDetails().presaleStart > block.timestamp &&
            ICre8ors(cre8orsNFT).mintedPerAddress(recipient).totalMints == 0
        ) {
            revert IERC721Drop.Presale_Inactive();
        }
        _;
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

    modifier arrayLengthMustBe3(uint256[] memory array) {
        if (array.length != 3) {
            revert IPaidMinter.InvalidArrayLength();
        }
        _;
    }
    modifier verifyCost(uint256[] memory carts) {
        uint256 totalCost = IMinterUtilities(minterUtility).calculateTotalCost(
            carts
        );
        if (msg.value < totalCost) {
            revert IERC721Drop.Purchase_WrongPrice(totalCost);
        }
        _;
    }
    modifier onlyValidTier(uint256 tier) {
        if (tier < 1 || tier > 3) {
            revert IPaidMinter.InvalidTier();
        }
        _;
    }
    /// @dev Modifier that restricts access to only the contract's admin.
    modifier onlyAdmin() {
        if (!ICre8ors(cre8orsNFT).isAdmin(msg.sender)) {
            revert IERC721Drop.Access_OnlyAdmin();
        }
        _;
    }
}
