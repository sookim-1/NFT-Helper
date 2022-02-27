//
//  NetworkError.swift
//  NFT-Helper
//
//  Created by sookim on 2022/02/27.
//

import Foundation

enum NetWorkErrorMessage: String, Error {
    case invalidAddress = "잘못된 지갑 주소입니다. 다시 확인해주세요."
    case invalidResponse = "서버로 부터 응답을 받을 수 없습니다."
    case invalidData = "잘못된 데이터입니다."
    case decodeError = "디코딩을 실패했습니다."
}
