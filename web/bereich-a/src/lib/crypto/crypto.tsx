import {type CryptoCache} from '../hooks/use-crypto-cache.ts';

export type EncryptedValue = {cipher: string; nonce: string; tag: string};

export const tagLength = 128;

const encoder = new TextEncoder();
const decoder = new TextDecoder();

function base64ToArrayBuffer(base64: string): ArrayBuffer {
  const binaryString = window.atob(base64);
  const len = binaryString.length;
  const bytes = new Uint8Array(len);
  for (let i = 0; i < len; i++) {
    bytes[i] = binaryString.charCodeAt(i);
  }
  return bytes.buffer;
}

function arrayBufferToBase64(buffer: ArrayBuffer): string {
  let binary = '';
  const bytes = new Uint8Array(buffer);
  const len = bytes.byteLength;
  for (let i = 0; i < len; i++) {
    binary += String.fromCharCode(bytes[i]);
  }
  return window.btoa(binary);
}

function arrayBufferConcat(...arrayBuffers: ArrayBuffer[]): ArrayBuffer {
  const arr = arrayBuffers.reduce(
    (pre, cur) => pre.concat(Array.from(new Uint8Array(cur))),
    [] as number[],
  );
  // @ts-ignore FIXME: TS 5.7+ Uint8Array/ArrayBuffer generic strictness
  return new Uint8Array(arr);
}

function splitCipherAndTag(concatenated: ArrayBuffer) {
  const cipher = new Uint8Array(
    concatenated.slice(0, concatenated.byteLength - tagLength / 8),
  );
  const tag = new Uint8Array(
    concatenated.slice(concatenated.byteLength - tagLength / 8),
  );

  return {cipher, tag};
}

export async function getServerLoginPassword(
  clientPassword: string,
  email: string,
): Promise<string> {
  const importedPassword = await crypto.subtle.importKey(
    'raw',
    encoder.encode(clientPassword),
    'PBKDF2',
    false,
    ['deriveBits'],
  );

  const derived = await crypto.subtle.deriveBits(
    {
      name: 'PBKDF2',
      hash: 'SHA-512',
      salt: encoder.encode(email),
      iterations: 100_000,
    },
    importedPassword,
    512,
  );

  return btoa(String.fromCharCode(...new Uint8Array(derived)));
}

export async function decryptPersonalKey(
  password: string,
  salt: string,
  key: EncryptedValue,
): Promise<CryptoKey> {
  const importedPassword = await crypto.subtle.importKey(
    'raw',
    encoder.encode(password),
    'PBKDF2',
    false,
    ['deriveBits'],
  );

  const derived = await crypto.subtle.deriveBits(
    {
      name: 'PBKDF2',
      hash: 'SHA-512',
      salt: base64ToArrayBuffer(salt),
      iterations: 100_000,
    },
    importedPassword,
    256,
  );

  const derivedKey = await crypto.subtle.importKey(
    'raw',
    derived,
    'AES-GCM',
    false,
    ['unwrapKey'],
  );

  return await crypto.subtle.unwrapKey(
    'pkcs8',
    arrayBufferConcat(
      base64ToArrayBuffer(key.cipher),
      base64ToArrayBuffer(key.tag),
    ),
    derivedKey,
    {
      name: 'AES-GCM',
      iv: base64ToArrayBuffer(key.nonce),
      tagLength,
    },
    {name: 'RSA-OAEP', hash: 'SHA-512'},
    true,
    ['decrypt', 'unwrapKey'],
  );
}

export async function decryptOrganisationKey(
  personalPrivateKey: CryptoKey,
  organisationPrivateKeyDecryption: string,
  organisationPrivateKey: EncryptedValue,
): Promise<CryptoKey> {
  const derivedKey = await crypto.subtle.unwrapKey(
    'raw',
    base64ToArrayBuffer(organisationPrivateKeyDecryption),
    personalPrivateKey,
    {
      name: 'RSA-OAEP',
    },
    {name: 'AES-GCM'},
    false,
    ['unwrapKey'],
  );

  return await crypto.subtle.unwrapKey(
    'pkcs8',
    arrayBufferConcat(
      base64ToArrayBuffer(organisationPrivateKey.cipher),
      base64ToArrayBuffer(organisationPrivateKey.tag),
    ),
    derivedKey,
    {
      name: 'AES-GCM',
      iv: base64ToArrayBuffer(organisationPrivateKey.nonce),
      tagLength,
    },
    {name: 'RSA-OAEP', hash: 'SHA-512'},
    true,
    ['decrypt', 'unwrapKey'],
  );
}

export async function randomSymmetricKey(): Promise<CryptoKey> {
  return await crypto.subtle.generateKey(
    {
      name: 'AES-GCM',
      length: 256,
    },
    true,
    ['encrypt', 'decrypt', 'wrapKey'],
  );
}

function uint8ArrayEqual(a: Uint8Array, b: Uint8Array): boolean {
  if (a.length !== b.length) {
    return false;
  }

  for (let i = 0; i < a.length; i++) {
    if (a[i] !== b[i]) {
      return false;
    }
  }

  return true;
}

function findUniqueIv(usedIvs: Uint8Array[]): Uint8Array {
  let iv: Uint8Array;
  do {
    iv = crypto.getRandomValues(new Uint8Array(12));
  } while (usedIvs.some((used) => uint8ArrayEqual(used, iv)));

  usedIvs.push(iv);

  return iv;
}

export async function symmetricEncryptValue(
  key: CryptoKey,
  value: string,
  usedIvs: Uint8Array[],
): Promise<EncryptedValue> {
  const iv = findUniqueIv(usedIvs);
  const encodedValue = encoder.encode(value);
  const paddedEncodedValue = new Uint8Array(
    Math.ceil((encodedValue.length + 1) / 16) * 16,
  );
  paddedEncodedValue.set(encodedValue);
  const encrypted: ArrayBuffer = await crypto.subtle.encrypt(
    {
      name: 'AES-GCM',
      // @ts-ignore FIXME: TS 5.7+ Uint8Array/ArrayBuffer generic strictness
      iv: iv,
      tagLength,
    },
    key,
    paddedEncodedValue,
  );

  const {cipher, tag} = splitCipherAndTag(encrypted);

  return {
    // @ts-ignore FIXME: TS 5.7+ Uint8Array/ArrayBuffer generic strictness
    cipher: arrayBufferToBase64(cipher),
    // @ts-ignore FIXME: TS 5.7+ Uint8Array/ArrayBuffer generic strictness
    tag: arrayBufferToBase64(tag),
    // @ts-ignore FIXME: TS 5.7+ Uint8Array/ArrayBuffer generic strictness
    nonce: arrayBufferToBase64(iv),
  };
}

export async function symmetricDecryptValue(
  key: CryptoKey,
  value: EncryptedValue,
): Promise<string> {
  const decrypted = await crypto.subtle.decrypt(
    {
      name: 'AES-GCM',
      iv: base64ToArrayBuffer(value.nonce),
      tagLength,
    },
    key,
    arrayBufferConcat(
      base64ToArrayBuffer(value.cipher),
      base64ToArrayBuffer(value.tag),
    ),
  );

  return decoder.decode(decrypted).replace(/\0*$/g, '');
}

export function symmetricDecryptValueWithCache(
  key: CryptoKey,
  value: EncryptedValue,
  cryptoCache?: CryptoCache,
): Promise<string> {
  return cryptoCache
    ? cryptoCache.getDecryptedValueCached(key, value)
    : symmetricDecryptValue(key, value);
}

export async function importPublicKey(publicKey: string): Promise<CryptoKey> {
  return await crypto.subtle.importKey(
    'spki',
    base64ToArrayBuffer(publicKey),
    {name: 'RSA-OAEP', hash: 'SHA-512'},
    true,
    ['encrypt', 'wrapKey'],
  );
}

export async function asymmetricWrapKey(
  key: CryptoKey,
  value: CryptoKey,
): Promise<string> {
  const arrayBuffer = await crypto.subtle.wrapKey('raw', value, key, {
    name: 'RSA-OAEP',
  });
  return arrayBufferToBase64(arrayBuffer);
}

export async function asymmetricUnwrapKey(
  key: CryptoKey,
  value: string,
): Promise<CryptoKey> {
  return await crypto.subtle.unwrapKey(
    'raw',
    base64ToArrayBuffer(value),
    key,
    {
      name: 'RSA-OAEP',
    },
    {name: 'AES-GCM'},
    true,
    ['encrypt', 'decrypt'],
  );
}

export function asymmetricUnwrapKeyWithCache(
  key: CryptoKey,
  value: string,
  cryptoCache?: CryptoCache,
): Promise<CryptoKey> {
  return cryptoCache
    ? cryptoCache.getAsymmetricUnwrappedKeyCached(key, value)
    : asymmetricUnwrapKey(key, value);
}

export async function generateKeyPair(): Promise<CryptoKeyPair> {
  return await crypto.subtle.generateKey(
    {
      name: 'RSA-OAEP',
      modulusLength: 4096,
      publicExponent: new Uint8Array([1, 0, 1]),
      hash: 'SHA-512',
    },
    true,
    ['wrapKey', 'unwrapKey'], // For some reason at least chrome throws an error not specifying unwrapKey here
  );
}

export async function exportPublicKey(publicKey: CryptoKey): Promise<string> {
  const exported = await crypto.subtle.exportKey('spki', publicKey);
  return arrayBufferToBase64(exported);
}

export async function encryptPersonalKey(
  password: string,
  email: string,
  personalPrivateKey: CryptoKey,
): Promise<{encrypted: EncryptedValue; salt: string}> {
  let salt: Uint8Array;

  do {
    salt = crypto.getRandomValues(new Uint8Array(64));
    // @ts-ignore FIXME: TS 5.7+ Uint8Array/ArrayBuffer generic strictness
  } while (arrayBufferToBase64(salt) === email);

  const importedPassword = await crypto.subtle.importKey(
    'raw',
    encoder.encode(password),
    'PBKDF2',
    false,
    ['deriveBits'],
  );

  const derived = await crypto.subtle.deriveBits(
    // @ts-ignore FIXME: TS 5.7+ Uint8Array/ArrayBuffer generic strictness
    {name: 'PBKDF2', hash: 'SHA-512', salt, iterations: 100_000},
    importedPassword,
    256,
  );

  const derivedKey = await crypto.subtle.importKey(
    'raw',
    derived,
    'AES-GCM',
    false,
    ['wrapKey'],
  );

  const iv = crypto.getRandomValues(new Uint8Array(12));
  const wrappedKey = await crypto.subtle.wrapKey(
    'pkcs8',
    personalPrivateKey,
    derivedKey,
    {
      name: 'AES-GCM',
      iv,
      tagLength,
    },
  );

  const {cipher, tag} = splitCipherAndTag(wrappedKey);

  return {
    encrypted: {
      // @ts-ignore FIXME: TS 5.7+ Uint8Array/ArrayBuffer generic strictness
      cipher: arrayBufferToBase64(cipher),
      // @ts-ignore FIXME: TS 5.7+ Uint8Array/ArrayBuffer generic strictness
      tag: arrayBufferToBase64(tag),
      // @ts-ignore FIXME: TS 5.7+ Uint8Array/ArrayBuffer generic strictness
      nonce: arrayBufferToBase64(iv),
    },
    // @ts-ignore FIXME: TS 5.7+ Uint8Array/ArrayBuffer generic strictness
    salt: arrayBufferToBase64(salt),
  };
}

export async function encryptOrganisationKey(
  personalPublicKey: CryptoKey,
  organisationPrivateKey: CryptoKey,
): Promise<{
  encryptedOrganisationKey: EncryptedValue;
  encryptedWithPublicKey: string;
}> {
  const symmetricKey = await randomSymmetricKey();

  const iv = crypto.getRandomValues(new Uint8Array(12));
  const encryptedOrganisationKey = await crypto.subtle.wrapKey(
    'pkcs8',
    organisationPrivateKey,
    symmetricKey,
    {
      name: 'AES-GCM',
      iv,
      tagLength,
    },
  );

  const {cipher, tag} = splitCipherAndTag(encryptedOrganisationKey);

  const encryptedWithPublicKey = await crypto.subtle.wrapKey(
    'raw',
    symmetricKey,
    personalPublicKey,
    {
      name: 'RSA-OAEP',
    },
  );

  return {
    encryptedOrganisationKey: {
      // @ts-ignore FIXME: TS 5.7+ Uint8Array/ArrayBuffer generic strictness
      cipher: arrayBufferToBase64(cipher),
      // @ts-ignore FIXME: TS 5.7+ Uint8Array/ArrayBuffer generic strictness
      tag: arrayBufferToBase64(tag),
      // @ts-ignore FIXME: TS 5.7+ Uint8Array/ArrayBuffer generic strictness
      nonce: arrayBufferToBase64(iv),
    },
    encryptedWithPublicKey: arrayBufferToBase64(encryptedWithPublicKey),
  };
}

export async function fingerprintPublicKey(publicKey: string): Promise<string> {
  const hash = await crypto.subtle.digest(
    'SHA-512',
    base64ToArrayBuffer(publicKey),
  );
  const arr = new Uint8Array(hash);

  return [...arr]
    .slice(0, 8)
    .map((byte) => {
      const hex = byte.toString(16);
      if (hex.length < 2) {
        return '0' + hex;
      }
      return hex;
    })
    .join(':');
}

export async function reencryptOrganisationKeyForNewUser(
  personalPrivateKey: CryptoKey,
  organisationPrivateKeyDecryptionKey: string,
  newUserPublicKey: CryptoKey,
): Promise<string> {
  const derivedKey = await crypto.subtle.unwrapKey(
    'raw',
    base64ToArrayBuffer(organisationPrivateKeyDecryptionKey),
    personalPrivateKey,
    {
      name: 'RSA-OAEP',
    },
    {name: 'AES-GCM'},
    true,
    ['unwrapKey'],
  );

  const encryptedWithPublicKey = await crypto.subtle.wrapKey(
    'raw',
    derivedKey,
    newUserPublicKey,
    {
      name: 'RSA-OAEP',
    },
  );

  return arrayBufferToBase64(encryptedWithPublicKey);
}

export function parseUsedIvs(usedIvs: string[]): Uint8Array[] {
  return usedIvs.map((iv) => new Uint8Array(base64ToArrayBuffer(iv)));
}

export async function supportsWebCrypto(): Promise<boolean> {
  try {
    await getServerLoginPassword('test', 'test');
  } catch {
    return false;
  }

  return true;
}

export function createEncryptNewValueWhenChanged(
  usedIvs: Uint8Array[],
  key?: CryptoKey,
  cryptoCache?: CryptoCache,
) {
  return async function (
    newValue: string | null,
    oldValue: EncryptedValue | null | undefined,
  ): Promise<EncryptedValue | undefined> {
    if (!key) {
      return;
    }
    if (!oldValue) {
      return newValue
        ? await symmetricEncryptValue(key, newValue, usedIvs)
        : undefined;
    }

    const oldDecrypted = await symmetricDecryptValueWithCache(
      key,
      oldValue,
      cryptoCache,
    );
    if (newValue === oldDecrypted) {
      return;
    }

    return await symmetricEncryptValue(key, newValue ?? '', usedIvs);
  };
}
