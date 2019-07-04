## This is a working repository for EIP-2135 Consumable Interface

### Development

Development requires [`truffle`](https://github.com/trufflesuite/truffle)

#### Setup
```bash
cd impl
npm i
```

Also install a local Ethereum testnet provider. We recommend [Ganache](https://github.com/trufflesuite/ganache/releases).



#### Run Tests

```bash
cd impl
npx truffle test
```


You will need to start an instance of Ethereum testnet. Ganache provides it with a default endpoint, port and netowrk Id. You will need to **make sure it matches the `truffle.config.js`**

```json5
{
    test: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 7545,            // Standard Ethereum port (default: none)
      network_id: "5777",       // Any network (default: none)
    }
}
```
