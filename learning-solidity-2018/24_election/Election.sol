/*
based on Ballot from http://solidity.readthedocs.io/en/v0.4.24/solidity-by-example.html
*/
pragma solidity ^0.4.24;

contract Election {
    // This declares a new complex type which will
    // be used for variables later.
    // It will represent a single voter.
    struct Voter {
        uint weight;
        bool voted;  // if true, that person already voted
        uint vote;   // index of the voted candidate
    }

    // This is a type for a single candidate.
    struct Candidate {
        bytes32 name;   // short name (up to 32 bytes)
        address candidateAddress;
        uint voteCount; // number of accumulated votes
    }

    address public chairperson;

    // This declares a state variable that
    // stores a `Voter` struct for each possible address.
    mapping(address => Voter) public voters;

    // A dynamically-sized array of `Candidate` structs.
    Candidate[] public candidates;

    /// Create a new election to choose one of `candidateNames`.
    constructor(bytes32[] candidateNames, address[] candidateAddresses) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        // For each of the provided candidate names,
        // create a new candidate object and add it
        // to the end of the array.
        for (uint i = 0; i < candidateNames.length; i++) {
            // `Candidate({...})` creates a temporary
            // Candidate object and `candidates.push(...)`
            // appends it to the end of `candidates`.
            candidates.push(Candidate({
                name: candidateNames[i],
                candidateAddress: candidateAddresses[i],
                voteCount: 0
            }));
        }
    }

    // Give `voter` the right to vote on this election.
    // May only be called by `chairperson`.
    function giveRightToVote(address voter) public {
        // If the first argument of `require` evaluates
        // to `false`, execution terminates and all
        // changes to the state and to Ether balances
        // are reverted.
        // This used to consume all gas in old EVM versions, but
        // not anymore.
        // It is often a good idea to use `require` to check if
        // functions are called correctly.
        // As a second argument, you can also provide an
        // explanation about what went wrong.
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    function vote(uint candidate) public {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "Already voted.");
        require(msg.sender != candidates[candidate].candidateAddress, "Can't vote on yourself");
        sender.voted = true;
        sender.vote = candidate;

        // If `candidate` is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        candidates[candidate].voteCount += sender.weight;
    }

    function getVoteCount(uint candidateIndex) public view returns(uint) {
        return candidates[candidateIndex].voteCount;
    }

    function winningCandidate() public view returns (uint winningCandidate_) {
        uint winningVoteCount = 0;
        for (uint p = 0; p < candidates.length; p++) {
            if (candidates[p].voteCount > winningVoteCount) {
                winningVoteCount = candidates[p].voteCount;
                winningCandidate_ = p;
            }
        }
    }

    // Calls winningCandidate() function to get the index
    // of the winner contained in the candidates array and then
    // returns the name of the winner
    function winnerName() public view
            returns (bytes32 winnerName_)
    {
        winnerName_ = candidates[winningCandidate()].name;
    }
}