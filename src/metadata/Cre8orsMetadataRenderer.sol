// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IMetadataRenderer} from "../interfaces/IMetadataRenderer.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {IERC721Metadata} from "lib/openzeppelin-contracts/contracts/interfaces/IERC721Metadata.sol";
import {NFTMetadataRenderer} from "../utils/NFTMetadataRenderer.sol";
import {MetadataRenderAdminCheck} from "./MetadataRenderAdminCheck.sol";

interface DropConfigGetter {
    function config()
        external
        view
        returns (IERC721Drop.Configuration memory config);
}

/**
 ██████╗██████╗ ███████╗ █████╗  ██████╗ ██████╗ ███████╗
██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝
██║     ██████╔╝█████╗  ╚█████╔╝██║   ██║██████╔╝███████╗
██║     ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██╔══██╗╚════██║
╚██████╗██║  ██║███████╗╚█████╔╝╚██████╔╝██║  ██║███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝                                                       
 */
/// @notice Cre8orsMetadataRenderer for editions support
contract Cre8orsMetadataRenderer is
    IMetadataRenderer,
    MetadataRenderAdminCheck
{
    /// @notice Storage for token edition information
    struct TokenEditionInfo {
        string description;
        string imageURI;
        string animationURI;
    }

    /// @notice Event for updated Media URIs
    event MediaURIsUpdated(
        address indexed target,
        address sender,
        string imageURI,
        string animationURI
    );

    /// @notice Event for a new edition initialized
    /// @dev admin function indexer feedback
    event NewMusicInitialized(
        address indexed target,
        uint256 tokenId,
        string description,
        string imageURI,
        string animationURI
    );

    /// @notice Description updated for this edition
    /// @dev admin function indexer feedback
    event DescriptionUpdated(
        address indexed target,
        address sender,
        string newDescription
    );

    /// @notice Token information mapping storage
    mapping(address => mapping(uint256 => TokenEditionInfo))
        internal _tokenInfos;

    function tokenInfos(
        address target,
        uint256 tokenId
    ) public view returns (TokenEditionInfo memory) {
        return _tokenInfos[target][tokenId];
    }

    /// @notice Update media URIs
    /// @param target target for contract to update metadata for
    /// @param tokenId target token to update metadata for
    /// @param imageURI new image uri address
    /// @param animationURI new animation uri address
    function updateMediaURIs(
        address target,
        uint256 tokenId,
        string memory imageURI,
        string memory animationURI
    ) external requireSenderAdmin(target) {
        _tokenInfos[target][tokenId].imageURI = imageURI;
        _tokenInfos[target][tokenId].animationURI = animationURI;
        emit MediaURIsUpdated({
            target: target,
            sender: msg.sender,
            imageURI: imageURI,
            animationURI: animationURI
        });
    }

    /// @notice Admin function to update description
    /// @param target target description
    /// @param tokenId target tokenId
    /// @param newDescription new description
    function updateDescription(
        address target,
        uint256 tokenId,
        string memory newDescription
    ) external requireSenderAdmin(target) {
        _tokenInfos[target][tokenId].description = newDescription;

        emit DescriptionUpdated({
            target: target,
            sender: msg.sender,
            newDescription: newDescription
        });
    }

    /// @notice Default initializer for edition data from a specific contract
    /// @param data data to init with
    function initializeWithData(bytes memory data) external {
        // data format: description, imageURI, animationURI, tokenId
        (
            string memory description,
            string memory imageURI,
            string memory animationURI,
            uint256 tokenId
        ) = abi.decode(data, (string, string, string, uint256));

        _tokenInfos[msg.sender][tokenId] = TokenEditionInfo({
            description: description,
            imageURI: imageURI,
            animationURI: animationURI
        });
        emit NewMusicInitialized({
            target: msg.sender,
            tokenId: tokenId,
            description: description,
            imageURI: imageURI,
            animationURI: animationURI
        });
    }

    /// @notice Contract URI information getter
    /// @return contract uri (if set)
    function contractURI() external view override returns (string memory) {
        address target = msg.sender;
        TokenEditionInfo storage editionInfo = _tokenInfos[target][1];
        IERC721Drop.Configuration memory config = DropConfigGetter(target)
            .config();

        return
            NFTMetadataRenderer.encodeContractURIJSON({
                name: IERC721Metadata(target).name(),
                description: editionInfo.description,
                imageURI: editionInfo.imageURI,
                royaltyBPS: uint256(config.royaltyBPS),
                royaltyRecipient: config.fundsRecipient
            });
    }

    /// @notice Token URI information getter
    /// @param tokenId to get uri for
    /// @return contract uri (if set)
    function tokenURI(
        uint256 tokenId
    ) external view override returns (string memory) {
        address target = msg.sender;

        TokenEditionInfo memory info = _tokenInfos[target][tokenId];
        IERC721Drop media = IERC721Drop(target);

        uint256 maxSupply = media.saleDetails().maxSupply;

        // For open editions, set max supply to 0 for renderer to remove the edition max number
        // This will be added back on once the open edition is "finalized"
        if (maxSupply == type(uint64).max) {
            maxSupply = 0;
        }

        return
            NFTMetadataRenderer.createMetadataEdition({
                name: IERC721Metadata(target).name(),
                description: info.description,
                imageUrl: info.imageURI,
                animationUrl: info.animationURI,
                tokenOfEdition: tokenId,
                editionSize: maxSupply
            });
    }
}
