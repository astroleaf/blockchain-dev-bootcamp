// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract VotingSystem {
    address public electionCommission;
    address public winner;

    struct Voter {
        string name;
        uint age;
        uint voterId;
        string gender;
        uint voteCandidateId;
        address voterAddress;
    }

    struct Candidate {
        string name;
        string party;
        uint age;
        string gender;
        uint candidateId;
        address candidateAddress;
        uint votes;
    }

    bool public votingStopped = false;
    uint public startTime;
    uint public endTime;

    uint public nextVoterId = 1;
    uint public nextCandidateId = 1;

    mapping(uint => Voter) public voters;
    mapping(uint => Candidate) public candidates;
    mapping(uint => bool) public voteVerified;

    bool public votingPaused = false;
    mapping(uint => uint) public voterProxy; // Voter ID to Proxy Voter ID
    mapping(uint => uint) public voterWithdrawal; // Voter ID to Candidate ID for Withdrawal

    constructor() {
        electionCommission = msg.sender;
    }

    modifier isVotingOver() {
        require(block.timestamp > endTime || votingStopped == true, "Voting is not over");
        _;
    }

    modifier onlyCommissioner() {
        require(electionCommission == msg.sender, "Not from the election commission");
        _;
    }

    modifier isVotingAllowed() {
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Voting not allowed at this time");
        _;
    }

    modifier isVotingPaused() {
        require(votingPaused == true, "Voting is not paused");
        _;
    }

    function pauseVoting() external onlyCommissioner() {
        votingPaused = true;
    }

    function resumeVoting() external onlyCommissioner() {
        votingPaused = false;
    }

    function castVote(uint _voterId, uint _candidateId) external isVotingAllowed() {
        require(voters[_voterId].voteCandidateId == 0, "Already voted");
        require(voters[_voterId].voterAddress == msg.sender, "You are not a voter");
        require(votingPaused == false, "Voting is paused");
        require(_candidateId > 0 && _candidateId < nextCandidateId, "Invalid Candidate Id");

        voters[_voterId].voteCandidateId = _candidateId;
        candidates[_candidateId].votes++;

        // Mark the vote as unverified initially
        voteVerified[_voterId] = false;
    }

    function verifyVote(uint _voterId) external {
        require(voters[_voterId].voterAddress == msg.sender, "You are not the voter");
        require(voters[_voterId].voteCandidateId > 0, "No vote cast for this voter");
        require(voteVerified[_voterId] == false, "Vote already verified");

        // Mark the vote as verified
        voteVerified[_voterId] = true;
    }

    function designateProxy(uint _voterId, uint _proxyVoterId) external {
        require(voters[_voterId].voterAddress == msg.sender, "You are not the voter");
        require(voters[_voterId].voteCandidateId == 0, "Already voted");
        require(voters[_proxyVoterId].voterAddress != address(0), "Proxy voter does not exist");

        voterProxy[_voterId] = _proxyVoterId;
    }

    function requestWithdrawal(uint _voterId, uint _candidateId) external isVotingAllowed() {
        require(voters[_voterId].voterAddress == msg.sender, "You are not the voter");
        require(voters[_voterId].voteCandidateId == _candidateId, "You did not vote for this candidate");
        require(voterWithdrawal[_voterId] == 0, "Withdrawal request already submitted");
        require(candidates[_candidateId].votes > 0, "Candidate has no votes");

        voterWithdrawal[_voterId] = _candidateId;
    }

    function delegateVote(uint _voterId, uint _delegateVoterId) external {
        require(voters[_voterId].voterAddress == msg.sender, "You are not the voter");
        require(voters[_voterId].voteCandidateId == 0, "Already voted");
        require(voterProxy[_delegateVoterId] == _voterId, "Delegate voter has not designated you as a proxy");

        voters[_voterId].voteCandidateId = voters[_delegateVoterId].voteCandidateId;
        candidates[voters[_delegateVoterId].voteCandidateId].votes++;
    }

    function startVoting(uint _duration) external onlyCommissioner() {
        startTime = block.timestamp;
        endTime = startTime + _duration;
    }

    function stopVoting() external onlyCommissioner() {
        votingStopped = true;
    }

    function finalize() external onlyCommissioner() isVotingOver() {
        require(nextCandidateId > 1, "No candidates registered");

        uint maxVotes = 0;
        address currentWinner;

        for (uint i = 1; i < nextCandidateId; i++) {
            if (candidates[i].votes > maxVotes) {
                maxVotes = candidates[i].votes;
                currentWinner = candidates[i].candidateAddress;
                winner = currentWinner;
            }
        }
    }
}

