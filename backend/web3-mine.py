import json

from web3 import Web3, HTTPProvider, TestRPCProvider
from web3.contract import ConciseContract

make_your_resolution_stick_json = open('MakeYourResolutionStick.json').read()
make_your_resolution_stick_artifact = json.loads(make_your_resolution_stick_json)

# web3.py instance
#w3 = Web3(TestRPCProvider())
#w3 = Web3(HTTPProvider('https://mainnet.infura.io'))
w3 = Web3(HTTPProvider('http://localhost:8545'))

# Contract instance in concise mode
contract_instance = w3.eth.contract(
    make_your_resolution_stick_artifact['abi'], '0x9168705c1ed0df5d45522a257d8aebe68385787e')  # make_your_resolution_stick_artifact['networks']['1510566504532']['address']

# print(make_your_resolution_stick_artifact['networks']['1510566504532']['address'])
# print(make_your_resolution_stick_artifact['abi'])
print(dir(contract_instance))
print(w3.eth.accounts)

# Getters + Setters for web3.eth.contract object
print(contract_instance.call().getGoal2())
#contract_instance.setGreeting('Nihao', transact={'from': w3.eth.accounts[0]})
#print('Setting value to: Nihao')
#print('Contract value: {}'.format(contract_instance.greet()))

# # MakeYourResolutionStickArtifact.networks['1510566504532'].address
