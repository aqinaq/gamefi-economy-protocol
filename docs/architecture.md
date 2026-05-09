# Architecture Document

## Overview

GameFi Economy Protocol is a decentralized game economy system that combines fungible tokens, NFT-style game items, AMM liquidity, vault deposits, DAO governance, upgradeable configuration, and oracle-based price validation.

## Main Components

### GameToken

`GameToken` is an ERC20Votes token used for governance voting power and in-game economy operations.

### GameItems

`GameItems` is an ERC1155 contract for minting fungible and semi-fungible game assets such as weapons, potions, rewards, and collectible items.

### GameAMM

`GameAMM` is a constant-product automated market maker. It allows users to:

- Add liquidity
- Remove liquidity
- Swap token A for token B
- Swap token B for token A

The AMM uses the formula:

```txt
x * y = k
GameAMMFactory

GameAMMFactory deploys new AMM pools using both normal deployment and deterministic CREATE2 deployment.

GameVault

GameVault is an ERC4626 vault that accepts GameToken deposits and issues vault shares.

Treasury

Treasury holds protocol ETH and allows withdrawals only by the owner. In the governance setup, ownership is transferred to the Timelock.

GameGovernor and Timelock

GameGovernor enables DAO governance. Proposals are created, voted on, queued, and executed through the Timelock.

Governance flow:

Proposal → Voting Delay → Voting Period → Queue → Timelock Delay → Execute
GameConfigV1 and GameConfigV2

The game configuration is upgradeable using the UUPS proxy pattern.

GameConfigV1 stores:

Drop rate
Crafting cost

GameConfigV2 adds:

Rare drop rate
PriceOracle

PriceOracle reads price data from a Chainlink-style feed and rejects stale or invalid price data.

SumUtils

SumUtils compares normal Solidity logic with inline Yul assembly to demonstrate low-level optimization.

Deployment Architecture
Deployer
   |
   |-- GameToken
   |-- GameItems
   |-- GameAMMFactory
   |-- GameVault
   |-- GameConfig Implementation
   |-- GameConfig Proxy
   |-- Timelock
   |-- GameGovernor
   |-- Treasury ownership transferred to Timelock
Security Model

The system uses:

OpenZeppelin audited base contracts
Ownable access control
Timelock-controlled treasury
UUPS upgrade authorization
Stale oracle price protection
Unit and fuzz testing
Slither static analysis
Testing Strategy

The test suite covers:

ERC20 minting
ERC1155 minting and batch minting
Treasury deposits and withdrawals
AMM liquidity and swaps
AMM fuzz invariant for constant product
Factory deployment and CREATE2 prediction
UUPS upgrade from V1 to V2
Oracle valid, invalid, and stale price checks
Governor proposal lifecycle
ERC4626 deposit and withdrawal
Coverage

Latest coverage:

Line coverage: 92.41%
Statement coverage: 91.24%
Branch coverage: 54.05%
Function coverage: 89.47%
Base Sepolia Deployment

Most core contracts were deployed to Base Sepolia.

GameGovernor deployment was tested locally but exceeded the EIP-170 contract size limit during live deployment due to OpenZeppelin Governor bytecode size. The governance lifecycle is still fully covered by local tests.

Design Patterns Used
Factory pattern
CREATE2 deterministic deployment
UUPS upgradeability
DAO governance
Timelock control
ERC4626 vault standard
ERC1155 multi-token standard
ERC20Votes governance token
Oracle adapter pattern

# Architecture Diagram

```mermaid
graph TD
    User --> GameToken
    User --> GameItems
    User --> GameAMM
    User --> GameVault

    GameAMMFactory --> GameAMM
    GameVault --> GameToken

    GameGovernor --> Timelock
    Timelock --> Treasury
    Timelock --> GameConfigProxy

    GameConfigProxy --> GameConfigV1
    GameConfigV1 --> GameConfigV2

    PriceOracle --> ChainlinkFeed
    SumUtils --> YulAssembly