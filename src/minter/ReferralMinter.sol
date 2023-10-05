// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {IERC721A} from "lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {IERC6551Registry} from "lib/ERC6551/src/interfaces/IERC6551Registry.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";

/**
 * @title ReferralMinter
 * @notice This contract allows for minting NFTs through referral links.
 * Referrals get a referral fee for any sales they help generate.
 */
contract ReferralMinter {
    /// @notice Address of the ERC6551Registry contract.
    address public erc6551Registry;
    /// @notice Address of the ERC6551AccountImplementation contract.
    address public erc6551AccountImplementation;
    /// @notice Address of the NFT contract.
    address public nft;
    /// @notice Referral fee in percentage (0 to 100).
    uint256 public referralFee;

    /// @notice Custom error to indicate that the smart wallet associated with the tokenId doesn't exist.
    error MissingSmartWallet();
    /// @notice Custom error to indicate the provided fee is invalid.
    error InvalidFee();
    /// @notice Custom error to indicate the payment failed.
    error PaymentFailed();

    /// @dev Emitted when an referral sale occurs.
    event ReferralSale(
        uint256 indexed tokenId,
        uint256 indexed referralFeePaid
    );

    /**
     * @dev Sets the initial state of the contract.
     * @param _nft Address of the NFT contract.
     * @param _erc6551Registry Address of the ERC6551Registry contract.
     * @param _erc6551AccountImplementation Address of the ERC6551AccountImplementation contract.
     * @param _referralFee Initial referral fee percentage (between 0 and 100) for the referral program.
     */
    constructor(
        address _nft,
        address _erc6551Registry,
        address _erc6551AccountImplementation,
        uint256 _referralFee
    ) checkFee(_referralFee) {
        nft = _nft;
        erc6551Registry = _erc6551Registry;
        erc6551AccountImplementation = _erc6551AccountImplementation;
        referralFee = _referralFee;
    }

    /**
     * @notice Allows minting of NFTs with referral fee distribution.
     * @param to Recipient of the minted NFTs.
     * @param referralId token ID used for referral.
     * @param quantity Quantity of NFTs to mint.
     */
    function mint(
        address to,
        uint256 referralId,
        uint256 quantity
    ) external payable {
        // get smart wallet address for referrer
        address referrer = IERC6551Registry(erc6551Registry).account(
            erc6551AccountImplementation,
            block.chainid,
            nft,
            referralId,
            0
        );

        // only if smart wallet has been set up
        if (!Address.isContract(referrer)) {
            revert MissingSmartWallet();
        }

        // verify price
        uint256 publicSalePrice = IERC721Drop(nft)
            .saleDetails()
            .publicSalePrice;
        if (msg.value < quantity * publicSalePrice) {
            revert IERC721Drop.Purchase_WrongPrice(quantity * publicSalePrice);
        }

        // calculate referral fee to be paid
        uint256 referralFeeAmount = (msg.value * referralFee) / 100;

        // pay referral fee
        (bool success, ) = payable(referrer).call{value: referralFeeAmount}("");
        if (!success) {
            revert PaymentFailed();
        }

        // pay base mint fee
        (success, ) = payable(address(nft)).call{
            value: msg.value - referralFeeAmount
        }("");
        if (!success) {
            revert PaymentFailed();
        }

        // mint nft
        IERC721Drop(nft).adminMint(to, quantity);

        // emit event
        emit ReferralSale(referralId, referralFeeAmount);
    }

    /**
     * @dev Sets the ERC6551Registry address.
     * @param _erc6551Registry Address of the new ERC6551Registry.
     */
    function setRegistryAddress(address _erc6551Registry) external onlyAdmin {
        erc6551Registry = _erc6551Registry;
    }

    /**
     * @dev Sets the ERC6551AccountImplementation address.
     * @param _erc6551AccountImplementation Address of the new ERC6551AccountImplementation.
     */
    function setAccountImplementationAddress(
        address _erc6551AccountImplementation
    ) external onlyAdmin {
        erc6551AccountImplementation = _erc6551AccountImplementation;
    }

    /**
     * @dev Updates the referral fee percentage.
     * @param _referralFee New referral fee.
     */
    function setReferralFee(
        uint256 _referralFee
    ) external onlyAdmin checkFee(_referralFee) {
        referralFee = _referralFee;
    }

    /**
     * @dev Modifier to ensure the caller is an admin.
     */
    modifier onlyAdmin() {
        if (!IERC721Drop(nft).isAdmin(msg.sender)) {
            revert IERC721Drop.Access_OnlyAdmin();
        }

        _;
    }

    /**
     * @dev Ensures the provided fee is between 0 and 100.
     */
    modifier checkFee(uint256 _fee) {
        if (_fee > 100 || _fee < 0) {
            revert InvalidFee();
        }
        _;
    }
}
