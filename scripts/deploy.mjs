import { writeFile } from 'fs/promises';
import dotenv from 'dotenv';
import esMain from 'es-main';
import { deployCre8ors } from './deploy/deployCre8ors.mjs';
import { deployStaking } from './deploy/deployStaking.mjs';
import { deployLockup } from './deploy/deployLockup.mjs';
import { deployTransfers } from './deploy/deployTransfers.mjs';
import { deploySubscription } from './deploy/deploySubscription.mjs';
import { deployInitializer } from './deploy/deployInitializer.mjs';
import { deployOwnerOf } from './deploy/deployOwnerOf.mjs';
import { deployDna } from './deploy/deployDna.mjs';
import { deployDnaMinter } from './deploy/deployDnaMinter.mjs';
import { deployFreeMinter } from './deploy/deployFreeMinter.mjs';
dotenv.config({
  path: `.env.${process.env.CHAIN}`
});

export async function setupContracts() {
  console.log('deploying...');
  const presaleMerkleRoot = '0x36c161febf4b54734baf31a4d6b00da9f4a1cc6eeae64bb328e095b1ab00ec96';
  const initialize = await deployInitializer();
  const cre8ors = await deployCre8ors(presaleMerkleRoot);
  const cre8orsAddress = cre8ors.deploy.deployedTo;
  const dna = await deployDna();
  const dnaMinter = await deployDnaMinter();
  const subscription = await deploySubscription(cre8orsAddress);
  const ownerOfHook = await deployOwnerOf();
  const staking = await deployStaking();
  const transferHook = await deployTransfers(cre8orsAddress, staking.deploy.deployedTo);
  const lockup = await deployLockup();
  const passportAddress = '0x31E28672F704d6F8204e41Ec0B93EE2b1172558E';
  const usedPassportTokenIDs = JSON.stringify([
    '755',
    '293',
    '720',
    '724',
    '598',
    '241',
    '458',
    '785',
    '728',
    '236',
    '736',
    '201',
    '188',
    '556',
    '507',
    '62',
    '780',
    '4',
    '192',
    '527',
    '691',
    '767',
    '502',
    '290',
    '594',
    '226',
    '455',
    '573',
    '45',
    '393',
    '484',
    '335',
    '495',
    '411',
    '813',
    '532',
    '805',
    '406',
    '208',
    '80',
    '599',
    '370',
    '770',
    '523',
    '344',
    '559',
    '497',
    '207',
    '35',
    '820',
    '819',
    '211',
    '252',
    '695',
    '786',
    '579',
    '322',
    '463',
    '129',
    '179',
    '609',
    '737',
    '103',
    '128',
    '389',
    '345',
    '530',
    '697',
    '764',
    '441',
    '512',
    '535',
    '95',
    '397',
    '55',
    '326',
    '30',
    '147',
    '57',
    '64',
    '483',
    '118',
    '478',
    '365',
    '479',
    '570',
    '323',
    '123',
    '262',
    '714',
    '351',
    '713',
    '216',
    '605',
    '17',
    '109',
    '803',
    '396',
    '391',
    '493',
    '105',
    '12',
    '419',
    '337',
    '448',
    '540',
    '219',
    '508',
    '358',
    '169',
    '359',
    '312',
    '60',
    '127',
    '591',
    '592',
    '751',
    '752',
    '136',
    '165',
    '269',
    '799',
    '367',
    '263',
    '39',
    '362',
    '170',
    '457',
    '563',
    '434',
    '473',
    '100',
    '168',
    '32',
    '420',
    '212',
    '228',
    '811',
    '513',
    '812',
    '809',
    '184',
    '253',
    '159',
    '689',
    '202',
    '509',
    '721',
    '711',
    '442',
    '218',
    '769',
    '706',
    '413',
    '336',
    '341',
    '343',
    '584',
    '96',
    '449',
    '392',
    '783',
    '191',
    '294',
    '33',
    '101',
    '332',
    '518',
    '255',
    '247',
    '114',
    '593',
    '185',
    '21',
    '115',
    '552',
    '20',
    '142',
    '27',
    '311',
    '153',
    '347',
    '776',
    '159',
    '18',
    '22',
    '414',
    '715',
    '3',
    '47',
    '222',
    '597',
    '412',
    '134',
    '230',
    '159',
    '161',
    '176',
    '102',
    '321',
    '777',
    '440',
    '775',
    '26',
    '590',
    '738',
    '548',
    '525',
    '15',
    '316',
    '173',
    '726',
    '496',
    '588',
    '50',
    '292',
    '273',
    '116',
    '154',
    '200',
    '355',
    '429',
    '437',
    '452',
    '465',
    '589',
    '732',
    '814',
    '275',
    '757',
    '514',
    '206',
    '130',
    '291',
    '274',
    '40',
    '379',
    '526',
    '576',
    '288',
    '348',
    '328',
    '261',
    '569',
    '464',
    '766',
    '562',
    '575',
    '787',
    '801',
    '180',
    '541',
    '330',
    '817',
    '187',
    '469',
    '138',
    '447',
    '818',
    '534',
    '235',
    '289',
    '186',
    '564',
    '611',
    '174',
    '760',
    '515',
    '46',
    '125',
    '196',
    '426',
    '427',
    '499',
    '450',
    '424',
    '71',
    '162',
    '740',
    '315',
    '300',
    '258',
    '270',
    '285',
    '132',
    '182',
    '232',
    '366',
    '536',
    '70',
    '546',
    '431',
    '279',
    '38',
    '146',
    '510',
    '794',
    '301',
    '529',
    '11',
    '405',
    '482',
    '318',
    '1',
    '156',
    '203',
    '106',
    '555',
    '137',
    '375',
    '308',
    '36',
    '545',
    '220',
    '49',
    '10',
    '444',
    '254',
    '466',
    '466',
    '76',
    '44',
    '240',
    '472',
    '74',
    '256',
    '181',
    '415',
    '133',
    '369',
    '16',
    '107',
    '59',
    '416',
    '183',
    '157',
    '490',
    '249',
    '340',
    '698',
    '131',
    '92',
    '439',
    '280',
    '268',
    '807',
    '494',
    '421',
    '231',
    '177',
    '56',
    '753',
    '788',
    '151',
    '730',
    '600',
    '802',
    '390',
    '99',
    '516',
    '149',
    '266',
    '407',
    '747',
    '155',
    '178',
    '295',
    '63',
    '501',
    '792',
    '81',
    '758',
    '459',
    '297',
    '233',
    '744',
    '544',
    '58',
    '542',
    '159',
    '432',
    '68',
    '145',
    '215',
    '731',
    '122',
    '2',
    '278',
    '797',
    '287',
    '524',
    '93',
    '383',
    '135',
    '43',
    '325',
    '790',
    '741',
    '606',
    '694',
    '521',
    '229',
    '248',
    '603',
    '553',
    '816',
    '72',
    '339',
    '372',
    '267',
    '550',
    '357',
    '456',
    '227',
    '94',
    '73',
    '487',
    '160',
    '795',
    '585',
    '386',
    '121',
    '815',
    '560',
    '461',
    '175',
    '204',
    '84',
    '31',
    '277',
    '476',
    '727',
    '587',
    '380',
    '317',
    '773',
    '113',
    '195',
    '565',
    '614',
    '342',
    '771',
    '350',
    '578',
    '65',
    '778',
    '793',
    '791',
    '42',
    '271',
    '87',
    '319',
    '692',
    '561',
    '503',
    '78',
    '51',
    '470',
    '371',
    '549',
    '543',
    '746',
    '468',
    '409',
    '735',
    '425',
    '572',
    '750',
    '404',
    '497',
    '497',
    '497',
    '497',
    '243',
    '167',
    '23',
    '66',
    '786',
    '171',
    '786',
    '190',
    '150',
    '306',
    '772',
    '88',
    '25',
    '374',
    '361',
    '210',
    '489',
    '595',
    '305',
    '108',
    '399',
    '31',
    '237',
    '704',
    '779',
    '257',
    '739',
    '349',
    '583',
    '7',
    '139',
    '75',
    '582',
    '260',
    '782',
    '223',
    '402',
    '602',
    '737',
    '610',
    '282',
    '164',
    '48',
    '205',
    '34',
    '54',
    '140',
    '749',
    '762',
    '8',
    '403',
    '461',
    '140',
    '345',
    '140',
    '401',
    '140',
    '745',
    '140',
    '78',
    '376',
    '209',
    '152',
    '768',
    '810',
    '246',
    '446',
    '504',
    '29',
    '31',
    '454',
    '41',
    '329',
    '239',
    '538',
    '85',
    '471',
    '310',
    '143',
    '581',
    '461',
    '601',
    '734',
    '461',
    '31',
    '37',
    '467',
    '500',
    '327',
    '13',
    '696',
    '331',
    '6',
    '119',
    '19',
    '276',
    '124',
    '14',
    '400',
    '568',
    '199',
    '176',
    '9',
    '89',
    '723',
    '120',
    '612',
    '5',
    '111',
    '221',
    '264',
    '423',
    '784',
    '443',
    '198',
    '238',
    '24',
    '90',
    '217',
    '395',
    '492',
    '314',
    '356',
    '189',
    '225',
    '281',
    '283',
    '158',
    '488',
    '355',
    '356',
    '420',
    '423',
    '424',
    '426',
    '427',
    '489',
    '491',
    '492',
    '499',
    '500',
    '501',
    '503',
    '504',
    '505',
    '515',
    '320',
    '126',
    '309',
    '104',
    '796',
    '551',
    '462',
    '748',
    '586'
  ]);
  const freeMinter = await deployFreeMinter(cre8orsAddress, passportAddress, usedPassportTokenIDs);
  return {
    cre8ors,
    freeMinter,
    dna,
    dnaMinter,
    transferHook,
    initialize,
    lockup,
    ownerOfHook,
    staking,
    subscription
  };
}

async function main() {
  const output = await setupContracts();
  const date = new Date().toISOString().slice(0, 10);
  writeFile(`./deployments/${date}.${process.env.CHAIN}.json`, JSON.stringify(output, null, 2));
}

if (esMain(import.meta)) {
  // Run main
  await main();
}
