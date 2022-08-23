//SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.9.0;

import "hardhat/console.sol";
import "./Staking.sol"
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract DanaToken is ERC20 {
    string public name ="DanaToken";
    string public symbol="DT";

    constructor(string memory name, string memory symbol) ERC20("DanaToken", "DT") {
        _mint(msg.sender, 1000000 * 10**decimals());
    }

    address public manager;
    mapping(address => uint) public balances;
    // balances[0x1111...] = 100;

    mapping(address => mapping(address => uint)) allowed;
    // allowed[0x111][0x222] = 100;

    function mint(address account, uint256 amount) external {
        _mint(account, amount);
    }

    function balanceOf(address tokenOwner) public view override returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public virtual override returns(bool success) {
        require(balances[msg.sender] >= tokens);

        balances[to] += tokens;
        balances[msg.sender] -= tokens;
        emit Transfer(msg.sender, to, tokens);

        return true;
    }

    function allowance(address tokenOwner, address spender) public view override returns(uint) {
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint tokens) public override returns (bool success) {
        require(balances[msg.sender] >= tokens);
        require(tokens > 0);

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public virtual override returns (bool success) {
        require(allowed[from][to] >= tokens);
        require(balances[from] >= tokens);

        balances[from] -= tokens;
        balances[to] += tokens;
        allowed[from][to] -= tokens;

        return true;
    }

}
