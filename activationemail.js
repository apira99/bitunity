const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const path = require('path');
const nodemailer = require('nodemailer');
const crypto = require('crypto');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const port = 3003;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cors());

// Path to the backend SQLite database
const dbPath = path.resolve(__dirname, 'activationdb.db');
const db = new sqlite3.Database(dbPath, (err) => {
    if (err) {
        console.error('Error opening database:', err.message);
    } else {
        console.log('Connected to the database.');
        db.run(`CREATE TABLE IF NOT EXISTS activation_tokens (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            parentEmail TEXT NOT NULL,
            activationToken TEXT NOT NULL,
            isActive INTEGER DEFAULT 0,
            createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )`);
    }
});

// Function to generate activation token
function generateActivationToken() {
    return crypto.randomBytes(16).toString('hex');
}

// Function to send activation email
function sendActivationEmail(parentEmail, activationToken) {
    const activationLink = `http://localhost:${port}/activate?token=${activationToken}`;
    const transporter = nodemailer.createTransport({
        host: 'smtp.gmail.com',
        port: 587,
        secure: false, // true for 465, false for other ports
        auth: {
            user: 'japira1899@gmail.com',
            pass: 'nvtl ltpk jvsj hbwy'
        },
        tls: {
            rejectUnauthorized: false // Important if using self-signed certificate or testing environment
        },
        // Debug option for more verbose output in the console
        debug: true
    });
    

    const mailOptions = {
        from: 'japira1899@gmail.com',
        to: parentEmail,
        subject: 'Account Activation',
        text: `Click the following link to activate your account: ${activationLink}`,
        html: `<a href="${activationLink}">Activate your account</a>`
    };

    transporter.sendMail(mailOptions, (error, info) => {
        if (error) {
            console.log('Error sending email:', error);
        } else {
            console.log('Activation email sent: %s', info.messageId);
        }
    });
}

// Endpoint to handle activation
app.get('/activate', (req, res) => {
    const token = req.query.token;

    if (!token) {
        res.status(400).send('Invalid request: Token is missing');
        return;
    }

    db.get("SELECT parentEmail FROM activation_tokens WHERE activationToken = ?", [token], (err, row) => {
        if (err) {
            console.error("Database error:", err);
            res.status(500).send("Error on the server.");
        } else if (row) {
            const parentEmail = row.parentEmail;
            db.run("UPDATE activation_tokens SET isActive = 1 WHERE parentEmail = ?", [parentEmail], function (err) {
                if (err) {
                    console.error("Error updating user:", err);
                    res.status(500).send("Error updating the user.");
                } else {
                    res.send('Email confirmed. You can now log in.');
                }
            });
        } else {
            res.status(400).send('Invalid activation token');
        }
    });
});


// Endpoint to create activation token
app.post('/create-activation-token', (req, res) => {
    const { parentEmail } = req.body;

    if (!parentEmail) {
        res.status(400).send('Invalid request: Email is missing');
        return;
    }

    const activationToken = generateActivationToken();

    db.run("INSERT INTO activation_tokens (parentEmail, activationToken) VALUES (?, ?)", [parentEmail, activationToken], function (err) {
        if (err) {
            console.error("Database error:", err);
            res.status(500).send("Error on the server.");
        } else {
            sendActivationEmail(parentEmail, activationToken);
            res.send('Activation email sent.');
        }
    });
});

// Endpoint to check activation status
app.get('/check-activation-status', (req, res) => {
    const email = req.query.email;

    if (!email) {
        res.status(400).send('Invalid request: Email is missing');
        return;
    }

    db.get("SELECT isActive FROM activation_tokens WHERE parentEmail = ?", [email], (err, row) => {
        if (err) {
            console.error("Database error:", err);
            res.status(500).send("Error on the server.");
        } else if (row) {
            res.json({ isActive: row.isActive });
        } else {
            res.status(404).send('Email not found');
        }
    });
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
