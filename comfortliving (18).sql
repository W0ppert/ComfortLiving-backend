-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Gegenereerd op: 11 nov 2024 om 15:34
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
(0, 'corendon', 'Michael', '', '0312345678', 'michael@example.com', 698765432, 0),
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
  `klant_aanmaak_datum` datetime NOT NULL DEFAULT current_timestamp(),
  `opmerkingen` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `klanten`
--

INSERT INTO `klanten` (`id`, `email`, `voornaam`, `tussenvoegsel`, `achternaam`, `geslacht`, `geboortedatum`, `huidig_woonadres`, `telefoonnummer`, `bruto_jaarinkomen`, `bewijs_jaarinkomen`, `voorkeur_plaats`, `straal_voorkeurs_plaats`, `wachtwoord`, `email_verificatie_datum`, `leeftijd_verificatie_datum`, `klant_aanmaak_datum`, `opmerkingen`) VALUES
(1, '97099231@st.deltion.nl', 'Dwayne', NULL, 'Piest', 'M', '2005-11-01', 'Schoolweg 11', 685532869, NULL, '', '', NULL, '$2b$10$Vx9it5W1IQj45vWjtCWeXeYNXXNVpiCTbgcWVOS8WypTfoa2rOOrq', '2024-10-23', NULL, '2024-10-23 00:00:00', ''),
(2, '', '', NULL, 'Koos', '', '0000-00-00', '', NULL, NULL, '', '', NULL, '', NULL, NULL, '0000-00-00 00:00:00', ''),
(3, '', 'hoer', '', 'Koos', '', '1899-11-30', '', NULL, NULL, '', '', NULL, '', NULL, NULL, '0000-00-00 00:00:00', ''),
(4, '', 'Jan', '', 'Jansen', 'Man', '1990-05-15', 'Hoofdstraat 123', NULL, NULL, '', '', NULL, '', NULL, NULL, '0000-00-00 00:00:00', ''),
(5, '', 'Jan', '', 'Jansen', 'Man', '1990-05-15', 'Hoofdstraat123', 688532756, NULL, '', '', NULL, '', NULL, NULL, '0000-00-00 00:00:00', ''),
(6, '', 'Jan', '', 'Jansen', 'Man', '1990-05-15', 'Hoofdstraat123', 688532756, NULL, '', '', NULL, '', NULL, NULL, '0000-00-00 00:00:00', ''),
(7, '', 'Mario', '', 'Jansen', 'Man', '1990-05-15', 'Hoofdstraat123', 688532756, NULL, '', '', NULL, '', NULL, NULL, '0000-00-00 00:00:00', ''),
(8, '', 'John', '', 'Doe', 'Man', '1990-01-01', '123 Main St', 123456789, NULL, '', '', NULL, '', NULL, NULL, '0000-00-00 00:00:00', ''),
(9, '', 'Dwayne', '', 'Jansen', 'Man', '1990-05-15', 'Hoofdstraat 124', NULL, NULL, '', '', NULL, '$2b$10$QwVWyE1pOMo/mMsyDEASu.tKm', NULL, NULL, '0000-00-00 00:00:00', ''),
(10, '', 'Merel', '', 'Jansen', 'Man', '1990-05-15', 'Hoofdstraat 1234', NULL, NULL, '', '', NULL, '$2b$10$6YipFQJizq5I3IOBd7//queup', NULL, NULL, '0000-00-00 00:00:00', ''),
(11, '', 'Jordy', '', 'Jansen', 'Man', '1990-05-15', 'Hoofdstraat 1234', NULL, NULL, '', '', NULL, '$2b$10$zNDmC/EBiyWA4lo2kAk.JeQGXNk1xYNtmywjvE.DisUI2sekMjYYW', NULL, NULL, '0000-00-00 00:00:00', ''),
(14, 'piet.devries@example.com', 'Piet', NULL, 'Vries', 'M', '1990-05-15', 'Dorpsstraat 45, 1234 AB Amsterdam', 612345678, NULL, NULL, NULL, NULL, '$2b$10$OMSuQ46UlXtGFKk6v90Ll.w1zI9dkukUgHF5mionUjCu.gQv3Avdu', NULL, NULL, '2024-11-08 15:42:18', NULL),
(15, 'voorbeeld@example.com', 'Jan', NULL, 'Dijk', 'Man', '2000-01-01', 'hoofddorp 11 ', 31, NULL, NULL, NULL, NULL, '$2b$10$7O6VBFN0bmV9W.dLzMvrDe6NUlRdPBoJ/rmlLgdLwCj8UEAN.QU6K', NULL, NULL, '2024-11-09 22:17:18', NULL);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `medewerkers`
--

CREATE TABLE `medewerkers` (
  `id` int(11) NOT NULL,
  `voornaam` varchar(255) NOT NULL,
  `tussenvoegsel` varchar(15) DEFAULT NULL,
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
(5, 'Tom', '', 'Smit', 'tom.smit@example.com', 36, '1987-09-05', 'wachtwoord345', 645678910, 'M', '2024-09-05', 'Waterweg 56, 5678IJ Den Haag', 'Contractverlenging in aanvraag'),
(6, 'Lisa', NULL, 'Diddy', 'lisa.devries@example.com', 32, '1990-09-15', 'veiligWachtwoord456', 611223344, 'V', '2024-11-30', 'Hoofdstraat 45, 1234 AB Utrecht', 'Werkzaam in HR-afdeling');

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
  `energielabel` char(1) NOT NULL,
  `slaapkamers` int(50) NOT NULL,
  `aangeboden_sinds` datetime NOT NULL DEFAULT current_timestamp(),
  `type` varchar(15) NOT NULL,
  `GPS` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `panden`
--

INSERT INTO `panden` (`id`, `straat`, `huisnummer`, `bij_voegsel`, `postcode`, `plaats`, `foto's`, `prijs`, `omschrijving`, `oppervlakte`, `energielabel`, `slaapkamers`, `aangeboden_sinds`, `type`, `GPS`) VALUES
(1, 'Kerkenbos ', '1101', '', '6546BC', 'Nijmegen', '', 0, 'Supermooie vrijstaande gezinswoning, met een redelijke grote tuin!\r\nHet is gelegen in een kind vriendelijke buurt en het is op een steenworp afstand van het winkelcentrum in Zwolle! ', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(2, 'Scharmbarg', '109', '', '9407EC', 'Assen', '', 2400, 'Super mooie vrijstaande een persoons woning. Het is niet het meest grootste huis maar het is een prima huis voor 1 of 2 personen! Het centrum is zo\'n circa 15 minuten fietsen. Daarnaast is de bakker ook nog is om de hoek!\r\n\r\nJe redt het prima in je eentje!', 205, 'C', 4, '2024-10-21 00:00:00', 'huur', ''),
(3, 'Brink', '23', '', '9401HT', 'Assen', '', 0, 'Een mooie woning met uitzicht op het water.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(4, 'Anjerstraat', '4', '', '7906LE', 'Hoogeveen', '', 0, 'Gezellige eengezinswoning met tuin.', 0, '', 0, '2024-10-21 00:00:00', 'recreatie', ''),
(5, 'Ouverture ', '16', '', '5629PV', 'Eindhoven', '', 0, 'Moderne woning in een rustige buurt.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(6, 'Rozenboomsteeg', '6', '', '1012PR', 'Amsterdam', '', 0, 'Charmante woning nabij het centrum.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(7, 'Spui', '21', '', '1012WX', 'Amsterdam', '', 0, 'Ruime woning met veel lichtinval.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(8, 'Claes van Gorcumstraat', '1', '', '9043BA', 'Assen', '', 0, 'Prachtige woning met tuin en zwembad.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(9, 'Brinkstraat', '83', '', '9401HZ', 'Assen', '', 0, 'Luxe appartement met balkon en uitzicht.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(10, '	Jan Evertsenstraat', '41', 'HS', '1057BM', 'Amsterdam', '', 0, 'Gezellige bungalow in een groene omgeving.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(11, 'Vredeman de Vriesstraat', '34', '', '8921BV', 'Leeuwarden', '', 0, 'Charmante woning met originele details.', 0, '', 0, '2024-10-21 00:00:00', 'recreatie', ''),
(12, 'Emmasingel', '14', '', '5611AZ', 'Eindhoven', '', 0, 'Moderne stadswoning met dakterras.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(13, 'Van Heuven Goedhartlaan', '1', '', '3527CE', 'Utrecht', '', 0, 'Riante eengezinswoning met garage.', 0, '', 0, '2024-10-21 00:00:00', 'recreatie', ''),
(14, 'Markt', '27', '', '6461EC', 'Kerkrade', '', 0, 'Ruime woning met zonnepanelen.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(15, 'Epelenberg', '20', '', '4817CM', 'Breda', '', 0, 'Statige villa in een rustige wijk.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(16, 'Brabantse Turfmarkt', '83', '', '2611CM', 'Delft', '', 0, 'Karakteristieke woning met tuin.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(17, 'Kleuvenstee', '120', '', '9403LS', 'Assen', '', 0, 'Instapklare woning met moderne afwerking.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(18, 'Flevoweg', '85', '', '8264PA', 'Kampen', '', 0, 'Huis met veel ruimte en een fijne tuin.', 0, '', 0, '2024-10-21 00:00:00', 'recreatie', ''),
(19, 'Bredaseweg', '137', '', '5038NC', 'Tilburg', '', 0, 'Woning met historische elementen en modern comfort.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(20, 'Euterpeplein', '7', 'A', '3816NM', 'Amersfoort', '', 0, 'Leuke starterswoning met leuke buurt.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(21, 'Marktstraat', '2', '4', '9401JH', 'Assen', '', 0, 'Woning met ruime kamers en een open keuken.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(22, 'Gerdesiaweg', '480', '', '3061RA', 'Rotterdam', '', 0, 'Nette woning met een zonnige tuin.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(23, 'Rembrandtplein', '38', '', '1017CV', 'Amsterdam', '', 0, 'Ruime gezinswoning nabij school en park.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(24, 'Willemstraat', '12', '', '4811AK', 'Breda', '', 0, 'Klassieke woning met moderne upgrades.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(25, 'Gedempte Kattendiep', '23', '1', '9711PL', 'Groningen', '', 0, 'Huis met veel karakter en een grote tuin.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(26, 'Weierspoort', '27', '', '9401DX', 'Assen', '', 0, 'Leuke hoekwoning met een balkon.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(27, 'Fluwijnstraat', '1', 'A', '5622AV', 'Eindhoven', '', 0, 'Fijne woning met veel lichtinval.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(28, 'Warandelaan', '2', '', '5037AB', 'Tilburg', '', 0, 'Moderne villa met grote oprit en tuin.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(29, 'Nieuwstraat', '16', '', '4531CW', 'Terneuzen', '', 0, 'Schitterende woning in het hart van het dorp.', 0, '', 0, '2024-10-21 00:00:00', 'recreatie', ''),
(30, 'Nijmeegseweg', '20', '', '5916PT', 'Venlo', '', 0, 'Prachtig appartement met uitzicht op de haven.', 0, '', 0, '2024-10-21 00:00:00', 'recreatie', ''),
(31, 'Weg naar Rhijnauwen', '13', '15', '3584AD', 'Utrecht', '', 0, 'Instapklare woning met een nette afwerking.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(32, 'Heuvel Galerie', '103', '', '5611DK', 'Eindhoven', '', 0, 'Zeer ruime woning met moderne keuken.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(33, 'Viergrenzenweg', '232', '', '6291BX', 'Vaals', '', 0, 'Luxe villa in een rustige straat.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(34, 'Van Leeuwenhoekstraat', '39', '', '1782HL', 'Den Helder', '', 0, 'Woning met grote tuin en schuurtje.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(35, 'Helperpark', '298', '', '9723ZA', 'Groningen', '', 0, 'Gezellige eengezinswoning met garage.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(36, 'Singelpassage', '9', '', '9401JB', 'Assen', '', 0, 'Charmante woning met een heerlijke tuin.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(37, 'Pianoweg', '112', '', '1312JK', 'Almere', '', 0, 'Moderne woning met zonnepanelen.', 0, '', 0, '2024-10-21 00:00:00', 'recreatie', ''),
(38, 'Willem II Straat', '27', '', '5038BA', 'Tilburg', '', 0, 'Licht en ruim appartement met balkon.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(39, 'Piusplein', '75', '', '5038WP', 'Tilburg', '', 0, 'Instapklare woning in een rustige buurt.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(40, 'Stationsplein', '4', '', '9401LB', 'Assen', '', 0, 'Woning met een grote tuin en terras.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(41, 'Baanhoekweg', '1', '', '3313LA', 'Dordrecht', '', 0, 'Nette woning dichtbij het centrum.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(42, 'Plein1992', '15', NULL, '6221JP', 'Maastricht', '', 0, 'Ruime woning met veel slaapkamers.', 0, '', 0, '2024-10-21 00:00:00', 'huur', ''),
(43, 'Meijersweg', '1', '', '7553AX', 'Hengelo', '', 0, 'Zeer ruime woning met garage en tuin.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(44, 'Roerdompplein', '9', '', '1602RW', 'Enkhuizen', '', 0, 'Prachtige villa met uitzicht op de Maas.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(45, 'Burgemeester Kerstenslaan', '20', '', '4837BM', 'Breda', '', 0, 'Moderne woning met ruime woonkamer.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(46, 'Baanstraat', '40', '', '3443TD', 'Woerden', '', 0, 'Charmante woning met karakter.', 0, '', 0, '2024-10-21 00:00:00', 'recreatie', ''),
(47, 'Lange Brinkweg', '65', '', '3764AB', 'Soest', '', 0, 'Fijne woning in een kindvriendelijke buurt.', 0, '', 0, '2024-10-21 00:00:00', 'recreatie', ''),
(48, 'Platielstraat', '21', '', '6211GV', 'Maastricht', '', 0, 'Woning met moderne afwerking en tuin.', 0, '', 0, '2024-10-21 00:00:00', 'koop', ''),
(49, 'Oonksweg', '38', 'A', '7622AW', 'Borne', '', 350000, 'Gelegen in een gezellige buurt met winkels en openbaar vervoer op loopafstand.', 75, 'B', 3, '2024-11-08 14:26:24', 'koop', NULL),
(50, 'Korenbloemstraat', '61', NULL, '8013XN', 'Zwolle', '', 1250, 'Rustige omgeving met veel groen en nabij een park.', 50, 'C', 2, '2024-11-08 14:26:24', 'huur', NULL),
(51, 'Bentingestraat', '13', NULL, '8331DD', 'Steenwijk', '', 400000, 'Ruime woning in een kindvriendelijke wijk met scholen en speeltuinen in de buurt.', 120, 'A', 4, '2024-11-08 14:26:24', 'koop', NULL),
(52, 'Coeshoeck', '27', NULL, '8303XE', 'Emmeloord', '', 295000, 'Kleine maar knusse buurt, dicht bij het stadscentrum.', 65, 'D', 2, '2024-11-08 14:26:24', 'koop', NULL),
(53, 'Langestraat', '104', NULL, '8281AN', 'Genemuiden', '', 100000, 'Ideale vakantiewoning midden in de natuur.', 30, 'E', 1, '2024-11-08 14:26:24', 'recreatie', NULL),
(54, 'Sickengastraat', '10', NULL, '8471BN', 'Wolvega', '', 425000, 'Moderne buurt met nieuwe voorzieningen en goed bereikbaar met openbaar vervoer.', 95, 'A', 3, '2024-11-08 14:26:24', 'nieuwbouw', NULL),
(55, 'Nicolaas Ter Maethstraat', '27', NULL, '8331KL', 'Steenwijk', '', 1350, 'Gezellige buurt met veel voorzieningen en een grote supermarkt in de buurt.', 55, 'B', 2, '2024-11-08 14:26:24', 'huur', NULL),
(56, 'Brederostraat', '34', 'I', '8023AT', 'Zwolle', '', 320000, 'Groene wijk aan de rand van de stad met mooie wandelroutes.', 85, 'C', 3, '2024-11-08 14:26:24', 'koop', NULL);

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
  `datum_afhandeling` date DEFAULT NULL,
  `status` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `serviceverzoek`
--

INSERT INTO `serviceverzoek` (`id`, `omschrijving`, `contract_id`, `servicetype_id`, `datum_aanvraag`, `datum_afhandeling`, `status`) VALUES
(1, 'Kraan lekt', 1, 2, '2024-05-16 18:38:15', '2024-10-21', 'afgehandeld'),
(7, 'dikke vette peace', NULL, NULL, '2024-10-23 11:30:19', NULL, 'in behandeling');

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

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `tokens`
--

CREATE TABLE `tokens` (
  `user_id` int(11) NOT NULL,
  `token` int(11) NOT NULL,
  `verval_datum` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
-- Indexen voor tabel `tokens`
--
ALTER TABLE `tokens`
  ADD PRIMARY KEY (`user_id`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT voor een tabel `medewerkers`
--
ALTER TABLE `medewerkers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

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
