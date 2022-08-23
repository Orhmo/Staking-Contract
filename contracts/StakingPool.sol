/* //SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.9.0;

import "hardhat/console.sol";
import "openzeppelin-solidity/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract Staking {

    address payable[] private stakeholders;
    address public manager;

    using SafeMath for uint256;

   //Stake variables
    mapping(address=>bool) public stakeholder;
    mapping(address=>uint256) public stakeholdersIndex;
    mapping(address => uint256) public balances;

    //uint256 private immutable i_stakingFee;
    uint256 public stakedAmount;
    uint256 public stakerCount;
    uint256 public totalRewards;
    uint256 public constant STAKETIME = 60;
    uint256 public constant THRESHOLD = 1 ether;

   /* Events
    event Stakers(address indexed stakeholder);
    event Staked(address indexed stakeholder, uint256 stake);
    event Unstaked(address indexed stakeholder, uint256 stakedAmount);
    event RewardClaim(uint256 indexed rewards);
    event Withdrawal(address indexed stakeholder, uint256 indexed rewards, uint256 indexed stakedAmount);

   /*
    enum State {Started, Running, Ended, Canceled}
    enum PoolType {FLEXIBLE, LOCKED}
    State public staking;

    modifier restricted() {
        require(msg.sender == manager, "Only the manager can call this function");
        _;
    }

    modifier staker() {
        require(stakeholdersIndex[msg.sender] > 0, "Only a stakeholder can call this function");
        _;
    }

    modifier end() {
        require(block.timestamp >= STAKETIME, "Staking period has ended");
        _;
    }

    constructor() {
        //i_stakingFee = stakingFee;
        manager = msg.sender;
        staking = State.Running;
    }

   // _stake amount staked
    function stake(uint256 _stake) external payable end {
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

        emit Stakers(msg.sender);
        emit Staked(msg.sender, msg.value);
    }

    function unstake() external payable staker end {
        require(stakeholdersIndex[msg.sender] > 0, "No  stakes available");
        require(stakedAmount == 0, "Already unstaked");
        require(block.timestamp < STAKETIME, "Cannot terminate after stake");
        staking = (State.Canceled);
      // value = stakeholdersIndex[msg.sender];

        emit Unstaked(msg.sender, msg.value);
    }

    function reward(uint256 _reward) external payable staker end {
        require(block.timestamp >= STAKETIME && stakedAmount > THRESHOLD, "Staking period has not elapsed");
        require(stakeholdersIndex[msg.sender] > 0, "Unauthorized");
        if (stakedAmount != 0) {

            transferFrom(msg.sender, address(this), _reward);
            emit RewardClaim(_reward);
        }else {
            revert("No stake");
        }
    }

   //_stake amount to unstake
   // unstakes tokens and gets in return deposited amount + reward.
    function withdrawStake(uint256 _stake) external payable staker end {
        require(block.timestamp > STAKETIME && stakedAmount > THRESHOLD, "Staking period has not not elapsed");
       //require(block.timestamp > sendBlock, "Wait 1 minute for withdrawal");
        require(stakeholdersIndex[msg.sender] > 0, "Not a stakeholder");

        stakeholders.length > 0;
        stakeholdersIndex[msg.sender] >= stakedAmount;
        uint256 staked = stakeholdersIndex[msg.sender];
        address payable recipent = payable(msg.sender);

        if (block.timestamp >= STAKETIME) {
            stakeholdersIndex[msg.sender] = (stakeholdersIndex[msg.sender]).add(_stake);
            balances[msg.sender] = balances[msg.sender].sub(_stake);
            uint256 rewards = _getReward(msg.sender, _stake);

            stakeholdersIndex[msg.sender] = staked - _stake;
            stakedAmount = stakedAmount - _stake;

            uint256 withdrawAmount = _stake + rewards;
            transfer(msg.sender, withdrawAmount);


            emit Withdrawal(msg.sender, rewards, withdrawAmount);
            stakeholdersIndex[recipent] = 0;

        }  else {
            revert("Tokens are only available after correct time period has elapsed");
        }
    }

   /* View / Pure functions
    function getstakeholdersIndex(address stakeholdersAddress) external view returns (uint256) {
        return stakeholdersIndex[stakeholdersAddress];
    }

    function getStakeholders(uint256 index) external view returns (address) {
        return stakeholders[index];
    }

    function getStakeholder() external view returns (address payable[] memory) {
        return stakeholders;
    }

    function isStakeholder(address stakeholdersAddress)external view returns (bool) {
        return stakeholder[stakeholdersAddress];
    }

    function getBalance() external view returns(uint) {
       //require(msg.sender == manager);
        return address(this).balance;
    }
  /*  function getStakingFee() external view returns(uint256) {
        return i_stakingFee;
    }

    function getReward(address stakeholdersAddress, uint256 _stake) external view returns (uint256 rewards) {
        if (stakeholdersIndex[stakeholdersAddress] > 0) {
            rewards = _getReward(stakeholdersAddress, _stake);
        }
    }

    function transfer(address stakeholdersAddress, uint _stake) public returns(bool success) {
        require(balances[msg.sender] >= _stake);

        balances[stakeholdersAddress] += _stake;
        balances[msg.sender] -= _stake;
    }

    function _getReward(address stakeholdersAddress, uint256 _stake) internal view returns (uint256 rewards) {
        return (_stake * (totalRewards-stakeholdersIndex[stakeholdersAddress])) / 1e18;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _stake
    ) internal {
        transferFrom(_from, _to, _stake);
    }

}

*/
