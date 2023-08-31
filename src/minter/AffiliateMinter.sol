// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {IERC721A} from "lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {IERC6551Registry} from "lib/ERC6551/src/interfaces/IERC6551Registry.sol";

contract AffiliateMinter {
    address public erc6551Registry;
    address public erc6551AccountImplementation;
    address public cre8orsNft;
    uint256 public referralFee = 20;

    error MissingSmartWallet();

    error InvalidFee();

    event AffiliateSale(
        address indexed buyer,
        uint256 indexed cre8orsNumber,
        uint256 indexed referralFeePaid,
        uint256 quantityPurchased
    );

    constructor(
        address _cre8orsNft,
        address _erc6551Registry,
        address _erc6551AccountImplementation
    ) {
        cre8orsNft = _cre8orsNft;
        erc6551Registry = _erc6551Registry;
        erc6551AccountImplementation = _erc6551AccountImplementation;
    }

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

    function setRegistryAddress(address _erc6551Registry) external onlyAdmin {
        erc6551Registry = _erc6551Registry;
    }

    function setAccountImplementationAddress(
        address _erc6551AccountImplementation
    ) external onlyAdmin {
        erc6551AccountImplementation = _erc6551AccountImplementation;
    }

    function setReferralFee(
        uint256 _referralFee
    ) external onlyAdmin checkFee(_referralFee) {
        referralFee = _referralFee;
    }

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

    function isContract(address _addr) private returns (bool isContract) {
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
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

    modifier checkFee(uint256 _fee) {
        if (_fee > 100 || _fee < 0) {
            revert InvalidFee();
        }
        _;
    }
    modifier onlySmartWallet(uint256 _cre8orsNumber) {
        address tba = _getTBA(_cre8orsNumber);
        if (!isContract(tba)) {
            revert MissingSmartWallet();
        }
        _;
    }

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
