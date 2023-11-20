declare module 'truffle' {
  export interface Deployer {
    deploy(contract: any): void;
  }
}
