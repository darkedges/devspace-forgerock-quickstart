export const environment = {
  production: false,
  msalConfig: {
    auth: {
      clientId: '2187ce6a-741b-4d70-9756-9365fd193249',
      authority: 'https://login.microsoftonline.com/4161be3f-bf2b-41d4-a02b-e6f82b529d53',
    },
  },
  apiConfig: {
    scopes: ['user.read'],
    uri: 'https://graph.microsoft.com/v1.0/me',
  },
};
