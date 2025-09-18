AutoSplit-STX
A Clarity smart contract for automatically splitting incoming payments on the Stacks blockchain.
Useful for royalties, team payments, DAOs, and group collaborations where funds must be divided fairly among multiple parties.

Features
Register recipients and set percentage shares
Automatically split STX payments among recipients
Update recipient list and shares securely
Transparent event logs for each split
Validates that shares always sum to 100%

Technical Overview
Language: Clarity
Core Functions:
set-recipients – define recipients and their share percentages
update-recipients – modify distribution list
distribute – split STX payment among recipients
Installation & Usage

Clone repository:
git clone https://github.com/your-repo/autosplit-stx.git
cd autosplit-stx
Deploy with Clarinet:
clarinet contract deploy autosplit-stx

Run tests:
clarinet test

Roadmap
Add SIP-010 token support
Enable time-locked payment streaming
DAO integration for group fund management
Security audits & optimizations

License
MIT License – free to use, modify, and distribute.
