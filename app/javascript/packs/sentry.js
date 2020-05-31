import * as Sentry from '@sentry/browser';

const {sentryConfig, renuoSentryConfig} = window;
Sentry.init({...sentryConfig, ...renuoSentryConfig});

if (Airesis.signed_in) {
  Sentry.setUser({
      "email": Airesis.email,
      "id": Airesis.id
  });
}

window.Sentry = Sentry;
