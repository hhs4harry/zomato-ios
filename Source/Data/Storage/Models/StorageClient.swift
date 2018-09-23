//
//  StorageClient.swift
//  zomato
//
//  Created by Harry on 24/09/18.
//  Copyright © 2018 |x|. All rights reserved.
//

final class StorageClient: Storage {

    // MARK: - Properties

    // MARK: Private

    private let fileManager: FileManager = .default
    private let cacheDirectory: FileManager.SearchPathDirectory = .cachesDirectory
    private let baseFolderName: String = "zomato"
    private let baseURL: URL

    init() {
        baseURL = (try! fileManager.url(for: cacheDirectory, in: .userDomainMask, appropriateFor: nil, create: true))
            .appendingPathComponent(baseFolderName, isDirectory: true)

        configureRootDirectory()
    }

    func configureRootDirectory() {
        var isDirectory: ObjCBool = ObjCBool(true)
        if !fileManager.fileExists(atPath: baseURL.path, isDirectory: &isDirectory) {
            try! fileManager.createDirectory(atPath: baseURL.path, withIntermediateDirectories: false, attributes: nil)
        }
    }

    // MARK: - Conformance

    // MARK: Storage

    func store(_ item: Data, named: String) throws {
        let url: URL = baseURL.appendingPathComponent(named, isDirectory: false)

        if fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)
        }
        fileManager.createFile(atPath: url.path, contents: item, attributes: nil)
    }

    func retrive(itemNamed name: String) throws -> Data? {
        let url: URL = baseURL.appendingPathComponent(name, isDirectory: false)

        return fileManager.contents(atPath: url.path)
    }

    func invalidate() throws {
        if fileManager.fileExists(atPath: baseURL.path) {
            try fileManager.removeItem(at: baseURL)
        }
    }
}

// MARK: - Conformance

// MARK: DependencyInjectionAware

extension StorageClient: DependencyInjectionAware {
    static func register(in container: Container) {
        container.register(Storage.self) { _ in StorageClient() }
    }
}

import Foundation
import Swinject
