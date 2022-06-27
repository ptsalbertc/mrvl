//
//  StringExtensions.swift
//  Marvel
//
//  Created by Albert on 17/2/22.
//

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

extension String {
	
	func from(_ table: String) -> String {
		return NSLocalizedString(self, tableName: table, bundle: Bundle.main, comment: String())
	}
	
	func md5() -> String {
		let length = Int(CC_MD5_DIGEST_LENGTH)
		let messageData = self.data(using:.utf8)!
		var digestData = Data(count: length)
		
		_ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
			messageData.withUnsafeBytes { messageBytes -> UInt8 in
				if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
					let messageLength = CC_LONG(messageData.count)
					CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
				}
				return 0
			}
		}
		return digestData.base64EncodedString()
	}
}
