# Tempow Smart Contracts
There are two smart contracts in Tempow UTO, which are interrelated: Tempow Token and Tempow Controller. Tempow Token represents a basic ERC20 token with mintable, ownable and related functionalities. Tempow Controller relies on token and it is responsible for token distribution aspects of UTO platform. Both smart contracts are going to be deployed up front, but they are actually going to be used after UTO finishes, to be able to distribute tokens.

Both contracts have the owner address. Owner of Tempow Token will be Tempow Controller. Owner of Tempow Controller will be a separate wallet. Tempow Token, through *MintableOwnableToken* and *StandardERC20Token* implements ERC20 interface. Both smart contracts are using ERC20 interface for the ability to extract the mistakenly sent ERC20 tokens (and even Ether). *StandardERC20Token* represents pure
implementation of ERC20 interface (transfer and approval functionalities). *MintableOwnableToken* extends *StandardERC20Token* with mint and ownership related functionalities. 

Token starts with *totalSupply* equal to zero and all new tokens assigned to different addresses are minted. Once minting is completed, there is an option to finish minting. When minting is finished, there is no way to go back and enable it. And it can be done only
through owner. Ownership can be transferred, and a proper event will be raised upon that action. Both contracts are having revertible fallback functions, thus not receiving Ether. On arithmetic operations, common exceptions like overflow and division with zero should be taken care of (through *SafeMath*).
