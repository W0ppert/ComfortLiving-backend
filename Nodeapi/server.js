const express = require('express');
const cors = require('cors');
const bcrypt = require('bcrypt');
const db = require('./db'); // Import the database connection
const port = 3000;

// Create an Express app
const app = express();
app.use(cors()); // To allow cross-origin requests
app.use(express.json()); // To parse JSON bodies

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
            console.log('Entered Password:', wachtwoord);
            console.log('Stored Hashed Password:', klant.wachtwoord);
            console.log('Password Match:', isMatch); // This should be true if the password matches

            if (!isMatch) {
                return res.status(400).send('Onjuist wachtwoord.');
            }

            res.send('Ingelogd!');
        } catch (compareError) {
            console.log('Error comparing passwords:', compareError);
            return res.status(500).send('Er is een fout opgetreden tijdens het vergelijken van wachtwoorden.');
        }
    });
});


app.post('/klanten', async (req, res) => {
    const { email, voornaam, tussenvoegsel, achternaam, geslacht, geboortedatum, huidig_woonadres, telefoonnummer, wachtwoord } = req.body;

    try {
        const hashedPassword = await bcrypt.hash(wachtwoord, 10);
        db.query(
            'INSERT INTO klanten (email, voornaam, achternaam, geslacht, geboortedatum, huidig_woonadres, telefoonnummer, wachtwoord) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            [email, voornaam, tussenvoegsel, achternaam,  geslacht, geboortedatum, huidig_woonadres, telefoonnummer, hashedPassword],
            (err, results) => {
                if (err) {
                    return res.status(500).send(err);
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
        res.status(500).send('Er is een fout opgetreden bij het hashen van het wachtwoord.');
    }
});
app.delete('/klanten/:email', (req, res) => {
    const email = req.params.email;

    // SQL query to delete the customer by email
    db.query('DELETE FROM klanten WHERE email = ?', [email], (err, results) => {
        if (err) {
            return res.status(500).send({ message: 'Er is een fout opgetreden tijdens het verwijderen van de klant.', error: err });
        }
        
        // Check if a row was deleted
        if (results.affectedRows === 0) {
            return res.status(404).send({ message: `Geen klant gevonden met email: ${email}` });
        }

        // Send success response
        res.status(200).send({ message: `Klant met email ${email} is succesvol verwijderd.` });
    });
});



// Panden
app.get('/panden', (req, res) => {
    db.query('SELECT * FROM panden', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
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
