import dotenv from 'dotenv';

const config = process.env;
dotenv.config();

const properties = ['PROTOCOL', 'HOST', 'PORT', 'NETWORK_ID'];

properties.forEach((property:string) => {
  if (!Object.prototype.hasOwnProperty.call(config, property))
    throw new Error(`Environment variable ${property} is not set!`)
  else config.property = eval(`config.${property}`);
});

export default config;
