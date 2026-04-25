import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mindloom/features/story/data/model/story_model.dart';
import 'package:mindloom/features/user/data/model/user_model.dart';
import 'package:mindloom/features/user/data/model/user_stat_model.dart';
import 'package:uuid/uuid.dart';

class TestingApp {
  TestingApp({required this.firestore, required this.auth});
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  final List<Map<String, String>> dummyUsers = [
    {
      'id': 'user_001',
      'name': 'Arjun Mehta',
      'email': 'arjun.mehta1@gmail.com',
    },
    {
      'id': 'user_002',
      'name': 'Riya Sharma',
      'email': 'riya.sharma2@gmail.com',
    },
    {
      'id': 'user_003',
      'name': 'Kabir Verma',
      'email': 'kabir.verma3@gmail.com',
    },
    {
      'id': 'user_004',
      'name': 'Ananya Singh',
      'email': 'ananya.singh4@gmail.com',
    },
    {
      'id': 'user_005',
      'name': 'Vivaan Kapoor',
      'email': 'vivaan.kapoor5@gmail.com',
    },
    {'id': 'user_006', 'name': 'Ishita Rao', 'email': 'ishita.rao6@gmail.com'},
    {
      'id': 'user_007',
      'name': 'Ayaan Malhotra',
      'email': 'ayaan.malhotra7@gmail.com',
    },
    {'id': 'user_008', 'name': 'Meera Iyer', 'email': 'meera.iyer8@gmail.com'},
    {'id': 'user_009', 'name': 'Rohan Das', 'email': 'rohan.das9@gmail.com'},
    {'id': 'user_010', 'name': 'Sara Khan', 'email': 'sara.khan10@gmail.com'},
    {
      'id': 'user_011',
      'name': 'Aditya Nair',
      'email': 'aditya.nair11@gmail.com',
    },
    {'id': 'user_012', 'name': 'Diya Patel', 'email': 'diya.patel12@gmail.com'},
    {
      'id': 'user_013',
      'name': 'Kunal Joshi',
      'email': 'kunal.joshi13@gmail.com',
    },
    {
      'id': 'user_014',
      'name': 'Priya Reddy',
      'email': 'priya.reddy14@gmail.com',
    },
    {
      'id': 'user_015',
      'name': 'Manav Bansal',
      'email': 'manav.bansal15@gmail.com',
    },
    {
      'id': 'user_016',
      'name': 'Sneha Kulkarni',
      'email': 'sneha.kulkarni16@gmail.com',
    },
    {'id': 'user_017', 'name': 'Yash Gupta', 'email': 'yash.gupta17@gmail.com'},
    {
      'id': 'user_018',
      'name': 'Tanya Chawla',
      'email': 'tanya.chawla18@gmail.com',
    },
    {'id': 'user_019', 'name': 'Dev Arora', 'email': 'dev.arora19@gmail.com'},
    {
      'id': 'user_020',
      'name': 'Naina Sethi',
      'email': 'naina.sethi20@gmail.com',
    },
    {
      'id': 'user_021',
      'name': 'Harsh Vardhan',
      'email': 'harsh.vardhan21@gmail.com',
    },
    {
      'id': 'user_022',
      'name': 'Pooja Mishra',
      'email': 'pooja.mishra22@gmail.com',
    },
    {
      'id': 'user_023',
      'name': 'Rahul Tripathi',
      'email': 'rahul.tripathi23@gmail.com',
    },
    {
      'id': 'user_024',
      'name': 'Aditi Desai',
      'email': 'aditi.desai24@gmail.com',
    },
    {
      'id': 'user_025',
      'name': 'Shivam Tiwari',
      'email': 'shivam.tiwari25@gmail.com',
    },
    {
      'id': 'user_026',
      'name': 'Neha Agarwal',
      'email': 'neha.agarwal26@gmail.com',
    },
    {
      'id': 'user_027',
      'name': 'Varun Saxena',
      'email': 'varun.saxena27@gmail.com',
    },
    {
      'id': 'user_028',
      'name': 'Simran Kaur',
      'email': 'simran.kaur28@gmail.com',
    },
    {
      'id': 'user_029',
      'name': 'Arnav Bhatt',
      'email': 'arnav.bhatt29@gmail.com',
    },
    {
      'id': 'user_030',
      'name': 'Kriti Malhotra',
      'email': 'kriti.malhotra30@gmail.com',
    },
    {
      'id': 'user_031',
      'name': 'Ritika Sharma',
      'email': 'ritika.sharma31@gmail.com',
    },
    {
      'id': 'user_032',
      'name': 'Siddharth Jain',
      'email': 'siddharth.jain32@gmail.com',
    },
    {
      'id': 'user_033',
      'name': 'Aarav Gupta',
      'email': 'aarav.gupta33@gmail.com',
    },
    {'id': 'user_034', 'name': 'Ira Bhatia', 'email': 'ira.bhatia34@gmail.com'},
    {
      'id': 'user_035',
      'name': 'Lakshya Arora',
      'email': 'lakshya.arora35@gmail.com',
    },
    {
      'id': 'user_036',
      'name': 'Myra Kapoor',
      'email': 'myra.kapoor36@gmail.com',
    },
    {
      'id': 'user_037',
      'name': 'Dhruv Singh',
      'email': 'dhruv.singh37@gmail.com',
    },
    {'id': 'user_038', 'name': 'Avni Mehta', 'email': 'avni.mehta38@gmail.com'},
    {
      'id': 'user_039',
      'name': 'Reyansh Verma',
      'email': 'reyansh.verma39@gmail.com',
    },
    {'id': 'user_040', 'name': 'Kiara Nair', 'email': 'kiara.nair40@gmail.com'},
    {
      'id': 'user_041',
      'name': 'Aryan Reddy',
      'email': 'aryan.reddy41@gmail.com',
    },
    {
      'id': 'user_042',
      'name': 'Saanvi Patel',
      'email': 'saanvi.patel42@gmail.com',
    },
    {
      'id': 'user_043',
      'name': 'Mohit Yadav',
      'email': 'mohit.yadav43@gmail.com',
    },
    {
      'id': 'user_044',
      'name': 'Anika Deshmukh',
      'email': 'anika.deshmukh44@gmail.com',
    },
    {'id': 'user_045', 'name': 'Parth Shah', 'email': 'parth.shah45@gmail.com'},
    {
      'id': 'user_046',
      'name': 'Shruti Menon',
      'email': 'shruti.menon46@gmail.com',
    },
    {
      'id': 'user_047',
      'name': 'Karthik Iyer',
      'email': 'karthik.iyer47@gmail.com',
    },
    {
      'id': 'user_048',
      'name': 'Tanvi Kulkarni',
      'email': 'tanvi.kulkarni48@gmail.com',
    },
    {
      'id': 'user_049',
      'name': 'Omkar Joshi',
      'email': 'omkar.joshi49@gmail.com',
    },
    {
      'id': 'user_050',
      'name': 'Riddhi Shah',
      'email': 'riddhi.shah50@gmail.com',
    },
    {
      'id': 'user_051',
      'name': 'Atharva Patil',
      'email': 'atharva.patil51@gmail.com',
    },
    {
      'id': 'user_052',
      'name': 'Navya Agarwal',
      'email': 'navya.agarwal52@gmail.com',
    },
    {
      'id': 'user_053',
      'name': 'Ishan Malhotra',
      'email': 'ishan.malhotra53@gmail.com',
    },
    {
      'id': 'user_054',
      'name': 'Prisha Kapoor',
      'email': 'prisha.kapoor54@gmail.com',
    },
    {
      'id': 'user_055',
      'name': 'Vedant Mishra',
      'email': 'vedant.mishra55@gmail.com',
    },
    {
      'id': 'user_056',
      'name': 'Aanya Chawla',
      'email': 'aanya.chawla56@gmail.com',
    },
    {
      'id': 'user_057',
      'name': 'Krish Arora',
      'email': 'krish.arora57@gmail.com',
    },
    {
      'id': 'user_058',
      'name': 'Nitya Singh',
      'email': 'nitya.singh58@gmail.com',
    },
    {
      'id': 'user_059',
      'name': 'Advik Sharma',
      'email': 'advik.sharma59@gmail.com',
    },
    {
      'id': 'user_060',
      'name': 'Samaira Gupta',
      'email': 'samaira.gupta60@gmail.com',
    },
    {
      'id': 'user_061',
      'name': 'Rudra Patel',
      'email': 'rudra.patel61@gmail.com',
    },
    {'id': 'user_062', 'name': 'Anvi Mehra', 'email': 'anvi.mehra62@gmail.com'},
    {
      'id': 'user_063',
      'name': 'Shaurya Verma',
      'email': 'shaurya.verma63@gmail.com',
    },
    {
      'id': 'user_064',
      'name': 'Mahi Kapoor',
      'email': 'mahi.kapoor64@gmail.com',
    },
    {
      'id': 'user_065',
      'name': 'Vivaan Choudhary',
      'email': 'vivaan.choudhary65@gmail.com',
    },
    {'id': 'user_066', 'name': 'Siya Rathi', 'email': 'siya.rathi66@gmail.com'},
    {'id': 'user_067', 'name': 'Arush Jain', 'email': 'arush.jain67@gmail.com'},
    {'id': 'user_068', 'name': 'Rhea Sinha', 'email': 'rhea.sinha68@gmail.com'},
    {'id': 'user_069', 'name': 'Kabir Sood', 'email': 'kabir.sood69@gmail.com'},
    {
      'id': 'user_070',
      'name': 'Anushka Batra',
      'email': 'anushka.batra70@gmail.com',
    },
    {
      'id': 'user_071',
      'name': 'Lakshit Goyal',
      'email': 'lakshit.goyal71@gmail.com',
    },
    {
      'id': 'user_072',
      'name': 'Ivaan Khanna',
      'email': 'ivaan.khanna72@gmail.com',
    },
    {
      'id': 'user_073',
      'name': 'Riya Malhotra',
      'email': 'riya.malhotra73@gmail.com',
    },
    {
      'id': 'user_074',
      'name': 'Vihaan Arora',
      'email': 'vihaan.arora74@gmail.com',
    },
    {
      'id': 'user_075',
      'name': 'Aarohi Desai',
      'email': 'aarohi.desai75@gmail.com',
    },
    {
      'id': 'user_076',
      'name': 'Darsh Patel',
      'email': 'darsh.patel76@gmail.com',
    },
    {
      'id': 'user_077',
      'name': 'Anika Sharma',
      'email': 'anika.sharma77@gmail.com',
    },
    {
      'id': 'user_078',
      'name': 'Yuvan Kapoor',
      'email': 'yuvan.kapoor78@gmail.com',
    },
    {'id': 'user_079', 'name': 'Tara Mehta', 'email': 'tara.mehta79@gmail.com'},
    {'id': 'user_080', 'name': 'Ira Joshi', 'email': 'ira.joshi80@gmail.com'},
    {
      'id': 'user_081',
      'name': 'Reyansh Malhotra',
      'email': 'reyansh.malhotra81@gmail.com',
    },
    {
      'id': 'user_082',
      'name': 'Suhana Khan',
      'email': 'suhana.khan82@gmail.com',
    },
    {'id': 'user_083', 'name': 'Kavya Iyer', 'email': 'kavya.iyer83@gmail.com'},
    {
      'id': 'user_084',
      'name': 'Aarav Bansal',
      'email': 'aarav.bansal84@gmail.com',
    },
    {
      'id': 'user_085',
      'name': 'Pranav Reddy',
      'email': 'pranav.reddy85@gmail.com',
    },
    {
      'id': 'user_086',
      'name': 'Navya Kapoor',
      'email': 'navya.kapoor86@gmail.com',
    },
    {
      'id': 'user_087',
      'name': 'Rudransh Gupta',
      'email': 'rudransh.gupta87@gmail.com',
    },
    {
      'id': 'user_088',
      'name': 'Kiara Sharma',
      'email': 'kiara.sharma88@gmail.com',
    },
    {
      'id': 'user_089',
      'name': 'Ayaan Verma',
      'email': 'ayaan.verma89@gmail.com',
    },
    {
      'id': 'user_090',
      'name': 'Saanvi Mehta',
      'email': 'saanvi.mehta90@gmail.com',
    },
    {
      'id': 'user_091',
      'name': 'Arnav Singh',
      'email': 'arnav.singh91@gmail.com',
    },
    {
      'id': 'user_092',
      'name': 'Myra Kapoor',
      'email': 'myra.kapoor92@gmail.com',
    },
    {
      'id': 'user_093',
      'name': 'Dhruv Patel',
      'email': 'dhruv.patel93@gmail.com',
    },
    {
      'id': 'user_094',
      'name': 'Ritika Jain',
      'email': 'ritika.jain94@gmail.com',
    },
    {
      'id': 'user_095',
      'name': 'Vivaan Sharma',
      'email': 'vivaan.sharma95@gmail.com',
    },
    {
      'id': 'user_096',
      'name': 'Ananya Gupta',
      'email': 'ananya.gupta96@gmail.com',
    },
    {
      'id': 'user_097',
      'name': 'Kabir Kapoor',
      'email': 'kabir.kapoor97@gmail.com',
    },
    {
      'id': 'user_098',
      'name': 'Meera Singh',
      'email': 'meera.singh98@gmail.com',
    },
    {
      'id': 'user_099',
      'name': 'Aditya Verma',
      'email': 'aditya.verma99@gmail.com',
    },
    {
      'id': 'user_100',
      'name': 'Sara Patel',
      'email': 'sara.patel100@gmail.com',
    },
  ];

  final List<String> testUserIds = [
    '1H8ChLrpQHMHe63XwpByskbc8Uv2',
    '1kw37ReS6jfoB9urGJ7ArZJLTTC2',
    '1q1UvXq9XZSvxCdtKLngkJZeSVh2',
    '1wmeD8z40gYnzy98jE8CqlNd2ch1',
    '21ZLQIcFzlUtLuQyRV5EcJ24QrB2',
    '2LpCaZq48UUviOqejcNVHRO3c203',
    '2S8cXee29PY6LRYOimzseLYcj613',
    '2gbzL85kFdVjSJzOagKJg9ZnC3q2',
    '2rWhoEZmN7VZS72lOA36zrvE2Gm1',
    '3t2tCjpooHPPZN3iyj6gapBr6rA2',
    '6ke0VDEEIjSG448FErvU5Z5vfdJ3',
    '7EmOqpvKcnMYWCUKlPUaEQBDOCP2',
    '7RzVbcDVabcUG1b8g8xHdXfXYto1',
    '7ptCh4TaFCciRK4N1hCwf3D3fXt1',
    '7v1EjPk13fTtXg8sgKf61S7E0qa2',
    '7vZPmlPtovVdOiZIf4IoYxrANF23',
    '89ZrdVkUUrbnYRDY03rshr6AB5C3',
    '8IhMlGuT26eODu4fYkfLUatttSz2',
    '8SBMzI4WhSNiYXEgXwJp9bpamPF3',
    '8SQJOqy6PpfieAYbHu9v57JaQ0Z2',
    '9mEvH3WDbsYOOFCQCKcwr962OsJ3',
    '9rORiyBDdSSvXyg1JuQJE1GNuPv1',
    'AgjIGIvlBoMOOiFs4cc5YQoUVVs2',
    'BYv5iq8pG5U2TtOEMCLLRKxBS8C2',
    'BfzUsqHYMQddgo3KiSrHICMVj0m1',
    'Byj0jTmxztV4NcOTSoiK89gfjB32',
    'DoFCqIhgElPjCWWdh1IhjQFPMRX2',
    'EVsMuBka05PmdFx5ezEqfykZSB22',
    'Ez2qrMcptgXl2moXcanrh6kSqtK2',
    'FBZaxlhKxpga3A6W9t36KZ6mTRm1',
    'FIa1wk6eQRVWymWY7PNL9DEoHH02',
    'GVkQC92URtXAKWnVYGSKcTsnOkD2',
    'H1u7lNnnMZQFgaRVS5bmI4cPRr83',
    'HVNwe0eo9lb9vA9n62A1GHzZRKj2',
    'J1JvLTPLurh4ghJYu8UcUX1sFVZ2',
    'JADB4OFfoQf0B606WlQfS93RQ5m2',
    'JKHuBjrpGxhvkSWXVjLk5RKMdi93',
    'KQI6lkcFA4W41siiRG8Y1SRtovn2',
    'L2WuJGuqi4QlRFaFwEtsqFVuck62',
    'LKyu74XjqJO35KrVArWQYSZds0c2',
    'LZ3g4X7vfKTGiZwtgqf6p0uLxfh1',
    'Lp7vyTSVgaM9XCVM4dFQW6YSY6Z2',
    'MUpAwLDjKEZkPiQ5zKxPTb3zm6z2',
    'Mb8AP3XyptfuCEMlfg34ci9gT933',
    'MqZOavlugSQUUq6HiAeYkanR7ct1',
    'OCFNHzaDyVZZwmNh5AlMl90JssA2',
    'Oc4tIqscrPeRCUC6VojsaUFFSpw2',
    'OprFHShlhDSUMzH26kpdq3FmzHO2',
    'QsEJPbFMDXNcA5COUcVMbP5uJPY2',
    'RO6FVQ9o2VWmuLAoHG8ELKrwJMD2',
    'ScGN4h5zNQW2VeOqNwqOZxEuxmA2',
    'VR77wx8fOBQIidM0tLzDFgEGd953',
    'VSZLl0Lg1aeNicNeLYtEoEdUnHc2',
    'W8pKY5bgEzUZYSETm8omQOyvLVE3',
    'WxMnnH7gdeaMdwauNTrjzzFVD4b2',
    'Xr3ySaW9qwdzo4Kr4SpPyT3MseK2',
    'Y6TgYKwWjnfl7gBmFu5z4OIjcna2',
    'Y8XCjRBwNTPTTpFjoJsAdFWybHm2',
    'YLIYtG4IP7Q6wUoSm5rKSHxjcbZ2',
    'YSktyl7UebeyPg02Pyht3vwHzfy1',
    'YTRF8rYMCQgXvib3naneUOOb2KA3',
    'Z3BmwfSR48Ok9XlbKE3JdfKQw863',
    'ZBEG11KjxSWNdW2ZVybHFHmFqt03',
    'Zilvp7ses7f8vwdKnRfWeSOI1hQ2',
    'ZtyvHfjVHrca3ayrpdlEehrwnSy1',
    'aUKMeSj20LSMMvffaKMKnNPKJAd2',
    'afAtKdmLKLWxXTacE1MSEztUfRJ2',
    'bbcgh1SW2gcImfVaEmJtzigd8Pg2',
    'bfUrr9TvWaSEVpCrs93NjLvZtDh1',
    'dRSCwVFtzLPrSJuLZhaG7uOv80q1',
    'eH8T64zvyggKWcbVzLk0o9jdSmJ3',
    'esfEt3VUMaPkfAvbtMfr30vDpjI2',
    'f0chwZynYZPDZDPpsvMszH7fQs33',
    'fDcZ8ayDzCRUyicHLlBTFUWdSjf2',
    'fRBNJ5btsLWiRRRnlV1NgNHlKQh2',
    'g7wKYFVznZgnSklquFoUYm7kuI23',
    'gTjnPdtIDJUojGzbtosLNqOtKYG2',
    'glDN2YN2Q8XIFZfa8EkOShfdM3O2',
    'hXSyd8oCcbVe5aaQaiLdOhSdyAs2',
    'hbTcCOtyZ2Pgs9lEAWUcM8A6QX83',
    'hbTpqAh6RTcdi6BGUqdPzzO9XYP2',
    'hxJFFW1XmTdbBPJIIXE110pgdaH2',
    'i2OUnZh42SVOTXK5cScn2C3V6Sm2',
    'ijeLKDxC5sTg8j3QeJoSagPUbZE2',
    'ijnqF6TzqnVguww6VAqf89LoqD23',
    'isClceJvL3OQUpj1oMVzq5gnshC3',
    'jNu49TSkmFMWvGh9MzvjEWsZVJt1',
    'jkP2SJFb17ZPfYkQeRZmVVenGRI2',
    'kGPFDZuV1YUepppjA6cTmiJv97n2',
    'kTfQHnTLltSb3zyRPZBU3pAqBSO2',
    'mi70cD2tAYXmlVAgJHOKQUW0dce2',
    'mzCviIfB8wQwOZrnBaFbwSi2KUY2',
    'o5UjQaz0cFToqGTEcK4wvvYr7Gx1',
    'oOYwlk1EmBbZqepUyJUGCJ0ah0K2',
    'pW1o6pgmpbY99Xd7JzVEQu6T0ng1',
    'paBhFSZzgjdWTVAncCqKCGr72K02',
    'pp69lw7355MurNe3UaoeS7SmpAw1',
    'qEOByEP4iiZ1BYOdM1S68TjYji42',
    'qNclP8V065UTEs5K1ubEuLboDLt2',
    'rP85tIHtEicshFoxzRO1jRUxPdv1',
    's7Y0RVsrjQhcPwYzMsqAR5mSKfd2',
    'sQrHK7OqCbbuo5KUIZYxL7e9HDx1',
    't5JDpAfdFzNHtspomDdNNPzrDO22',
    'u5jbsJhbIERfymcSbCQM9BewiO13',
    'vNJb65CaknRqlph8FiO7qFNeil82',
    'wAAAsHHIQER9AoTBuvZfD6oGIjp2',
  ];
  final List<String> dummyTitles = [
    'The Last Signal',
    'Midnight in the City',
    'When the Rain Stopped',
    'Fragments of Yesterday',
    'The Hidden Room',
    'Beyond the Horizon',
    'Echoes of Silence',
    'Shadows Beneath',
    'The Broken Promise',
    'Before Sunrise',
  ];

  final List<String> dummyGenres = [
    'Drama',
    'Romance',
    'Thriller',
    'Mystery',
    'Sci-Fi',
    'Fantasy',
  ];

  final List<String> dummyCovers = [
    'https://images.pexels.com/photos/11836671/pexels-photo-11836671.jpeg',
    'https://images.pexels.com/photos/210186/pexels-photo-210186.jpeg',
    'https://images.pexels.com/photos/355465/pexels-photo-355465.jpeg',
    'https://images.pexels.com/photos/46274/pexels-photo-46274.jpeg',
  ];

  String _generateLongContent() {
    return 'The air felt heavier than usual, as if the world itself was holding its breath. '
        'Every decision carried weight, and every silence echoed louder than words spoken in anger. '
        'Memories surfaced like distant waves, reminding them of choices made and paths not taken. '
        'In the quiet moments between fear and hope, something shifted. '
        'And in that fragile space, a new beginning started to form. ';
  }

  Future<void> sendDummyData() async {
    try {
      debugPrint('Execution Started');
      for (var user in dummyUsers) {
        debugPrint('Uploading ${user['name']} Data');
        final credential = await auth.createUserWithEmailAndPassword(
          email: user['email']!,
          password: 'Password123',
        );
        await _saveUserToDatabase(
          userId: credential.user!.uid,
          fullname: user['name']!,
          email: user['email']!,
        );
      }
      debugPrint('Users Dummy Data Uploaded Successfully');
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> _saveUserToDatabase({
    required String userId,
    required String fullname,
    required String email,
  }) async {
    final user = UserModel(
      id: userId,
      fullName: fullname,
      email: email,
      createdAt: Timestamp.now(),
    );

    await firestore.collection('users').doc(userId).set(user.toMap());
    final userStat = UserStatModel(
      userId: userId,
      storiesCount: 0,
      diariesCount: 0,
      followersCount: 0,
      followingCount: 0,
      totalLikesReceived: 0,
      totalReadsReceived: 0,
      commentsCount: 0,
      savedStoriesCount: 0,
    );
    await firestore.collection('user_stats').doc(userId).set(userStat.toMap());
  }

  Future<void> uploadUserStory() async {
    try {
      final random = Random();
      debugPrint('Uploading Stories Wait for some time');
      for (final userId in testUserIds) {
        // Each user gets 5–10 stories
        final int storyCount = 5 + random.nextInt(6);

        for (int i = 0; i < storyCount; i++) {
          final bool isPublished = true;

          // Spread timestamps in last 60 days
          final createdAt = Timestamp.now();

          final List<Map<String, dynamic>> chapters = List.generate(3, (index) {
            final content = _generateLongContent() + _generateLongContent();

            return {
              'id': 'ch_${index + 1}',
              'title': 'Chapter ${index + 1}',
              'content': content,
              'wordCount': content.split(RegExp(r'\s+')).length,
            };
          });

          final storyData = {
            'userId': userId,
            'title': dummyTitles[random.nextInt(dummyTitles.length)],
            'tags': [dummyGenres[random.nextInt(dummyGenres.length)]],
            'chapters': chapters,
            'createdAt': createdAt,
            'isPublished': isPublished,
            'publishedAt': Timestamp.now(),
            'generatedByAI': false,
            'coverImageUrl': dummyCovers[random.nextInt(dummyCovers.length)],
          };

          debugPrint('Uploading story for $userId');
          await _uploadStory(storyData);
        }
      }

      debugPrint('🔥 All Dummy Stories Uploaded Successfully');
    } catch (e) {
      debugPrint('❌ Error Uploading Stories $e');
    }
  }

  Future<void> _uploadStory(Map<String, dynamic> data) async {
    try {
      String storyId = Uuid().v4();
      final chapters = (data['chapters'] as List)
          .map((e) => StoryChapterModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
      final StoryModel newStory = StoryModel(
        id: storyId,
        userId: data['userId'],
        title: data['title'],
        tags: List.from(data['tags'] ?? []),
        chapters: chapters,
        createdAt: Timestamp.now(),
        isPublished: data['isPublished'],
        coverImageUrl: data['coverImageUrl'],
        publishedAt: data['publishedAt'],
        generatedByAI: data['generatedByAI'],
      );

      await firestore.collection('stories').doc(storyId).set(newStory.toMap());

      await firestore.collection('story_stats').doc(storyId).set({
        'storyId': storyId,
        'reads': 0,
        'likes': 0,
        'comments': 0,
        'saved': 0,
        'trendingScore': 1,
      });
    } catch (e) {
      debugPrint('Error Uploading Story');
    }
  }

  Future<void> addTitleLowerToStories() async {
    final firestore = FirebaseFirestore.instance;

    try {
      final snapshot = await firestore.collection('stories').get();

      final batch = firestore.batch();

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final title = data['title'];

        if (title != null && title is String) {
          batch.update(doc.reference, {'titleLower': title.toLowerCase()});
        }
        debugPrint('Updated Title of $title');
      }

      await batch.commit();

      debugPrint('✅ titleLower added to all stories');
    } catch (e) {
      debugPrint('❌ Error updating stories: $e');
    }
  }

  Future<void> fixStoriesCount() async {
    try {
      debugPrint(
        '🔧 Starting storiesCount fix for ${testUserIds.length} users...',
      );

      for (final userId in testUserIds) {
        final snapshot = await firestore
            .collection('stories')
            .where('userId', isEqualTo: userId)
            .where('isPublished', isEqualTo: true)
            .get();

        final count = snapshot.docs.length;

        await firestore.collection('user_stats').doc(userId).update({
          'storiesCount': count,
        });

        debugPrint('✅ $userId → $count stories');
      }

      debugPrint('🎉 storiesCount fix completed for all users');
    } catch (e) {
      debugPrint('❌ Error fixing storiesCount: $e');
    }
  }
}
