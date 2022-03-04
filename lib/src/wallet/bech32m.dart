import 'dart:typed_data';

const CHARSET = "qpzry9x8gf2tvdw0s3jn54khce6mua7l";
const M = 0x2BC830A3;
/**
 * def encode_puzzle_hash(puzzle_hash: bytes32, prefix: str) -> str:
    # TODO: address hint error and remove ignore
    #       Argument 1 to "convertbits" has incompatible type "bytes32"; expected "List[int]"  [arg-type]
    encoded = bech32_encode(prefix, convertbits(puzzle_hash, 8, 5))  # type: ignore[arg-type]
    return encoded
 */

encodePuzzeHash({required Uint8List puzzleHash, String prefix = "xch"}) {}
