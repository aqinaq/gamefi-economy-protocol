# gamefi-economy-protocol
# GameFi Economy Protocol

A full-stack decentralized GameFi economy protocol built for Blockchain Technologies 2 Final Project.

## Scenario

Option B — GameFi Economy.

The protocol includes:
- ERC20 governance token
- ERC1155 in-game item economy
- Constant-product AMM with LP tokens
- ERC4626 vault
- DAO governance with Governor + Timelock
- UUPS upgradeable game configuration
- Factory using CREATE and CREATE2
- Inline Yul benchmark
- Chainlink-style price oracle with stale price checks
- Subgraph schema and mapping
- Foundry deployment script

## Tech Stack

- Solidity
- Foundry
- OpenZeppelin
- The Graph
- GitHub
- L2 target: Base Sepolia or Arbitrum Sepolia

## Test Status

Current test suite:

```bash
forge test --match-path "contracts/test/*"

Latest result:

27 tests passed
0 tests failed
Coverage
forge coverage --match-path "contracts/test/*" --report summary --no-match-coverage "contracts/lib/*"

Latest result:

Line coverage: 92.41%
Statement coverage: 91.24%
Deployment

Local dry run:

forge script contracts/script/Deploy.s.sol

L2 deployment example:

forge script contracts/script/Deploy.s.sol \
  --rpc-url $BASE_SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast \
  --verify
Main Contracts
GameToken.sol — ERC20Votes governance token
GameItems.sol — ERC1155 game items
GameAMM.sol — constant-product AMM
GameAMMFactory.sol — CREATE and CREATE2 factory
GameVault.sol — ERC4626 vault
GameGovernor.sol — DAO governance
Treasury.sol — timelock-controlled treasury
GameConfigV1.sol / GameConfigV2.sol — UUPS upgrade path
PriceOracle.sol — oracle adapter with staleness check
SumUtils.sol — Solidity vs Yul benchmark
Governance Parameters
Timelock delay: 2 days
Voting delay: 7200 blocks
Voting period: 50400 blocks
Quorum: 4%
Proposal threshold: 10,000 GTK
Project Status

Smart contract core is implemented and tested. Frontend, final L2 deployment, verified addresses, full audit report, and final presentation remain.
## Base Sepolia Deployment

Deployment wallet:

```txt
0x7aAc4872D0Eac6a43A1aeB20BC53310233d18854

Network:

Base Sepolia
Chain ID: 84532
Deployed Contracts
Contract	Address
GameToken	0x86281544e8f63E0aca012a1b7013D995613844b1
GameItems	0xf556B42B72d29b4D6189c6d00Ef3A83C0774Ae3f
Treasury	0xc1CB2cF7Ce07f809A740867DAB63C0A4466Ce337
GameAMMFactory	0x019ee2B7c6eB989735df52e6eb5827F0BF8aB2a7
GameVault	0x123579f7F5989C8DB92f2a74A4D2D42C9cb56E9d
GameConfigProxy	0x8261Df7e6f13587a0DcFA3bf7a984b1dED05CAf2
Timelock	0xD8D722F3871Ec59665163C7C7665188A6E3A6BA2
Governance Deployment Note

GameGovernor was fully implemented and tested locally, including the full proposal lifecycle. However, live deployment on Base Sepolia failed because the OpenZeppelin Governor bytecode exceeded the EIP-170 contract size limit.

Local governance test result:

GameGovernorTest: 2 passed, 0 failed
Full test suite: 27 passed, 0 failed