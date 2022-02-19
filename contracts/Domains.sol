// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import { StringUtils } from "./libraries/StringUtils.sol";
import "hardhat/console.sol";

contract Domains {

    string public tld;

    mapping(string => address) domains;
    mapping(address => string) inverseDomain;
    mapping(string => Record) records;

    struct Record {
        string nickname;
        string spotifyLink;
        string twitter;
    }

    constructor(string memory _tld) payable {
        tld = _tld;
        console.log(".%s domain service contract deployed", _tld);
    }

      // This function will give us the price of a domain based on length
    function price(string calldata name) public pure returns(uint) {
        uint len = StringUtils.strlen(name);
        require(len > 0, "Domain can't be blank");
        if (len == 3) {
            return 5 * 10**17; // 5 MATIC = 5 000 000 000 000 000 000 (18 decimals). We're going with 0.5 Matic cause the faucets don't give a lot
        } else if (len == 4) {
            return 3 * 10**17; // To charge smaller amounts, reduce the decimals. This is 0.3
        } else {
            return 1 * 10**17;
        }
    }

    function register(string calldata _name) public payable{
        require(domains[_name] == address(0), "Domain is already registered");

        uint _price = price(_name);

        // Check if enough Matic was paid in the transaction
        require(msg.value >= _price, "Not enough MATIC paid");
        
        domains[_name] = msg.sender;
        inverseDomain[msg.sender] = _name;
        records[_name] = Record('','','');

        console.log("%s has registered the domain %s.%s", msg.sender, _name, tld);
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
