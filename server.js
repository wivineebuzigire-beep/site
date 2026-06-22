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
const rateWindowMs = Number(process.env.RATE_LIMIT_WINDOW_MS || 10 * 60 * 1000);
const maxRequestsPerWindow = Number(process.env.RATE_LIMIT_MAX || 5);
const minSubmitDelayMs = Number(process.env.MIN_SUBMIT_DELAY_MS || 3000);
const rateLimitStore = new Map();

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

function getClientIp(req) {
  const forwardedFor = req.headers['x-forwarded-for'];
  if (typeof forwardedFor === 'string' && forwardedFor.length > 0) {
    return forwardedFor.split(',')[0].trim();
  }

  return req.ip || 'unknown';
}

function isRateLimited(ip) {
  const now = Date.now();
  const existing = rateLimitStore.get(ip);

  if (!existing || now > existing.resetAt) {
    rateLimitStore.set(ip, { count: 1, resetAt: now + rateWindowMs });
    return false;
  }

  existing.count += 1;
  return existing.count > maxRequestsPerWindow;
}

function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

app.get('/api/health', (req, res) => {
  const isConfigured = Boolean(gmailUser && gmailAppPassword);
  return res.json({
    ok: true,
    configured: isConfigured,
    antiSpam: {
      enabled: true,
      rateWindowMs,
      maxRequestsPerWindow,
      minSubmitDelayMs,
    },
  });
});

app.post('/api/contact', async (req, res) => {
  const name = String(req.body.name || '').trim();
  const email = String(req.body.email || '').trim();
  const message = String(req.body.message || '').trim();
  const website = String(req.body.website || '').trim();
  const formStartedAt = Number(req.body.formStartedAt || 0);
  const clientIp = getClientIp(req);

  if (website.length > 0) {
    return res.json({ ok: true, message: 'Votre message a bien été envoyé à Ganti Busime.' });
  }

  if (!Number.isFinite(formStartedAt) || Date.now() - formStartedAt < minSubmitDelayMs) {
    return res.status(429).json({
      ok: false,
      message: 'Envoi trop rapide. Veuillez patienter quelques secondes puis réessayer.',
    });
  }

  if (isRateLimited(clientIp)) {
    return res.status(429).json({
      ok: false,
      message: 'Trop de tentatives. Merci de réessayer plus tard.',
    });
  }

  if (!name || !email || !message) {
    return res.status(400).json({ ok: false, message: 'Tous les champs sont obligatoires.' });
  }

  if (name.length > 120 || message.length > 3000) {
    return res.status(400).json({
      ok: false,
      message: 'Le message est trop long. Merci de réduire la taille des champs.',
    });
  }

  if (!isValidEmail(email)) {
    return res.status(400).json({ ok: false, message: 'Adresse e-mail invalide.' });
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