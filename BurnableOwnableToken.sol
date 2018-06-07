pragma solidity ^0.4.21;

import "./StandardERC20Token.sol";

 /**
 * @title Burnable Ownable Token
 * @dev Token that can be burned by owner
 */
 contract BurnableOwnableToken is StandardERC20Token {
    address public owner;
    bool public burningFinished = false;

    event BurnFinished();
    event Burn(address indexed from, uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
    * @dev The Burnable Ownable constructor sets the original `owner` of the contract to the sender
    * account.
    */
    function BurnableOwnableToken() public {
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
    * @dev Throws if burning is finished
    */
    modifier canBurn() {
      require(!burningFinished);
      _;
    }

    /**
    * @dev Function to burn tokens
    * @param _from The address tokens will be burned from.
    * @param _amount The amount of tokens to burn.
    * @return A boolean that indicates if the operation was successful.
    */
    function burn(address _from, uint256 _amount) onlyOwner canBurn public returns (bool) {
	  require(_amount <= balances[_from]);
      totalSupply_ = totalSupply_.sub(_amount);
      balances[_from] = balances[_from].sub(_amount);
      emit Burn(_from, _amount);
      emit Transfer(_from, address(0), _amount);
      return true;
    }

    /**
    * @dev Function to stop burning new tokens.
    * @return True if the operation was successful.
    */
    function finishBurning() onlyOwner canBurn public returns (bool) {
      burningFinished = true;
      emit BurnFinished();
      return true;
    }

}

