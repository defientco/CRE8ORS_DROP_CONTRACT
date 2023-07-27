// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/**
 * @title Interface for MinterUtilities contract.
 * @dev This interface provides the functions to interact with the MinterUtilities contract.
 */
interface IMinterUtilities {
    /**
     * @dev Represents pricing and lockup information for a specific tier.
     */
    struct TierInfo {
        uint256 price; // Price in wei for the tier
        uint256 lockup; // Lockup period in seconds for the tier
    }

    /**
     * @dev Represents a tier and quantity of NFTs.
     */
    struct Cart {
        uint8 tier;
        uint256 quantity;
    }

    /**
     * @dev Emitted when the price of a tier is updated.
     * @param tier The tier whose price is updated.
     * @param price The new price for the tier.
     */
    event TierPriceUpdated(uint256 tier, uint256 price);

    /**
     * @dev Emitted when the lockup period of a tier is updated.
     * @param tier The tier whose lockup period is updated.
     * @param lockup The new lockup period for the tier.
     */
    event TierLockupUpdated(uint256 tier, uint256 lockup);

    /**
     * @dev Returns the TierInfo struct associated with a specific tier.
     * @param tier The tier to get information for.
     * @return The TierInfo struct containing price and lockup information for the specified tier.
     */
    function getTierInfo(uint8 tier) external view returns (TierInfo memory);

    /**
     * @dev Calculates the total price for a given quantity of NFTs in a specific tier.
     * @param tier The tier to calculate the price for.
     * @param quantity The quantity of NFTs to calculate the price for.
     * @return The total price in wei for the given quantity in the specified tier.
     */
    function calculatePrice(
        uint8 tier,
        uint256 quantity
    ) external view returns (uint256);

    /**
     * @dev Converts an amount from ether to gwei (1 ether = 10^9 gwei).
     * @param value The amount in ether to convert to gwei.
     * @return The equivalent amount in gwei.
     */
    function etherToGwei(uint256 value) external pure returns (uint256);

    /**
     * @dev Returns the quantity of NFTs left that can be minted by the given recipient.
     * @param passportHolderMinter The address of the PassportHolderMinter contract.
     * @param friendsAndFamilyMinter The address of the FriendsAndFamilyMinter contract.
     * @param target The address of the target contract (ICre8ors contract).
     * @param recipient The recipient's address.
     * @return The quantity of NFTs that can still be minted by the recipient.
     */
    function quantityLeft(
        address passportHolderMinter,
        address friendsAndFamilyMinter,
        address target,
        address recipient
    ) external view returns (uint256);

    /**
     * @dev Calculates the total cost for a given list of NFTs in different tiers.
     * @param carts An array of Cart struct representing the tiers and quantities.
     * @return The total cost in wei for the given list of NFTs.
     */
    function calculateTotalCost(
        Cart[] calldata carts
    ) external view returns (uint256);

    /**
     * @dev Calculates the lockup period for a specific tier.
     * @param tier The tier to calculate the lockup period for.
     * @return The lockup period in seconds for the specified tier.
     */
    function calculateLockupDate(uint8 tier) external view returns (uint256);

    /**
     * @dev Calculates the total quantity of NFTs in a given list of Cart structs.
     * @param carts An array of Cart struct representing the tiers and quantities.
     * @return The total quantity of NFTs in the given list of carts.
     */
    function calculateTotalQuantity(
        Cart[] calldata carts
    ) external view returns (uint256);

    /**
     * @dev Updates the prices for all tiers in the MinterUtilities contract.
     * @param tierPrices A bytes array representing the new prices for all tiers (in gwei).
     */
    function updateAllTierPrices(bytes calldata tierPrices) external;

    /**
     * @dev Updates the price for Tier 1.
     * @param _tier1 The new price for Tier 1 (in wei).
     */
    function updateTierOnePrice(uint256 _tier1) external;

    /**
     * @dev Updates the price for Tier 2.
     * @param _tier2 The new price for Tier 2 (in wei).
     */
    function updateTierTwoPrice(uint256 _tier2) external;

    /**
     * @dev Updates the price for Tier 3.
     * @param _tier3 The new price for Tier 3 (in wei).
     */
    function updateTierThreePrice(uint256 _tier3) external;

    /**
     * @dev Sets new default lockup periods for all tiers.
     * @param lockupInfo A bytes array representing the new lockup periods for all tiers (in seconds).
     */
    function setNewDefaultLockups(bytes calldata lockupInfo) external;

    /**
     * @dev Updates the lockup period for Tier 1.
     * @param _tier1 The new lockup period for Tier 1 (in seconds).
     */
    function updateTierOneLockup(uint256 _tier1) external;

    /**
     * @dev Updates the lockup period for Tier 2.
     * @param _tier2 The new lockup period for Tier 2 (in seconds).
     */
    function updateTierTwoLockup(uint256 _tier2) external;

    /**
     * @dev Updates the maximum allowed quantity for the allowlist.
     * @param _maxAllowlistQuantity The new maximum allowed quantity for the allowlist.
     */
    function updateMaxAllowlistQuantity(uint256 _maxAllowlistQuantity) external;

    /**
     * @dev Updates the maximum allowed quantity for the public.
     * @param _maxPublicMintQuantity The new maximum allowed quantity for public mint.
     */
    function updateMaxPublicMintQuantity(
        uint256 _maxPublicMintQuantity
    ) external;
}
