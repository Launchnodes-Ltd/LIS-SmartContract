import { loadFixture } from '@nomicfoundation/hardhat-network-helpers';
import { deployNGOFactoryWithNgo } from './utils/deploy';
import { ethers } from 'hardhat';
import { expect } from 'chai';

export const upgradeFlowTest = function () {
  /*-------------------------------------- Positive cases ---------------------------------------- */

  describe('Positive cases', () => {
    it('should UPGRADE contract to V2', async function () {
      const { ngo } = await loadFixture(deployNGOFactoryWithNgo);
      const NgoV2Impl = await ethers.getContractFactory('NGOLisV2');
      const ngoV2Impl = await NgoV2Impl.deploy();
      await ngo.upgradeToAndCall(ngoV2Impl.address, '0x');

      const ngoV2 = await ethers.getContractAt('NGOLisV2', ngo.address);

      expect(await ngoV2.getNGOLisV2()).to.eq('This is NGOLIs V2');
      expect(await ngoV2.anotherNGOLisV2Fn()).to.eq(
        'This is another NGOLIs V2 function'
      );
    });
  });

  /*-------------------------------------- Negative cases ---------------------------------------- */

  describe('Negative cases', () => {
    it('should REVERT if not owner', async () => {
      const { ngo } = await loadFixture(deployNGOFactoryWithNgo);
      const tx = ngo.upgradeToAndCall(
        '0x0000000000000000000000000000000000000000',
        '0x'
      );

      await expect(tx).to.be.revertedWithoutReason();
    });
  });
};
