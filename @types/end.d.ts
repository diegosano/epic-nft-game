declare namespace NodeJS {
  interface ProcessEnv {
    readonly ALCHEMY_STAGING_URL: string;
    readonly ALCHEMY_PRIVATE_KEY: string;
  }
}