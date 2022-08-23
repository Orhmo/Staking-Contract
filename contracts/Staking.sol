//SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.9.0;

import "hardhat/console.sol";
import "openzeppelin/contracts/utils/math/SafeMath.sol";
import "openzeppelin/contracts/token/ERC20/ERC20.sol";

import "./Token.sol";


contract Staking is ERC20 {
    address public manager;
    address payable public stake;

    struct Stake {
        uint256 amount; // The stake amount
        uint256 reward; //Stake reward
        uint256 deposited;
        uint256 currentTimeStamp;
    }

    uint tokenPrice = 0.01 ether;
    uint public hardCap = 500 ether;
    uint256 public totalStaked; //Total stake
    uint256 public totalRewards; //Total rewards
    uint256 public constant STAKETIME = 60;// Staking period
    uint256 public constant THRESHOLD = 1 ether; //Minimum amount to stake

    //Mapping of stakers info
    address payable[] internal stakeholders;
    uint256 internal currentTimeStamp= block.timestamp;

    //The stake for each Stakeholder
    mapping(address=>bool) public stakeholder;
    mapping(address=>Stake) public stakers;

    mapping(address => uint256) public balances;

    //rewards
    mapping(address => uint256) private rewards;

    //Events
    event Staked(address indexed staker, uint256 amount, uint token);
    event Staked(address indexed staker, uint256 stake);
    event Unstaked(address indexed staker, uint256 amount);
    event RewardClaim(address indexed staker, uint256 indexed reward);
    event TransferRecieved(address _from, uint _amount);
    event TransferSent(address _from, address _destAddr, uint _amount);
    event Withdrawal(address indexed staker, uint256 indexed reward, uint256 indexed stakedAmount);

    //modifiers
    modifier restricted() {
        require(msg.sender == manager, "Only the manager can call this function");
        _;
    }

    modifier staker() {
        require(stakers[msg.sender] > 0, "Only a stakeholder can call this function");
        _;
    }

    modifier end() {
        require(block.timestamp >= STAKETIME, "Staking period has ended");
        _;
    }

//constructor function.
    constructor(address payable _stake) ERC20("DanaToken", "DT") {
        manager = msg.sender;
        stake = _stake;
    }

    function createStake (uint256 _amount) external payable returns(bool) {
        require(_amount >= THRESHOLD, "Minimum stake is 1 ether");
        require(
        balanceOf(msg.sender) >= _amount, "Can't stake more than you own");

        if (_amount >= THRESHOLD) {
            stakers[msg.sender].deposited = _amount;
            stakers[msg.sender].currentTimeStamp = block.timestamp;
            stakers[msg.sender].reward = 0;

            totalStaked += _amount;
            uint token = _amount / tokenPrice;

            stakers[msg.sender] = true;
            stakerCount++;

            balances[msg.sender] += tokens;
            balances[manager] -= tokens;
            stake.transfer(_amount);
            rewards[msg.sender] = totalRewards;
        }
        emit Staked(msg.sender, _amount, tokens);
        return true;
    }

    function unstake() external payable staker {
        require(stakers[msg.sender] > 0, "No  stakes available");
        require(totalStaked == 0, "Already unstaked");
        require(block.timestamp < STAKETIME, "Cannot terminate after stake");

        emit Unstaked(msg.sender, msg.value);
    }

    function claimReward(uint256 _reward) external payable staker end {
        require(block.timestamp >= STAKETIME && totalStaked > THRESHOLD, "Staking period has not elapsed");
        require(stakersIndex[msg.sender] > 0, "Unauthorized");
        if (totalStaked != 0) {
            totalRewards = totalRewards + ((_reward * 1e18) / totalStaked);
            transferFrom(msg.sender, address(this), _reward);
            emit RewardClaim(_reward);
        }else {
            revert("No stake");
        }
    }

    //_stake amount to unstake
    // unstakes tokens and gets in return deposited amount + reward.
    function withdrawStake(uint256 _amount) external payable staker end {
        require(block.timestamp > STAKETIME && totalStaked > THRESHOLD, "Staking period has not not elapsed");
        require(stakers[msg.sender] > 0, "Not a stakeholder");

        stake.length > 0;
        stakers[msg.sender] >= totalStaked;
        uint256 staked = stakers[msg.sender];
        address payable recipent = payable(msg.sender);

        if (block.timestamp >= STAKETIME) {
            stakers[msg.sender] = (stakers[msg.sender]).add(_amount);
            balances[msg.sender] = balances[msg.sender].sub(_amount);
            uint256 rewards = _getReward(msg.sender, _amount);

            stakers[msg.sender] = stakedAmount - _amount;
            stakedAmount = stakedAmount - _amount;

            uint256 withdrawAmount = _amount + rewards;
            token.transfer(msg.sender, withdrawAmount);


            emit Withdrawal(msg.sender, rewards, withdrawAmount);
            stakers[recipent] = 0;

        }  else {
            revert("Tokens are only available after correct time period has elapsed");
        }
    }

    /* View / Pure functions*/
    function getstakeholdersIndex(address stakeholdersAddress) external view returns (uint256) {
        return stakers[stakeholdersAddress];
    }

    function getStakeholders(uint256 index) external view returns (address) {
        return stake[index];
    }

    function getStakeholder() external view returns (address payable[] memory) {
        return stake;
    }

    function isStakeholder(address stakeholdersAddress)external view returns (bool) {
        return stakeholder[stakeholdersAddress];
    }

    function getBalance() external view returns(uint) {
        return address(this).balance;
    }
    /*  function getStakingFee() external view returns(uint256) {
         return i_stakingFee;
     }*/

    function getReward(address stakeholdersAddress, uint256 _amount) external view returns (uint256 reward) {
        if (stakers[stakeholdersAddress] > 0) {
            rewards = _getReward(stakeholdersAddress, _amount);
        }
    }

    function _getReward(address stakeholdersAddress, uint256 _amount) internal view returns (uint256) {
        return (_amount * (totalRewards - rewards[stakeholdersAddress])) / 1e18;
    }

}
