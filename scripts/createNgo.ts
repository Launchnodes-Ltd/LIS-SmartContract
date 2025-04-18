import { ethers } from "hardhat";

const ngos = [
  {
    name: "Treedom",
    image:
      "https://solarimpulse.com/files/companies/logo/2020-05-22-101901/xlogoTreedom.jpg.pagespeed.ic.Scf2tmXtZ5.png",
    description:
      "The right tree, in the right place and for the right purpose. Planting trees to make them grow, with a long-term perspective.",
    url: "https://www.treedom.net/en",
    country: "United Kingdom",
    rewarder: "0xdf9C8EfB80f2DAd58d2E2D7C30F1d190C02197a8",
    owner: "0xC946cB236481C159F460b212b34AB246daC37FcD",
    oracle: "0x4fA5e90C10b40ceDc17BE7bAE4a9DcD0FE931B83",
  },
  {
    name: "GiveDirectly",
    image:
      "https://www.givedirectly.org/wp-content/uploads/2020/02/cropped-knowledge_graph_logo-1.jpg",
    description:
      "Send money directly to people who need it most. Your donation empowers families in poverty to choose how best to improve their lives.",
    url: "https://www.givedirectly.org/",
    country: "Kenya",
    rewarder: "0xdf9C8EfB80f2DAd58d2E2D7C30F1d190C02197a8",
    owner: "0xC946cB236481C159F460b212b34AB246daC37FcD",
    oracle: "0x4fA5e90C10b40ceDc17BE7bAE4a9DcD0FE931B83",
  },
  {
    name: "WFP",
    image:
      "https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/World_Food_Programme_Logo_Simple.svg/640px-World_Food_Programme_Logo_Simple.svg.png",
    description:
      "The World Food Programme is the world’s largest humanitarian organization saving lives in emergencies and using food assistance to build a pathway to peace, stability and prosperity, for people recovering from conflict, disasters and the impact of climate change.",
    url: "https://www.wfp.org/",
    country: "Italy",
    rewarder: "0xdf9C8EfB80f2DAd58d2E2D7C30F1d190C02197a8",
    owner: "0xC946cB236481C159F460b212b34AB246daC37FcD",
    oracle: "0x4fA5e90C10b40ceDc17BE7bAE4a9DcD0FE931B83",
  },
  {
    name: "Giga",
    image:
      "https://media.licdn.com/dms/image/D4E10AQFlOYZfQnrkLw/image-shrink_800/0/1700160902525?e=2147483647&v=beta&t=jD6cTZiGCOFZuUIOrkvZGv1yFv8Ym0uq26-8YbxDQGM",
    description:
      "Giga is a UNICEF-ITU initiative to connect every school to the Internet and every young person to information, opportunity and choice.",
    url: "https://giga.global/",
    country: "Central Asia",
    rewarder: "0xdf9C8EfB80f2DAd58d2E2D7C30F1d190C02197a8",
    owner: "0xC946cB236481C159F460b212b34AB246daC37FcD",
    oracle: "0x4fA5e90C10b40ceDc17BE7bAE4a9DcD0FE931B83",
  },
];

async function main() {
  console.log("Creating Ngo...");

  const ngoFactory = await ethers.getContractAt(
    "NGOLisFactory",
    "0x365476306425BbFDB6a988f10cfA20559f209126"
  );

  // const tx1 = await ngoFactory.createNGO(
  //   'UNICEF',
  //   'https://i.pinimg.com/736x/50/ba/9f/50ba9f98aaf8f8ded4d576a6969668f0.jpg',
  //   "UNICEF works in over 190 countries and territories to save children's lives to defend their rights and to help them fulfil their potential from early childhood through adolescence. And we never give up.",
  //   'https://www.unicef.org/',
  //   'United Kingdom',
  //   '0xdf9C8EfB80f2DAd58d2E2D7C30F1d190C02197a8',
  //   '0xC946cB236481C159F460b212b34AB246daC37FcD',
  //   '0x4fA5e90C10b40ceDc17BE7bAE4a9DcD0FE931B83'
  // );

  // const tx2 = await ngoFactory.createNGO(
  //   'GiveDirectly',
  //   'https://www.givedirectly.org/wp-content/uploads/2020/02/cropped-knowledge_graph_logo-1.jpg',
  //   'Send money directly to people who need it most. Your donation empowers families in poverty to choose how best to improve their lives.',
  //   'https://www.givedirectly.org/',
  //   'Kenya',
  //   '0xdf9C8EfB80f2DAd58d2E2D7C30F1d190C02197a8',
  //   '0xC946cB236481C159F460b212b34AB246daC37FcD',
  //   '0x4fA5e90C10b40ceDc17BE7bAE4a9DcD0FE931B83'
  // );

  // const tx3 = await ngoFactory.createNGO(
  //   'Yash wallet',
  //   'https://cdn-icons-png.flaticon.com/512/4838/4838856.png',
  //   'Testing',
  //   'https://dev.impactstake.com/social-impact/',
  //   'United Kingdom',
  //   '0xdf9C8EfB80f2DAd58d2E2D7C30F1d190C02197a8',
  //   '0xC946cB236481C159F460b212b34AB246daC37FcD',
  //   '0x4fA5e90C10b40ceDc17BE7bAE4a9DcD0FE931B83'
  // );

  let tx;
  let info;
  let ngoAddress;
  let ngo;

  for (let i = 0; i < ngos.length; i++) {
    ngo = ngos[i];

    tx = await ngoFactory.createNGO(
      ngo.name,
      ngo.image,
      ngo.description,
      ngo.url,
      ngo.country,
      ngo.rewarder,
      ngo.owner,
      ngo.oracle
    );

    info = await tx.wait();

    ngoAddress = info?.events?.[3]?.args?.["_ngoAddress"];

    console.log("\n");
    console.log(`NGO${i + 1} (${ngo.name}): ${ngoAddress}`);
    console.log(`https://holesky.etherscan.io/address/${ngoAddress}`);
  }

  // const info1 = await tx1.wait();
  // const info2 = await tx2.wait();
  // const info3 = await tx3.wait();

  // const ngo1Address: string = info1?.events?.[3]?.args?.['_ngoAddress'];
  // const ngo2Address: string = info2?.events?.[3]?.args?.['_ngoAddress'];
  // const ngo3Address: string = info3?.events?.[3]?.args?.['_ngoAddress'];

  // console.log('\n');
  // console.log(`NGO1: ${ngo1Address}`);
  // console.log(`https://holesky.etherscan.io/address/${ngo1Address}`);

  // console.log('\n');
  // console.log(`NGO2: ${ngo2Address}`);
  // console.log(`https://holesky.etherscan.io/address/${ngo2Address}`);

  // console.log('\n');
  // console.log(`NGO3: ${ngo3Address}`);
  // console.log(`https://holesky.etherscan.io/address/${ngo3Address}\n`);

  // const stringAddresses = `NGO1: ${ngo1Address}\nhttps://holesky.etherscan.io/address/${ngo1Address}\n\nNGO2: ${ngo2Address}\nhttps://holesky.etherscan.io/address/${ngo2Address}\n\nNGO3: ${ngo3Address}\nhttps://holesky.etherscan.io/address/${ngo3Address}\n\n`;
  // await sendMessage(stringAddresses);
  process.exit();
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
