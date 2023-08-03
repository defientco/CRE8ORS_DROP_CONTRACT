// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {IERC721A} from "lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {ICre8orsCollective} from "../interfaces/ICre8orsCollective.sol";

contract Cre8orsClaimPassportMinter {
    address private cre8orsClaimContractAddress;
    address private cre8orsPassportContractAddress;

    constructor(
        address _cre8orsClaimContractAddress,
        address _cre8orsPassportContractAddress
    ) {
        cre8orsClaimContractAddress = _cre8orsClaimContractAddress;
        cre8orsPassportContractAddress = _cre8orsPassportContractAddress;
    }

    function claimPassport(uint256 _tokenId) external returns (uint256) {
        require(
            IERC721A(cre8orsClaimContractAddress).ownerOf(_tokenId) ==
                msg.sender,
            "You do not own this token"
        );
        ICre8orsCollective(cre8orsClaimContractAddress).burn(_tokenId);
        // Mint the token to the sender
        return
            IERC721Drop(cre8orsPassportContractAddress).adminMint(
                msg.sender,
                1
            );
    }
}
