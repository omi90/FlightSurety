# FlightSurety

FlightSurety is a sample application project for Udacity's Blockchain course.

### Programming Libraries Used:
- **Truffle v5.8.1 (core: 5.8.1):** used to deploy and test smart contracts.
- **Solidity v0.5.16 (solc-js):** high-level langauge for writing smart contracts.
- **Node v18.15.0:** used for building web applications quickly
- **Web3.js v1.8.2:** used to allow the smart contracts to interact with a local/remote Ethereum node with an HTTP, HTTPS, or IPC connection.

## Install

This repository contains Smart Contract code in Solidity (using Truffle), tests (also using Truffle), dApp scaffolding (using HTML, CSS and JS) and server app scaffolding.

To install, download or clone the repo, then:

`npm install`

`truffle compile`

<img width="454" alt="image" src="https://github.com/omi90/FlightSurety/assets/1911548/d114de4f-da6c-4e09-b9b1-acde97447e35">

## Develop Client

To run truffle tests:

`truffle test ./test/flightSurety.js`

`truffle test ./test/oracles.js`

To use the dapp:

`truffle migrate`

<img width="529" alt="image" src="https://github.com/omi90/FlightSurety/assets/1911548/afe236c0-4c8a-4ae3-80d2-13ae5fabaeda">
<img width="554" alt="image" src="https://github.com/omi90/FlightSurety/assets/1911548/b615f025-02bf-4089-81b2-b333ec270ff6">
<img width="523" alt="image" src="https://github.com/omi90/FlightSurety/assets/1911548/813ce6b1-107b-43ba-8868-9c9dc98bb584">

`npm run dapp`

To view dapp:

`http://localhost:8000`

## Develop Server

`npm run server`
`truffle test ./test/oracles.js`

## Deploy

To build dapp for prod:
`npm run dapp:prod`

Deploy the contents of the ./dapp folder


## Resources

* [How does Ethereum work anyway?](https://medium.com/@preethikasireddy/how-does-ethereum-work-anyway-22d1df506369)
* [BIP39 Mnemonic Generator](https://iancoleman.io/bip39/)
* [Truffle Framework](http://truffleframework.com/)
* [Ganache Local Blockchain](http://truffleframework.com/ganache/)
* [Remix Solidity IDE](https://remix.ethereum.org/)
* [Solidity Language Reference](http://solidity.readthedocs.io/en/v0.4.24/)
* [Ethereum Blockchain Explorer](https://etherscan.io/)
* [Web3Js Reference](https://github.com/ethereum/wiki/wiki/JavaScript-API)
