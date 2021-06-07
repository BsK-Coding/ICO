/* eslint-disable comma-dangle */
/* eslint-disable no-unused-expressions */
/* eslint-disable no-undef */
/* eslint-disable no-unused-vars */
const { expect } = require('chai');
const { ethers } = require('hardhat');

/**
 * @dev Informations de notre constructeur.
 */
describe('VieDeMerde Token', async function () {
  let dev, owner, Viedemerde, viedemerde;
  const NAME = 'VieDeMerde';
  const SYMBOL = 'VDM';
  const INIT_SUPPLY = ethers.utils.parseEther('5000000000000');

  /**
   * @dev fonction qui sera lancé avant chaque "Test Unitaire".
   * @notice 
   *  création du fichier Json "VieDeMerde", contenant les infos du contrat.
   *  Transaction du contrat
   */
  beforeEach(async function () {
    [dev, owner] = await ethers.getSigners();
    Viedemerde = await ethers.getContractFactory('VieDeMerde');
    viedemerde = await Viedemerde.connect(dev).deploy(owner.address, INIT_SUPPLY);
    await viedemerde.deployed();
  });

  /**
   * @dev "Tests Unitaires" concernant les données renseigné dans notre constructeur.
   * @notice  
   *  Vérification du Nom de notre Token
   *  Vérification du Symbol de notre Token
   *  Vérification du nombre total de token créer "initialSupply"
   *  Vérification du solde de l'adresse owner auquel les jetons aurront été attribué
   */
  it(`Should have name ${NAME}`, async function () {
    expect(await viedemerde.name()).to.equal(NAME);
  });
  it(`Should have name ${SYMBOL}`, async function () {
    expect(await viedemerde.symbol()).to.equal(SYMBOL);
  });
  it(`Should have total supply ${INIT_SUPPLY.toString()}`, async function () {
    expect(await viedemerde.totalSupply()).to.equal(INIT_SUPPLY);
  });
  it(`Should mint initial supply ${INIT_SUPPLY.toString()} to owner`, async function () {
    expect(await viedemerde.balanceOf(owner.address)).to.equal(INIT_SUPPLY);
  });
});

