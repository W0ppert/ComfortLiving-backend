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
app.get('/contracten', apiKeyMiddleware, (req, res) => {
    db.query('SELECT * FROM contracten', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

app.post('/contracten', apiKeyMiddleware, (req, res) => {
    const { pandid, klantid } = req.body;
    db.query('INSERT INTO contracten (pandid, klantid) VALUES (?, ?)', [pandid, klantid], (err, results) => {
        if (err) return res.status(500).send(err);
        res.json({ id: results.insertId, pandid, klantid });
    });
});

// Externe partij
app.get('/externepartij', apiKeyMiddleware, (req, res) => {
    db.query('SELECT * FROM externepartij', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

app.post('/externepartij', apiKeyMiddleware, (req, res) => {
    const { bedrijfsnaam, contactpersoon, email_contactpersoon, telefoonnummer_bedrijf, telefoon_contactpersoon } = req.body;
    db.query('INSERT INTO externepartij (bedrijfsnaam, contactpersoon, email_contactpersoon, telefoonnummer_bedrijf, telefoon_contactpersoon) VALUES (?, ?, ?, ?, ?)', 
    [bedrijfsnaam, contactpersoon, email_contactpersoon, telefoonnummer_bedrijf, telefoon_contactpersoon], (err, results) => {
        if (err) return res.status(500).send(err);
        res.json({ id: results.insertId, bedrijfsnaam, contactpersoon, email_contactpersoon, telefoonnummer_bedrijf, telefoon_contactpersoon });
    });
});

app.put('/externepartij/:id', apiKeyMiddleware, (req, res) => {
    const { id } = req.params;
    const { bedrijfsnaam, contactpersoon, email_contactpersoon, telefoonnummer_bedrijf, telefoon_contactpersoon } = req.body;

    // Stap 1: Haal de huidige gegevens op
    db.query('SELECT * FROM externepartij WHERE id = ?', [id], (err, results) => {
        if (err) return res.status(500).send(err);
        if (results.length === 0) return res.status(404).send('Externe partij niet gevonden');

        // Bestaande gegevens behouden, enkel de meegegeven velden updaten
        const bestaandeGegevens = results[0];
        const nieuweGegevens = {
            bedrijfsnaam: bedrijfsnaam || bestaandeGegevens.bedrijfsnaam,
            contactpersoon: contactpersoon || bestaandeGegevens.contactpersoon,
            email_contactpersoon: email_contactpersoon || bestaandeGegevens.email_contactpersoon,
            telefoonnummer_bedrijf: telefoonnummer_bedrijf || bestaandeGegevens.telefoonnummer_bedrijf,
            telefoon_contactpersoon: telefoon_contactpersoon || bestaandeGegevens.telefoon_contactpersoon
        };

        // Stap 2: Update de gegevens in de database
        db.query(
            'UPDATE externepartij SET bedrijfsnaam = ?, contactpersoon = ?, email_contactpersoon = ?, telefoonnummer_bedrijf = ?, telefoon_contactpersoon = ? WHERE id = ?',
            [nieuweGegevens.bedrijfsnaam, nieuweGegevens.contactpersoon, nieuweGegevens.email_contactpersoon, nieuweGegevens.telefoonnummer_bedrijf, nieuweGegevens.telefoon_contactpersoon, id],
            (err, updateResult) => {
                if (err) return res.status(500).send(err);
                res.json({ id, ...nieuweGegevens });
            }
        );
    });
});

// Klanten
app.get('/klanten', apiKeyMiddleware, (req, res) => {
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

app.get('/klanten/:id', apiKeyMiddleware, (req, res) => {
    const userId = req.params.id;
    db.query('SELECT * FROM klanten WHERE id = ?', [userId], (err, results) => {
        if (err) return res.status(500).send(err);
        if (results.length === 0) return res.status(404).send('Gebruiker niet gevonden');
        const user = results[0];
        delete user.wachtwoord; // Verwijder het wachtwoord voordat je de gegevens terugstuurt
        res.json(user);
    });
});

app.post('/klanten',apiKeyMiddleware, async (req, res) => {
    const { email, voornaam, tussenvoegsel, achternaam, geslacht, geboortedatum, huidig_woonadres, telefoonnummer, wachtwoord } = req.body;

    try {
        const hashedPassword = await bcrypt.hash(wachtwoord, 10);
        db.query(
            'INSERT INTO klanten (email, voornaam, tussenvoegsel, achternaam, geslacht, geboortedatum, huidig_woonadres, telefoonnummer, wachtwoord) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',

            [email, voornaam, tussenvoegsel, achternaam, geslacht, geboortedatum, huidig_woonadres, telefoonnummer, hashedPassword],
            async (err, results) => {

                if (err) {
                    return res.status(500).send(err);
                }

                // Create the verification link
                const verificationLink = `http://api.22literverf.store/verify-email/${results.insertId}`;

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

        // jordy hier moet een inlog functie komen zodat je automatsch inlogt als je je email verifieert
        res.redirect('localhost:3000');
    });
});


app.delete('/klanten/:id', apiKeyMiddleware, (req, res) => {
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

app.put('/klanten/:id', apiKeyMiddleware, (req, res) => {
    const { id } = req.params;
    const { email, voornaam, tussenvoegsel, achternaam, geslacht, geboortedatum, huidig_woonadres, telefoonnummer, straal_voorkeurs_plaats } = req.body;

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
            straal_voorkeurs_plaats: straal_voorkeurs_plaats || klant.straal_voorkeurs_plaats,
            telefoonnummer: telefoonnummer || klant.telefoonnummer
        };

        // Update de klant in de database
        db.query(
            'UPDATE klanten SET email = ?, voornaam = ?, tussenvoegsel = ?, achternaam = ?, geslacht = ?, geboortedatum = ?, huidig_woonadres = ?, telefoonnummer = ?, straal_voorkeurs_plaats = ? WHERE id = ?',
            [updatedKlant.email, updatedKlant.voornaam, updatedKlant.tussenvoegsel, updatedKlant.achternaam, updatedKlant.geslacht, updatedKlant.geboortedatum, updatedKlant.huidig_woonadres, updatedKlant.telefoonnummer, updatedKlant.straal_voorkeurs_plaats, id],
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

// app.post('/request-password-reset', (req, res) => {
//     const { email } = req.body;

//     db.query('SELECT id FROM klanten WHERE email = ?', [email], (err, results) => {
//         if (err) {
//             return res.status(500).send('Internal Server Error');
//         }
//         if (results.length === 0) {
//             return res.status(404).send('No user found with this email');
//         }

//         const userId = results[0].id;

//         const token = new Date().getTime().toString();  // Token created from timestamp

//         // Store the plain token (not hashed)
//         const tokenExpiry = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours

//         db.query(
//             'INSERT INTO tokens (user_id, token, verval_datum) VALUES (?, ?, ?)',
//             [userId, token, tokenExpiry],
//             (err) => {
//                 if (err) {
//                     return res.status(500).send('Error saving token to the database');
//                 }

//                 // Send the reset email with the plain token in the link
//                 const mailOptions = {
//                     from: process.env.EMAIL_USER,
//                     to: email,
//                     subject: 'Password Reset Request',
//                     text: `To reset your password, click the link: http://localhost:3000/reset-password?token=${token}`,
//                 };

//                 transporter.sendMail(mailOptions, (err) => {
//                     if (err) {
//                         return res.status(500).send('Error sending the email');
//                     }
//                     res.json({ message: 'Password reset email sent successfully' });
//                 });
//             }
//         );
//     });
// });


app.post('/request-password-reset',apiKeyMiddleware, (req, res) => {
    const { email } = req.body;

    db.query('SELECT id FROM klanten WHERE email = ?', [email], (err, results) => {
        if (err) {
            return res.status(500).send('Internal Server Error');
        }
        if (results.length === 0) {
            return res.status(404).send('No user found with this email');
        }

        const userId = results[0].id;

        // Genereer een eenvoudige token met timestamp en random getal
        const plainToken = `${new Date().getTime()}-${Math.floor(Math.random() * 1000000)}`;

        // Hash de token
        bcrypt.hash(plainToken, saltRounds, (err, hashedToken) => {
            if (err) {
                return res.status(500).send('Error hashing the token');
            }

            const tokenExpiry = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours

            db.query(
                'INSERT INTO tokens (user_id, token, verval_datum) VALUES (?, ?, ?)',
                [userId, hashedToken, tokenExpiry],
                (err) => {
                    if (err) {
                        return res.status(500).send('Error saving token to the database');
                    }

                    // Stuur het plainToken in de link van de e-mail
                    const mailOptions = {
                        from: process.env.EMAIL_USER,
                        to: email,
                        subject: 'Password Reset Request',
                        text: `To reset your password, click the link: http://localhost:3000/reset-password?token=${plainToken}`,
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
});

// app.post('/reset-password', (req, res) => {
//     const { token, newPassword } = req.body;

    

//     db.query('SELECT * FROM tokens WHERE token = ?', [token], (err, results) => {
//         if (err) {
//             return res.status(500).send('Internal Server Error');
//         }

//         if (results.length === 0) {
            
//             return res.status(400).send('Invalid or expired token');
//         }

//         const tokenData = results[0];

//         // Log the token stored in the database
        

//         const currentTime = new Date();
//         if (currentTime > new Date(tokenData.verval_datum)) {
            
//             return res.status(400).send('Token has expired');
//         }

//         // Directly compare the plain token
//         if (token !== tokenData.token) {
           
//             return res.status(400).send('Invalid or expired token');
//         }

//         // If token matches, proceed with password reset
        

//         db.query('SELECT * FROM klanten WHERE id = ?', [tokenData.user_id], (err, userResults) => {
//             if (err) {
//                 return res.status(500).send('Internal Server Error');
//             }

//             if (userResults.length === 0) {
//                 return res.status(404).send('User not found');
//             }

//             const user = userResults[0];

//             // Hash the new password
//             bcrypt.hash(newPassword, 10, (err, hashedPassword) => {
//                 if (err) {
//                     return res.status(500).send('Error hashing password');
//                 }

//                 // Update the user's password
//                 db.query('UPDATE klanten SET wachtwoord = ? WHERE id = ?', [hashedPassword, user.id], (err) => {
//                     if (err) {
//                         return res.status(500).send('Error updating password');
//                     }

//                     // Optionally, delete the token after it's used
//                     db.query('DELETE FROM tokens WHERE token = ?', [token], (err) => {
//                         if (err) {
                            
//                         }

//                         res.json({ message: 'Password reset successfully' });
//                     });
//                 });
//             });
//         });
//     });
// });

app.post('/reset-password', (req, res) => {
    const { token, newPassword } = req.body;


    // Zoek de token in de database
    db.query('SELECT * FROM tokens', (err, results) => {
        if (err) {
            console.error('Databasefout:', err);
            return res.status(500).send('Internal Server Error');
        }

        console.log('Tokens in database:', results); // Debug log

        if (results.length === 0) {
            return res.status(400).send('Invalid or expired token');
        }

        // Doorloop de resultaten en vergelijk de gehashte tokens
        let matchedToken = null;
        results.forEach((tokenData) => {
            const isMatch = bcrypt.compareSync(token, tokenData.token);
            if (isMatch) {
                matchedToken = tokenData;
            }
        });

        if (!matchedToken) {
            console.error('Geen overeenkomende token gevonden.');
            return res.status(400).send('Invalid or expired token');
        }


        // Controleer of de token is verlopen
        const currentTime = new Date();
        if (currentTime > new Date(matchedToken.verval_datum)) {
            console.error('Token is verlopen.');
            return res.status(400).send('Token has expired');
        }

        // Token is geldig, reset het wachtwoord
        bcrypt.hash(newPassword, 10, (err, hashedPassword) => {
            if (err) {
                console.error('Error hashing password:', err);
                return res.status(500).send('Error hashing password');
            }

            db.query(
                'UPDATE klanten SET wachtwoord = ? WHERE id = ?',
                [hashedPassword, matchedToken.user_id],
                (err) => {
                    if (err) {
                        console.error('Error updating password:', err);
                        return res.status(500).send('Error updating password');
                    }

                    // Verwijder de gebruikte token
                    db.query('DELETE FROM tokens WHERE id = ?', [matchedToken.id], (err) => {
                        if (err) {
                            console.error('Error deleting token:', err);
                        }
                        res.json({ message: 'Password reset successfully' });
                    });
                }
            );
        });
    });
});



app.put('/klanten/:id/wachtwoord', apiKeyMiddleware, (req, res) => {
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



app.get('/panden', apiKeyMiddleware, (req, res) => {
    db.query('SELECT * FROM panden', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});
app.get('/panden/:id', apiKeyMiddleware, (req, res) => {
    const id = req.params.id;
    db.query('SELECT * FROM panden WHERE id = ?', [id], (err, results) => {
        if (err) return res.status(500).send(err);
        if (results.length === 0) return res.status(404).send('Pand niet gevonden');
        const pand = results[0];
        res.json(pand);
    });
});

app.post('/panden', apiKeyMiddleware, (req, res) => {
    const { postcode, straat, huisnummer, plaats, langitude, altitude } = req.body;
    db.query('INSERT INTO panden (postcode, straat, huisnummer, plaats, langitude, altitude) VALUES (?, ?, ?, ?, ?, ?)', 
    [postcode, straat, huisnummer, plaats, langitude, altitude], (err, results) => {
        if (err) return res.status(500).send(err);
        res.json({ id: results.insertId, postcode, straat, huisnummer, plaats, langitude, altitude });
    });
});

app.delete('/panden/:id', apiKeyMiddleware, (req, res) => {
    const id = req.params.id;
    db.query('DELETE FROM panden WHERE id = ?;', [id], (err, results) => {
        if (err) {
            return res.status(500).send({ message: 'Er is een fout opgetreden tijdens het verwijderen van het pand.', error: err });
        }
    });
});
// Servicetype
app.get('/servicetype', apiKeyMiddleware, (req, res) => {
    db.query('SELECT * FROM servicetype', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

app.post('/servicetype', apiKeyMiddleware, (req, res) => {
    const { omschrijving } = req.body;
    db.query('INSERT INTO servicetype (omschrijving) VALUES (?)', [omschrijving], (err, results) => {
        if (err) return res.status(500).send(err);
        res.json({ id: results.insertId, omschrijving });
    });
});

// Serviceverzoek
app.get('/serviceverzoek', apiKeyMiddleware, (req, res) => {
    db.query('SELECT * FROM serviceverzoek', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

app.post('/serviceverzoek', apiKeyMiddleware, (req, res) => {
    const { omschrijving } = req.body;
    db.query('INSERT INTO serviceverzoek (omschrijving) VALUES (?)', 
    [omschrijving], (err, results) => {
        if (err) return res.status(500).send(err);
        res.json({ id: results.insertId, omschrijving });
    });
});

app.put('/serviceverzoek/:id', apiKeyMiddleware, (req, res) => {
    const { id } = req.params;  // Haal de id uit de URL
    const { status } = req.body;  // Haal de nieuwe status en bezichtiging uit het verzoek

    db.query('UPDATE serviceverzoek SET status = ?,  WHERE id = ?', 
    [status, id], (err, results) => {
        if (err) return res.status(500).send(err);
        if (results.affectedRows === 0) {
            return res.status(404).json({ message: 'Serviceverzoek niet gevonden' });
        }
        res.json({ id, status, bezichtiging });
    });
});

// Stappen
app.get('/stappen', apiKeyMiddleware, (req, res) => {
    db.query('SELECT * FROM sv_stappen', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

app.post('/stappen', apiKeyMiddleware, (req, res) => {
    const { omschrijving, serviceverzoek_id, externepartij_id, datum } = req.body;
    db.query('INSERT INTO sv_stappen (omschrijving, serviceverzoek_id, externepartij_id, datum) VALUES (?, ?, ?, ?)', 
    [omschrijving, serviceverzoek_id, externepartij_id, datum], (err, results) => {
        if (err) return res.status(500).send(err);
        res.json({ id: results.insertId, omschrijving, serviceverzoek_id, externepartij_id, datum });
    });
});

app.get('/inschrijvingen', apiKeyMiddleware, (req, res) => {
    db.query('SELECT * FROM inschrijvingen', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

app.post('/inschrijvingen', apiKeyMiddleware, (req, res) => {
    

    const { hoeveel_personen, jaar_inkomen, userid, pandid, bezichtiging } = req.body;


    // Converteer expliciet naar integers/numbers
    const parsedData = {
        hoeveel_personen: parseInt(hoeveel_personen),
        jaar_inkomen: parseFloat(jaar_inkomen),
        userid: parseInt(userid),
        pandid: parseInt(pandid),
        bezichtiging: parseInt(bezichtiging)
    };

    const query = 'INSERT INTO inschrijvingen (hoeveel_personen, jaar_inkomen, userid, pandid, bezichtiging) VALUES (?, ?, ?, ?, ?)';

    db.query(
        query, 
        [parsedData.hoeveel_personen, parsedData.jaar_inkomen, parsedData.userid, parsedData.pandid, parsedData.bezichtiging], 
        (err, results) => {
            if (err) {
                console.error('Database error:', err);
                return res.status(500).json({ 
                    error: 'Database error', 
                    details: err.message 
                });
            }
            console.log('4. Query uitgevoerd met waarden:', [parsedData.hoeveel_personen, parsedData.jaar_inkomen, parsedData.userid, parsedData.pandid, parsedData.bezichtiging]);
            res.status(201).json({ 
                message: 'Inschrijving succesvol',
                insertedData: parsedData,
                results: results
            });
        }
    );
});


app.put('/inschrijvingen/:id', apiKeyMiddleware, (req, res) => { 
    const { id } = req.params; // Haal de ID uit de URL
    const { hoeveel_personen, jaar_inkomen, bezichtiging } = req.body; // Haal de data uit de request body

    // Haal de bestaande gegevens op uit de database
    db.query('SELECT * FROM inschrijvingen WHERE id = ?', [id], (err, results) => {
        if (err) return res.status(500).send(err);

        if (results.length === 0) {
            return res.status(404).json({ message: 'Inschrijving niet gevonden' });
        }

        // Haal de bestaande waarden op
        const existingData = results[0];

        // Stel de nieuwe waarden in, gebruik de bestaande waarden als ze niet zijn meegegeven in de request
        const updatedHoeveelPersonen = hoeveel_personen || existingData.hoeveel_personen;
        const updatedJaarInkomen = jaar_inkomen || existingData.jaar_inkomen;
        const updatedBezichtiging = bezichtiging || existingData.bezichtiging;

        // Update de inschrijving in de database
        db.query(
            'UPDATE inschrijvingen SET hoeveel_personen = ?, jaar_inkomen = ?, bezichtiging = ? WHERE id = ?', 
            [updatedHoeveelPersonen, updatedJaarInkomen, updatedBezichtiging, id], 
            (err, results) => {
                if (err) return res.status(500).send(err);
                
                // Als de update gelukt is, stuur je een succesbericht terug
                if (results.affectedRows > 0) {
                    res.json({ 
                        message: 'Inschrijving succesvol bijgewerkt', 
                        id, 
                        hoeveel_personen: updatedHoeveelPersonen, 
                        jaar_inkomen: updatedJaarInkomen, 
                        bezichtiging: updatedBezichtiging
                    });
                } else {
                    res.status(404).json({ message: 'Inschrijving niet gevonden' });
                }
            }
        );
    });
});

app.post('/serviceverzoek', apiKeyMiddleware, (req, res) => {
    const { omschrijving, status } = req.body;
    db.query('INSERT INTO serviceverzoek (omschrijving, status) VALUES (?, ?)', 
    [omschrijving, status], (err, results) => {
        if (err) return res.status(500).send(err);
        res.json({ id: results.insertId, omschrijving, status });
    });
});


app.get('/medewerkers', apiKeyMiddleware, (req, res) => {
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

app.post('/medewerker/login', async (req, res) => {
    const { email, wachtwoord } = req.body;

    db.query('SELECT * FROM medewerkers WHERE email = ?', [email], async (err, results) => {
        if (err) {
            
            return res.status(500).send('Er is een fout opgetreden.');
        }

        if (results.length === 0) {
            return res.status(400).send('Medewerker niet gevonden.');
        }

        const medewerker = results[0];

        try {
            const isMatch = await bcrypt.compare(wachtwoord, medewerker.wachtwoord);
            

            if (!isMatch) {
                return res.status(400).send('Onjuist wachtwoord.');
            }

            // Verwijder het wachtwoord uit de medewerkergegevens voordat je ze terugstuurt
            delete medewerker.wachtwoord;

            // Log de volledige medewerkersgegevens in de console
            

            // Stuur de volledige medewerkersgegevens terug als JSON
            res.json(medewerker);
        } catch (compareError) {
            
            return res.status(500).send('Er is een fout opgetreden tijdens het vergelijken van wachtwoorden.');
        }
    });
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

app.delete('/medewerkers/:id', apiKeyMiddleware, (req, res) => {
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


// Start the serverx
app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}/`);
});