pragma solidity ^0.4.21;

import "./BurnableOwnableToken.sol";
import "./ERC20.sol";

contract TempowToken is BurnableOwnableToken {
  string public constant name = "Tempow Token";
  string public constant symbol = "TEMP";
  uint8 public constant decimals = 18;
  string public constant version = "v1";
  uint256 public creationBlock;

  event ClaimedTokens(address indexed token, address indexed owner, uint amount);

  /// @notice Tempow Token constructor
  /// @param _initTotalSupply Initial total supply that is going to be assigned to owner
  function TempowToken(uint _initTotalSupply) public {
	  totalSupply_ = _initTotalSupply;
	  balances[owner] = totalSupply_;
      creationBlock = block.number;
  }

  /// @notice Revertible fallback function
  function () public payable {
      revert();
  }

  /// @notice This method can be used by the owner to extract mistakenly
  ///  sent tokens to this contract.
  /// @param _token The address of the token contract that you want to recover
  ///  set to 0 in case you want to extract ether.
  function claimTokens(address _token) public onlyOwner {
      if (_token == address(0)) {
          owner.transfer(address(this).balance);
          return;
      }

      ERC20 erc20Token = ERC20(_token);
      uint balance = erc20Token.balanceOf(this);
      erc20Token.transfer(owner, balance); //maybe round this call with require()
      emit ClaimedTokens(_token, owner, balance);
  }

}
