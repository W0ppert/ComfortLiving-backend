-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Gegenereerd op: 06 nov 2024 om 10:50
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
  `klantid` int(11) NOT NULL,
  `teken_datum` date NOT NULL,
  `verval_datum` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `contracten`
--

INSERT INTO `contracten` (`id`, `pandid`, `klantid`, `teken_datum`, `verval_datum`) VALUES
(1, 1, 2, '2024-10-23', NULL);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `externepartij`
--

CREATE TABLE `externepartij` (
  `id` int(11) NOT NULL,
  `bedrijfsnaam` varchar(50) NOT NULL,
  `contactpersoon` varchar(255) NOT NULL,
  `email_bedrijf` varchar(256) NOT NULL,
  `telefoonnummer_bedrijf` varchar(11) NOT NULL,
  `email_contactpersoon` varchar(255) NOT NULL,
  `telefoon_contactpersoon` int(13) NOT NULL,
  `servicetype_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `externepartij`
--

INSERT INTO `externepartij` (`id`, `bedrijfsnaam`, `contactpersoon`, `email_bedrijf`, `telefoonnummer_bedrijf`, `email_contactpersoon`, `telefoon_contactpersoon`, `servicetype_id`) VALUES
(1, 'Loodgieter maakt alles', '', 'info@lma.nl', '0123456789', '', 0, 0),
(2, 'Miontage bedrijf monteurs', '', 'info@mbm.nl', '01234567980', '', 0, 0);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `inschrijvingen`
--

CREATE TABLE `inschrijvingen` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `pandid` int(11) NOT NULL,
  `hoeveel_personen` int(11) NOT NULL,
  `datum` timestamp NOT NULL DEFAULT current_timestamp(),
  `jaar_inkomen` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `inschrijvingen`
--

INSERT INTO `inschrijvingen` (`id`, `userid`, `pandid`, `hoeveel_personen`, `datum`, `jaar_inkomen`) VALUES
(1, 0, 0, 3, '2024-10-11 11:18:55', '');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `klanten`
--

CREATE TABLE `klanten` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `voornaam` varchar(256) NOT NULL,
  `tussenvoegsel` varchar(15) DEFAULT NULL,
  `achternaam` varchar(255) NOT NULL,
  `geslacht` varchar(255) NOT NULL,
  `geboortedatum` date NOT NULL,
  `huidig_woonadres` varchar(255) NOT NULL,
  `telefoonnummer` int(13) DEFAULT NULL,
  `bruto_jaarinkomen` bigint(20) DEFAULT NULL,
  `bewijs_jaarinkomen` varchar(255) DEFAULT NULL,
  `voorkeur_plaats` varchar(255) DEFAULT NULL,
  `straal_voorkeurs_plaats` bigint(255) DEFAULT NULL,
  `wachtwoord` varchar(200) NOT NULL,
  `email_verificatie_datum` date DEFAULT NULL,
  `leeftijd_verificatie_datum` date DEFAULT NULL,
  `klant_aanmaak_datum` datetime DEFAULT current_timestamp(),
  `opmerkingen` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `klanten`
--

INSERT INTO `klanten` (`id`, `email`, `voornaam`, `tussenvoegsel`, `achternaam`, `geslacht`, `geboortedatum`, `huidig_woonadres`, `telefoonnummer`, `bruto_jaarinkomen`, `bewijs_jaarinkomen`, `voorkeur_plaats`, `straal_voorkeurs_plaats`, `wachtwoord`, `email_verificatie_datum`, `leeftijd_verificatie_datum`, `klant_aanmaak_datum`, `opmerkingen`) VALUES
(2, '', '', NULL, 'Koos', '', '0000-00-00', '', NULL, NULL, '', '', NULL, '', NULL, NULL, NULL, ''),
(3, '', 'hoer', '', 'Koos', '', '1899-11-30', '', NULL, NULL, '', '', NULL, '', NULL, NULL, NULL, ''),
(4, '', 'Jan', '', 'Jansen', 'Man', '1990-05-15', 'Hoofdstraat 123', NULL, NULL, '', '', NULL, '', NULL, NULL, NULL, ''),
(5, '', 'Jan', '', 'Jansen', 'Man', '1990-05-15', 'Hoofdstraat123', 688532756, NULL, '', '', NULL, '', NULL, NULL, NULL, ''),
(6, '', 'Jan', '', 'Jansen', 'Man', '1990-05-15', 'Hoofdstraat123', 688532756, NULL, '', '', NULL, '', NULL, NULL, NULL, ''),
(7, '', 'Mario', '', 'Jansen', 'Man', '1990-05-15', 'Hoofdstraat123', 688532756, NULL, '', '', NULL, '', NULL, NULL, NULL, ''),
(8, '', 'John', '', 'Doe', 'Man', '1990-01-01', '123 Main St', 123456789, NULL, '', '', NULL, '', NULL, NULL, NULL, ''),
(9, '', 'Dwayne', '', 'Jansen', 'Man', '1990-05-15', 'Hoofdstraat 124', NULL, NULL, '', '', NULL, '$2b$10$QwVWyE1pOMo/mMsyDEASu.tKm', NULL, NULL, NULL, ''),
(10, '', 'Merel', '', 'Jansen', 'Man', '1990-05-15', 'Hoofdstraat 1234', NULL, NULL, '', '', NULL, '$2b$10$6YipFQJizq5I3IOBd7//queup', NULL, NULL, NULL, ''),
(11, '', 'Jordy', '', 'Jansen', 'Man', '1990-05-15', 'Hoofdstraat 1234', NULL, NULL, '', '', NULL, '$2b$10$zNDmC/EBiyWA4lo2kAk.JeQGXNk1xYNtmywjvE.DisUI2sekMjYYW', NULL, NULL, NULL, ''),
(13, '97099231@st.deltion.nl', 'Dwayne', NULL, 'Piest', 'M', '2005-11-01', 'Schoolweg 11', 685532869, NULL, '', '', NULL, '$2b$10$kFBh1D0iG3N6rS0sI0l2J.5yUqFKV0HWrphZ6eJnJ3RyhOMUiOtQi', '2024-10-23', NULL, '2024-10-23 00:00:00', '');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `medewerkers`
--

CREATE TABLE `medewerkers` (
  `id` int(11) NOT NULL,
  `voornaam` varchar(255) NOT NULL,
  `tussenvoegsel` varchar(15) NOT NULL,
  `achternaam` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `contract_uren` int(43) NOT NULL,
  `geboortedatum` date DEFAULT NULL,
  `wachtwoord` varchar(255) NOT NULL,
  `telefoonnummer` int(13) NOT NULL,
  `geslacht` varchar(3) NOT NULL,
  `contract_verval_datum` date DEFAULT NULL,
  `huidig_adres` varchar(255) NOT NULL,
  `opmerkingen` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `medewerkers`
--

INSERT INTO `medewerkers` (`id`, `voornaam`, `tussenvoegsel`, `achternaam`, `email`, `contract_uren`, `geboortedatum`, `wachtwoord`, `telefoonnummer`, `geslacht`, `contract_verval_datum`, `huidig_adres`, `opmerkingen`) VALUES
(1, 'Jan', 'van', 'Dijk', 'jan.vandijk@example.com', 40, '1990-05-12', 'wachtwoord123', 612345678, 'M', '2025-05-12', 'Hoofdstraat 123, 1234AB Amsterdam', 'Geen opmerkingen'),
(2, 'Maria', 'de', 'Vries', 'maria.devries@example.com', 32, '1985-07-23', 'wachtwoord456', 618765432, 'V', '2024-07-23', 'Dorpsstraat 45, 2345CD Rotterdam', 'Part-time medewerker'),
(3, 'Peter', '', 'Jansen', 'peter.jansen@example.com', 40, '1992-11-15', 'wachtwoord789', 623456789, 'M', '2026-11-15', 'Parklaan 78, 3456EF Utrecht', 'Voltijd'),
(4, 'Sanne', 'van', 'Berg', 'sanne.vanberg@example.com', 20, '1998-03-30', 'wachtwoord012', 698765432, 'V', '2025-03-30', 'Lindelaan 12, 4567GH Eindhoven', 'Stagiair'),
(5, 'Tom', '', 'Smit', 'tom.smit@example.com', 36, '1987-09-05', 'wachtwoord345', 645678910, 'M', '2024-09-05', 'Waterweg 56, 5678IJ Den Haag', 'Contractverlenging in aanvraag');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `panden`
--

CREATE TABLE `panden` (
  `id` int(11) NOT NULL,
  `straat` varchar(256) NOT NULL,
  `huisnummer` varchar(8) NOT NULL,
  `bij_voegsel` varchar(2) DEFAULT NULL,
  `postcode` varchar(6) NOT NULL,
  `plaats` varchar(100) NOT NULL,
  `foto's` blob NOT NULL,
  `prijs` bigint(20) NOT NULL,
  `omschrijving` longtext NOT NULL,
  `oppervlakte` bigint(20) NOT NULL COMMENT 'Altijd in m²',
  `energielabel` varchar(2) NOT NULL,
  `slaapkamers` int(50) NOT NULL,
  `aangeboden_sinds` datetime NOT NULL DEFAULT current_timestamp(),
  `type` varchar(15) NOT NULL,
  `GPS` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `panden`
--

INSERT INTO `panden` (`id`, `straat`, `huisnummer`, `bij_voegsel`, `postcode`, `plaats`, `foto's`, `prijs`, `omschrijving`, `oppervlakte`, `energielabel`, `slaapkamers`, `aangeboden_sinds`, `type`, `GPS`) VALUES
(1, 'Dorpslaan', '12', '', '8000AZ', 'Zwolle', '', 0, 'Supermooie vrijstaande gezinswoning, met een redelijke grote tuin!\r\nHet is gelegen in een kind vriendelijke buurt en het is op een steenworp afstand van het winkelcentrum in Zwolle! ', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(2, 'Dorpslaan', '23', '', '8000AX', 'Zwolle', '', 0, 'Super mooie vrijstaande een persoons woning. Het is niet het meest grootste huis maar het is een prima huis voor 1 of 2 personen! Het centrum is zo\'n circa 15 minuten fietsen. Daarnaast is de bakker ook nog is om de hoek!\r\n\r\nJe redt het prima in je eentje!', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(3, 'Hoofdstraat', '1', '', '1234 A', 'Amsterdam', '', 0, 'Een mooie woning met uitzicht op het water.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(4, 'Dorpsstraat', '12', '', '2345 B', 'Utrecht', '', 0, 'Gezellige eengezinswoning met tuin.', 0, '', 0, '2024-10-21 00:00:00', 'recreatie', ''),
(5, 'Kerklaan', '5', '', '3456 C', 'Rotterdam', '', 0, 'Moderne woning in een rustige buurt.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(6, 'Burgemeesterstraat', '8', '', '4567 D', 'Den Haag', '', 0, 'Charmante woning nabij het centrum.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(7, 'Lindenlaan', '15', '', '5678 E', 'Eindhoven', '', 0, 'Ruime woning met veel lichtinval.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(8, 'Vijverweg', '20', '', '6789 F', 'Groningen', '', 0, 'Prachtige woning met tuin en zwembad.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(9, 'Achterweg', '22', '', '7890 G', 'Maastricht', '', 0, 'Luxe appartement met balkon en uitzicht.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(10, 'Bosweg', '30', '', '8901 H', 'Nijmegen', '', 0, 'Gezellige bungalow in een groene omgeving.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(11, 'Zonstraat', '18', '', '9012 I', 'Leiden', '', 0, 'Charmante woning met originele details.', 0, '', 0, '2024-10-21 00:00:00', 'recreatie', ''),
(12, 'Zilverlaan', '2', '', '0123 J', 'Haarlem', '', 0, 'Moderne stadswoning met dakterras.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(13, 'Eikenlaan', '4', '', '1234 K', 'Tilburg', '', 0, 'Riante eengezinswoning met garage.', 0, '', 0, '2024-10-21 00:00:00', 'recreatie', ''),
(14, 'Hofstraat', '6', '', '2345 L', 'Almere', '', 0, 'Ruime woning met zonnepanelen.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(15, 'Heuvelweg', '8', '', '3456 M', 'Breda', '', 0, 'Statige villa in een rustige wijk.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(16, 'Westerstraat', '10', '', '4567 N', 'Haarlemmermeer', '', 0, 'Karakteristieke woning met tuin.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(17, 'Plataanweg', '12', '', '5678 O', 'Dordrecht', '', 0, 'Instapklare woning met moderne afwerking.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(18, 'Oostlaan', '14', '', '6789 Q', 'Leeuwarden', '', 0, 'Huis met veel ruimte en een fijne tuin.', 0, '', 0, '2024-10-21 00:00:00', 'recreatie', ''),
(19, 'Westersingel', '16', '', '7890 R', 'Den Bosch', '', 0, 'Woning met historische elementen en modern comfort.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(20, 'Noordweg', '17', '', '8901 S', 'Hengelo', '', 0, 'Leuke starterswoning met leuke buurt.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(21, 'Zuidlaan', '19', '', '9012 T', 'Enschede', '', 0, 'Woning met ruime kamers en een open keuken.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(22, 'Tuinweg', '21', '', '0123 U', 'Helmond', '', 0, 'Nette woning met een zonnige tuin.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(23, 'Laan van Meerdervoort', '23', '', '1234 V', 'Arnhem', '', 0, 'Ruime gezinswoning nabij school en park.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(24, 'Kloosterstraat', '25', '', '2345 W', 'Amersfoort', '', 0, 'Klassieke woning met moderne upgrades.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(25, 'Steenweg', '27', '', '3456 X', 'Gouda', '', 0, 'Huis met veel karakter en een grote tuin.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(26, 'Molenstraat', '29', '', '4567 Y', 'Utrecht', '', 0, 'Leuke hoekwoning met een balkon.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(27, 'Windsingel', '31', '', '5678 A', 'Hoofddorp', '', 0, 'Fijne woning met veel lichtinval.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(28, 'Kasteelweg', '33', '', '6789 B', 'Amstelveen', '', 0, 'Moderne villa met grote oprit en tuin.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(29, 'Dorpsplein', '35', '', '7890 C', 'Leiden', '', 0, 'Schitterende woning in het hart van het dorp.', 0, '', 0, '2024-10-21 00:00:00', 'recreatie', ''),
(30, 'Havenstraat', '37', '', '8901 D', 'Groningen', '', 0, 'Prachtig appartement met uitzicht op de haven.', 0, '', 0, '2024-10-21 00:00:00', 'recreatie', ''),
(31, 'Rivierenlaan', '39', '', '9012 E', 'Den Haag', '', 0, 'Instapklare woning met een nette afwerking.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(32, 'Schapenweg', '41', '', '0123 F', 'Almere', '', 0, 'Zeer ruime woning met moderne keuken.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(33, 'Fazantenlaan', '43', '', '1234 G', 'Breda', '', 0, 'Luxe villa in een rustige straat.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(34, 'Heuvelweg', '45', '', '2345 H', 'Utrecht', '', 0, 'Woning met grote tuin en schuurtje.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(35, 'Kraaienlaan', '47', '', '3456 I', 'Tilburg', '', 0, 'Gezellige eengezinswoning met garage.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(36, 'Valkenhorst', '49', '', '4567 J', 'Den Bosch', '', 0, 'Charmante woning met een heerlijke tuin.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(37, 'Rozenlaan', '51', '', '5678 K', 'Haarlem', '', 0, 'Moderne woning met zonnepanelen.', 0, '', 0, '2024-10-21 00:00:00', 'recreatie', ''),
(38, 'Bovenweg', '53', '', '6789 L', 'Nijmegen', '', 0, 'Licht en ruim appartement met balkon.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(39, 'Oudeweg', '55', '', '7890 M', 'Gouda', '', 0, 'Instapklare woning in een rustige buurt.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(40, 'Dijkstraat', '57', '', '8901 N', 'Haarlemmermeer', '', 0, 'Woning met een grote tuin en terras.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(41, 'Bovenweg', '59', '', '9012 O', 'Enschede', '', 0, 'Nette woning dichtbij het centrum.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(42, 'Weteringstraat', '61', '', '0123 P', 'Dordrecht', '', 0, 'Ruime woning met veel slaapkamers.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(43, 'Zevenheuvelen', '63', '', '1234 Q', 'Leeuwarden', '', 0, 'Zeer ruime woning met garage en tuin.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(44, 'Zuidwal', '65', '', '2345 R', 'Maastricht', '', 0, 'Prachtige villa met uitzicht op de Maas.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(45, 'Hoogstraat', '67', '', '3456 S', 'Hengelo', '', 0, 'Moderne woning met ruime woonkamer.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(46, 'Kerklaan', '69', '', '4567 T', 'Breda', '', 0, 'Charmante woning met karakter.', 0, '', 0, '2024-10-21 00:00:00', 'recreatie', ''),
(47, 'Weg naar beneden', '71', '', '5678 U', 'Amersfoort', '', 0, 'Fijne woning in een kindvriendelijke buurt.', 0, '', 0, '2024-10-21 00:00:00', 'recreatie', ''),
(48, 'Hoofdweg', '73', '', '6789 V', 'Almere', '', 0, 'Woning met moderne afwerking en tuin.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(49, 'Spaarndammerstraat', '75', '', '7890 W', 'Groningen', '', 0, 'Ruime woning met een prachtige tuin.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(50, 'Hoogstraat', '77', '', '8901 X', 'Den Haag', '', 0, 'Luxe appartement in een levendige buurt.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(51, 'Beukenlaan', '79', '', '9012 Y', 'Tilburg', '', 0, 'Gezellige woning met veel karakter.', 0, '', 0, '2024-10-21 00:00:00', 'huur', '');

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
  `contract_id` int(11) DEFAULT NULL,
  `servicetype_id` int(11) DEFAULT NULL,
  `datum_aanvraag` datetime NOT NULL DEFAULT current_timestamp(),
  `datum_afhandeling` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `serviceverzoek`
--

INSERT INTO `serviceverzoek` (`id`, `omschrijving`, `contract_id`, `servicetype_id`, `datum_aanvraag`, `datum_afhandeling`) VALUES
(1, 'Kraan lekt', 1, 2, '2024-05-16 18:38:15', '2024-10-21'),
(7, 'dikke vette peace', NULL, NULL, '2024-10-23 11:30:19', NULL);

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
-- Indexen voor tabel `inschrijvingen`
--
ALTER TABLE `inschrijvingen`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `klanten`
--
ALTER TABLE `klanten`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `medewerkers`
--
ALTER TABLE `medewerkers`
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
  ADD KEY `Fk_contract` (`contract_id`);

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
-- AUTO_INCREMENT voor een tabel `inschrijvingen`
--
ALTER TABLE `inschrijvingen`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT voor een tabel `klanten`
--
ALTER TABLE `klanten`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT voor een tabel `medewerkers`
--
ALTER TABLE `medewerkers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT voor een tabel `servicetype`
--
ALTER TABLE `servicetype`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT voor een tabel `serviceverzoek`
--
ALTER TABLE `serviceverzoek`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

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
