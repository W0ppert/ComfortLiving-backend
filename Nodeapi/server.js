const express = require('express');
const cors = require('cors');
const bcrypt = require('bcrypt');
const db = require('./db'); // Import the database connection
const port = 3001;
const nodemailer = require('nodemailer'); // Import nodemailer for sending emails
require('dotenv').config();
const saltRounds = 10;

const apiKeyMiddleware = (req, res, next) => {
    const apiKey = req.headers['api-key']; // API key is sent in the 'x-api-key' header

    if (!apiKey || apiKey !== process.env.API_KEY) {
        return res.status(403).send('Forbidden: Invalid API Key');
    }
    next(); // Proceed to the next middleware/route handler
};


// Create an Express app
const corsOptions = {
    origin: 'http://localhost:3000', // Specifieke origin
    credentials: true 
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
app.get('/contracten',apiKeyMiddleware ,(req, res) => {
    db.query('SELECT * FROM contracten', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

app.post('/contracten',apiKeyMiddleware ,(req, res) => {
    const { pandid, klantid } = req.body;
    db.query('INSERT INTO contracten (pandid, klantid) VALUES (?, ?)', [pandid, klantid], (err, results) => {
        if (err) return res.status(500).send(err);
        res.json({ id: results.insertId, pandid, klantid });
    });
});

// Externe partij
app.get('/externepartij',apiKeyMiddleware ,(req, res) => {
    db.query('SELECT * FROM externepartij', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

app.post('/externepartij',apiKeyMiddleware ,(req, res) => {
    const { naam, email, telefoonnummer } = req.body;
    db.query('INSERT INTO externepartij (naam, email, telefoonnummer) VALUES (?, ?, ?)', 
    [naam, email, telefoonnummer], (err, results) => {
        if (err) return res.status(500).send(err);
        res.json({ id: results.insertId, naam, email, telefoonnummer });
    });
});


// Klanten
app.get('/klanten',apiKeyMiddleware ,(req, res) => {
    db.query('SELECT * FROM klanten', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});


app.post('/klanten/login', async (req, res) => {
    const { email, wachtwoord } = req.body;

    db.query('SELECT * FROM klanten WHERE email = ?', [email], async (err, results) => {
        if (err) {
            
            return res.status(500).send('Er is een fout opgetreden.');
        }

        if (results.length === 0) {
            return res.status(400).send('Gebruiker niet gevonden.');
        }

        const klant = results[0];

        try {
            const isMatch = await bcrypt.compare(wachtwoord, klant.wachtwoord);
            

            if (!isMatch) {
                return res.status(400).send('Onjuist wachtwoord.');
            }

            // Verwijder het wachtwoord uit de klantgegevens voordat je ze terugstuurt
            delete klant.wachtwoord;

            // Log de volledige gebruikersgegevens in de console
            

            // Stuur de volledige gebruikersgegevens terug als JSON
            res.json(klant);
        } catch (compareError) {
            
            return res.status(500).send('Er is een fout opgetreden tijdens het vergelijken van wachtwoorden.');
        }
    });
});
app.get('/klanten/:id',apiKeyMiddleware ,(req, res) => {
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
        const hashedPassword = await bcrypt.hash(wachtwoord, 10);
        db.query(
            'INSERT INTO klanten (email, voornaam, achternaam, geslacht, geboortedatum, huidig_woonadres, telefoonnummer, wachtwoord) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',

            [email, voornaam, achternaam, geslacht, geboortedatum, huidig_woonadres, telefoonnummer, hashedPassword],
            async (err, results) => {

                if (err) {
                    return res.status(500).send(err);
                }

                // Create the verification link
                const verificationLink = `https://api.22literverf.store/verify-email/${results.insertId}`;

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


app.get('/verify-email/:id',apiKeyMiddleware ,(req, res) => {
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

        // jordy hier moet een inlog functie komen zodat je automatsch inlogt als je je email verifieert
        res.redirect('localhost:3000');
    });
});


app.delete('/klanten/:id',apiKeyMiddleware ,(req, res) => {
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

app.put('/klanten/:id',apiKeyMiddleware ,(req, res) => {
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



app.post('/request-password-reset',apiKeyMiddleware ,(req, res) => {
    const { email } = req.body;

    db.query('SELECT id FROM klanten WHERE email = ?', [email], (err, results) => {
        if (err) {
            return res.status(500).send('Internal Server Error');
        }
        if (results.length === 0) {
            return res.status(404).send('No user found with this email');
        }

        const userId = results[0].id;

        const token = new Date().getTime().toString();  // Token created from timestamp

        // Store the plain token (not hashed)
        const tokenExpiry = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours

        db.query(
            'INSERT INTO tokens (user_id, token, verval_datum) VALUES (?, ?, ?)',
            [userId, token, tokenExpiry],
            (err) => {
                if (err) {
                    return res.status(500).send(err);
                }

                // Send the reset email with the plain token in the link
                const mailOptions = {
                    from: process.env.EMAIL_USER,
                    to: email,
                    subject: 'Password Reset Request',
                    text: `To reset your password, click the link: https://api.22literverf.store/reset-password?token=${token}`,
                };

                transporter.sendMail(mailOptions, (err) => {
                    if (err) {
                        return res.status(500).send('Error sending the email');
                    }
                    res.json({ message: 'Password reset email sent successfully' });
                });
            }
        );
    });
});


app.post('/reset-password',apiKeyMiddleware ,(req, res) => {
    const { token, newPassword } = req.body;

    

    db.query('SELECT * FROM tokens WHERE token = ?', [token], (err, results) => {
        if (err) {
            return res.status(500).send('Internal Server Error');
        }

        if (results.length === 0) {
            
            return res.status(400).send('Invalid or expired token');
        }

        const tokenData = results[0];

        // Log the token stored in the database
        

        const currentTime = new Date();
        if (currentTime > new Date(tokenData.verval_datum)) {
            
            return res.status(400).send('Token has expired');
        }

        // Directly compare the plain token
        if (token !== tokenData.token) {
           
            return res.status(400).send(token.toString() === tokenData.token.toString());
        }

        // If token matches, proceed with password reset
        

        db.query('SELECT * FROM klanten WHERE id = ?', [tokenData.user_id], (err, userResults) => {
            if (err) {
                return res.status(500).send('Internal Server Error');
            }

            if (userResults.length === 0) {
                return res.status(404).send('User not found');
            }

            const user = userResults[0];

            // Hash the new password
            bcrypt.hash(newPassword, 10, (err, hashedPassword) => {
                if (err) {
                    return res.status(500).send('Error hashing password');
                }

                // Update the user's password
                db.query('UPDATE klanten SET wachtwoord = ? WHERE id = ?', [hashedPassword, user.id], (err) => {
                    if (err) {
                        return res.status(500).send('Error updating password');
                    }

                    // Optionally, delete the token after it's used
                    db.query('DELETE FROM tokens WHERE token = ?', [token], (err) => {
                        if (err) {
                            
                        }

                        res.json({ message: 'Password reset successfully' });
                    });
                });
            });
        });
    });
});





app.put('/klanten/:id/wachtwoord',apiKeyMiddleware ,(req, res) => {
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
app.get('/panden',apiKeyMiddleware ,(req, res) => {
    db.query('SELECT * FROM panden', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});
app.get('/panden/:id',apiKeyMiddleware ,(req, res) => {
    const id = req.params.id;
    db.query('SELECT * FROM panden WHERE id = ?', [id], (err, results) => {
        if (err) return res.status(500).send(err);
        if (results.length === 0) return res.status(404).send('Pand niet gevonden');
        const pand = results[0];
        res.json(pand);
    });
});

app.post('/panden',apiKeyMiddleware ,(req, res) => {
    const { postcode, straat, huisnummer, plaats } = req.body;
    db.query('INSERT INTO panden (postcode, straat, huisnummer, plaats) VALUES (?, ?, ?, ?)', 
    [postcode, straat, huisnummer, plaats], (err, results) => {
        if (err) return res.status(500).send(err);
        res.json({ id: results.insertId, postcode, straat, huisnummer, plaats });
    });
});

// Servicetype
app.get('/servicetype',apiKeyMiddleware ,(req, res) => {
    db.query('SELECT * FROM servicetype', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

app.post('/servicetype',apiKeyMiddleware ,(req, res) => {
    const { omschrijving } = req.body;
    db.query('INSERT INTO servicetype (omschrijving) VALUES (?)', [omschrijving], (err, results) => {
        if (err) return res.status(500).send(err);
        res.json({ id: results.insertId, omschrijving });
    });
});

// Serviceverzoek
app.get('/serviceverzoek',apiKeyMiddleware ,(req, res) => {
    db.query('SELECT * FROM serviceverzoek', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

// app.post('/serviceverzoek',apiKeyMiddleware ,(req, res) => {
//     const { omschrijving, contract_Id, servicetype_id, datum } = req.body;
//     db.query('INSERT INTO serviceverzoek (omschrijving, contract_Id, servicetype_id, datum) VALUES (?, ?, ?, ?)', 
//     [omschrijving, contract_Id, servicetype_id, datum], (err, results) => {
//         if (err) return res.status(500).send(err);
//         res.json({ id: results.insertId, omschrijving, contract_Id, servicetype_id, datum });
//     });
// });

// Stappen
app.get('/stappen',apiKeyMiddleware ,(req, res) => {
    db.query('SELECT * FROM sv_stappen', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

app.post('/stappen',apiKeyMiddleware ,(req, res) => {
    const { omschrijving, serviceverzoek_id, externepartij_id, datum } = req.body;
    db.query('INSERT INTO sv_stappen (omschrijving, serviceverzoek_id, externepartij_id, datum) VALUES (?, ?, ?, ?)', 
    [omschrijving, serviceverzoek_id, externepartij_id, datum], (err, results) => {
        if (err) return res.status(500).send(err);
        res.json({ id: results.insertId, omschrijving, serviceverzoek_id, externepartij_id, datum });
    });
});

app.get('/inschrijvingen',apiKeyMiddleware ,(req, res) => {
    db.query('SELECT * FROM inschrijvingen', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

app.post('/inschrijvingen',apiKeyMiddleware ,(req, res) => {
    

    const { hoeveel_personen, jaar_inkomen, userid, pandid } = req.body;


    // Converteer expliciet naar integers/numbers
    const parsedData = {
        hoeveel_personen: parseInt(hoeveel_personen),
        jaar_inkomen: parseFloat(jaar_inkomen),
        userid: parseInt(userid),
        pandid: parseInt(pandid)
    };

    const query = 'INSERT INTO inschrijvingen (hoeveel_personen, jaar_inkomen, userid, pandid) VALUES (?, ?, ?, ?)';

    db.query(
        query, 
        [parsedData.hoeveel_personen, parsedData.jaar_inkomen, parsedData.userid, parsedData.pandid], 
        (err, results) => {
            if (err) {
                console.error('Database error:', err);
                return res.status(500).json({ 
                    error: 'Database error', 
                    details: err.message 
                });
            }
            console.log('4. Query uitgevoerd met waarden:', [parsedData.hoeveel_personen, parsedData.jaar_inkomen, parsedData.userid, parsedData.pandid]);
            res.status(201).json({ 
                message: 'Inschrijving succesvol',
                insertedData: parsedData,
                results: results
            });
        }
    );
});

app.post('/serviceverzoek',apiKeyMiddleware ,(req, res) => {
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
