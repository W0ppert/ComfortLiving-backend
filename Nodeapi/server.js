const express = require('express');
const cors = require('cors');
const bcrypt = require('bcrypt');
const db = require('./db'); // Import the database connection
const port = 3000;
const nodemailer = require('nodemailer'); // Import nodemailer for sending emails
require('dotenv').config();




// Create an Express app
const corsOptions = {
    origin: 'http://localhost:3000/', // Specifieke origin
    credentials: true // Toestaan van credentials
  };

  // Create an Express app
const app = express();
app.use(cors(corsOptions)); // To allow cross-origin requests
app.use(express.json()); // To parse JSON bodies


// Set up a transporter using your environment variables
const transporter = nodemailer.createTransport({
 host: process.env.EMAIL_HOST,
 port: process.env.EMAIL_PORT,
 secure: process.env.EMAIL_SECURE === 'true', // Convert string to boolean
 auth: {
     user: process.env.EMAIL_USER,
     pass: process.env.EMAIL_PASS
 }
});


// CRUD operations for each table

// Contracten
app.get('/contracten', (req, res) => {
    db.query('SELECT * FROM contracten', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

app.post('/contracten', (req, res) => {
    const { pandid, klantid } = req.body;
    db.query('INSERT INTO contracten (pandid, klantid) VALUES (?, ?)', [pandid, klantid], (err, results) => {
        if (err) return res.status(500).send(err);
        res.json({ id: results.insertId, pandid, klantid });
    });
});

// Externe partij
app.get('/externepartij', (req, res) => {
    db.query('SELECT * FROM externepartij', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

app.post('/externepartij', (req, res) => {
    const { naam, email, telefoonnummer } = req.body;
    db.query('INSERT INTO externepartij (naam, email, telefoonnummer) VALUES (?, ?, ?)', 
    [naam, email, telefoonnummer], (err, results) => {
        if (err) return res.status(500).send(err);
        res.json({ id: results.insertId, naam, email, telefoonnummer });
    });
});


// Klanten
app.get('/klanten', (req, res) => {
    db.query('SELECT * FROM klanten', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});


app.post('/klanten/login', async (req, res) => {
    const { email, wachtwoord } = req.body;

    db.query('SELECT * FROM klanten WHERE email = ?', [email], async (err, results) => {
        if (err) {
            console.log('Database query error:', err);
            return res.status(500).send('Er is een fout opgetreden.');
        }

        if (results.length === 0) {
            return res.status(400).send('Gebruiker niet gevonden.');
        }

        const klant = results[0];

        try {
            const isMatch = await bcrypt.compare(wachtwoord, klant.wachtwoord);
            console.log('Password Match:', isMatch);

            if (!isMatch) {
                return res.status(400).send('Onjuist wachtwoord.');
            }

            // Verwijder het wachtwoord uit de klantgegevens voordat je ze terugstuurt
            delete klant.wachtwoord;

            // Log de volledige gebruikersgegevens in de console
            console.log('User data:', JSON.stringify(klant, null, 2));

            // Stuur de volledige gebruikersgegevens terug als JSON
            res.json(klant);
        } catch (compareError) {
            console.log('Error comparing passwords:', compareError);
            return res.status(500).send('Er is een fout opgetreden tijdens het vergelijken van wachtwoorden.');
        }
    });
});
app.get('/klanten/:id', (req, res) => {
    const userId = req.params.id;
    db.query('SELECT * FROM klanten WHERE id = ?', [userId], (err, results) => {
        if (err) return res.status(500).send(err);
        if (results.length === 0) return res.status(404).send('Gebruiker niet gevonden');
        const user = results[0];
        delete user.wachtwoord; // Verwijder het wachtwoord voordat je de gegevens terugstuurt
        res.json(user);
    });
});


app.post('/klanten', async (req, res) => {
    const { email, voornaam, tussenvoegsel, achternaam, geslacht, geboortedatum, huidig_woonadres, telefoonnummer, wachtwoord } = req.body;

    try {
        const Password = await bcrypt.hash(wachtwoord, 10);
        db.query(
            'INSERT INTO klanten (email, voornaam, achternaam, geslacht, geboortedatum, huidig_woonadres, telefoonnummer, wachtwoord) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',

            [email, voornaam, achternaam, geslacht, geboortedatum, huidig_woonadres, telefoonnummer, hashedPassword],
            async (err, results) => {

                if (err) {
                    return res.status(500).send(err);
                }

                // Create the verification link
                const verificationLink = `http://localhost:3000/verify-email/${results.insertId}`;

                // Email options
                const mailOptions = {
                    from: '"Comfortliving" <your-email@example.com>',
                    to: email,
                    subject: 'Verify Your Email Address',
                    html: `<p>Hello ${voornaam},</p><p>Please verify your email by clicking the link: <a href="${verificationLink}">Verify Email</a></p>`
                };

                // Send the email
                try {
                    await transporter.sendMail(mailOptions);
                    console.log('Verification email sent to:', email);
                } catch (mailError) {
                    console.error('Error sending email:', mailError);
                }

                res.json({
                    id: results.insertId,
                    email,
                    voornaam,
                    tussenvoegsel,
                    achternaam,
                    geslacht,
                    geboortedatum,
                    huidig_woonadres,
                    telefoonnummer
                });
            }
        );
    } catch (err) {
        console.error('Error hashing password: ', err);
        res.status(500).send('Error occurred during registration.');
    }
});


app.get('/verify-email/:id', (req, res) => {
    const klantId = req.params.id;
    const currentDate = new Date();

    db.query('UPDATE klanten SET email_verificatie_datum = ? WHERE id = ?', [currentDate, klantId], (err, results) => {
        if (err) {
            console.error('Database error:', err);
            return res.status(500).send('Er is een fout opgetreden.');
        }

        if (results.affectedRows === 0) {
            return res.status(404).send('Gebruiker niet gevonden.');
        }

        res.send('Email verified successfully! You can now log in.');
    });
});


app.delete('/klanten/:id', (req, res) => {
    const id = req.params.id;

    // Verwijder eerst gerelateerde serviceverzoeken
    db.query('DELETE FROM serviceverzoek WHERE contract_Id IN (SELECT id FROM contracten WHERE klantid = ?);', [id], (err, results) => {
        if (err) {
            return res.status(500).send({ message: 'Er is een fout opgetreden tijdens het verwijderen van de serviceverzoeken.', error: err });
        }

        // Verwijder vervolgens de gerelateerde contracten
        db.query('DELETE FROM contracten WHERE klantid = ?;', [id], (err, results) => {
            if (err) {
                return res.status(500).send({ message: 'Er is een fout opgetreden tijdens het verwijderen van de contracten.', error: err });
            }

            // Nu de klant zelf verwijderen
            db.query('DELETE FROM klanten WHERE id = ?;', [id], (err, results) => {
                if (err) {
                    return res.status(500).send({ message: 'Er is een fout opgetreden tijdens het verwijderen van de klant.', error: err });
                }

                // Controleer of een rij werd verwijderd
                if (results.affectedRows === 0) {
                    return res.status(404).send({ message: `Geen klant gevonden met id: ${id}` });
                }

                // Stuur een succesbericht terug
                res.status(200).send({ message: `Klant met id ${id} is succesvol verwijderd, inclusief bijbehorende contracten en serviceverzoeken.` });
            });
        });
    });
});

app.put('/klanten/:id', (req, res) => {
    const { id } = req.params;
    const { email, voornaam, tussenvoegsel, achternaam, geslacht, geboortedatum, huidig_woonadres, telefoonnummer } = req.body;

    // Haal de bestaande klantgegevens op
    db.query('SELECT * FROM klanten WHERE id = ?', [id], (err, results) => {
        if (err) {
            return res.status(500).send(err);
        }
        if (results.length === 0) {
            return res.status(404).send('Klant niet gevonden.');
        }

        const klant = results[0];

        // Alleen de velden bijwerken die zijn meegegeven, de rest behouden
        const updatedKlant = {
            email: email || klant.email,
            voornaam: voornaam || klant.voornaam,
            tussenvoegsel: tussenvoegsel || klant.tussenvoegsel,
            achternaam: achternaam || klant.achternaam,
            geslacht: geslacht || klant.geslacht,
            geboortedatum: geboortedatum || klant.geboortedatum,
            huidig_woonadres: huidig_woonadres || klant.huidig_woonadres,
            telefoonnummer: telefoonnummer || klant.telefoonnummer
        };

        // Update de klant in de database
        db.query(
            'UPDATE klanten SET email = ?, voornaam = ?, tussenvoegsel = ?, achternaam = ?, geslacht = ?, geboortedatum = ?, huidig_woonadres = ?, telefoonnummer = ? WHERE id = ?',
            [updatedKlant.email, updatedKlant.voornaam, updatedKlant.tussenvoegsel, updatedKlant.achternaam, updatedKlant.geslacht, updatedKlant.geboortedatum, updatedKlant.huidig_woonadres, updatedKlant.telefoonnummer, id],
            (err, updateResults) => {
                if (err) {
                    return res.status(500).send(err);
                }
                res.json({
                    message: 'Klantgegevens succesvol bijgewerkt',
                    id,
                    ...updatedKlant
                });
            }
        );
    });
});

app.put('/klanten/:id/wachtwoord', (req, res) => {
    const { id } = req.params;
    const { oudWachtwoord, nieuwWachtwoord } = req.body;

    if (!oudWachtwoord || !nieuwWachtwoord) {
        return res.status(400).send('Vul zowel het oude als het nieuwe wachtwoord in.');
    }

    // Haal het huidige gehashte wachtwoord op
    db.query('SELECT wachtwoord FROM klanten WHERE id = ?', [id], (err, results) => {
        if (err) {
            return res.status(500).send(err);
        }
        if (results.length === 0) {
            return res.status(404).send('Klant niet gevonden.');
        }

        const gehashteWachtwoord = results[0].wachtwoord;

        // Vergelijk het ingevoerde oude wachtwoord met het gehashte wachtwoord
        bcrypt.compare(oudWachtwoord, gehashteWachtwoord, (err, match) => {
            if (err) {
                return res.status(500).send(err);
            }
            if (!match) {
                return res.status(401).send('Oude wachtwoord is onjuist.');
            }

            // Hash het nieuwe wachtwoord
            bcrypt.hash(nieuwWachtwoord, 10, (err, hashedNieuwWachtwoord) => {
                if (err) {
                    return res.status(500).send(err);
                }

                // Update het wachtwoord in de database
                db.query(
                    'UPDATE klanten SET wachtwoord = ? WHERE id = ?',
                    [hashedNieuwWachtwoord, id],
                    (err) => {
                        if (err) {
                            return res.status(500).send(err);
                        }
                        res.json({ message: 'Wachtwoord succesvol bijgewerkt' });
                    }
                );
            });
        });
    });
});



// Panden
app.get('/panden', (req, res) => {
    db.query('SELECT * FROM panden', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});
app.get('/panden/:id', (req, res) => {
    const id = req.params.id;
    db.query('SELECT * FROM panden WHERE id = ?', [id], (err, results) => {
        if (err) return res.status(500).send(err);
        if (results.length === 0) return res.status(404).send('Pand niet gevonden');
        const pand = results[0];
        res.json(pand);
    });
});

app.post('/panden', (req, res) => {
    const { postcode, straat, huisnummer, plaats } = req.body;
    db.query('INSERT INTO panden (postcode, straat, huisnummer, plaats) VALUES (?, ?, ?, ?)', 
    [postcode, straat, huisnummer, plaats], (err, results) => {
        if (err) return res.status(500).send(err);
        res.json({ id: results.insertId, postcode, straat, huisnummer, plaats });
    });
});

app.delete('/panden/:id', (req, res) => {
    const id = req.params.id;
    db.query('DELETE FROM panden WHERE id = ?;', [id], (err, results) => {
        if (err) {
            return res.status(500).send({ message: 'Er is een fout opgetreden tijdens het verwijderen van het pand.', error: err });
        }
    });
});
// Servicetype
app.get('/servicetype', (req, res) => {
    db.query('SELECT * FROM servicetype', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

app.post('/servicetype', (req, res) => {
    const { omschrijving } = req.body;
    db.query('INSERT INTO servicetype (omschrijving) VALUES (?)', [omschrijving], (err, results) => {
        if (err) return res.status(500).send(err);
        res.json({ id: results.insertId, omschrijving });
    });
});

// Serviceverzoek
app.get('/serviceverzoek', (req, res) => {
    db.query('SELECT * FROM serviceverzoek', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

// app.post('/serviceverzoek', (req, res) => {
//     const { omschrijving, contract_Id, servicetype_id, datum } = req.body;
//     db.query('INSERT INTO serviceverzoek (omschrijving, contract_Id, servicetype_id, datum) VALUES (?, ?, ?, ?)', 
//     [omschrijving, contract_Id, servicetype_id, datum], (err, results) => {
//         if (err) return res.status(500).send(err);
//         res.json({ id: results.insertId, omschrijving, contract_Id, servicetype_id, datum });
//     });
// });

// Stappen
app.get('/stappen', (req, res) => {
    db.query('SELECT * FROM sv_stappen', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

app.post('/stappen', (req, res) => {
    const { omschrijving, serviceverzoek_id, externepartij_id, datum } = req.body;
    db.query('INSERT INTO sv_stappen (omschrijving, serviceverzoek_id, externepartij_id, datum) VALUES (?, ?, ?, ?)', 
    [omschrijving, serviceverzoek_id, externepartij_id, datum], (err, results) => {
        if (err) return res.status(500).send(err);
        res.json({ id: results.insertId, omschrijving, serviceverzoek_id, externepartij_id, datum });
    });
});

app.get('/inschrijvingen', (req, res) => {
    db.query('SELECT * FROM inschrijvingen', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

app.post('/inschrijvingen', (req, res) => {
    const { hoeveel_personen, jaar_inkomen } = req.body;
    db.query('INSERT INTO inschrijvingen (hoeveel_personen, jaar_inkomen) VALUES (?, ?)', 
    [hoeveel_personen, jaar_inkomen], (err, results) => {
        if (err) return res.status(500).send(err);
        res.json({ hoeveel_personen, jaar_inkomen });
    });
});
app.post('/serviceverzoek', (req, res) => {
    const { omschrijving } = req.body;
    db.query('INSERT INTO serviceverzoek (omschrijving) VALUES (?)', 
    [omschrijving], (err, results) => {
        if (err) return res.status(500).send(err);
        res.json({ id: results.insertId, omschrijving });
    });
});
// Start the serverx
app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}/`);
});

app.get('/medewerkers', (req, res) => {
    db.query('SELECT * FROM medewerkers', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

app.post('/medewerkers', async (req, res) => {
    const { voornaam, tussenvoegsel, achternaam, email, contract_uren, geboortedatum, wachtwoord, telefoonnummer, geslacht, contract_verval_datum, huidig_adres, opmerkingen } = req.body;

    try {
        // Wachtwoord hashen
        const hashedPassword = await bcrypt.hash(wachtwoord, 10);

        // Database-insert met gehasht wachtwoord
        db.query(
            'INSERT INTO medewerkers (voornaam, tussenvoegsel, achternaam, email, contract_uren, geboortedatum, wachtwoord, telefoonnummer, geslacht, contract_verval_datum, huidig_adres, opmerkingen) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
            [voornaam, tussenvoegsel, achternaam, email, contract_uren, geboortedatum, hashedPassword, telefoonnummer, geslacht, contract_verval_datum, huidig_adres, opmerkingen],
            (err, results) => {
                if (err) {
                    return res.status(500).send(err);
                }

                res.json({ id: results.insertId, voornaam, tussenvoegsel, achternaam, email, contract_uren, geboortedatum, telefoonnummer, geslacht, contract_verval_datum, huidig_adres, opmerkingen });
            }
        );
    } catch (err) {
        res.status(500).send('Error hashing password');
    }
});

app.put('/medewerkers/:id', async (req, res) => {
    const { voornaam, tussenvoegsel, achternaam, email, contract_uren, geboortedatum, wachtwoord, telefoonnummer, geslacht, contract_verval_datum, huidig_adres, opmerkingen } = req.body;
    const medewerkerId = req.params.id;

    try {
        // Stap 1: Haal de huidige gegevens van de medewerker op
        db.query('SELECT * FROM medewerkers WHERE id = ?', [medewerkerId], async (err, rows) => {
            if (err) {
                return res.status(500).send(err);
            }
            if (rows.length === 0) {
                return res.status(404).send('Medewerker niet gevonden');
            }

            // Huidige gegevens
            const currentData = rows[0];

            // Stap 2: Bepaal de waarden die geüpdatet moeten worden (gebruik huidige waarden indien niet meegegeven)
            const updatedData = {
                voornaam: voornaam || currentData.voornaam,
                tussenvoegsel: tussenvoegsel || currentData.tussenvoegsel,
                achternaam: achternaam || currentData.achternaam,
                email: email || currentData.email,
                contract_uren: contract_uren || currentData.contract_uren,
                geboortedatum: geboortedatum || currentData.geboortedatum,
                wachtwoord: wachtwoord ? await bcrypt.hash(wachtwoord, 10) : currentData.wachtwoord, // hash het wachtwoord indien meegegeven
                telefoonnummer: telefoonnummer || currentData.telefoonnummer,
                geslacht: geslacht || currentData.geslacht,
                contract_verval_datum: contract_verval_datum || currentData.contract_verval_datum,
                huidig_adres: huidig_adres || currentData.huidig_adres,
                opmerkingen: opmerkingen || currentData.opmerkingen
            };

            // Stap 3: Update-query uitvoeren met de bijgewerkte waarden
            const query = `
                UPDATE medewerkers 
                SET 
                    voornaam = ?, 
                    tussenvoegsel = ?, 
                    achternaam = ?, 
                    email = ?, 
                    contract_uren = ?, 
                    geboortedatum = ?, 
                    wachtwoord = ?, 
                    telefoonnummer = ?, 
                    geslacht = ?, 
                    contract_verval_datum = ?, 
                    huidig_adres = ?, 
                    opmerkingen = ?
                WHERE id = ?
            `;

            const values = [
                updatedData.voornaam,
                updatedData.tussenvoegsel,
                updatedData.achternaam,
                updatedData.email,
                updatedData.contract_uren,
                updatedData.geboortedatum,
                updatedData.wachtwoord,
                updatedData.telefoonnummer,
                updatedData.geslacht,
                updatedData.contract_verval_datum,
                updatedData.huidig_adres,
                updatedData.opmerkingen,
                medewerkerId
            ];

            db.query(query, values, (err, results) => {
                if (err) {
                    return res.status(500).send(err);
                }
                res.json({ message: 'Medewerker succesvol geüpdatet' });
            });
        });
    } catch (err) {
        res.status(500).send('Error updating medewerker');
    }
});

app.delete('/medewerkers/:id', (req, res) => {
    const medewerkerId = req.params.id;

    db.query('DELETE FROM medewerkers WHERE id = ?', [medewerkerId], (err, results) => {
        if (err) {
            return res.status(500).send(err);
        }
        if (results.affectedRows === 0) {
            return res.status(404).send('Medewerker niet gevonden');
        }

        res.json({ message: 'Medewerker succesvol verwijderd' });
    });
});