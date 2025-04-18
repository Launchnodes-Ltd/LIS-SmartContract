import hre from 'hardhat';

export function waitAMinute() {
  return new Promise((resolve) => setTimeout(resolve, 60000));
}

/**
 * Verifies a contract in Etherscan
 * @param address - Address of the contract
 * @param constructorArguments - List of arguments provided to the constructor
 */

export async function verifyContract(
  address: string,
  ...constructorArguments: any
) {
  try {
    console.log(
      "Wait a minute for changes to propagate to Etherscan's backend..."
    );

    await waitAMinute();

    console.log(`Verifying contract ${address}...`);

    await hre.run('verify:verify', {
      address,
      constructorArguments: [...constructorArguments],
    });

    console.log(`Contract ${address} verified on Etherscan ✅\n`);
    console.log('==============================================================================\n');
  } catch (err) {
    console.log(err);
  }
}
