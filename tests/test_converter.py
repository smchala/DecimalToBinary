"""demux.cairo test file."""
import os

import pytest
import asyncio

from starkware.starknet.testing.starknet import Starknet
CONTRACT_FILE = os.path.join("contracts", "converter.cairo")


@pytest.fixture(scope="session")
def event_loop():
    return asyncio.get_event_loop()


@pytest.fixture(scope="session")
async def starknet():
    return await Starknet.empty()


@pytest.fixture(scope="session")
async def contract(starknet):
    return await starknet.deploy(source=CONTRACT_FILE,)


@pytest.mark.asyncio
@pytest.mark.parametrize("input, result", [
    (0, [0, 0]),
    (1, [0, 1]),
    (10, [1, 0, 1, 0]),
    (233, [1, 1, 1, 0, 1, 0, 0, 1]),
    (53978, [1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0]),
    (11209824350, [1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1,
     0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0]),
    (23987543987239487293847234, [1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0,
     1, 0, 0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0]),
])
async def test_decimal_to_binary_conversion(contract, input, result):
    execution_info = await contract.convertDecimalToBinary(decimal_value=input).invoke()
    assert execution_info.result[0] == result
