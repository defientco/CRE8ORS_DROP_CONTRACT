// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ERC721HAC} from "../../src/ERC721HAC.sol";

contract ERC721HACMock is ERC721HAC {
    constructor() ERC721HAC("ERC-721HAC Mock", "MOCK") {}

    function mint(address to, uint256 quantity) external {
        _mint(to, quantity);
    }

    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    function _requireCallerIsContractOwner() internal view override(ERC721HAC) {
        // Derived contract's implementation here
    }
}
