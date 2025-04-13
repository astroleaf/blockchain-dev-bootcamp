// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract DecentralizedAutonomousOrganization {
    struct Proposal {
        uint id;
        string description;
        uint amount;
        address payable recipient;
        uint votes;
        uint end;
        bool isExecuted;
    }

    mapping(address => bool) private isInvestor;
    mapping(address => uint) public numOfShares;
    mapping(address => mapping(uint => bool)) public isVoted;
    address[] public investorsList;
    mapping(uint => Proposal) public proposals;
    uint public totalShares;
    uint public availableFunds;
    uint public contributionTimeEnd;
    uint public nextProposalId;
    uint public voteTime;
    uint public quorum;
    address public manager;

    constructor(uint _contributionTimeEnd, uint _voteTime, uint _quorum) {
        require(_quorum > 0 && _quorum < 100, "Invalid quorum value");
        contributionTimeEnd = block.timestamp + _contributionTimeEnd;
        voteTime = _voteTime;
        quorum = _quorum;
        manager = msg.sender;
    }

    modifier onlyInvestor() {
        require(isInvestor[msg.sender], "You are not an investor");
        _;
    }

    modifier onlyManager() {
        require(msg.sender == manager, "You are not the manager");
        _;
    }

    function contribute() public payable {
        require(block.timestamp <= contributionTimeEnd, "Contribution time has ended");
        require(msg.value > 0, "Contribution must be greater than 0");
        isInvestor[msg.sender] = true;
        numOfShares[msg.sender] += msg.value;
        totalShares += msg.value;
        availableFunds += msg.value;
        investorsList.push(msg.sender);
    }

    function redeemShare(uint amount) public onlyInvestor {
        require(numOfShares[msg.sender] >= amount, "Insufficient shares");
        require(availableFunds >= amount, "Insufficient funds");
        numOfShares[msg.sender] -= amount;
        if (numOfShares[msg.sender] == 0) {
            isInvestor[msg.sender] = false;
        }
        availableFunds -= amount;
        payable(msg.sender).transfer(amount);
    }

    function transferShare(uint amount, address to) public onlyInvestor {
        require(availableFunds >= amount, "Insufficient funds");
        require(numOfShares[msg.sender] >= amount, "Insufficient shares");
        numOfShares[msg.sender] -= amount;
        if (numOfShares[msg.sender] == 0) {
            isInvestor[msg.sender] = false;
        }
        numOfShares[to] += amount;
        isInvestor[to] = true;
        investorsList.push(to);
    }

    function createProposal(string calldata description, uint amount, address payable recipient) public onlyManager {
        require(availableFunds >= amount, "Insufficient funds");
        proposals[nextProposalId] = Proposal(nextProposalId, description, amount, recipient, 0, block.timestamp + voteTime, false);
        nextProposalId++;
    }

    function voteProposal(uint proposalId) public onlyInvestor {
        Proposal storage proposal = proposals[proposalId];
        require(!isVoted[msg.sender][proposalId], "You have already voted for this proposal");
        require(block.timestamp <= proposal.end, "Voting time has ended");
        require(!proposal.isExecuted, "Proposal has already been executed");
        isVoted[msg.sender][proposalId] = true;
        proposal.votes += numOfShares[msg.sender];
    }

    function executeProposal(uint proposalId) public onlyManager {
        Proposal storage proposal = proposals[proposalId];
        require((proposal.votes * 100 / totalShares) >= quorum, "Quorum not met");
        proposal.isExecuted = true;
        availableFunds -= proposal.amount;
        _transfer(proposal.recipient, proposal.amount);
    }

    function _transfer(address payable recipient, uint amount) private {
        recipient.transfer(amount);
    }

    function getProposals() public view returns (Proposal[] memory) {
        Proposal[] memory arr = new Proposal[](nextProposalId);
        for (uint i = 0; i < nextProposalId; i++) {
            arr[i] = proposals[i];
        }
        return arr;
    }

    function getInvestors() public view returns (address[] memory) {
        return investorsList;
    }
}
