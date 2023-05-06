// SPDX-License-Identifier: MIT

/**
Implement a crowd funding contract.

User creates a campaign to raise funds, setting start time, end time and goal (amount to raise).

Other users can pledge to the campaign. This will transfer tokens into the contract.

If the goal is reached before the campaign ends, the campaign is successful. Campaign creator can claim the funds.

Otherwise, the goal was not reached in time, users can withdraw their pledge.

https://www.youtube.com/watch?v=P-4ucHdjGpU

*/

pragma solidity ^0.8.17;

contract CrowdFund {
    event Launch(
        uint id,
        address indexed creator,
        uint goal,
        uint32 startAt,
        uint32 endAt
    );
    event Cancel(uint id);
    event Pledge(uint indexed id, address indexed caller, uint amount);
    event Unpledge(uint indexed id, address indexed caller, uint amount);
    event Claim(uint id);
    event Refund(uint id, address indexed caller, uint amount);

    struct Campaign {
        // Creator of campaign
        address creator;
        // Amount of tokens to raise
        uint goal;
        // Total amount pledged
        uint pledged;
        // Timestamp of start of campaign
        uint32 startAt;
        // Timestamp of end of campaign
        uint32 endAt;
        // True if goal was reached and creator has claimed the tokens.
        bool claimed;
    }

    IERC20 public immutable token;
    // Total count of campaigns created.
    // It is also used to generate id for new campaigns.
    uint public count;
    // Mapping from id to Campaign
    mapping(uint => Campaign) public campaigns;
    // Mapping from campaign id => pledger => amount pledged
    mapping(uint => mapping(address => uint)) public pledgedAmount;

    constructor(address _token) {
        token = IERC20(_token);
    }
    
    modifier onlyCreator(uint _id) {
        require(campaigns[_id].creator == msg.sender, "You're not creator of this campaign");
        _;
    }

    function launch(uint _goal, uint32 _startAt, uint32 _endAt) external {
        uint periodTime = block.timestamp + 7776000;
        require(_startAt >= block.timestamp, "Campaign was start");
        require(_startAt <= _endAt, "start date invalid");
        require(_endAt <= periodTime, "end date should be less than 90 days");
        count++;
        uint campaignId = count;
    
        campaigns[campaignId] = Campaign({
            creator: msg.sender,
            goal: _goal,
            pledged: 0,
            startAt: _startAt,
            endAt: _endAt,
            claimed: false
        });
        emit Launch(campaignId, msg.sender, _goal, _startAt, _endAt);
    }

    function cancel(uint _id) external onlyCreator(_id) {
        require(campaigns[_id].startAt > block.timestamp, "Campaign has started");
    
        delete campaigns[_id];

        emit Cancel(_id);
    }

    function pledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(campaign.startAt < block.timestamp, "campaign has not yet started");
        require(campaign.endAt > block.timestamp, "campaign was end");
        
        campaign.pledged += _amount;
        pledgedAmount[_id][msg.sender] += _amount;
        token.transferFrom(msg.sender, address(this), _amount);

        emit Pledge(_id, msg.sender, _amount);
    }

    function unpledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(campaign.endAt > block.timestamp, "campaign was end");

        campaign.pledged -= _amount;
        pledgedAmount[_id][msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);
        
        emit Unpledge(_id, msg.sender, _amount);
    }

    function claim(uint _id) external onlyCreator(_id) {
        Campaign storage campaign = campaigns[_id];
        require(campaign.endAt < block.timestamp, "campaign has not ended");
        require(campaign.pledged >= campaign.goal, "campaign has not ended");
        require(!campaign.claimed, "campaign was claim");
    
        campaign.claimed = true;
        token.transfer(campaign.creator, campaign.pledged);
        
        emit Claim(_id);
    }

    function refund(uint _id) external {
        Campaign memory campaign = campaigns[_id];
        require(block.timestamp > campaign.endAt, "not ended");
        require(campaign.pledged < campaign.goal, "pledged >= goal");
    
        uint bal = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0;
        token.transfer(msg.sender, bal);
    
        emit Refund(_id, msg.sender, bal);
    }
}
