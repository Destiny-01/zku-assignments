// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MerkleTree {
    bytes32[] leaves;
    uint256 leafLen;

    function add(
        address sender,
        address receiver,
        uint256 tokenId,
        string calldata tokenURI
    ) public returns (bytes32) {
        bytes32 nftHash = keccak256(abi.encodePacked(sender, receiver, tokenId, tokenURI));
        if (leafLen == 0 || leafLen == 1) {
            leaves.push(nftHash);
        }
        else if (leafLen & (leafLen - 1) == 0) {
            leaves.push(nftHash);
            for (uint256 i = 0; i < leafLen - 1; i++) {
                leaves.push(bytes32(0));
            }
        } else {
            leaves[leafLen] = nftHash;
        }
        leafLen++;
        return computeRoot();
    }

    function computeRoot() private view returns (bytes32) {
        uint256 n = leaves.length;
        bytes32[] memory prevLayer = leaves;
        bytes32[] memory nextLayer = new bytes32[](n / 2);
        uint256 nextI;
        while (n != 1) {
            for (uint256 prevI = 0; prevI < n; prevI += 2) {
                nextLayer[nextI++] = keccak256(
                    abi.encodePacked(prevLayer[prevI], prevLayer[prevI + 1])
                );
            }
            prevLayer = nextLayer;
            nextI = 0;
            n /= 2;
        }
        return prevLayer[0];
    }
}