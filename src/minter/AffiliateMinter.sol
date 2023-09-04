// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {IERC721A} from "lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {IERC6551Registry} from "lib/ERC6551/src/interfaces/IERC6551Registry.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";

/**
 * @title AffiliateMinter
 * @notice This contract allows for minting Cre8ors NFTs through affiliate links.
 * Affiliates get a referral fee for any sales they help generate.
 */
contract AffiliateMinter {
    /// @notice Address of the ERC6551Registry contract.
    address public erc6551Registry;
    /// @notice Address of the ERC6551AccountImplementation contract.
    address public erc6551AccountImplementation;
    /// @notice Address of the Cre8ors NFT contract.
    address public cre8orsNft;
    /// @notice Referral fee in percentage (0 to 100).
    uint256 public referralFee;

    /// @notice Custom error to indicate that the smart wallet associated with the Cre8or number doesn't exist.
    error MissingSmartWallet();
    /// @notice Custom error to indicate the provided fee is invalid.
    error InvalidFee();

    /// @dev Emitted when an affiliate sale occurs.
    event AffiliateSale(
        address indexed buyer,
        uint256 indexed cre8orsNumber,
        uint256 indexed referralFeePaid,
        uint256 quantityPurchased
    );

    /**
     * @dev Sets the initial state of the contract.
     * @param _cre8orsNft Address of the Cre8ors NFT contract.
     * @param _erc6551Registry Address of the ERC6551Registry contract.
     * @param _erc6551AccountImplementation Address of the ERC6551AccountImplementation contract.
     * @param _referralFee Initial referral fee percentage (between 0 and 100) for the affiliate program.
     */
    constructor(
        address _cre8orsNft,
        address _erc6551Registry,
        address _erc6551AccountImplementation,
        uint256 _referralFee
    ) checkFee(_referralFee) {
        cre8orsNft = _cre8orsNft;
        erc6551Registry = _erc6551Registry;
        erc6551AccountImplementation = _erc6551AccountImplementation;
        referralFee = _referralFee;
    }

    /**
     * @notice Allows minting of Cre8ors NFTs with referral fee distribution.
     * @param to Recipient of the minted NFTs.
     * @param referralCre8orNumber Cre8or number used for referral.
     * @param quantity Quantity of NFTs to mint.
     */
    function mint(
        address to,
        uint256 referralCre8orNumber,
        uint256 quantity
    )
        external
        payable
        onlySmartWallet(referralCre8orNumber)
        verifyCost(quantity)
    {
        // get smart wallet address
        address referrer = _getTBA(referralCre8orNumber);

        // calculate referral fee to be paid
        uint256 referralFeeAmount = (msg.value * referralFee) / 100;

        // pay referral fee
        payable(referrer).call{value: referralFeeAmount}("");
        // pay cre8ors
        payable(address(cre8orsNft)).call{value: msg.value - referralFeeAmount}(
            ""
        );

        // mint cre8ors
        ICre8ors(cre8orsNft).adminMint(to, quantity);

        // emit event
        emit AffiliateSale(
            to,
            referralCre8orNumber,
            referralFeeAmount,
            quantity
        );
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
     * @dev Retrieves the Token Bound Account (TBA) for a given Cre8or number.
     * @param _cre8orsNumber The Cre8or number to find the TBA for.
     * @return tba The Token Bound Account.
     */
    function _getTBA(
        uint256 _cre8orsNumber
    ) internal view returns (address tba) {
        tba = IERC6551Registry(erc6551Registry).account(
            erc6551AccountImplementation,
            block.chainid,
            cre8orsNft,
            _cre8orsNumber,
            0
        );
    }

    /**
     * @dev Modifier to ensure the caller is an admin.
     */
    modifier onlyAdmin() {
        if (!ICre8ors(cre8orsNft).isAdmin(msg.sender)) {
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

    /**
     * @dev Ensures the operation is only performed by a valid smart wallet for the given Cre8or number.
     * @param _cre8orsNumber Cre8or number used to determine the associated smart wallet.
     */
    modifier onlySmartWallet(uint256 _cre8orsNumber) {
        address tba = _getTBA(_cre8orsNumber);
        if (!Address.isContract(tba)) {
            revert MissingSmartWallet();
        }
        _;
    }

    /**
     * @dev Ensures that the sent value matches the expected cost for the NFT purchase.
     * @param _quantity Quantity of NFTs being purchased.
     */
    modifier verifyCost(uint256 _quantity) {
        if (
            msg.value <
            _quantity * ICre8ors(cre8orsNft).saleDetails().publicSalePrice
        ) {
            revert IERC721Drop.Purchase_WrongPrice(
                _quantity *
                    IERC721Drop(cre8orsNft).saleDetails().publicSalePrice
            );
        }
        _;
    }
}
