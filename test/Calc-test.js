const { expect } = require('chai');
const { ethers } = require("hardhat");

describe('Calc', function () {
  //Déclaration des variables, afin d'être pris en compte dans "beforeEach"
  let Calc, calc

  beforeEach(async function () {
    Calc = await ethers.getContractFactory('Calc')
    calc = await Calc.deploy()
    await calc.deployed()
  });

  it('Should calculate the right result: addition', async function () {
    expect(await calc.add(10, 5)).to.equal(15)
  })

  it('should calculate the right result: substraction', async function () {
    expect(await calc.sub(10, 5)).to.equal(5)
  })

  it('Should calculate the right result: multiply', async function () {
    expect(await calc.mul(10, 5)).to.equal(50)
  })

  it('Should calculate the right result: divide', async function () {
    expect(await calc.div(10, 5)).to.equal(2)
  })

  it('Should revert if nb2 equals 0', async function () {
    await expect(calc.div(10, 0)).to.be.revertedWith('Calc: cannot divide by zero')
  })

  it('Should calculate the right result: modulo', async function () {
    expect(await calc.mod(10, 5)).to.equal(0)
  })
})
