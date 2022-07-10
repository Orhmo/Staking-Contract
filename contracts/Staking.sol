 //SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.9.0;

import "hardhat/console.sol";


contract Staking {
    address payable[] private stakeholders;
    address public manager;

    bool complete;
    bool initialized;
    mapping(address=>bool) public stakeholder;
    mapping(address=>uint256) public stakeholdersIndex;
    mapping(address => uint256) public balance;


    uint256 public stakedAmount;
    uint256 public stakerCount;
    uint256 public startBlock;
    uint256 public endBlock;
    uint256 public sendBlock;
    uint256 public constant THRESHOLD = 1 ether;


    event Staked(address indexed stakeholder, uint256 value);
    event Unstaked(address indexed stakeholder, uint256 stake);
    event RewardClaim(address indexed stakeholder, uint256 reward);
    event Withdrawal(address indexed stakeholder, uint256 stake);

    enum State {Started, Running, Ended, Canceled}
    State public staking;

    modifier restricted() {
        require(msg.sender == manager, "Only the manager can call this function");
        _;
    }

    modifier staker() {
        require(stakeholdersIndex[msg.sender] > 0, "Only a stakeholder can call this function");
        _;
    }

    modifier start() {
        require(block.timestamp >= startBlock);
        _;
    }

    modifier end() {
        require(block.timestamp <= endBlock, "Staking period has ended");
        _;
    }

    modifier send() {
        require(block.timestamp >= sendBlock);
        _;
    }

    constructor() {
        manager = msg.sender;
        staking = State.Running;
        startBlock = block.number;
        endBlock = startBlock + 40320;
        sendBlock = endBlock + 40320;
    }

    function stake() public payable start end {
        require(staking == State.Running);
        require(msg.value >= THRESHOLD, "Minimum stake is 1 ether");

        if (msg.value >= THRESHOLD) {

            stakeholder[msg.sender] = true;
            stakerCount++;

            stakeholdersIndex[msg.sender] += msg.value;
            stakedAmount += msg.value;
        }
        stakeholders.push
        (
        payable
        (msg.sender));

        emit Staked(msg.sender, msg.value);
    }

    function unstake() public payable staker start end {
        require(stakeholdersIndex[msg.sender] > 0, "No  stakes available");
        require(stakedAmount == 0, "Already unstaked");
        require(block.number < endBlock, "Cannot terminate after stake");
        staking = (State.Canceled);
       // value = stakeholdersIndex[msg.sender];

        emit Unstaked(msg.sender, msg.value);
    }

    function reward() public payable staker start end {
        require(block.number > endBlock && stakedAmount > THRESHOLD, "Staking period has not elapsed");
        require(stakeholdersIndex[msg.sender] > 0);
    }

    function withdrawStake() public payable staker start send end {
        require(block.number > sendBlock && stakedAmount > THRESHOLD, "Staking period has not not elapsed");
        //require(block.timestamp > sendBlock, "Wait 1 minute for withdrawal");
        require(stakeholdersIndex[msg.sender] > 0, "Not a stakeholder");

        stakeholders.length > 0;
        stakeholdersIndex[msg.sender] >= stakedAmount;
        //withdraw(msg.sender, this.balance);

        address payable recipent = payable(msg.sender);
        uint value = stakeholdersIndex[msg.sender];

        recipent.transfer(value);


       // emit Withdrawal RewardClaim (msg.sender, msg.value + Reward);
    //stakeholdersIndex[recipent] = 0;
    }

    function getstakeholdersIndex(address stakeholdersAddress) public view returns (uint256) {
        return stakeholdersIndex[stakeholdersAddress];
    }

    function getStakeholders(uint256 index) public view returns (address) {
        return stakeholders[index];
    }

    function getStakeholder() public view returns (address payable[] memory) {
        return stakeholders;
    }

    function isStakeholder(address stakeholdersAddress) public view returns (bool) {
        return stakeholder[stakeholdersAddress];
    }

    function getBalance() public view returns(uint) {
        //require(msg.sender == manager);
        return address(this).balance;
    }

}
