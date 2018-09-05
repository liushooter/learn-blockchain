import json
import web3
from web3 import Web3, HTTPProvider

my = "0xD551234Ae421e3BCBA99A0Da6d736074f22192FF"
eos_contract_address = "0x86Fa049857E0209aa7D9e616F7eb3b3B78ECfdb0"

abi_str='''
[{
  "type":"function",
  "name":"balanceOf",
  "constant":true,
  "payable":false,
  "inputs":[{"name":"","type":"address"}],
  "outputs":[{"name":"","type":"uint256","value":"0"}]
}]
'''


contract_source_code='''
[
  {
    "constant": true,
    "inputs": [],
    "name": "name",
    "outputs": [
      {
        "name": "",
        "type": "string"
      }
    ],
    "payable": false,
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "totalSupply",
    "outputs": [
      {
        "name": "",
        "type": "uint256"
      }
    ],
    "payable": false,
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "decimals",
    "outputs": [
      {
        "name": "",
        "type": "uint8"
      }
    ],
    "payable": false,
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {
        "name": "_owner",
        "type": "address"
      }
    ],
    "name": "balanceOf",
    "outputs": [
      {
        "name": "balance",
        "type": "uint256"
      }
    ],
    "payable": false,
    "type": "function"
  }
]
'''

abi = json.loads(contract_source_code)

web3 = Web3(HTTPProvider("https://mainnet.infura.io/") )
source_code = web3.eth.getCode(eos_contract_address)
contract = web3.eth.contract(abi=abi, address=eos_contract_address)
balance = contract.call().balanceOf(my)

total_supply = contract.call().totalSupply()

print(balance)
print(total_supply)
