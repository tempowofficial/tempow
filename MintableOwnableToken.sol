pragma solidity ^0.4.21;

import "./StandardERC20Token.sol";

 /**
 * @title Mintable Ownable Token
 * @dev Token that can be minted by owner
 */
 contract MintableOwnableToken is StandardERC20Token {
    address public owner;
    bool public mintingFinished = false;

    event MintFinished();
    event Mint(address indexed to, uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
    * @dev The Mintable Ownable constructor sets the original `owner` of the contract to the sender
    * account.
    */
    function MintableOwnableToken() public {
      owner = msg.sender;
    }

    /**
    * @dev Throws if called by any account other than the owner.
    */
    modifier onlyOwner() {
      require(msg.sender == owner);
      _;
    }

    /**
    * @dev Allows the current owner to transfer control of the contract to a newOwner.
    * @param newOwner The address to transfer ownership to.
    */
    function transferOwnership(address newOwner) public onlyOwner {
      require(newOwner != address(0));
      emit OwnershipTransferred(owner, newOwner);
      owner = newOwner;
    }

    /**
    * @dev Throws if minting is finished
    */
    modifier canMint() {
      require(!mintingFinished);
      _;
    }

    /**
    * @dev Function to mint tokens
    * @param _to The address that will receive the minted tokens.
    * @param _amount The amount of tokens to mint.
    * @return A boolean that indicates if the operation was successful.
    */
    function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
      totalSupply_ = totalSupply_.add(_amount);
      balances[_to] = balances[_to].add(_amount);
      emit Mint(_to, _amount);
      emit Transfer(address(0), _to, _amount);
      return true;
    }

    /**
    * @dev Function to stop minting new tokens.
    * @return True if the operation was successful.
    */
    function finishMinting() onlyOwner canMint public returns (bool) {
      mintingFinished = true;
      emit MintFinished();
      return true;
    }

}

