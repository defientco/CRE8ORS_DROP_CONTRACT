// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IMetadataRenderer} from "../interfaces/IMetadataRenderer.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {ITraitRenderer} from "../interfaces/ITraitRenderer.sol";
import {IERC721Metadata} from "lib/openzeppelin-contracts/contracts/interfaces/IERC721Metadata.sol";
import {NFTMetadataRenderer} from "../utils/NFTMetadataRenderer.sol";
import {MetadataRenderAdminCheck} from "./MetadataRenderAdminCheck.sol";

interface DropConfigGetter {
    function config()
        external
        view
        returns (IERC721Drop.Configuration memory config);
}

/// @notice Cre8orsMetadataRenderer with trait support
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

    /// @notice Token information mapping storage
    mapping(address => TokenEditionInfo) public tokenInfos;

    /// @notice Contract URI information getter
    /// @return contract uri (if set)
    function contractURI() external view override returns (string memory) {
        address target = msg.sender;
        TokenEditionInfo storage editionInfo = tokenInfos[target];
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
    function tokenURI(uint256 tokenId, address traitRenderer)
        external
        view
        returns (string memory)
    {
        address target = msg.sender;

        TokenEditionInfo memory info = tokenInfos[target];
        IERC721Drop media = IERC721Drop(target);

        uint256 maxSupply = media.saleDetails().maxSupply;

        // For open editions, set max supply to 0 for renderer to remove the edition max number
        // This will be added back on once the open edition is "finalized"
        if (maxSupply == type(uint64).max) {
            maxSupply = 0;
        }

        string[] memory traitKeys = new string[](1);
        traitKeys[0] = "music";
        string[] memory traitValues = ITraitRenderer(traitRenderer).tokenTraits(
            tokenId
        );

        return
            NFTMetadataRenderer.createMetadataEdition({
                name: IERC721Metadata(target).name(),
                description: info.description,
                imageUrl: info.imageURI,
                animationUrl: traitValues[0], // trait 0
                tokenOfEdition: tokenId,
                editionSize: maxSupply,
                attributeKeys: traitKeys,
                attributeValues: traitValues
            });
    }
}
