const RouteManager = artifacts.require("RouteManager");

contract('Route Manager', async (accounts) => {
    let instance;

    beforeEach(async () => {
        instance = await RouteManager.deployed();
    });

    describe('constructor', async () => {
        it("sets owner address", async () => {
            let ownerAddress = await instance.owner.call();
            assert.equal(ownerAddress, accounts[0]);
        });
    });

    describe('addStop', async () => {
        let id = 0x7369656d;
        let name = 0x7369656d6b610000000000000000000000000000000000000000000000000000; 
        let latitude = 0x7369656d6b6100000000; 
        let longitude = 0x7369656d6b6100000000;

        describe('as owner', async () => {
            it("adds new stop to the list", async () => {
                await instance.addStop(id, name, latitude, longitude);
                // you can display values in the console - useful when writing/modifying tests
                console.log("ID: ", id); 
                
                assert.equal(await instance.getStopId(0), id);    
                assert.equal(await instance.getStopCount(), 1); 
            });
        });

        describe('as not owner', async () => {
            it("adds new stop to the list", async () => {
                try {
                    await instance.addStop(id, name, latitude, longitude, { from: accounts[1] });
                    assert.fail();
                } catch (err) {
                    assert.ok(/revert/.test(err.message));
                }
            });
        });
    });
});