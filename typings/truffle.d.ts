declare module 'truffle' {
  export interface Deployer {
    deploy: (contract: any, contractA?: any, contractB?: any) => void;
  }
}
