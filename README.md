# DecimalToBinary
Starknet smart contract converting decimal to binary

This is a quick and dirty conversion, deviding a decimal by 2, add the remainder to an array and keep deviding the result until its equal to 0!

The result of that conversion is an array containing [LSB, ..., MSB]

An array inversion is performed to end up with a binary in the correct order [MSB, ..., LSB]

Have a go on voyager: 
[0x075bd66b354610c7378218bd7822fe242ee9b04e67800e43438fffe6699152d7](https://goerli.voyager.online/contract/0x075bd66b354610c7378218bd7822fe242ee9b04e67800e43438fffe6699152d7#readContract)

Thanks to the [cairo math lib](https://github.com/starkware-libs/cairo-lang) for the division and [gaetbout/starknet-array-manipulation](https://github.com/gaetbout/starknet-array-manipulation) for the array manipulation!


Any improvement or comments please raise a pr :)

