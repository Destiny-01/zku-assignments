pragma circom 2.0.0;

include "../../circuits/mimcsponge.circom";

template Main(){
    signal input previousSuit;
    signal input card;
    signal input salt;
    signal output cardhash;
    signal output suithash;

    signal suit;
    suit <== card \ 13;

    assert(previousSuit == suit)

    component mimc = MiMCSponge(3, 220, 1);

    mimc.ins[0] <== card;
    mimc.ins[1] <== suit;
    mimc.ins[2] <== salt;
    mimc.k <== 0;

    cardhash <== mimc.outs[0];
    suithash <== mimc.outs[1];
}

component main = Main();