const { expect } = require('chai');
const { ethers } = require('hardhat');

/**
 * @dev Informations de notre constructeur.
 */
describe('VdmIco', async function () {
  let dev, owner, vendeur, addressIco, spender, bob, sender, dan, VieDeMerde, viedemerde;
  //VdmIco (commercial = 5% des tokens VieDeMerde Total)
  const INIT_SUPPLY = ethers.utils.parseEther('250000000000');
  const PRIX = ethers.utils.parseEther('1000000000');

  //sender=expediteur
  //spender = depensier
  //vendeur
  //addressIco


  /**
   * @dev fonction qui sera lancé avant chaque "Test Unitaire".
   * @notice 
   *  création du fichier Json "VieDeMerde", contenant les infos du contrat.
   *  Transaction du contrat
   */
  beforeEach(async function () {
    [dev, owner, vendeur, addressIco, spender, bob, sender, dan] = await ethers.getSigners();
    VieDeMerde = await ethers.getContractFactory('VieDeMerde');
    viedemerde = await VieDeMerde.connect(dev).deploy(owner.address, INIT_SUPPLY);
    await viedemerde.deployed();
  });

  describe('deployement', function () {
    it(`Should mint total supply ${INIT_SUPPLY.toString()} to owner`, async function () {
      expect(await viedemerde.balanceOf(owner.address)).to.equal(INIT_SUPPLY);
    });
    it('Should emit Transfer at deployment', async function () {
      const receipt = await viedemerde.deployTransaction.wait();
      const txHash = receipt.transactionHash;
      await expect(txHash).to.emit(viedemerde, 'Transfer').withArgs(ethers.constants.AddressZero, owner.address, INIT_SUPPLY);
    });
  });

  describe('Allowance', function () {
    it('owner can allow spender', async function () {
      await viedemerde.connect(spender).approve(sender.address, 200);
      expect(await viedemerde.allowance(spender.address, sender.address)).to.equal(200);
    });
    it('Should change old allowance', async function () {
      await viedemerde.connect(spender).approve(sender.address, 200);
      await viedemerde.connect(spender).approve(sender.address, 150);
      expect(await viedemerde.allowance(spender.address, sender.address)).to.equal(150);
    });
    it('Should revert if owners allow zero-address', async function () {
      await expect(viedemerde.connect(spender).approve(ethers.constants.AddressZero, 1000)).to.revertedWith(
        'ERC20: approve to the zero address'
        // 'VdmIco: approve to the zero address'
        // 'VdmIco: approve from the zero address' => Revert fait par défaut
      );

    });
    it('Should emit Approval event', async function () {
      await expect(viedemerde.connect(spender).approve(sender.address, 200))
        .to.emit(viedemerde, 'Approval')
        .withArgs(spender.address, sender.address, 200);
    });
    "VdmIco: decreased allowance below zero"

  });

  // describe('Buy Token', function () {
  //    PRIX
  //   "VdmIco: Le prix n'est pas de 0 ether"
  //   "VdmIco: Ether insuffisant pour l'achat"
  //  "VdmIco: Doit envoyer 0.000000001 ether pour l'achat d'un Token"
  // })

  describe('Token Transfers', function () {
    const spender_INIT_BALANCE = ethers.utils.parseEther('1000');
    const BOB_INIT_BALANCE = ethers.utils.parseEther('500');
    beforeEach(async function () {
      await viedemerde.connect(owner).transfer(spender.address, spender_INIT_BALANCE);
      await viedemerde.connect(owner).transfer(bob.address, BOB_INIT_BALANCE);
    });
    it('Should transfer token from sender to recipient', async function () {
      await viedemerde.connect(spender).transfer(bob.address, 1);
      expect(await viedemerde.balanceOf(spender.address)).to.equal(spender_INIT_BALANCE.sub(1));
      expect(await viedemerde.balanceOf(bob.address)).to.equal(BOB_INIT_BALANCE.add(1));
    });

    it('Should transferFrom token from sender to recipient', async function () {
      await viedemerde.connect(spender).approve(sender.address, 200);
      await viedemerde.connect(sender).transferFrom(spender.address, dan.address, 150);
      expect(await viedemerde.balanceOf(spender.address)).to.equal(spender_INIT_BALANCE.sub(150));
      expect(await viedemerde.balanceOf(dan.address)).to.equal(150);
    });

    it('Should decrease allowance when transferFrom to recipient', async function () {
      await viedemerde.connect(spender).approve(sender.address, 200);
      await viedemerde.connect(sender).transferFrom(spender.address, dan.address, 150);
      expect(await viedemerde.allowance(spender.address, sender.address)).to.equal(200 - 150);
    });

    it('Should revert when transferFrom amount exceeds balance', async function () {
      await viedemerde.connect(spender).approve(sender.address, INIT_SUPPLY);
      await expect(
        viedemerde.connect(sender).transferFrom(spender.address, dan.address, spender_INIT_BALANCE.add(1))
      ).to.revertedWith('ERC20: transfer amount exceeds balance');
    });

    it('Should revert if transfer to zero-address', async function () {
      await expect(viedemerde.connect(spender).transfer(ethers.constants.AddressZero, 1)).to.revertedWith(
        'ERC20: transfer to the zero address'
        // 'VdmIco: transfer to the zero address'
      );
    });

    it('Should revert when transferFrom amount exceeds allowance', async function () {
      await viedemerde.connect(spender).approve(sender.address, 200);
      await expect(viedemerde.connect(sender).transferFrom(spender.address, dan.address, 200 + 1)).to.revertedWith(
        'ERC20: transfer amount exceeds allowance'
        // 'VdmIco: transfer amount exceeds allowance'
      );
    });

    it('Should revert when transferFrom to zero-address', async function () {
      await viedemerde.connect(spender).approve(sender.address, INIT_SUPPLY);
      await expect(viedemerde.connect(sender).transferFrom(spender.address, ethers.constants.AddressZero, 10)).to.revertedWith(
        'ERC20: transfer to the zero address'
        // 'VdmIco: transfer from the zero address'
      );
    });

    it('Should revert when transfer amount exceeds balance', async function () {
      await expect(viedemerde.connect(spender).transfer(sender.address, spender_INIT_BALANCE.add(1))).to.revertedWith(
        'ERC20: transfer amount exceeds balance'
        // 'VdmIco: transfer amount exceeds balance'
      );
    });
    it('Should emit Transfer event', async function () {
      await expect(viedemerde.connect(spender).transfer(sender.address, 500))
        .to.emit(viedemerde, 'Transfer')
        .withArgs(spender.address, sender.address, 500);
    });

    it('Should emit Transfer event when transferFrom', async function () {
      await viedemerde.connect(spender).approve(sender.address, 200);
      await expect(viedemerde.connect(sender).transferFrom(spender.address, dan.address, 150))
        .to.emit(viedemerde, 'Transfer')
        .withArgs(spender.address, dan.address, 150);
    });

    // describe('Mint to the zero address', function () {
    // "VdmIco: mint to the zero address"
    // })

    // describe('Burn to the zero address', function () {
    // "VdmIco: mint to the zero address"
    // "VdmIco: burn amount exceeds balance"
    // })
  });
});
