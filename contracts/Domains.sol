// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import { StringUtils } from "./libraries/StringUtils.sol";
import { Base64 } from "./libraries/Base64.sol";

import "hardhat/console.sol";

contract Domains is ERC721URIStorage {

    string public tld;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // We'll be storing our NFT images on chain as SVGs
    string svgPartOne = '<svg xmlns="http://www.w3.org/2000/svg" width="270" height="270" fill="none"><path fill="url(#a)" d="M0 0h270v270H0z"/><defs><filter id="b" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse" height="270" width="270"><feDropShadow dx="0" dy="1" stdDeviation="2" flood-opacity=".225" width="200%" height="200%"/></filter></defs><g transform="translate(20 25)"><g fill="#ff9d27"><path d="M10.9 48.7c4-4 4.4-5 6.9-2.5s1.5 2.8-2.5 6.9c-3 3-6.8 2.4-6.8 2.4s-.6-3.8 2.4-6.8"/><path d="M18.5 52.8c1.6-4.2 2.1-4.7-.2-6-2.3-1.3-2.3-.4-3.8 3.8-1.2 3.1.2 5.9.2 5.9s2.7-.5 3.8-3.7"/></g><path d="M16.2 48.9c.9-2.3.9-2.8 2.1-2.1 1.3.7 1 1 .1 3.3-.6 1.7-2.1 2.1-2.1 2.1s-.7-1.5-.1-3.3" fill="#fdf516"/><path d="M17.1 45.7c-1.3-2.3-1.8-1.8-6-.2-3.1 1.2-3.7 3.8-3.7 3.8s2.8 1.4 5.9.2c4.2-1.6 5.1-1.6 3.8-3.8" fill="#ff9d27"/><g fill="#fdf516"><path d="M15 47.8c2.3-.9 2.8-.9 2.1-2.1-.7-1.3-1-1-3.3-.1-1.7.6-2.1 2.1-2.1 2.1s1.6.7 3.3.1"/><path d="M13.9 47.6c2.2-2.2 2.4-2.8 3.8-1.4s.8 1.6-1.4 3.8c-1.7 1.7-3.8 1.3-3.8 1.3s-.2-2 1.4-3.7"/></g><path d="M18.5 38C12.3 27.6 2 31.9 2 31.9s14.7-14.7 24.6-4.8L18.5 38z" fill="#3baacf"/><path d="m23.3 30.3 3.2-3.2C16.7 17.2 2 31.9 2 31.9s12.9-9.2 21.3-1.6" fill="#428bc1"/><path d="M26 45.5C36.4 51.7 32.1 62 32.1 62s14.7-14.7 4.8-24.6L26 45.5z" fill="#3baacf"/><path d="m33.7 40.7 3.2-3.2c9.9 9.9-4.8 24.6-4.8 24.6s9.2-13 1.6-21.4" fill="#428bc1"/><path d="M48.8 30.9C37.1 42.5 24.2 48.8 19.7 44.3c-4.5-4.5 1.8-17.4 13.4-29.1 13.6-13.6 28.7-13 28.7-13s.5 15.1-13 28.7" fill="#c5d0d8"/><path d="M45.8 27.6C34.2 39.2 22.6 46.8 19.9 44.1c-2.7-2.7 4.9-14.3 16.5-25.9C50 4.6 62 2 62 2s-2.6 12-16.2 25.6z" fill="#dae3ea"/><path d="M24.3 47.5c-.5.5-1.3.5-1.8 0l-6-6c-.5-.5-.5-1.4 0-1.9l1.8-1.8 7.8 7.8-1.8 1.9" fill="#c94747"/><path d="M22.6 45.7c-.5.5-1.1.7-1.4.4l-3.4-3.4c-.3-.3-.1-.9.4-1.4l1.8-1.8 4.4 4.4-1.8 1.8" fill="#f15744"/><path d="M20.9 48.2c-.3.3-1 .3-1.3 0l-3.9-3.9c-.3-.3-.2-.9.1-1.2l1.2-1.2 5.1 5.1-1.2 1.2" fill="#3e4347"/><path d="M20.1 47.4c-.3.3-.9.4-1.1.2l-2.7-2.7c-.2-.2-.1-.7.3-1l1.2-1.2 3.5 3.5-1.2 1.2" fill="#62727a"/><path d="M61.8 2.2S56.4 2 49.1 4.8l10.1 10.1C62 7.6 61.8 2.2 61.8 2.2" fill="#c94747"/><path d="M61.8 2.2s-4.3.9-10.8 4.6l6.2 6.2c3.7-6.5 4.6-10.8 4.6-10.8" fill="#f15744"/><circle cx="43.5" cy="20.5" r="5" fill="#edf4f9"/><circle cx="43.5" cy="20.5" r="3.3" fill="#3baacf"/><circle cx="33.5" cy="30.5" r="5" fill="#edf4f9"/><circle cx="33.5" cy="30.5" r="3.3" fill="#3baacf"/><g fill="#fff"><path d="M48.9 6.9c-.3.3-.9.3-1.2 0-.3-.3-.3-.9 0-1.2.3-.3.9-.3 1.2 0 .3.3.3.9 0 1.2"/><circle cx="50.6" cy="8.6" r=".8"/><circle cx="53" cy="11" r=".8"/><circle cx="55.3" cy="13.4" r=".8"/><circle cx="57.7" cy="15.7" r=".8"/></g></g><defs><linearGradient id="a" x1="0" y1="0" x2="270" y2="270" gradientUnits="userSpaceOnUse"><stop stop-color="#111ddf"/><stop offset="1" stop-color="#0cd7e4" stop-opacity=".99"/></linearGradient></defs><text x="32.5" y="231" font-size="27" fill="#fff" filter="url(#b)" font-family="Plus Jakarta Sans,DejaVu Sans,Noto Color Emoji,Apple Color Emoji,sans-serif" font-weight="bold">';
    string svgPartTwo = '</text></svg>';

    mapping(string => address) domains;
    mapping(string => Record) records;
    mapping(string => uint256) domainToNftId;

    struct Record {
        string nickname;
        string spotifyLink;
        string twitter;
    }

    constructor(string memory _tld) payable ERC721("Ibis Name Service", "INS"){
        tld = _tld;
        console.log(".%s domain service contract deployed", _tld);
    }

      // This function will give us the price of a domain based on length
    function price(string calldata name) public pure returns(uint) {
        uint len = StringUtils.strlen(name);
        require(len > 0, "Domain can't be blank");
        if (len <= 3) {
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

        //Increment then get id, so tokenId 0 does not get minted
        _tokenIds.increment();
        
        //build SVG

        string memory finalName = string(abi.encodePacked(_name, ".", tld));
        string memory finalSvg = string(abi.encodePacked(svgPartOne, finalName, svgPartTwo));
        uint256 newRecordId = _tokenIds.current();
        uint256 length = StringUtils.strlen(finalName);
        string memory strLen = Strings.toString(length);

        string memory json = Base64.encode(
            bytes(
            string(
                abi.encodePacked(
                '{"name": "',
                finalName,
                '", "description": "A domain on the Ibis name service", "image": "data:image/svg+xml;base64,',
                Base64.encode(bytes(finalSvg)),
                '","length":"',
                strLen,
                '"}'
                )
            )
            )
        );

        string memory finalTokenUri = string( abi.encodePacked("data:application/json;base64,", json));
                
        console.log("\n--------------------------------------------------------");
        console.log("Final tokenURI", finalTokenUri);
        console.log("--------------------------------------------------------\n");

        //mint NFT

        _safeMint(msg.sender, newRecordId);
        _setTokenURI(newRecordId, finalTokenUri);
        domains[_name] = msg.sender;
        records[_name] = Record('','','');
        domainToNftId[_name] = newRecordId;

        console.log("%s has registered the domain %s with token ID %d", msg.sender, finalName, newRecordId);
    }

    function getAddress(string calldata _name) public view returns (address) {
        return domains[_name];
    }

    function getNftId(string calldata _name) public view returns (uint){
        return domainToNftId[_name];
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
