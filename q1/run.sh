# circom multiplier.circom --r1cs --wasm --sym --c
# cd multiplier_js

# node generate_witness.js
# cd ../
# node multiplier_js/generate_witness.js multiplier_js/multiplier.wasm in.json witness.wtns
# snarkjs wtns export json witness.wtns witness.json
# snarkjs plonk setup multiplier.r1cs powersOfTau28_hez_final_11.ptau multiplier.zkey
# snarkjs zkey export verificationkey multiplier.zkey verification_key.json
# snarkjs plonk prove multiplier.zkey witness.wtns proof.json public.json
# snarkjs plonk verify verification_key.json public.json proof.json
# snarkjs zkey export solidityverifier multiplier.zkey verifier.sol
# snarkjs zkey export soliditycalldata public.json proof.json

#!/bin/bash
# Note to ZKU TAs: I did not paramaterize this script, everything is hard coded/inlined
# I don't usually work in bash so I didnt want to spend the time to get all the parameterization just right

# Compile the merkel circom circuit into:
# wasm which can actually execute the circuit in a straightforward way, will be used to create the witness
# And r1cs (constraints) which describe the circuit in a more abstract sense (hard to explain) that is consumed by snark to generate a proof
circom merkel.circom --r1cs --wasm --sym
cd merkel_js
# Using a set of inputs (inputs_8), and the circom web assembly code, generate a witness file that shows a "solution" to a circuit
node generate_witness.js merkel.wasm ../input_8.json witness.wtns

# Prover Section:  This would be run by the Prover

# Snarkjs - trusted setup / Phase 1
# These steps create a empty 'canvas' to run the other steps

# Start a brand new ceremony with powers of tau 15 so it is big enough to hold 
snarkjs powersoftau new bn128 15 pot15_0000.ptau -v
# Add true randomness to the ceremony. In a real application this would not use a hardcoded value seed and instead some other source
# In a real ceremony there would also be more iterations of this command, from other sources/users
snarkjs powersoftau contribute pot15_0000.ptau pot15_0001.ptau --name="First contribution" -v
# Complete the phase 1 of the ceremony - stop taking contributions because we are moving to the next step
snarkjs powersoftau prepare phase2 pot15_0001.ptau pot15_final.ptau -v

# SnarkJS - Proof Generation / Phase 2

# Use groth16 algorithm to generate a zkey 
# I don't fully understand what a zkey is but:
# it can be turned into a verification key that is used by the verifier to describe the underlying circuit
# could not find documentation
snarkjs groth16 setup ../merkel.r1cs pot15_final.ptau merkel_0000.zkey
# Add randomness to the verification key
snarkjs zkey contribute merkle_0000.zkey merkle_0001.zkey --name="1st Contributor Name" -v
# complete the verification key
snarkjs zkey export verificationkey merkle_0001.zkey verification_key.json
# Gives a proof proof.json that:
# shows that the prover posessess a witness (solution) for the circuit
# given the provided public inputs in public.json
# and with secret inputs withheld 
snarkjs groth16 prove merkle_0001.zkey witness.wtns proof.json public.json

# Verification Section: Run by the Verifier

# Validates that the proof.json is a valid proof that the Prover has a witness
# for a given set of public inputs public.json
# and a verification key verification_key.json
snarkjs groth16 verify verification_key.json public.json proof.json




snarkjs groth16 setup ../merkle.r1cs pot12_final.ptau merkle_0000.zkey
snarkjs zkey contribute circuit_0000.zkey circuit_0001.zkey --name="1st Contributor Name" -v
