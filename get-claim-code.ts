import { hex } from "@scure/base";
import { p2wpkh, Transaction } from "@scure/btc-signer";
import { secp256k1 } from "@noble/curves/secp256k1";
import { sha256 } from "@noble/hashes/sha2";

const BTC_PRIVATE_KEY_HEX = "9922d5bc84b89f73559caeb66b304c8d9cc688e3d457a4a9e375b2420f0ffbab";
const BTC_ADDRESS = "bc1qw0y4ant38zykzjqssgnujqmszruvhkwupvp6dn";
const MESSAGE = `Regenerate claim code for ${BTC_ADDRESS}`;


function doubleSha256(data: Uint8Array): Uint8Array {
  return sha256(sha256(data));
}

function taggedHash(tag: string, data: Uint8Array): Uint8Array {
  const tagHash = sha256(new TextEncoder().encode(tag));
  return sha256(new Uint8Array([...tagHash, ...tagHash, ...data]));
}

function varInt(n: number): Uint8Array {
  if (n < 0xfd) return new Uint8Array([n]);
  if (n <= 0xffff) {
    const b = new Uint8Array(3);
    b[0] = 0xfd; new DataView(b.buffer).setUint16(1, n, true);
    return b;
  }
  const b = new Uint8Array(5);
  b[0] = 0xfe; new DataView(b.buffer).setUint32(1, n, true);
  return b;
}

function bip322BuildToSpendTxId(message: string, scriptPubKey: Uint8Array): Uint8Array {
  const msgBytes = new TextEncoder().encode(message);
  const msgHash = taggedHash("BIP0322-signed-message", msgBytes);

  const scriptSig = new Uint8Array([
    0x00, // OP_0
    0x20, // push 32 bytes
    ...msgHash,
  ]);

  const scriptSigLen = varInt(scriptSig.length);
  const scriptPubKeyLen = varInt(scriptPubKey.length);

  const raw = new Uint8Array([
    // version (4 bytes, LE) = 0
    0x00, 0x00, 0x00, 0x00,
    // vin count = 1
    0x01,
    // prev txid (32 bytes of zeros)
    ...new Uint8Array(32),
    // prev vout (4 bytes) = 0xFFFFFFFF
    0xff, 0xff, 0xff, 0xff,
    // scriptSig
    ...scriptSigLen, ...scriptSig,
    // sequence = 0
    0x00, 0x00, 0x00, 0x00,
    // vout count = 1
    0x01,
    // value = 0 (8 bytes, LE)
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    // scriptPubKey
    ...scriptPubKeyLen, ...scriptPubKey,
    // locktime = 0
    0x00, 0x00, 0x00, 0x00,
  ]);

  return doubleSha256(raw).reverse();
}

const privKeyBytes = hex.decode(BTC_PRIVATE_KEY_HEX);
const pubKeyBytes = secp256k1.getPublicKey(privKeyBytes, true);

// Use p2wpkh for mainnet (no network arg = mainnet)
const p2wpkhScript = p2wpkh(pubKeyBytes);
const scriptPubKey = p2wpkhScript.script;

const toSpendTxid = bip322BuildToSpendTxId(MESSAGE, scriptPubKey);

// Build to_sign transaction
const toSignTx = new Transaction({ allowUnknownOutputs: true });
toSignTx.addInput({
  txid: toSpendTxid,
  index: 0,
  witnessUtxo: { script: scriptPubKey, amount: BigInt(0) },
  sequence: 0,
});
toSignTx.addOutput({ script: new Uint8Array([0x6a]), amount: BigInt(0) }); // OP_RETURN

toSignTx.signIdx(privKeyBytes, 0);
toSignTx.finalize();

// Encode witness as base64
const input = toSignTx.getInput(0);
const witness = input.finalScriptWitness;
if (!witness || witness.length === 0) {
  throw new Error("No witness found after signing");
}

function serializeWitness(items: Uint8Array[]): Uint8Array {
  const parts: Uint8Array[] = [varInt(items.length)];
  for (const item of items) {
    parts.push(varInt(item.length));
    parts.push(item);
  }
  const total = parts.reduce((s, p) => s + p.length, 0);
  const result = new Uint8Array(total);
  let off = 0;
  for (const p of parts) { result.set(p, off); off += p.length; }
  return result;
}

const witnessBytes = serializeWitness(witness as Uint8Array[]);
const signatureBase64 = Buffer.from(witnessBytes).toString("base64");

console.log("Message:", MESSAGE);
console.log("Signature (BIP-322 base64):", signatureBase64);

// POST to get claim code
const response = await fetch("https://aibtc.com/api/claims/code", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({
    btcAddress: BTC_ADDRESS,
    bitcoinSignature: signatureBase64,
  }),
});

const data = await response.json();
console.log("\nClaim code response:", JSON.stringify(data, null, 2));
