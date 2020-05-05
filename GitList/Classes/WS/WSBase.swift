//
//  WSBase.swift
//  GitList
//
//  Created by Thales Toniolo on 22/04/20.
//  Copyright © 2020 Flameworks. All rights reserved.
//
import UIKit
import Alamofire

// MARK: - Class Declaration
class WSBase: NSObject {
	// MARK: - Support Public Methods

	// MARK: - Private Methods
	private class func tratarRetorno(_ response: DataResponse<Any>, _ serviceURL: String, _ completionHandler: @escaping (_ jsonResponse: [String: AnyObject]?, _ error: VOError?) -> Void) {
		if (response.result.isSuccess && response.result.value != nil && response.response!.statusCode == 200) {
			debugPrint("tratarRetorno - Resultvalue: \(response.result.value!)")
			if let jsonResult:[String: AnyObject] = response.result.value as? [String: AnyObject] {
				completionHandler(jsonResult, nil)
			} else {
				completionHandler(nil, self.formatErrorWithMessage("Erro ao recuperar retorno JSON"))
			}
		} else if (response.response != nil && response.response!.statusCode == 200) {
			// Caso de apenas 200 (sucesso), retorna vazio
			completionHandler([:], nil)
		} else if (response.response != nil && response.response!.statusCode == NSURLErrorTimedOut) {
			let err: VOError = self.formatErrorWithMessage("Timeout!")
			err.statusCode = kErrorCodeTimeOut
			if let code = response.response?.statusCode {
				err.statusCode = code
			}
			completionHandler(nil, err)
		} else {
			switch (response.result) {
				case .failure(let error):
					if (error._code == NSURLErrorTimedOut) {
						let err: VOError = self.formatErrorWithMessage("Timeout!")
						err.statusCode = kErrorCodeTimeOut
						completionHandler(nil, err)
						return
					}
					break
					
				default:
					//...
					break
			}
			var msgError: String = "Erro ao acessar o serviço. Verifique sua configuração com a internet."
			if let msg = response.result.value as? [String: Any] {
				if let item = msg["message"] as? String {
					msgError = item
				}
			}

			let err: VOError = self.formatErrorWithMessage(msgError)
			err.statusCode = kErrorCodeNoStatusCode
			if let code = response.response?.statusCode {
				err.statusCode = code
			}
			completionHandler(nil, err)
		}
	}

	// MARK: - Public Methods
	public class func getConnError() -> VOError {
		let error: VOError = VOError()
		error.errorMessage = "Sem conexão com a internet"
		error.status = "failed"
		error.statusCode = kErrorCodeSemInternet
		
		return error
	}
	
	public class func formatErrorWithMessage(_ msg: String) -> VOError {
		let error: VOError = VOError()
		
		error.errorMessage = msg
		error.status = ""
		error.statusCode = kErrorCodeGenerico
		
		return error
	}
	
	public class func executeGet(_ serviceURL: String, completionHandler: @escaping (_ jsonResponse: [String: AnyObject]?, _ error: VOError?) -> Void) {
		if (!NetworkReachabilityManager()!.isReachable) {
			completionHandler(nil, self.getConnError())
			return
		}

		let manager: SessionManager = Alamofire.SessionManager.default

		manager.request(serviceURL, method: HTTPMethod.get, encoding: JSONEncoding.default)
			.responseJSON { response in
				debugPrint("GET ===============================> \(serviceURL)")
				self.tratarRetorno(response, serviceURL, completionHandler)
		}
	}
}
