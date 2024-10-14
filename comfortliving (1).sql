-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Gegenereerd op: 11 okt 2024 om 10:22
-- Serverversie: 10.4.32-MariaDB
-- PHP-versie: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `comfortliving`
--

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `contracten`
--

CREATE TABLE `contracten` (
  `id` int(11) NOT NULL,
  `pandid` int(11) NOT NULL,
  `klantid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `contracten`
--

INSERT INTO `contracten` (`id`, `pandid`, `klantid`) VALUES
(1, 1, 2),
(2, 2, 1);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `externepartij`
--

CREATE TABLE `externepartij` (
  `id` int(11) NOT NULL,
  `naam` varchar(50) NOT NULL,
  `email` varchar(256) NOT NULL,
  `telefoonnummer` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `externepartij`
--

INSERT INTO `externepartij` (`id`, `naam`, `email`, `telefoonnummer`) VALUES
(1, 'Loodgieter maakt alles', 'info@lma.nl', '0123456789'),
(2, 'Miontage bedrijf monteurs', 'info@mbm.nl', '01234567980');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `klanten`
--

CREATE TABLE `klanten` (
  `id` int(11) NOT NULL,
  `naam` varchar(256) NOT NULL,
  `achternaam` varchar(255) NOT NULL,
  `Geslacht` int(2) NOT NULL,
  `Geboortedatum` bigint(20) NOT NULL,
  `Huidig Woonadres` varchar(255) NOT NULL,
  `Telefoonnummer` bigint(20) NOT NULL,
  `Bruto jaarinkomen` bigint(20) NOT NULL,
  `Bewijs jaarinkomen` varchar(255) NOT NULL,
  `Voorkeur plaats` varchar(255) NOT NULL,
  `Straal voorkeurs plaats` bigint(255) NOT NULL,
  `wachtwoord` varchar(42) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `klanten`
--

INSERT INTO `klanten` (`id`, `naam`, `achternaam`, `Geslacht`, `Geboortedatum`, `Huidig Woonadres`, `Telefoonnummer`, `Bruto jaarinkomen`, `Bewijs jaarinkomen`, `Voorkeur plaats`, `Straal voorkeurs plaats`, `wachtwoord`) VALUES
(1, 'Stegeman', '', 0, 0, '', 0, 0, '', '', 0, ''),
(2, 'Starreveld', '', 0, 0, '', 0, 0, '', '', 0, ''),
(3, 'hoer', '', 0, 0, '', 0, 0, '', '', 0, 'Jemoeder');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `panden`
--

CREATE TABLE `panden` (
  `id` int(11) NOT NULL,
  `postcode` varchar(6) NOT NULL,
  `straat` varchar(256) NOT NULL,
  `huisnummer` varchar(8) NOT NULL,
  `plaats` varchar(100) NOT NULL,
  `Omschrijving` longtext NOT NULL,
  `GPS` varchar(512) NOT NULL,
  `type` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `panden`
--

INSERT INTO `panden` (`id`, `postcode`, `straat`, `huisnummer`, `plaats`, `Omschrijving`, `GPS`, `type`) VALUES
(1, '8000AZ', 'Dorpslaan', '12', 'Zwolle', 'Supermooie vrijstaande gezinswoning, met een redelijke grote tuin!\r\nHet is gelegen in een kind vriendelijke buurt en het is op een steenworp afstand van het winkelcentrum in Zwolle! ', '', 'huur'),
(2, '8000AX', 'Dorpslaan', '23', 'Zwolle', 'Super mooie vrijstaande een persoons woning. Het is niet het meest grootste huis maar het is een prima huis voor 1 of 2 personen! Het centrum is zo\'n circa 15 minuten fietsen. Daarnaast is de bakker ook nog is om de hoek!\r\n\r\nJe redt het prima in je eentje!', '', 'huur'),
(3, '1234 A', 'Hoofdstraat', '1', 'Amsterdam', 'Een mooie woning met uitzicht op het water.', '', 'koop'),
(4, '2345 B', 'Dorpsstraat', '12', 'Utrecht', 'Gezellige eengezinswoning met tuin.', '', 'recreatie'),
(5, '3456 C', 'Kerklaan', '5', 'Rotterdam', 'Moderne woning in een rustige buurt.', '', 'koop'),
(6, '4567 D', 'Burgemeesterstraat', '8', 'Den Haag', 'Charmante woning nabij het centrum.', '', 'koop'),
(7, '5678 E', 'Lindenlaan', '15', 'Eindhoven', 'Ruime woning met veel lichtinval.', '', 'huur'),
(8, '6789 F', 'Vijverweg', '20', 'Groningen', 'Prachtige woning met tuin en zwembad.', '', 'huur'),
(9, '7890 G', 'Achterweg', '22', 'Maastricht', 'Luxe appartement met balkon en uitzicht.', '', 'koop'),
(10, '8901 H', 'Bosweg', '30', 'Nijmegen', 'Gezellige bungalow in een groene omgeving.', '', 'koop'),
(11, '9012 I', 'Zonstraat', '18', 'Leiden', 'Charmante woning met originele details.', '', 'recreatie'),
(12, '0123 J', 'Zilverlaan', '2', 'Haarlem', 'Moderne stadswoning met dakterras.', '', 'koop'),
(13, '1234 K', 'Eikenlaan', '4', 'Tilburg', 'Riante eengezinswoning met garage.', '', 'recreatie'),
(14, '2345 L', 'Hofstraat', '6', 'Almere', 'Ruime woning met zonnepanelen.', '', 'huur'),
(15, '3456 M', 'Heuvelweg', '8', 'Breda', 'Statige villa in een rustige wijk.', '', 'huur'),
(16, '4567 N', 'Westerstraat', '10', 'Haarlemmermeer', 'Karakteristieke woning met tuin.', '', 'huur'),
(17, '5678 O', 'Plataanweg', '12', 'Dordrecht', 'Instapklare woning met moderne afwerking.', '', 'huur'),
(18, '6789 Q', 'Oostlaan', '14', 'Leeuwarden', 'Huis met veel ruimte en een fijne tuin.', '', 'recreatie'),
(19, '7890 R', 'Westersingel', '16', 'Den Bosch', 'Woning met historische elementen en modern comfort.', '', 'huur'),
(20, '8901 S', 'Noordweg', '17', 'Hengelo', 'Leuke starterswoning met leuke buurt.', '', 'koop'),
(21, '9012 T', 'Zuidlaan', '19', 'Enschede', 'Woning met ruime kamers en een open keuken.', '', 'koop'),
(22, '0123 U', 'Tuinweg', '21', 'Helmond', 'Nette woning met een zonnige tuin.', '', 'huur'),
(23, '1234 V', 'Laan van Meerdervoort', '23', 'Arnhem', 'Ruime gezinswoning nabij school en park.', '', 'koop'),
(24, '2345 W', 'Kloosterstraat', '25', 'Amersfoort', 'Klassieke woning met moderne upgrades.', '', 'huur'),
(25, '3456 X', 'Steenweg', '27', 'Gouda', 'Huis met veel karakter en een grote tuin.', '', 'koop'),
(26, '4567 Y', 'Molenstraat', '29', 'Utrecht', 'Leuke hoekwoning met een balkon.', '', 'huur'),
(27, '5678 A', 'Windsingel', '31', 'Hoofddorp', 'Fijne woning met veel lichtinval.', '', 'huur'),
(28, '6789 B', 'Kasteelweg', '33', 'Amstelveen', 'Moderne villa met grote oprit en tuin.', '', 'koop'),
(29, '7890 C', 'Dorpsplein', '35', 'Leiden', 'Schitterende woning in het hart van het dorp.', '', 'recreatie'),
(30, '8901 D', 'Havenstraat', '37', 'Groningen', 'Prachtig appartement met uitzicht op de haven.', '', 'recreatie'),
(31, '9012 E', 'Rivierenlaan', '39', 'Den Haag', 'Instapklare woning met een nette afwerking.', '', 'koop'),
(32, '0123 F', 'Schapenweg', '41', 'Almere', 'Zeer ruime woning met moderne keuken.', '', 'huur'),
(33, '1234 G', 'Fazantenlaan', '43', 'Breda', 'Luxe villa in een rustige straat.', '', 'huur'),
(34, '2345 H', 'Heuvelweg', '45', 'Utrecht', 'Woning met grote tuin en schuurtje.', '', 'huur'),
(35, '3456 I', 'Kraaienlaan', '47', 'Tilburg', 'Gezellige eengezinswoning met garage.', '', 'koop'),
(36, '4567 J', 'Valkenhorst', '49', 'Den Bosch', 'Charmante woning met een heerlijke tuin.', '', 'koop'),
(37, '5678 K', 'Rozenlaan', '51', 'Haarlem', 'Moderne woning met zonnepanelen.', '', 'recreatie'),
(38, '6789 L', 'Bovenweg', '53', 'Nijmegen', 'Licht en ruim appartement met balkon.', '', 'koop'),
(39, '7890 M', 'Oudeweg', '55', 'Gouda', 'Instapklare woning in een rustige buurt.', '', 'huur'),
(40, '8901 N', 'Dijkstraat', '57', 'Haarlemmermeer', 'Woning met een grote tuin en terras.', '', 'huur'),
(41, '9012 O', 'Bovenweg', '59', 'Enschede', 'Nette woning dichtbij het centrum.', '', 'huur'),
(42, '0123 P', 'Weteringstraat', '61', 'Dordrecht', 'Ruime woning met veel slaapkamers.', '', 'huur'),
(43, '1234 Q', 'Zevenheuvelen', '63', 'Leeuwarden', 'Zeer ruime woning met garage en tuin.', '', 'koop'),
(44, '2345 R', 'Zuidwal', '65', 'Maastricht', 'Prachtige villa met uitzicht op de Maas.', '', 'koop'),
(45, '3456 S', 'Hoogstraat', '67', 'Hengelo', 'Moderne woning met ruime woonkamer.', '', 'koop'),
(46, '4567 T', 'Kerklaan', '69', 'Breda', 'Charmante woning met karakter.', '', 'recreatie'),
(47, '5678 U', 'Weg naar beneden', '71', 'Amersfoort', 'Fijne woning in een kindvriendelijke buurt.', '', 'recreatie'),
(48, '6789 V', 'Hoofdweg', '73', 'Almere', 'Woning met moderne afwerking en tuin.', '', 'koop'),
(49, '7890 W', 'Spaarndammerstraat', '75', 'Groningen', 'Ruime woning met een prachtige tuin.', '', 'huur'),
(50, '8901 X', 'Hoogstraat', '77', 'Den Haag', 'Luxe appartement in een levendige buurt.', '', 'koop'),
(51, '9012 Y', 'Beukenlaan', '79', 'Tilburg', 'Gezellige woning met veel karakter.', '', 'huur');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `servicetype`
--

CREATE TABLE `servicetype` (
  `id` int(11) NOT NULL,
  `omschrijving` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `servicetype`
--

INSERT INTO `servicetype` (`id`, `omschrijving`) VALUES
(1, 'Onderhoud buiten \r\n'),
(2, 'Onderhoud riool/sanitair'),
(3, 'Onderhoud binnen'),
(4, 'Bezichtiging (eerste bezoek) \r\n\r\n'),
(5, 'Onderhoud Elektra'),
(6, 'Onderhoud beveiliging');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `serviceverzoek`
--

CREATE TABLE `serviceverzoek` (
  `id` int(11) NOT NULL,
  `omschrijving` varchar(255) NOT NULL,
  `contract_Id` int(11) NOT NULL,
  `servicetype_id` int(11) NOT NULL,
  `datum` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `serviceverzoek`
--

INSERT INTO `serviceverzoek` (`id`, `omschrijving`, `contract_Id`, `servicetype_id`, `datum`) VALUES
(1, 'Kraan lekt', 1, 2, '2024-05-16 18:38:15'),
(2, 'Verwarming lekt', 2, 3, '2024-05-16 18:38:15');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `sv_stappen`
--

CREATE TABLE `sv_stappen` (
  `id` int(11) NOT NULL,
  `omschrijving` varchar(255) NOT NULL,
  `serviceverzoek_id` int(11) NOT NULL,
  `externepartij_id` int(11) NOT NULL,
  `datum` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `sv_stappen`
--

INSERT INTO `sv_stappen` (`id`, `omschrijving`, `serviceverzoek_id`, `externepartij_id`, `datum`) VALUES
(1, 'Even loodgieter gebeld om te fixen. komt vanmiddag langs', 1, 1, '2024-05-16 18:41:52');

--
-- Indexen voor geëxporteerde tabellen
--

--
-- Indexen voor tabel `contracten`
--
ALTER TABLE `contracten`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Fk_klant` (`klantid`),
  ADD KEY `Fk_pand` (`pandid`);

--
-- Indexen voor tabel `externepartij`
--
ALTER TABLE `externepartij`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `klanten`
--
ALTER TABLE `klanten`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `panden`
--
ALTER TABLE `panden`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `servicetype`
--
ALTER TABLE `servicetype`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `serviceverzoek`
--
ALTER TABLE `serviceverzoek`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Fk_servicetype` (`servicetype_id`),
  ADD KEY `Fk_contract` (`contract_Id`);

--
-- Indexen voor tabel `sv_stappen`
--
ALTER TABLE `sv_stappen`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_ServiceVerzoekId` (`serviceverzoek_id`),
  ADD KEY `Fk_externepartij` (`externepartij_id`);

--
-- AUTO_INCREMENT voor geëxporteerde tabellen
--

--
-- AUTO_INCREMENT voor een tabel `klanten`
--
ALTER TABLE `klanten`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT voor een tabel `servicetype`
--
ALTER TABLE `servicetype`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT voor een tabel `serviceverzoek`
--
ALTER TABLE `serviceverzoek`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Beperkingen voor geëxporteerde tabellen
--

--
-- Beperkingen voor tabel `contracten`
--
ALTER TABLE `contracten`
  ADD CONSTRAINT `Fk_klant` FOREIGN KEY (`klantid`) REFERENCES `klanten` (`id`),
  ADD CONSTRAINT `Fk_pand` FOREIGN KEY (`pandid`) REFERENCES `panden` (`id`);

--
-- Beperkingen voor tabel `serviceverzoek`
--
ALTER TABLE `serviceverzoek`
  ADD CONSTRAINT `Fk_contract` FOREIGN KEY (`contract_Id`) REFERENCES `contracten` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `Fk_servicetype` FOREIGN KEY (`servicetype_id`) REFERENCES `servicetype` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Beperkingen voor tabel `sv_stappen`
--
ALTER TABLE `sv_stappen`
  ADD CONSTRAINT `FK_ServiceVerzoekId` FOREIGN KEY (`serviceverzoek_id`) REFERENCES `serviceverzoek` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `Fk_externepartij` FOREIGN KEY (`externepartij_id`) REFERENCES `externepartij` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
