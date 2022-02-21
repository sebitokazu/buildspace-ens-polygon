const { expect } = require("chai");

describe('Polygon domain service', () => {

    const setup = async({ tld = 'ibis' }) =>{
        const [owner, randomPerson] = await hre.ethers.getSigners();
        const domainContractFactory = await hre.ethers.getContractFactory("Domains");
        const deployedContract = await domainContractFactory.deploy(tld);
        await deployedContract.deployed();

        return {
            owner,
            deployedContract,
            randomPerson
        };
    }

    describe('Deployment', () =>{
        it('Set top level domain on constructor', async () =>{
            const tld = 'arg';

            const { deployedContract } = await setup({ tld });

            const returnedTld = await deployedContract.tld();

            expect(returnedTld).to.be.equal(tld, "TLD is not being set correctly");
        });
    })

    describe('Domain price', () =>{
        it('Checks that price for 3 or less characters domain is 0.5 MATIC', async() =>{
            const { owner, deployedContract } = await setup({});

            const domainA = 'A';
            const domainB = 'dev';

            const priceA = await deployedContract.price(domainA);
            const priceB = await deployedContract.price(domainB);
            
            expect(priceA).to.be.equal(hre.ethers.utils.parseEther('0.5'), "3 or less characters domain should cost 0.5 MATIC");
            expect(priceB).to.be.equal(hre.ethers.utils.parseEther('0.5'), "3 or less characters domain should cost 0.5 MATIC");
        });

        it('Checks that price for 4 characters domain is 0.3 MATIC', async() =>{
            const { owner, deployedContract } = await setup({});

            const domain = 'cool';

            const price = await deployedContract.price(domain);
            
            expect(price).to.be.equal(hre.ethers.utils.parseEther('0.3'), "4 characters domain should cost 0.3 MATIC");
        });

        it('Checks that price for 5 or more characters domain is 0.1 MATIC', async() =>{
            const { owner, deployedContract } = await setup({});

            const domainA = 'matic';
            const domainB = 'software';

            const priceA = await deployedContract.price(domainA);
            const priceB = await deployedContract.price(domainB);
            
            expect(priceA).to.be.equal(hre.ethers.utils.parseEther('0.1'), "5 or more characaters domain should cost 0.1 MATIC");
            expect(priceB).to.be.equal(hre.ethers.utils.parseEther('0.1'), "5 or more characaters domain should cost 0.1 MATIC");
        });
    });

    describe('Register', () => {

        it('Register blank domain should fail', async() => {
            const { deployedContract, randomPerson } = await setup({});

            const domain = '';

            expect(deployedContract.register(domain,{ value: hre.ethers.utils.parseEther('0.1')})).to.be.revertedWith("Domain can't be blank");
        });


        it('Register "messi.ibis" domain', async() => {
            const { deployedContract, randomPerson } = await setup({});

            const domain = 'messi';

            await deployedContract.connect(randomPerson).register(domain,{ value: hre.ethers.utils.parseEther('0.1')});
            const domainOwner = await deployedContract.getAddress(domain);

            expect(domainOwner).to.be.equal(randomPerson.address, 'Domain owner is not contract caller');
        });

        it('Register first domain should have NFT Token Id 1', async() => {
            const { deployedContract, randomPerson } = await setup({});

            const domain = 'messi';

            await deployedContract.register(domain,{ value: hre.ethers.utils.parseEther('0.1')});
            const domainNftId = await deployedContract.getNftId(domain);

            expect(domainNftId).to.be.equal(1, 'First NFT Token Id should be 1');
        });

        it('Register existent domain should fail', async() => {
            const { owner, deployedContract, randomPerson } = await setup({});

            const domain = 'messi';

            await deployedContract.connect(owner).register(domain,{ value: hre.ethers.utils.parseEther('0.1')});

            expect(deployedContract.connect(randomPerson).register(domain,{ value: hre.ethers.utils.parseEther('0.1')})).to.be.revertedWith("Domain is already registered");
        });

        it('Register domain with not enough MATIC should fail', async() => {
            const { deployedContract, randomPerson } = await setup({});

            const domain = 'as';

            expect(deployedContract.connect(randomPerson).register(domain,{ value: hre.ethers.utils.parseEther('0.1')})).to.be.revertedWith("Not enough MATIC paid");
        });

    });


    describe('Setting domain records', () =>{
        it('Set all records', async () =>{
            const { deployedContract } = await setup({ });

            const domain = 'messi';
            const nickname = 'GOAT';
            const spotifyLink = 'https://open.spotify.com/track/4JC18crxRPZOuTqBfXKFIR?si=3039c8bc0af44103';
            const twitter = 'TeamMessi';

            await deployedContract.register(domain,{ value: hre.ethers.utils.parseEther('0.1')});
            await deployedContract.setAllRecords(domain, nickname, spotifyLink, twitter);

            const domainRecords = await deployedContract.getRecord(domain);

            expect(domainRecords.nickname).to.be.equal(nickname, "Nickname wasn't set correctly");
            expect(domainRecords.spotifyLink).to.be.equal(spotifyLink, "Spotify Link wasn't set correctly");
            expect(domainRecords.twitter).to.be.equal(twitter, "Twitter wasn't set correctly");
        });

        it('Set nickname record', async () =>{
            const { deployedContract } = await setup({ });

            const domain = 'messi';
            const nickname = 'GOAT';

            await deployedContract.register(domain,{ value: hre.ethers.utils.parseEther('0.1')});
            await deployedContract.setNickname(domain, nickname);

            const domainRecords = await deployedContract.getRecord(domain);

            expect(domainRecords.nickname).to.be.equal(nickname, "Nickname wasn't set correctly");
        });

        it('Set spotifyLink record', async () =>{
            const { deployedContract } = await setup({ });

            const domain = 'messi';
            const spotifyLink = 'https://open.spotify.com/track/4JC18crxRPZOuTqBfXKFIR?si=3039c8bc0af44103';

            await deployedContract.register(domain,{ value: hre.ethers.utils.parseEther('0.1')});
            await deployedContract.setSpotifyLink(domain, spotifyLink);

            const domainRecords = await deployedContract.getRecord(domain);

            expect(domainRecords.spotifyLink).to.be.equal(spotifyLink, "Spotify Link wasn't set correctly");
        });

        it('Set twitter record', async () =>{
            const { deployedContract } = await setup({ });

            const domain = 'messi';
            const twitter = 'TeamMessi';

            await deployedContract.register(domain,{ value: hre.ethers.utils.parseEther('0.1')});
            await deployedContract.setTwitter(domain, twitter);

            const domainRecords = await deployedContract.getRecord(domain);

            expect(domainRecords.twitter).to.be.equal(twitter, "Twitter wasn't set correctly");
        });

        it('Setting record for domain that is not owned should fail', async () =>{
            const { deployedContract, randomPerson } = await setup({ });

            const domain = 'messi';
            const nickname = 'GOAT';
            const spotifyLink = 'https://open.spotify.com/track/4JC18crxRPZOuTqBfXKFIR?si=3039c8bc0af44103';
            const twitter = 'TeamMessi';

            await deployedContract.register(domain,{ value: hre.ethers.utils.parseEther('0.1')});
            expect(deployedContract.connect(randomPerson).setAllRecords(domain, nickname, spotifyLink, twitter)).to.be.revertedWith("You're not the owner of the domain");
        });
    });

    describe('Withdrawing funds', () => {

        it('Withdrawing funds from owner account', async () => {
            const { owner, deployedContract, randomPerson } = await setup({ });

            const domain = 'messi';

            await deployedContract.connect(randomPerson).register(domain,{ value: hre.ethers.utils.parseEther('0.1')});
            const tx = await deployedContract.withdraw();

            const finalContractBalance = await hre.ethers.provider.getBalance(deployedContract.address);

            expect(finalContractBalance).to.be.equal(hre.ethers.utils.parseEther('0'), "Funds weren't withdraw successfully");
        });

        it('Withdrawing funds from random account should fail', async () => {
            const { owner, deployedContract, randomPerson } = await setup({ });

            const domain = 'messi';
            const prevBalance = await owner.getBalance();

            await deployedContract.connect(randomPerson).register(domain,{ value: hre.ethers.utils.parseEther('0.1')});
            
            expect(deployedContract.connect(randomPerson).withdraw()).to.be.revertedWith('Failed to withdraw Matic');
        });

    });
});