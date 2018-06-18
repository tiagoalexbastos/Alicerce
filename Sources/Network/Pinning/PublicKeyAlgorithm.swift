//
//  PublicKeyAlgorithm.swift
//  Alicerce
//
//  Created by André Pacheco Neves on 18/05/2018.
//  Copyright © 2018 Mindera. All rights reserved.
//

import Security

public enum PublicKeyAlgorithm {
    case rsa2048
    case rsa4096
    case ecDsaSecp256r1
    case ecDsaSecp384r1
    case ecDsaSecp521r1

    public static let allCases: [PublicKeyAlgorithm] = [.rsa2048,
                                                        .rsa4096,
                                                        .ecDsaSecp384r1,
                                                        .ecDsaSecp384r1,
                                                        .ecDsaSecp521r1]

    public var asn1HeaderData: Data {
        switch self {
        case .rsa2048:
            return Data(bytes: [0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
                                0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00])
        case .rsa4096:
            return Data(bytes: [0x30, 0x82, 0x02, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
                                0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x02, 0x0f, 0x00])
        case .ecDsaSecp256r1:
            return Data(bytes: [0x30, 0x59, 0x30, 0x13, 0x06, 0x07, 0x2a, 0x86, 0x48, 0xce, 0x3d, 0x02,
                                0x01, 0x06, 0x08, 0x2a, 0x86, 0x48, 0xce, 0x3d, 0x03, 0x01, 0x07, 0x03,
                                0x42, 0x00])
        case .ecDsaSecp384r1:
            return Data(bytes: [0x30, 0x76, 0x30, 0x10, 0x06, 0x07, 0x2a, 0x86, 0x48, 0xce, 0x3d, 0x02,
                                0x01, 0x06, 0x05, 0x2b, 0x81, 0x04, 0x00, 0x22, 0x03, 0x62, 0x00])
        case .ecDsaSecp521r1:
            return Data(bytes: [0x30, 0x81, 0x9B, 0x30, 0x10, 0x06, 0x07, 0x2a, 0x86, 0x48, 0xce, 0x3d,
                                0x02, 0x01, 0x06, 0x05, 0x2b, 0x81, 0x04, 0x00, 0x23, 0x03, 0x81, 0x86,
                                0x00])
        }
    }

    public init?(secKeyAttributes: [CFString : Any]) {
        let algorithm = secKeyAttributes[kSecAttrKeyType] as? String
        let keySize = secKeyAttributes[kSecAttrKeySizeInBits] as? Int

        let kSecAttrKeyTypeEllipticCurve: String = {
            if #available(iOS 10.0, *) { return kSecAttrKeyTypeECSECPrimeRandom.string }
            else { return kSecAttrKeyTypeEC.string }
        }()

        switch (algorithm, keySize) {
        case (kSecAttrKeyTypeRSA.string, 2048): self = .rsa2048
        case (kSecAttrKeyTypeRSA.string, 4096): self = .rsa4096
        case (kSecAttrKeyTypeEllipticCurve, 256): self = .ecDsaSecp256r1
        case (kSecAttrKeyTypeEllipticCurve, 384): self = .ecDsaSecp384r1
        case (kSecAttrKeyTypeEllipticCurve, 521): self = .ecDsaSecp521r1
        default: return nil
        }
    }
}

// MARK: - CFString {

private extension CFString {

    var string: String { return self as String }
}