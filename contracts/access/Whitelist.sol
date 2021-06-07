// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Whitelist
 * @author Alberto Cuesta Canada
 * @dev Implements a simple whitelist of addresses for the Owner Group.
 * @notice This contract has three functions:
 *  isMember        => Member in the list.
 *  addMember       => Add Member on the list, who inherited from functions of contract Ownable of Openzepellin.
 *  removeMember    => Remove Member of the list, who inherited from functions of contract Ownable of Openzepellin.
 */
contract Whitelist is Ownable {
    mapping(address => bool) private _members;

    event MemberAdded(address member);
    event MemberRemoved(address member);

    /**
     * @dev The contract constructor.
     */
    constructor() Ownable() {}

    /**
     * @dev A method to verify whether an address is a member of the whitelist
     * @param _member The address to verify.
     * @return Whether the address is a member of the whitelist.
     */
    function isMember(address _member) public view returns (bool) {
        return _members[_member];
    }

    /**
     * @dev A method to add a member to the whitelist
     * @param _member The member to add as a member.
     */
    function addMember(address _member) public onlyOwner {
        require(!isMember(_member), "Address is member already.");

        _members[_member] = true;
        emit MemberAdded(_member);
    }

    /**
     * @dev A method to remove a member from the whitelist
     * @param _member The member to remove as a member.
     */
    function removeMember(address _member) public onlyOwner {
        require(isMember(_member), "Not member of whitelist.");

        delete _members[_member];
        emit MemberRemoved(_member);
    }
}
