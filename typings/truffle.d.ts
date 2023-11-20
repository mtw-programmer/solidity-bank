declare module 'truffle' {
  export interface Deployer {
    deploy(contract: any): void;
  }

  export const artifacts: any;
}
