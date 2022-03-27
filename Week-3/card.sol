pragma solidity ^0.6.11;

import "./Verifier.sol";

contract CardContract {
    struct Card {
        bytes32 cardHash;
        uint256 cardSuite;
    }

    mapping(address => Card) public cards;

    function checkCardCommit(
        bytes32 cardHash,
        uint256 cardSuite,
        uint[2] a,
        uint[2][2] b,
        uint[2] c,
        uint[2] input
    ) public {
        require(
            Verifier.verifyProof(a, b, c, input),
            "Failed proof check"
        );
        cards[msg.sender] = Card(cardHash, cardSuite);
    }
}