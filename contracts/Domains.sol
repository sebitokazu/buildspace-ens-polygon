// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "hardhat/console.sol";

contract Domains {
    mapping(string => address) domains;
    mapping(address => string) inverseDomain;
    mapping(string => Record) records;

    struct Record {
        string nickname;
        string spotifyLink;
        string twitter;
    }

    constructor() {
        console.log("IBIS domains");
    }

    function register(string calldata _name) public {
        require(domains[_name] == address(0), "Domain is already registered");
        require(keccak256(abi.encodePacked(_name)) != keccak256(abi.encodePacked("")), "Domain can't be blank");
        domains[_name] = msg.sender;
        inverseDomain[msg.sender] = _name;
        records[_name] = Record('','','');

        console.log("%s has registered the domain %s", msg.sender, _name);
    }

    function getAddress(string calldata _name) public view returns (address) {
        return domains[_name];
    }

    function getDomain(address _address) public view returns (string memory){
        return inverseDomain[_address];
    }

    function getRecord(string calldata _name) view public returns (Record memory) {
        return records[_name];
    }

    function setAllRecords(string calldata _name, string calldata _nickname, string calldata _spotifyLink, string calldata _twitter) public{
        require(domains[_name] == msg.sender, "You're not the owner of the domain");
        records[_name].nickname = _nickname;
        records[_name].spotifyLink = _spotifyLink;
        records[_name].twitter = _twitter;

        console.log("Setting nickname record to %s for domain %s", _nickname, _name);
        console.log("Setting Spotify Link record to %s for domain %s", _spotifyLink, _name);
        console.log("Setting Twitter record to %s for domain %s", _twitter, _name);
    }
    
    function setNickname(string calldata _name, string calldata _nickname) public {
        require(domains[_name] == msg.sender, "You're not the owner of the domain");
        records[_name].nickname = _nickname;

        console.log("Setting nickname record to %s for domain %s", _nickname, _name);
    }

    function setSpotifyLink(string calldata _name, string calldata _spotifyLink) public {
        require(domains[_name] == msg.sender, "You're not the owner of the domain");
        records[_name].spotifyLink = _spotifyLink;

        console.log("Setting Spotify Link record to %s for domain %s", _spotifyLink, _name);
    }

    function setTwitter(string calldata _name, string calldata _twitter) public {
        require(domains[_name] == msg.sender, "You're not the owner of the domain");
        records[_name].twitter = _twitter;

        console.log("Setting Twitter record to %s for domain %s", _twitter, _name);
    }
}
