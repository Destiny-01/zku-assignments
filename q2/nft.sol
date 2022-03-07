// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./merkle.sol";

contract GameItem is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("CoolNFT", "CNF") {}

    function tokenURI(tokenId)
        private
        pure
        override
        returns (string memory)
    {
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "MyCoolNFT #', tokenId.toString(), '"',
                '"description": "This is a cool token', '"',
            '}'
        );

        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function mintNFT(
        address receiver,
        uint256 tokenId
    )
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(receiver, newItemId);
        _setTokenURI(newItemId, tokenURI());

        merkle.add(msg.sender, receiver, tokenId, tokenURI(tokenId))
        return newItemId;
    }
}


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Merkle.sol";

contract NFTMint is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Merkle public merkle = new Merkle();

    constructor() ERC721("CoolNFT", "CNF") {}

    function tokenURI()
        private
        pure
        returns (string memory)
    {
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "MyCoolNFT #', '"',
                '"description": "This is a cool token', '"',
            '}'
        );

        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function mintNFT(
        address receiver,
        uint256 tokenId
    )
        public
        returns (uint256)
    {
        address _receiver = receiver;
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(receiver, newItemId);
        _setTokenURI(newItemId, tokenURI());

        merkle.add(msg.sender, _receiver, tokenId, tokenURI());
        return newItemId;
    }
}
