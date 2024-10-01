-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Gegenereerd op: 16 mei 2024 om 18:43
-- Serverversie: 10.4.21-MariaDB
-- PHP-versie: 8.0.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `melker`
--
CREATE DATABASE IF NOT EXISTS `melker` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `melker`;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `contracten`
--

CREATE TABLE `contracten` (
  `id` int(11) NOT NULL,
  `pandid` int(11) NOT NULL,
  `klantid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
  `naam` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Gegevens worden geëxporteerd voor tabel `klanten`
--

INSERT INTO `klanten` (`id`, `naam`) VALUES
(1, 'Stegeman'),
(2, 'Starreveld');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `panden`
--

CREATE TABLE `panden` (
  `id` int(11) NOT NULL,
  `postcode` varchar(6) NOT NULL,
  `straat` varchar(256) NOT NULL,
  `huisnummer` varchar(8) NOT NULL,
  `plaats` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Gegevens worden geëxporteerd voor tabel `panden`
--

INSERT INTO `panden` (`id`, `postcode`, `straat`, `huisnummer`, `plaats`) VALUES
(1, '8000AZ', 'Dorpslaan', '12', 'Zwolle'),
(2, '8000AX', 'Dorpslaan', '23', 'Zwolle');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `servicetype`
--

CREATE TABLE `servicetype` (
  `id` int(11) NOT NULL,
  `omschrijving` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Gegevens worden geëxporteerd voor tabel `servicetype`
--

INSERT INTO `servicetype` (`id`, `omschrijving`) VALUES
(1, 'Onderhoud buiten \r\n'),
(2, 'Onderhoud riool/sanitair'),
(3, 'Onderhoud binnen'),
(4, 'Bezichtiging (eerste bezoek) \r\n\r\n');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
-- AUTO_INCREMENT voor een tabel `servicetype`
--
ALTER TABLE `servicetype`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

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
