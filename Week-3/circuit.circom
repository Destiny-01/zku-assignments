pragma circom 2.0.0;

include "../../circomlib/circuits/comparators.circom";

template Move () {
    signal private input a_x;
    signal private input a_y;
    signal private input b_x;
    signal private input b_y;
    signal private input c_x;
    signal private input c_y;
    signal input energy;
    signal output out;


    // Verify energy is within range
    signal ba_x;
    signal ba_y;
    signal cb_x;
    signal cb_y;
    signal ba_xSq;
    signal ba_ySq;
    signal cb_xSq;
    signal cb_ySq;
    signal abSq;
    signal bcSq;
    signal energySq;

    energySq <== energy * energy;
    ba_x <== b_x - a_x;
    ba_y <== b_y - a_y;
    ba_xSq <== ba_x * ba_x;
    ba_ySq <== ba_y * ba_y;
    abSq <== ba_xSq + ba_ySq;
    assert(abSq <= energySq);

    cb_x <== c_x - b_x;
    cb_y <== c_y - b_y;
    cb_xSq <== cb_x * cb_x;
    cb_ySq <== cb_y * cb_y;
    bcSq <== cb_xSq + cb_ySq;
    assert(bcSq <= energySq);


    // Verify points form triangle
    signal areaOne;
    signal areaTwo;
    signal areaThree;
    signal area;

    areaOne <== (a_x * (b_y - c_y));
    areaTwo <== (b_x * (c_y - a_y));
    areaThree <== (c_x * (a_y - b_y));    

    area <== areaOne + areaTwo + areaThree;  

    component isz = IsZero();
    isz.in <== area;
    isz.out === 0;
}


component main = Move();