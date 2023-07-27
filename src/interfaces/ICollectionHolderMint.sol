// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface ICollectionHolderMint {
    // Events
    error AlreadyClaimedFreeMint();
    error IERC721A_ApprovalCallerNotOwnerNorApproved();
    error IERC721Drop_Access_OnlyAdmin();

    // Functions
    function freeMintClaimed(uint256 tokenId) external view returns (bool);

    function collectionContractAddress() external view returns (address);

    function minterUtilityContractAddress() external view returns (address);

    function maxClaimedFree(address) external view returns (uint256);

    function mint(
        uint256 tokenId,
        address passportContract,
        address recipient
    ) external returns (uint256);

    function setNewMinterUtilityContractAddress(
        address _newMinterUtilityContractAddress
    ) external;

    function toggleHasClaimedFreeMint(uint256 tokenId) external;
}
