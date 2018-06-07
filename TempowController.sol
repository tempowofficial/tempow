pragma solidity ^0.4.21;

import "./TempowToken.sol";
import "./SafeMath.sol";

 /**
 * @title Tempow Controller
 */
contract TempowController {
    using SafeMath for uint256;

    string public constant version = "v1";
    uint256 public creationBlock;
    address public owner;
    uint256 public tokensTransferred;
    uint256 public usdRaised;
    TempowToken public token;

    event ClaimedTokens(address indexed token, address indexed owner, uint amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
    * @dev Throws if called by any account other than the owner.
    */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function TempowController(address _tokenAddress) public {
        require(_tokenAddress != address(0));
        token = TempowToken(_tokenAddress);
        owner = msg.sender;
        creationBlock = block.number;
        tokensTransferred = 0;
        usdRaised = 0;
    }

    /**
    * @dev Revertible fallback function, because controller doesn't receive any Ether
    */
    function () public {
        revert();
    }

    /**
    * @dev Internal function for transferring tokens over token contract
    */
    function _transfer(address _to, uint256 _value, uint256 _usdValue) internal returns (bool) {
        tokensTransferred = tokensTransferred.add(_value);
        usdRaised = usdRaised.add(_usdValue);
        return token.transfer(_to, _value);
    }

    /**
    * @dev Function that sends specified amount of tokens expressed also in USD
    */
    function sendTokens(address _to, uint256 _value, uint256 _usdValue) public onlyOwner returns (bool) {
        return _transfer(_to, _value, _usdValue);
    }

    /**
    * @dev Function that bulk sends specified amount of tokens expressed also in USD
    */
    function bulkSendTokens(address[] _tos, uint256[] _values, uint256[] _usdValues) public onlyOwner {
        require(_tos.length == _values.length && _tos.length == _usdValues.length && _tos.length > 0);
        for (uint256 i = 0; i < _tos.length; i++) {
            address to = _tos[i];
            uint256 value = _values[i];
            uint256 usdValue = _usdValues[i];
            require(_transfer(to, value, usdValue));
        }
    }

    function claimTokensTempowToken(address _token) public onlyOwner {
        token.claimTokens(_token);
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
