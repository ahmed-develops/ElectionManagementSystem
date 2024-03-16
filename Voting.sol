// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Voting {
    struct Party {
        string partyId;
        string partyName;
        string partyLeader;
        Candidate[] candidates;
        uint8 numberOfCandidates;
    }

    struct Candidate {
        string candidateName;
        address candidateId;
    }

    struct Voter {
        string voterName;
        address voterId;
    }

    address public administrator;
    uint public VotingStartTime;
    uint public VotingEndTime;
    mapping (address => bool) public alreadyVoted;
    mapping (address => Party) public voteToParty;
    mapping (string => Party) public MAP_PartyDetails;

    constructor () payable {
        administrator = msg.sender;   
    }

    function addParty(string calldata _partyId, string calldata _partyName, string calldata _partyLeader) public {
        Party storage newParty = MAP_PartyDetails[_partyId];
        newParty.partyId = _partyId;
        newParty.partyName = _partyName;
        newParty.partyLeader = _partyLeader;
    }

    function addCandidateToParty(string calldata _partyId, string calldata _candidateName, address _candidateId) public {
        Party storage party = MAP_PartyDetails[_partyId];
        party.candidates.push(Candidate(_candidateName, _candidateId));
        party.numberOfCandidates++;
    }

    modifier adminOnly {
        require (msg.sender == administrator, "You do not have sufficient privileges to start voting.");
        _;
    }

    modifier timeEndedOrNot {
        require (block.timestamp < VotingEndTime, "Voting time has ended.");
        _;
    }

    modifier hasNotVotedAlready(address voter_address) {
        require (alreadyVoted[voter_address] == false, "You have already put in your vote.");
        _;
    }

    event votingStarted (address indexed invoker, uint startTime, uint endTime);
    event votingEnded (uint endTime);

    function startVoting () adminOnly public {
        VotingStartTime = block.timestamp;
        VotingEndTime = VotingStartTime + 1 days;
        emit votingStarted (msg.sender, VotingStartTime, VotingEndTime);
    }

    function endVoting () adminOnly public {
        require (VotingEndTime > 0 && VotingStartTime > 0, "Voting has not started, yet.");
        require (block.timestamp >= VotingEndTime, "There is still some time left for voting to end.");
        emit votingEnded(block.timestamp);
    }

    function getPartyById (string calldata _partyId) public view returns (Party memory) {
        return MAP_PartyDetails[_partyId];
    }

    function getCandidatesByPartyId (string calldata _partyId) public view returns (Candidate[] memory) {
        return MAP_PartyDetails[_partyId].candidates;
    }
}