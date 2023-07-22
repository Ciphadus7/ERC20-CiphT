// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface ERC20Interface {
    function totalSupply() external view returns (uint256);
    function balanceOf(address owner) external view returns (uint256 balance);
    function transfer(address to, uint256 tokens) external  returns (bool success);

    function allowance(address owner, address spender) external  view returns (uint256 remaining);
    function approve(address spender, uint256 tokens) external  returns (bool success);
    function transferFrom(address from, address to, uint256 tokens) external  returns (bool success);

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
}


contract Cryptos is ERC20Interface{
    string public name = "CiphT";
    string public symbol = "CIPT";
    uint256 public decimals = 0; //18 is the most used value of decimal symbols
    uint256 public override totalSupply;

    address public founder;
    mapping(address => uint256) public balances;
    //balances[0x111...] = 100

    mapping(address => mapping(address => uint256)) allowed;
    //0x111...(owner) allows 0x2222.... (the spender) ---- 100 tokens
    //allowed[0x1111][0x2222] = 100;



    constructor() {
        totalSupply = 1000000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

    function balanceOf(address tokenOwner) public view override returns (uint256 balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint256 tokens) public override returns (bool success){
        require(balances[msg.sender] >= tokens);
        balances[to] += tokens;
        balances[msg.sender] -= tokens;
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) view public override returns(uint256) {
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint256 tokens) public override returns (bool success) {
        require(balances[msg.sender] >= tokens);
        require(tokens > 0);

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);
        return true;
    }
    
    function transferFrom(address from, address to, uint256 tokens) external  returns (bool success){
        require(allowed[from][msg.sender] >= tokens);
        require(balances[from] >= tokens);
        balances[from] -= tokens;
        allowed[from][msg.sender] -= tokens;
        balances[to] += tokens;

        emit Transfer(from, to, tokens);
        return true;
    }


}