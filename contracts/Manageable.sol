// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "poolz-helper-v2/contracts/GovManager.sol";

contract Manageable is GovManager {
    event NewWhiteList(uint _WhitelistId, address _creator, uint _changeUntil);

    modifier OnlyCreator(uint256 _Id) {
        require(
            WhitelistSettings[_Id].Creator == msg.sender,
            "Only creator can access"
        );
        _;
    }

    modifier TimeRemaining(uint256 _Id){
        require(
            block.timestamp < WhitelistSettings[_Id].ChangeUntil,
            "Time for edit is finished"
        );
        _;
    }

    modifier ValidateId(uint256 _Id){
        require(_Id < WhiteListCount, "Wrong ID");
        _;
    }

    struct WhiteListItem {
        address Creator;
        uint256 ChangeUntil;
        bool isReady; // defualt false | true after first address is added
    }

    mapping(uint256 => mapping(address => bool)) public WhitelistDB;
    mapping(uint256 => WhiteListItem) public WhitelistSettings;
    uint256 public WhiteListCount;
    uint256 public MainWhitelistId;

    function SetMainWhitelistId(uint256 _Id)
        external
        onlyOwnerOrGov
        ValidateId(_Id)
    {
        MainWhitelistId = _Id;
    }

    function _AddAddress(uint256 _Id, address user) internal {
        WhitelistDB[_Id][user] = true;
    }

    function _RemoveAddress(uint256 _Id, address user) internal {
        WhitelistDB[_Id][user] = false;
    }

    function IsPOZHolder(address _Sender) external view returns(bool){
        return WhitelistDB[MainWhitelistId][_Sender];
    }
}