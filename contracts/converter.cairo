%lang starknet
# Part of my POC I needed a decimal to binary converter,
# This is by no means production grade code, no range check nor extensive tests has been done!
# Providing this snippet for whoever needs it, want to improve it, and give feedback :)

from starkware.cairo.common.cairo_builtins import HashBuiltin
from libs.starknetarraymanipulation.contracts.array_manipulation import reverse
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import unsigned_div_rem

# Ideally would do away with this storage var, tried local, tempvar no joy, early days though in my cairo journey!
@storage_var
func decimal_conversion_index() -> (index : felt):
end

@view
func convertDecimalToBinary{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    decimal_value : felt
) -> (binary_array_len : felt, binary_array : felt*):
    alloc_locals
    # Convert decimal to binary, result is an array [LSB, ..., MSB]
    let (len, inversedArray) = convertToBinary(decimal_value)
    # Reversing the above array to the correct order: [MSB, ..., LSB]
    let (len, resultArray) = reverse(len, inversedArray)

    return (len, resultArray)
end

func convertToBinary{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    decimal_value : felt
) -> (binary_array_len : felt, binary_array : felt*):
    alloc_locals
    let (local binary_array : felt*) = alloc()
    decimal_conversion_index.write(0)
    let (local index) = decimal_conversion_index.read()

    # Conversion to binary,
    # Dividing the decimal by 2 as binary is base 2
    # the cairo unsigned_div_rem method returns q and r
    # q is the result of decimal_value/2
    # r is the remainder
    # add the r's to an array
    # repeat it using a jmp until q = 0
    # we end up with an array: [LSB,...,MSB]

    let (q, r) = unsigned_div_rem(value=decimal_value, div=2)
    assert binary_array[index] = r
    decimal_conversion_index.write(index + 1)

    let (index) = decimal_conversion_index.read()

    loop:
    let (q, r) = unsigned_div_rem(value=q, div=2)
    assert binary_array[index] = r
    decimal_conversion_index.write(index + 1)
    let (index) = decimal_conversion_index.read()

    jmp loop if q != 0

    return (index, binary_array)
end
