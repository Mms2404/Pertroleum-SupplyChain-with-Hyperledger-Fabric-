# 🔗 Blockchain in the Petroleum Supply Chain
---
## 🌍 Why Blockchain?

Imagine a world where every transaction is:
- 💡 Transparent
- 🔐 Tamper-proof
- 🤝 Trustless (but in a good way — no need to "trust", just verify)

Blockchain is a secure, shared digital ledger that lets multiple parties record, track, and verify transactions transparently—without needing to trust a central authority—making it perfect for building trust in systems like supply chains.

---

# 🔧  Hyperledger Fabric ?
## Hyperledger Fabric is a permissioned blockchain framework designed for building secure, scalable, and modular enterprise-grade applications, where only authorized participants can access and interact with the network.

✨ Here's what makes it perfect for supply chains:

- **Permissioned Access** – Only verified participants (like refiners, transporters, retailers) can join the network.
- **Modular Design** – You control how consensus, identity, and privacy work.
- **Private Channels & Data Collections** – Keep sensitive business info (like pricing or deals) confidential — even on the blockchain.
- **Smart Contracts (Chaincode)** – Automate petroleum batch tracking: from creation to delivery.
- **Auditability** – Every transaction is recorded and verifiable. Perfect for compliance and trust.

---

## ⛽ What This Project Demonstrates

This isn’t just code — it’s a working model of how blockchain transforms petroleum supply tracking.

With this Hyperledger Fabric network, you can:
- 🛢️ Create petroleum batches with all metadata (origin, quantity, timestamp)
- 🚛 Track ownership transfer across organizations
- 📦 Update the status in real time (In-Transit, Delivered, etc.)
- 🧾 Prove it all — every step is recorded on a tamper-proof ledger ( blockchain beauty )

---
## Ouick Start :
## Pre-requistics :
  - Install Docker, Docker Compose
  - Install WSL (for Windows users)
  - Install Fabric Samples and Binaries :  [ You don't have to download this if you clone this repo , i have provided it here ]
    ``` bash
    curl -sSL https://bit.ly/2ysbOFE | bash -s
    ```
    IMP : Ensure you add fabric-samples/bin to your environment path.
  - Start network : ( In the project directory - cd Petroleum-chaincode )
     ``` bash
     wsl
     docker-compose up -d
     ```

## Rather than a quick start , wanna build your network , your own supplychain ? Read below :

To learn how to bring this network to life on your machine and explore the entire flow - go to the COMMANDS.text file in this repo ( it has all the commands you should run to create this supplychain and the possible errors you can face with solution )



