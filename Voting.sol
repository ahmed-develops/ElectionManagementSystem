// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Voting {

    struct Party {
        string partyName;
        string partyLeader;
    }

    address public administrator;
    uint public VotingStartTime;
    uint public VotingEndTime;
    mapping (address => bool) alreadyVoted;
    mapping (address => Party) voteToParty;

    constructor () payable {
        administrator = msg.sender;
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

    // function vote(string partyCandidate) hasNotVotedAlready public {
        
    // }
}


// contract BallotBox {
//     struct BallotBoxes {
//         string box_id;
//         uint32 number_of_votes;
//         string region;
//         string station_number;
//         string city;
//     }
//     mapping (string => BallotBoxes) public MAP_BallotBox;
//     mapping (string => uint) public MAP_station_number;

//     constructor (string memory region, string memory city) {
//         string memory box_id = string(abi.encodePacked(region,"_",city,));
//         BallotBoxes memory new_ballot_box = BallotBoxes(box_id, 0, region, MAP_station_number[city], city);
//     }

//     function viewAllBallotBoxByCity (string calldata city) public view returns (BallotBoxes memory) {
//         return MAP_BallotBox[city];
//     }
// }
