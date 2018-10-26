pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "../../contracts/13_route_manager/RouteManager.sol";

contract RouteManagerTest {
    RouteManager instance;
    
    function beforeEach() public {
        instance = new RouteManager();
    } 
  
    function testSetOwner() public {
        Assert.equal(instance.owner(), address(this), "missing owner address");
    }

    function testAddStop() public {
        bytes4 id = 0x7369656d;
        bytes32 name = 0x7369656d6b610000000000000000000000000000000000000000000000000000; 
        bytes10 latitude = 0x7369656d6b6100000000; 
        bytes10 longitude = 0x7369656d6b6100000000;
        instance.addStop(id, name, latitude, longitude);
        Assert.equal(instance.getStopCount(), 1, "wrong stops number");
        Assert.equal(instance.getStopId(0), id, "wrong id");
    }
}