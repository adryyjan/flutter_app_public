// const jsonData = '''
// {
//     "Lokal1": {
//         "id": "Lokal1_52.227399999999996_21.0285",
//         "nazwa": "Lokal1",
//         "rodzaj_lokalu": "klub muzyczny",
//         "glowna_specjalonsc": "Fancy drineczki",
//         "strefa_palenia": "0",
//         "na_randke": "0",
//         "przystosowany": "1",
//         "ocena": "0.69",
//         "x_cord": "52.227399999999996",
//         "y_cord": "21.0285",
//         "halas": "0.45",
//         "bezpieczenstwo": "3.24",
//         "opis": "Gowno opis 123 moze nawet dluzszy aaaaaaaaa",
//         "czystosc": "2.81",
//         "atmosfera": "4.01",
//         "kameralnosc": "0.0",
//         "muzyka": "4.3",
//         "personel": "3.14",
//         "users_rating": 0,
//         "liczba_ocen": 0
//     },
//     "Lokal2": {
//         "id": "Lokal2_52.279399999999995_21.063200000000002",
//         "nazwa": "Lokal2",
//         "rodzaj_lokalu": "Bar",
//         "glowna_specjalonsc": "Shoty",
//         "strefa_palenia": "0",
//         "na_randke": "0",
//         "przystosowany": "1",
//         "ocena": "1.45",
//         "x_cord": "52.279399999999995",
//         "y_cord": "21.063200000000002",
//         "halas": "1.61",
//         "bezpieczenstwo": "1.83",
//         "opis": "Gowno opis 123 moze nawet dluzszy aaaaaaaaa",
//         "czystosc": "2.97",
//         "atmosfera": "4.19",
//         "kameralnosc": "0.21",
//         "muzyka": "0.97",
//         "personel": "3.58",
//         "users_rating": 0,
//         "liczba_ocen": 0
//     },
//     "Lokal3": {
//         "id": "Lokal3_52.2215_21.028200000000002",
//         "nazwa": "Lokal3",
//         "rodzaj_lokalu": "Koktajlbar",
//         "glowna_specjalonsc": "Piwko",
//         "strefa_palenia": "1",
//         "na_randke": "0",
//         "przystosowany": "0",
//         "ocena": "2.04",
//         "x_cord": "52.2215",
//         "y_cord": "21.028200000000002",
//         "halas": "0.96",
//         "bezpieczenstwo": "1.22",
//         "opis": "Gowno opis 123 moze nawet dluzszy aaaaaaaaa",
//         "czystosc": "0.52",
//         "atmosfera": "4.14",
//         "kameralnosc": "2.58",
//         "muzyka": "1.06",
//         "personel": "2.08",
//         "users_rating": 0,
//         "liczba_ocen": 0
//     },
//     "Lokal4": {
//         "id": "Lokal4_52.2993_21.093400000000003",
//         "nazwa": "Lokal4",
//         "rodzaj_lokalu": "Pub",
//         "glowna_specjalonsc": "Fancy drineczki",
//         "strefa_palenia": "0",
//         "na_randke": "0",
//         "przystosowany": "1",
//         "ocena": "1.28",
//         "x_cord": "52.2993",
//         "y_cord": "21.093400000000003",
//         "halas": "0.36",
//         "bezpieczenstwo": "3.5",
//         "opis": "Gowno opis 123 moze nawet dluzszy aaaaaaaaa",
//         "czystosc": "1.01",
//         "atmosfera": "4.96",
//         "kameralnosc": "1.01",
//         "muzyka": "0.8",
//         "personel": "3.46",
//         "users_rating": 0,
//         "liczba_ocen": 0
//     },
//     "Lokal5": {
//         "id": "Lokal5_52.2382_21.089100000000002",
//         "nazwa": "Lokal5",
//         "rodzaj_lokalu": "klub muzyczny",
//         "glowna_specjalonsc": "Koktajle",
//         "strefa_palenia": "1",
//         "na_randke": "1",
//         "przystosowany": "0",
//         "ocena": "3.83",
//         "x_cord": "52.2382",
//         "y_cord": "21.089100000000002",
//         "halas": "4.7",
//         "bezpieczenstwo": "2.67",
//         "opis": "Gowno opis 123 moze nawet dluzszy aaaaaaaaa",
//         "czystosc": "4.99",
//         "atmosfera": "3.98",
//         "kameralnosc": "4.83",
//         "muzyka": "1.4",
//         "personel": "1.73",
//         "users_rating": 0,
//         "liczba_ocen": 0
//     },
//     "Lokal6": {
//         "id": "Lokal6_52.3119_21.035600000000002",
//         "nazwa": "Lokal6",
//         "rodzaj_lokalu": "Koktajlbar",
//         "glowna_specjalonsc": "Piwko Craftowe",
//         "strefa_palenia": "1",
//         "na_randke": "1",
//         "przystosowany": "1",
//         "ocena": "4.94",
//         "x_cord": "52.3119",
//         "y_cord": "21.035600000000002",
//         "halas": "1.13",
//         "bezpieczenstwo": "0.99",
//         "opis": "Gowno opis 123 moze nawet dluzszy aaaaaaaaa",
//         "czystosc": "0.79",
//         "atmosfera": "2.95",
//         "kameralnosc": "3.89",
//         "muzyka": "4.67",
//         "personel": "4.15",
//         "users_rating": 5,
//         "liczba_ocen": 2
//     },
//     "Lokal7": {
//         "id": "Lokal7_52.2936_21.0987",
//         "nazwa": "Lokal7",
//         "rodzaj_lokalu": "Piwiarnia",
//         "glowna_specjalonsc": "Fancy drineczki",
//         "strefa_palenia": "1",
//         "na_randke": "1",
//         "przystosowany": "1",
//         "ocena": "0.2",
//         "x_cord": "52.2936",
//         "y_cord": "21.0987",
//         "halas": "3.75",
//         "bezpieczenstwo": "1.69",
//         "opis": "Gowno opis 123 moze nawet dluzszy aaaaaaaaa",
//         "czystosc": "2.55",
//         "atmosfera": "2.37",
//         "kameralnosc": "4.51",
//         "muzyka": "0.88",
//         "personel": "1.73",
//         "users_rating": 0,
//         "liczba_ocen": 0
//     },
//     "Lokal8": {
//         "id": "Lokal8_52.2675_21.070800000000002",
//         "nazwa": "Lokal8",
//         "rodzaj_lokalu": "Piwiarnia",
//         "glowna_specjalonsc": "Piwko",
//         "strefa_palenia": "1",
//         "na_randke": "0",
//         "przystosowany": "0",
//         "ocena": "1.18",
//         "x_cord": "52.2675",
//         "y_cord": "21.070800000000002",
//         "halas": "1.74",
//         "bezpieczenstwo": "3.07",
//         "opis": "Gowno opis 123 moze nawet dluzszy aaaaaaaaa",
//         "czystosc": "3.61",
//         "atmosfera": "1.19",
//         "kameralnosc": "1.79",
//         "muzyka": "0.61",
//         "personel": "3.43",
//         "users_rating": 0,
//         "liczba_ocen": 0
//     },
//     "Lokal9": {
//         "id": "Lokal9_52.267199999999995_21.0176",
//         "nazwa": "Lokal9",
//         "rodzaj_lokalu": "Bar",
//         "glowna_specjalonsc": "Fancy drineczki",
//         "strefa_palenia": "1",
//         "na_randke": "1",
//         "przystosowany": "0",
//         "ocena": "2.97",
//         "x_cord": "52.267199999999995",
//         "y_cord": "21.0176",
//         "halas": "0.06",
//         "bezpieczenstwo": "2.21",
//         "opis": "Gowno opis 123 moze nawet dluzszy aaaaaaaaa",
//         "czystosc": "2.36",
//         "atmosfera": "1.07",
//         "kameralnosc": "2.62",
//         "muzyka": "0.22",
//         "personel": "4.12",
//         "users_rating": 0,
//         "liczba_ocen": 0
//     },
//     "Lokal10": {
//         "id": "Lokal10_52.2915_21.067400000000003",
//         "nazwa": "Lokal10",
//         "rodzaj_lokalu": "Pub",
//         "glowna_specjalonsc": "Drineczki",
//         "strefa_palenia": "0",
//         "na_randke": "0",
//         "przystosowany": "0",
//         "ocena": "0.96",
//         "x_cord": "52.2915",
//         "y_cord": "21.067400000000003",
//         "halas": "0.54",
//         "bezpieczenstwo": "2.18",
//         "opis": "Gowno opis 123 moze nawet dluzszy aaaaaaaaa",
//         "czystosc": "0.06",
//         "atmosfera": "4.47",
//         "kameralnosc": "3.61",
//         "muzyka": "0.74",
//         "personel": "2.65",
//         "users_rating": 0,
//         "liczba_ocen": 0
//     }
// }
//   ''';
//
// const ofertData = '''
// {
//     "Ofert1": {
//         "id": "Lokal1_52.227399999999996_21.0285",
//         "nazwa": "Lokal1",
//         "oferta": "Ladies Night",
//         "opis_oferta": "-20%",
//         "przedmiot_oferty": "PIWO",
//         "data": "14.06.2025",
//         "czas": "24 - 4",
//         "cena": "20 zl",
//         "wielorazowa": "Nie"
//     },
//     "Ofert2": {
//         "id": "Lokal2_52.279399999999995_21.063200000000002",
//         "nazwa": "Lokal2",
//         "oferta": "Happy Hours",
//         "opis_oferta": "3 za 1",
//         "przedmiot_oferty": "ALL",
//         "data": "30.06.2025",
//         "czas": "23 - 3",
//         "cena": "20 zl",
//         "wielorazowa": "Tak"
//     },
//     "Ofert3": {
//         "id": "Lokal3_52.2215_21.028200000000002",
//         "nazwa": "Lokal3",
//         "oferta": "Boys night",
//         "opis_oferta": "-20%",
//         "przedmiot_oferty": "DRINECZKI",
//         "data": "8.11.2025",
//         "czas": "22 - 2",
//         "cena": "54 zl",
//         "wielorazowa": "Tak"
//     },
//     "Ofert4": {
//         "id": "Lokal4_52.2993_21.093400000000003",
//         "nazwa": "Lokal4",
//         "oferta": "Boys night",
//         "opis_oferta": "-35%",
//         "przedmiot_oferty": "DRINECZKI",
//         "data": "8.04.2025",
//         "czas": "19 - 23",
//         "cena": "20 zl",
//         "wielorazowa": "Nie"
//     },
//     "Ofert5": {
//         "id": "Lokal5_52.2382_21.089100000000002",
//         "nazwa": "Lokal5",
//         "oferta": "Happy Hours",
//         "opis_oferta": "3 za 1",
//         "przedmiot_oferty": "SHOTY",
//         "data": "16.04.2025",
//         "czas": "16 - 20",
//         "cena": "54 zl",
//         "wielorazowa": "Nie"
//     },
//     "Ofert6": {
//         "id": "Lokal6_52.3119_21.035600000000002",
//         "nazwa": "Lokal6",
//         "oferta": "Ladies Night",
//         "opis_oferta": "3 za 1",
//         "przedmiot_oferty": "ALL",
//         "data": "5.08.2025",
//         "czas": "24 - 4",
//         "cena": "12 zl",
//         "wielorazowa": "Tak"
//     },
//     "Ofert7": {
//         "id": "Lokal7_52.2936_21.0987",
//         "nazwa": "Lokal7",
//         "oferta": "Boys night",
//         "opis_oferta": "-50%",
//         "przedmiot_oferty": "ALL",
//         "data": "4.12.2025",
//         "czas": "23 - 3",
//         "cena": "7 zl",
//         "wielorazowa": "Nie"
//     },
//     "Ofert8": {
//         "id": "Lokal8_52.2675_21.070800000000002",
//         "nazwa": "Lokal8",
//         "oferta": "Warto studiowac",
//         "opis_oferta": "2 za 1",
//         "przedmiot_oferty": "DRINECZKI",
//         "data": "10.05.2025",
//         "czas": "17 - 21",
//         "cena": "20 zl",
//         "wielorazowa": "Tak"
//     },
//     "Ofert9": {
//         "id": "Lokal9_52.267199999999995_21.0176",
//         "nazwa": "Lokal9",
//         "oferta": "Beer Bucket",
//         "opis_oferta": "-15%",
//         "przedmiot_oferty": "PIWO",
//         "data": "26.06.2025",
//         "czas": "16 - 20",
//         "cena": "12 zl",
//         "wielorazowa": "Tak"
//     },
//     "Ofert10": {
//         "id": "Lokal10_52.2915_21.067400000000003",
//         "nazwa": "Lokal10",
//         "oferta": "Weekend Fun",
//         "opis_oferta": "-50%",
//         "przedmiot_oferty": "PIWO Z KIJA",
//         "data": "27.03.2025",
//         "czas": "21 - 1",
//         "cena": "19 zl",
//         "wielorazowa": "Tak"
//     }
// }
//   ''';
