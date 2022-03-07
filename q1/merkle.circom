pragma circom 2.0.0;
include "./mimc.circom";

template MerkleOne(num) 
{
    signal input leaves[num];
    signal output root;

    component leaves_component[num-1];

    for (var i = 0; i < num/2; i++)
    {
        leaves_component[i] = MiMCSponge(2, 220, 1);
        leaves_component[i].ins[0] <== leaves[i*2];
        leaves_component[i].ins[1] <== leaves[i*2 + 1];
        leaves_component[i].k <== 0;
    }

    // wire up the 2nd and onwards level (B, C, ...) to previous component

    for (var i = num/2; i < num-1; i++)
    {
        leaves_component[i] = MiMCSponge(2, 220, 1);
        leaves_component[i].ins[0] <== leaves_component[(i - num/2) * 2].outs[0];
        leaves_component[i].ins[1] <== leaves_component[(i - num/2) * 2 + 1].outs[0];
        leaves_component[i].k <== 0;
    }

    // wire up the last component to output

    root <== leaves_component[num-2].outs[0];
}

component main {public [leaves]} = MerkleOne(4); 