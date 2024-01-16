# LFGHO Hackathon

## 1. **Executive Summary**

**Project Overview**: RWA Marketplace is a platform designed to tokenise and fractionalize Real World Assets (RWAs). This platform aims to merge the physical and digital economies, offering a novel method to manage, trade, and invest in RWAs with enhanced security, transparency, and efficiency.

## **2. Introduction**

RWAs, such as real estate, art, and commodities, traditionally suffer from illiquidity and accessibility issues. RWA Marketplace addresses these challenges by enabling the tokenization of these assets, making them more accessible to a broader range of investors and providing a more liquid market for these traditionally illiquid assets.

## **3. Technical Architecture**

### **3.1 Blockchain and Smart Contracts**

RWA marketplace is not restrictive to any chain or network, it’s a chain agnostic platform. The platform utilises smart contracts for bringing RWAs on-chain, managing the Bancor curve for pricing, and handling transactions. These contracts are designed for optimal security and efficiency.

### **3.2 Tokenization Process**

Tokenization in this context refers to the process of converting a real-world asset (RWA) into a digital token, specifically within a Decentralized Autonomous Organization (DAO) structure. Here’s how it works:

1. **Consensus and Listing**: First, members of a DAO agree to list a specific asset. This involves a collaborative decision-making process.
2. **Minting and Identifier Assignment**: Once the asset is selected, it's 'minted' as a digital token. This token is assigned a unique identifier, which acts as its digital signature or identity.
3. **Involvement of Oracle**: This unique identifier, along with the details of the agreement (like pricing, terms, etc.), is listed with an Oracle. The Oracle's role is pivotal—it fetches the real-world price of the asset and provides essential agreement details to smart contracts. This information is crucial for creating a decentralized secondary market.

### **3.3 Fractionalization Mechanics**

The concept of fractionalization allows for the division of Non-Fungible Tokens (NFTs), which represent real-world assets (RWAs), into smaller, tradeable units. This process involves several steps:

1. **Locking the NFT in a Vault**: An RWA, represented by an ERC-721 Token (a type of NFT), is locked into a vault contract. This is the first step in the fractionalization process.
2. **DAO and Asset Originator Agreement**: The DAO and the asset's original owner (Asset Originator) must agree on certain aspects like price, market liquidity, and the duration of market existence (if applicable).
3. **Proposal for Secondary Market**: The Asset Originator proposes to create a secondary market for this asset by locking their ERC-721 token in the vault contract. The DAO then reviews this proposal and can either accept or reject it. If rejected, the token is returned to the owner.
4. **DAO's Financial Contribution and GHO Token Minting**: Upon acceptance, the DAO deposits an amount equivalent to the RWA's value in ETH (Ether) into the contract. Based on the RWA's price, sourced from the Oracle, GHO tokens are minted. The Oracle also indicates the agreed-upon initial market liquidity.
5. **Distribution of GHO Tokens and Market Creation**: Depending on the agreed-upon terms, a portion of the GHO tokens (e.g., 80% if that's the liquid share agreed upon) is transferred to the Asset Originator. The rest (e.g., 20%) is used to create a market using the Bancor curve algorithm. This algorithm determines the pricing of fractional tokens based on real-time supply and demand, setting a reserve ratio (in this example, 20%).

### **3.4 Yield Generation Mechanics**

Yield generation in this RWA-based finance system is structured to benefit both the Asset Originator and the DAO (Decentralized Autonomous Organization), facilitated by a fee mechanism on each buy and sell transaction. Here's how it operates:

1. **Transaction Fees on Buys and Sells**: Every time an asset is bought or sold in the secondary market, a predetermined fee is charged. This fee is integral to the system's revenue generation model.
2. **Allocation of Fees**: The collected fees are split between incentivizing the Asset Originator and the DAO. This allocation is strategically designed to reward both parties for their roles in the ecosystem.
3. **Incentivizing the Asset Originator**: A significant portion of the fee goes to the Asset Originator. This incentivizes individuals or entities that bring real-world assets (RWAs) into the blockchain domain, fostering a diverse and active marketplace.
4. **Earnings for the DAO**: The DAO, responsible for overseeing and managing the platform's ecosystem, receives a portion of the transaction fees. However, since the DAO earns from multiple assets listed on the platform, the fee share per individual asset is comparatively smaller than that of the Asset Originator.
5. **Sustainable Yield Generation**: This fee structure ensures a sustainable yield generation model. It encourages Asset Originators to list high-quality assets by offering them a higher share of the transaction fees. Simultaneously, it provides a steady income stream to the DAO, enabling it to manage and expand the platform effectively.
6. **Dynamic Fee Structure**: The exact fee percentages can be adjusted based on market dynamics, ensuring that the system remains competitive and attractive for both Asset Originators and investors.

### **3.5 Reserve Currencies**

Ether or any Stablecoin can be used for spinning up the market

## **4. Economic Model**

### **4.1 Pricing Strategy**

The Bancor curve adjusts prices dynamically, ensuring liquidity and fair pricing that reflects current market conditions. This is based on the reserve ratio, continuous token supply and continuous token price.
This further creates a very good utility for underlying Truffles Token

Price Dynamics: For instance, if a user wants to tokenize a housing unit worth $100K, and deposits $10K as initial liquidity, the reserve ratio is set at 10%. The price of these fractionalized tokens will then vary based on the Bancor Formula, which uses this reserve ratio and the total supply of tokens to determine their value. The Bancor Formula ensures a balanced and dynamic pricing mechanism, adjusting according to market demand and supply. It's an efficient way to create a liquid market for fractionalized real estate assets, making investment opportunities more accessible to a wider audience.
![Untitled (6)](https://github.com/auralshin/rwa-marketplace/assets/41705919/aa873a8c-b09e-4075-8d69-6d0772799f94)

![Untitled (7)](https://github.com/auralshin/rwa-marketplace/assets/41705919/fa5329d8-dcca-45c2-9e44-5a9ab3459084)


### **4.2 Revenue Streams**

Revenue is generated through transaction fees, minting charges, etc.

## **5. Use Cases**

The RWA Marketplace transforms the landscape of asset ownership and investment by offering tokenization and fractionalization of Real World Assets. This innovative approach opens up new economic markets for traders, investors, and asset creators, as illustrated in the following detailed use cases:

### 1. Real Estate Tokenization and Fractional Ownership

- **Situation**: Real estate, traditionally a high-value and illiquid asset class, is often beyond the reach of average investors.
- **Solution**: Tokenizing properties as NFTs allows them to be fractionalized into smaller, affordable units.
- **Impact**: Investors can buy fractions of property, diversifying their portfolios without the need for significant capital. According to a [World Economic Forum report](https://www.weforum.org/), blockchain technology in real estate could increase the global GDP by $1.76 trillion by 2030 through enhanced liquidity and transparency.
- **Benefit for Asset Creators**: Property owners can unlock the value of their assets by selling fractions to a broader market.

### 2. Commodities and Collectibles Market

- **Situation**: Investing in commodities like gold or unique collectibles often requires significant upfront investment and storage costs.
- **Solution**: Tokenization allows these assets to be fractionally owned and traded, reducing the entry barrier and storage concerns.
- **Impact**: As per a [study by McKinsey & Company](https://www.mckinsey.com/), blockchain's application in commodities can streamline trading processes and enhance transparency.
- **Benefit for Owners**: Asset owners can easily liquidate part of their holdings while retaining a stake in their investments.

### 3. New Avenues for Investors and Traders

- **Situation**: Traditional markets can be volatile and offer limited diversification options.
- **Solution**: The RWA Marketplace offers a new asset class for investment, providing additional diversification options.
- **Impact**: This can potentially reduce portfolio risk and offer uncorrelated returns, as suggested by a [J.P. Morgan report](https://www.jpmorgan.com/), indicating the potential of alternative investments in stabilizing portfolios.
- **Benefit for Traders and Investors**: Access to a new, diversified market with potentially lower entry costs and increased liquidity.

## 6. User Flow
![Untitled (8)](https://github.com/auralshin/rwa-marketplace/assets/41705919/52c63b23-2529-4f0d-8081-3d46addf610d)

