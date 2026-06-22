import express from 'express';
import nodemailer from 'nodemailer';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const app = express();
const port = process.env.PORT || 3000;
const contactTo = process.env.CONTACT_TO || 'gantibusiness@gmail.com';
const gmailUser = process.env.GMAIL_USER;
const gmailAppPassword = process.env.GMAIL_APP_PASSWORD;

app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(express.static(__dirname));

function createTransport() {
  if (!gmailUser || !gmailAppPassword) {
    return null;
  }

  return nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: gmailUser,
      pass: gmailAppPassword,
    },
  });
}

app.post('/api/contact', async (req, res) => {
  const name = String(req.body.name || '').trim();
  const email = String(req.body.email || '').trim();
  const message = String(req.body.message || '').trim();

  if (!name || !email || !message) {
    return res.status(400).json({ ok: false, message: 'Tous les champs sont obligatoires.' });
  }

  const transport = createTransport();

  if (!transport) {
    return res.status(500).json({
      ok: false,
      message: 'La configuration Gmail n\'est pas définie. Renseignez GMAIL_USER et GMAIL_APP_PASSWORD.',
    });
  }

  try {
    await transport.sendMail({
      from: process.env.SMTP_FROM || gmailUser,
      to: contactTo,
      replyTo: email,
      subject: `Nouveau message de ${name}`,
      text: `Nom: ${name}\nEmail: ${email}\n\nMessage:\n${message}`,
      html: `
        <h2>Nouveau message de contact</h2>
        <p><strong>Nom :</strong> ${name}</p>
        <p><strong>Email :</strong> ${email}</p>
        <p><strong>Message :</strong></p>
        <p>${message.replace(/\n/g, '<br />')}</p>
      `,
    });

    return res.json({ ok: true, message: 'Votre message a bien été envoyé à Ganti Busime.' });
  } catch (error) {
    return res.status(500).json({
      ok: false,
      message: 'Impossible d\'envoyer le message. Vérifiez la configuration SMTP du serveur.',
    });
  }
});

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});