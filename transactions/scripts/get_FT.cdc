import FungibleToken from 0xFUNGIBLETOKENADDRESS
import ExampleToken from 0xTOKENADDRESS

/// This script gets the view-based metadata associated with the specified Fungible Token
/// and returns it as a single struct

pub struct FT {
    pub let name: String
    pub let description: String
    pub let owner: Address
    pub let type: String
    pub let externalURL: String
    pub let receiverPath: PublicPath
    pub let balancePath: PublicPath
    pub let storagePath: StoragePath
    pub let providerPath: PrivatePath
    pub let receiverType: String
    pub let balanceType: String
    pub let providerType: String
    pub let customStoragePath: {String : StoragePath}
    pub let customPrivatePath: {String : PrivatePath}
    pub let customPublicPath: {String : PublicPath}
    pub let squareImage: String
    pub let bannerImage: String?
    pub let socials: {String: String}

    init(
        name: String,
        description: String,
        owner: Address,
        type: String,
        externalURL: String,
        receiverPath: PublicPath,
        balancePath: PublicPath,
        storagePath: StoragePath,
        providerPath: PrivatePath,
        receiverType: String,
        balanceType: String,
        providerType: String,
        customStoragePath: {String : StoragePath},
        customPrivatePath: {String : PrivatePath},
        customPublicPath: {String : PublicPath},
        squareImage: String,
        bannerImage: String?,
        socials: {String: String}
    ) {
        self.name = name
        self.description = description
        self.owner = owner
        self.type = type
        self.externalURL = externalURL
        self.receiverPath = receiverPath
        self.balancePath = balancePath
        self.storagePath = storagePath
        self.providerPath = providerPath
        self.receiverType = receiverType
        self.balanceType = balanceType
        self.providerType = providerType
        self.customStoragePath = customStoragePath
        self.customPrivatePath = customPrivatePath
        self.customPublicPath = customPublicPath
        self.squareImage = squareImage
        self.bannerImage = bannerImage
        self.socials = socials

    }
}

pub fun main(address: Address): FT {
    let account = getAccount(address)

    let vault = account
        .getCapability(ExampleToken.balancePublicPath)
        .borrow<&{MetadataViews.Resolver}>()
        ?? panic("Could not borrow a reference to the vault")

    let vaultDisplay = MetadataViews.getFTVaultDisplay(vault)!

    let vaultData = MetadataViews.getFTVaultData(vault)!

    let socials: {String: String} = {}
    for key in vaultDisplay.socials.keys {
        socials[key] = vaultDisplay.socials[key]!.url
    }

    let customStoragePath: {String : StoragePath} = {}
    for key in vaultData.customStoragePath.keys {
        customStoragePath[key.identifier] = vaultData.customStoragePath[key]!
    }

    let customPrivatePath: {String : PrivatePath} = {}
    for key in vaultData.customPrivatePath.keys {
        customPrivatePath[key.identifier] = vaultData.customPrivatePath[key]!
    }

    let customPublicPath: {String : PublicPath} = {}
    for key in vaultData.customPublicPath.keys {
        customPublicPath[key.identifier] = vaultData.customPublicPath[key]!
    }

    var bannerImage: String? = nil 
    if vaultDisplay.bannerImage != nil {
        bannerImage = vaultDisplay.bannerImage!.file.uri()
    }

    return FT(
        name: vaultDisplay.name,
        description: vaultDisplay.description,
        owner: vault.owner!.address,
        type: vaultDisplay.getType().identifier,
        externalURL: vaultDisplay.externalURL.url,
        receiverPath: vaultData.receiverPath,
        balancePath: vaultData.balancePath,
        storagePath: vaultData.storagePath,
        providerPath: vaultData.providerPath,
        receiverType: vaultData.receiverType.identifier,
        balanceType: vaultData.balanceType.identifier,
        providerType: vaultData.providerType.identifier,
        customStoragePath: customStoragePath,
        customPrivatePath: customPrivatePath,
        customPublicPath: customPublicPath,
        squareImage: vaultDisplay.squareImage.file.uri(),
        bannerImage: bannerImage,
        socials: socials
    )
}