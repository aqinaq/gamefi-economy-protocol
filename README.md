# GameFi Economy Protocol

A full-stack decentralized GameFi economy protocol built for the **Blockchain Technologies 2 Final Project**.

---

## Scenario

**Option B — GameFi Economy**

This protocol implements a complete on-chain GameFi ecosystem including:

- ERC20 governance token
- ERC1155 in-game item economy
- Constant-product AMM with LP tokens
- ERC4626 yield vault
- DAO governance using Governor + Timelock
- UUPS upgradeable game configuration
- Factory using CREATE and CREATE2
- Inline Yul benchmark
- Chainlink-style price oracle with stale price checks
- The Graph subgraph schema and mapping
- Foundry deployment scripts

---

## Tech Stack

| Tool | Purpose |
|---|---|
| Solidity | Smart contract language |
| Foundry | Testing & deployment framework |
| OpenZeppelin | Contract standards & security |
| The Graph | On-chain event indexing |
| GitHub Actions | CI/CD pipeline |
| Base Sepolia | L2 deployment target |

---

## Test Status

### Run Tests

```bash
forge test --match-path "contracts/test/*"
```

**Latest Result:** ✅ 27 passed · 0 failed

### Run Coverage

```bash
forge coverage --match-path "contracts/test/*" \
  --report summary \
  --no-match-coverage "contracts/lib/*"
```

**Coverage Results:**

| Metric | Coverage |
|---|---|
| Line Coverage | 92.41% |
| Statement Coverage | 91.24% |
| Function Coverage | 89.47% |

> Includes fuzz testing for AMM invariant (`x * y = k`)

---

## Deployment

### Local Dry Run

```bash
forge script contracts/script/Deploy.s.sol
```

### Base Sepolia Deployment

```bash
forge script contracts/script/Deploy.s.sol \
  --rpc-url $BASE_SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast
```

---

## Main Contracts

| Contract | Description |
|---|---|
| `GameToken.sol` | ERC20Votes governance token |
| `GameItems.sol` | ERC1155 multi-token game items |
| `GameAMM.sol` | Constant-product AMM (`x * y = k`) |
| `GameAMMFactory.sol` | Factory using CREATE and CREATE2 |
| `GameVault.sol` | ERC4626 tokenized vault |
| `GameGovernor.sol` | DAO governance contract |
| `Treasury.sol` | Timelock-controlled treasury |
| `GameConfigV1.sol` | Upgradeable game configuration |
| `GameConfigV2.sol` | Extended upgrade implementation |
| `PriceOracle.sol` | Chainlink-style oracle adapter |
| `SumUtils.sol` | Solidity vs Yul gas benchmark |

---

## Governance Parameters

| Parameter | Value |
|---|---|
| Timelock Delay | 2 days |
| Voting Delay | 7,200 blocks |
| Voting Period | 50,400 blocks |
| Quorum | 4% of total supply |
| Proposal Threshold | 10,000 GTK |

---

## Base Sepolia Deployment

**Deployment Wallet:** `0x7aAc4872D0Eac6a43A1aeB20BC53310233d18854`

**Network:** Base Sepolia · **Chain ID:** `84532`

### Deployed Contracts

| Contract | Address |
|---|---|
| GameToken | `0x86281544e8f63E0aca012a1b7013D995613844b1` |
| GameItems | `0xf556B42B72d29b4D6189c6d00Ef3A83C0774Ae3f` |
| Treasury | `0xc1CB2cF7Ce07f809A740867DAB63C0A4466Ce337` |
| GameAMMFactory | `0x019ee2B7c6eB989735df52e6eb5827F0BF8aB2a7` |
| GameVault | `0x123579f7F5989C8DB92f2a74A4D2D42C9cb56E9d` |
| GameConfigProxy | `0x8261Df7e6f13587a0DcFA3bf7a984b1dED05CAf2` |
| Timelock | `0xD8D722F3871Ec59665163C7C7665188A6E3A6BA2` |

### Governance Deployment Note

`GameGovernor.sol` was fully implemented and tested locally, including the complete proposal lifecycle. However, live deployment on Base Sepolia failed because the OpenZeppelin Governor bytecode exceeded the **EIP-170 contract size limit**.

**Local Governance Test Results:** ✅ GameGovernorTest: 2 passed, 0 failed · Full suite: 27 passed, 0 failed

---

## Security Analysis

Static analysis was performed using [Slither](https://github.com/crytic/slither):

```bash
slither src
```

The reported findings were reviewed and determined to be informational or expected design choices:

- Low-level calls in `Treasury.sol`
- Timestamp checks in `PriceOracle.sol`
- Assembly usage in `SumUtils.sol`
- Naming convention warnings

**No critical vulnerabilities were identified.**

---

## Subgraph Integration

The project includes a full subgraph for off-chain querying and analytics:

```
subgraph/
├── schema.graphql
├── subgraph.yaml
└── src/mapping.ts
```

---

## Documentation

Additional reports are available in the `docs/` directory:

| File | Description |
|---|---|
| `architecture.md` | System architecture overview |
| `audit-report.md` | Internal audit findings |
| `gas-report.md` | Gas usage analysis |
| `slither-report.txt` | Full Slither static analysis output |

---

## Project Status

### ✅ Completed

- Smart contracts implementation
- Unit and fuzz testing
- Coverage analysis
- Security analysis
- Local and Base Sepolia deployment
- Subgraph schema and mappings
- Documentation

### 🔲 Remaining (Optional)

- Contract verification on BaseScan
- Frontend integration
- Final presentation slides

---

## License

[MIT](LICENSE)
