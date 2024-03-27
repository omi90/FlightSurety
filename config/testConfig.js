
var FlightSuretyApp = artifacts.require("FlightSuretyApp");
var FlightSuretyData = artifacts.require("FlightSuretyData");
var BigNumber = require('bignumber.js');

var Config = async function(accounts) {
    
    // These test addresses are useful when you need to add
    // multiple users in test scripts
    let testAddresses = [
        "0x584f689397FC7242d2e8c653a4605830c4041015",
        "0x90fa307C76c8AEd2501c0ebFc278B38ED6b1e6Aa",
        "0x7f1AF0Ef654Ba05B7eb975CCfCf21638b091b9b7",
        "0x7b5de76BbD88D0Cd2a0dF9Ff1331dA164Af3d25C",
        "0x3e10c3028E9876482f4FF75b3b3A3b9358fa3595",
        "0xdA9F4f881309B69C6B5D39367Fc10Be93077d928",
        "0x5D6150B0C80E377895a9a439E6850fd1265165b7",
        "0x5E9cD61ceA1C75AF14497F4E749e675e9645A57C",
        "0x20Df0c7B1Ca6F0E7271CA01FbEa49E61e8c5b08b"
    ];


    let owner = accounts[0];
    let firstAirline = accounts[1];

    let flightSuretyData = await FlightSuretyData.new();
    let flightSuretyApp = await FlightSuretyApp.new(FlightSuretyData.address, firstAirline);
    //let flightSuretyApp = await FlightSuretyApp.new();

    
    return {
        owner: owner,
        firstAirline: firstAirline,
        weiMultiple: (new BigNumber(10)).pow(18),
        testAddresses: testAddresses,
        flightSuretyData: flightSuretyData,
        flightSuretyApp: flightSuretyApp
    }
}

module.exports = {
    Config: Config
};